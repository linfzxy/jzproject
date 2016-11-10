class JzprojectController < ApplicationController
  def reset
    Comment.delete_all
    Post.delete_all
    WordCount.delete_all
    render plain:"没了~"
  end

  def resetWordcount
    WordCount.delete_all
    render plain:"分词表没了~~"
  end

  def newgrab
  end

  def checkstage
    @posts=Post.all
  end

  def makexlsx
    filepath=File.join(Rails.root,'public','count.xlsx')
    require 'write_xlsx'
    workbook = WriteXLSX.new(filepath)

    sheet1 = workbook.add_worksheet
    posts=Post.all
    row=0
    posts.each{ |posts|
      begin
        sheet1.write(row,0,posts[:lastpage])
        sheet1.write(row,1,posts[:body])
        sheet1.write(row,2,posts[:url])
      rescue
      end
      row+=1
    }

    sheet2=workbook.add_worksheet
    comments=Comment.all
    row=0
    comments.each{ |comment|
      begin
        sheet2.write(row,0,comment[:likecount])
        sheet2.write(row,1,comment[:body])
      rescue
      end
      row+=1
    }

    sheet3=workbook.add_worksheet
    wcs=WordCount.all
    row=0
    wcs.each{ |wc|
      begin
        sheet3.write(row,0,wc[:count])
        sheet3.write(row,1,wc[:word])
      rescue
      end
      row+=1
    }

    workbook.close
    render plain:"ok~"
  end

  def analysis
    comments=Comment.all
    map=Hash.new {|e,k| e=Array.new }
    comments.each{ |comment|
      map[comment[:likecount]]=map[comment[:likecount]]<<comment[:body]
    }

    #向分词器发送请求

    result_map=Hash.new 0
    map.each{ |k,v|
      next if k==nil
      sendbody=""
      v.each{ |c|
        while c.index('<')!=nil
          c[c.index('<')..c.index('>')]=''
        end
        sendbody=sendbody+c
        if sendbody.size>10000
          analyzer_client sendbody,result_map,k
          sendbody=""
        end
      }
      analyzer_client sendbody,result_map,k
    }
    result_map.each{ |k,v|
      temp=k.dup
      temp.force_encoding('GBK')
      puts temp.encoding


      puts k


       WordCount.create(word: k,count: v)
    }
    render plain:"分析完啦~"
  end

  # def inflate(string)
  #   require 'zlib'
  #   gz = Zlib::GzipReader.new(StringIO.new(string))
  #   uncompressed_string = gz.read
  #   gz.close
  #   return uncompressed_string
  # end

  def analyzer_client(body,result_map,power)
    #puts body
    require 'excon'
    analyzer_url='http://api.bosonnlp.com/tag/analysis?space_mode=0&oov_level=4&t2s=0&&special_char_conv=1'
    header={}
    header['X-Token']='YvAMLWML.10329.7L42JkIazPUk'
    header['Content-Type']='application/json'
    header['Accept']='application/json'
    body.gsub! "\"",""
    body="[\""+body+"\"]"
    response=Excon.post(analyzer_url, :headers => header,:body=>body)
    require 'json'
    result_array=JSON.parse response.body
    result_array[0]['word'].each{ |w|
      # ########################
      # filepath='C:\Users\Lynn\Desktop\temp\test.txt'
      # aFile = File.new(filepath, "r+")
      # aFile.syswrite w
      result_map[w]+=(1+power)
    }
  end

  def dograb
    url=params[:jzproject][:url]
    cookie=params[:jzproject][:cookie]
    startpage=params[:jzproject][:startpage]
    gap=params[:jzproject][:gap]

    response=http_get(url,cookie)
    render plain:"看一下是不是cookie复制错了~" if response==nil || response.status!=200


    #Thread.new{
      #postbody 丢到数据库post的body中~
      body=response.body
      shift=body.index('mblog')==nil ? body.index('retweeted_status'):body.index('mblog')
      i=body.index 'text',shift
      j=body.index '"',i+7
      str=body[i+7...j]
      post_body=eval('"'+str+'"')

      #mid是comments的标识符
      i= body.index 'mid',body.index('mblog')
      j= body.index 'idstr',body.index('mblog')
      mid= body[i+6..j-4]

      #需要在结尾附上pagenumber
      comment_url='http://m.weibo.cn/single/rcList?format=cards&id='+mid.to_s+'&type=comment&hot=0&page='
      map,lastpage=comments_geter(comment_url,cookie,startpage,gap)

      #向数据库里丢东西
      post=Post.create(url: url,body: post_body, lastpage: lastpage, mid: mid)
      map.each{ |k,v|
        v.each{ |comment_body|
          while comment_body.index('<')!=nil
            comment_body[comment_body.index('<')..comment_body.index('>')]=''
          end
          while comment_body.index('[')!=nil
            comment_body[comment_body.index('[')..comment_body.index(']')]=''
          end
          post.comments.create(body: comment_body ,likecount:k)
        }
      }
   # }
    render plain:'ok~ 成功啦~'
  end

  def comments_geter(url,cookie,startpage,gap)
    i=startpage.to_i
    map=Hash.new {|e,k| e=Array.new }
    #body=nil
    loop do
      current_url=url+i.to_s
      response=http_get(current_url,cookie)
      body=response.body.gsub 'null','""'
      body=eval(body)
      flag=true
      break if body==nil
      body.each{ |element|
        next if element[:mod_type]!='mod/pagelist'
        flag=false
        element[:card_group].each{ |message|
          map[message[:like_counts]]=map[message[:like_counts]]<<message[:text]
        }
      }
      i+=1
      break if flag
      sleep gap.to_i
    end
    #puts body.inspect
    return map,i
  end

  def http_get(url,cookie)
    require 'excon'
    header={}
    header['Accept']='text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
    header['Accept-Encoding']='utf-8'
    header['Accept-Language']='zh-CN,zh;q=0.8'
    header['Cache-Control']='max-age=0'
    header['Connection']='keep-alive'
    header['Host']='m.weibo.cn'
    header['Upgrade-Insecure-Requests']='1'
    header['User-Agent']='Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36'
    header['Cookie']=cookie
    Excon.get(url, :headers => header)
  end
end
