class ZhprojectController < ApplicationController
  def index
    render 'newgrab_zh'
  end

  #额外附加文本分析
  def additional_quest
    ans=Post.create(url: 'hand-type-in',body: params[:zhproject][:content], lastpage: 0, mid: 0)
    ans.comments.create(body:params[:zhproject][:content],likecount:params[:zhproject][:likecounter])
    render plain:'ok~'
  end

  #抓回答+评论
  def quse_ans_comme
    quest_id=params[:zhproject][:quest_id]
    xsrftoken=params[:zhproject][:xsrftoken]
    offset=params[:zhproject][:offset].to_i
    gap=params[:zhproject][:gap].to_i
    ques_po=Post.create(url: quest_id,body: 'zh_question_'+quest_id, lastpage: offset, mid: '')
    require 'json'
    begin

      begin
        response=postclient(quest_id,xsrftoken,offset,gap)
        msgs=JSON.parse response.body
        msgs=msgs['msg']
        msgs.each{ |msg|
          offset+=1
          start=msg.index 'js-voteCount'
          votcount=0
          if start!=nil
            i=msg.index '>',start
            j=msg.index '<',start
            votcount=msg[i+1...j]
          else
            start=0
          end

          start=msg.index 'zm-editable-content clearfix',start
          i=msg.index '>',start
          j=msg.index '</div>',start
          content=msg[i+1...j]

          start=msg.index 'zg-anchor-hidden ac',start
          i=msg.index 'name',start
          j=msg.index '-comment',start
          comment_id=msg[i+6...j]

          strDeHtml content
          ques_po.comments.create(body: content ,likecount:votcount)
          grab_comments(comment_id,0,gap)
          }
      end until msgs==nil || msgs.size==0
    rescue
      ques_po.lastpage=offset
      ques_po.save
    end
    render plain:'ok~'
  end

  #回答
  def ans_comme
    ans_id=params[:zhproject][:ans_id]
    offset=params[:zhproject][:offset].to_i
    gap=params[:zhproject][:gap].to_i
    grab_comments(ans_id,offset,gap)
    render plain:'ok~'
  end
  def grab_comments(ans_id,offset,gap)
    require 'json'
    url='https://www.zhihu.com/r/answers/'+ans_id.to_s+'/comments?page='
    body=JSON.parse httpclient(url+'0',gap).body
    max=body['paging']['totalCount'].to_i
    ans=Post.create(url: url+'0',body: 'zh_comments_'+ans_id.to_s, lastpage: 0, mid: 0)
    begin
      while offset*30<max
        response=httpclient url+offset.to_s,gap
        break if response.body==nil
        body=JSON.parse response.body
        body['data'].each{ |ele|
          like_count=ele['likesCount']
          content=ele['content']
          strDeHtml content
          ans.comments.create(body:content,likecount:like_count)
        }
        offset+=1
      end
    rescue
      ans.lastpage=offset
      ans.save
    end
  end

  #去掉<>[]之间的内容 html文本化
  def strDeHtml comment_body
    while comment_body.index('<')!=nil
      comment_body[comment_body.index('<')..comment_body.index('>')]=''
    end
    while comment_body.index('[')!=nil
      comment_body[comment_body.index('[')..comment_body.index(']')]=''
    end
  end
  #common https://www.zhihu.com/r/answers/47810271/comments?page=0
  def httpclient(url,gap)
    require 'excon'
    header={}
    header['User-Agent']='Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36'
    header['Accept']='*/*'
    header['Accept-Encoding']='utf-8'
    header['Accept-Language']='zh-CN,zh;q=0.8'
    response=nil
    (0..7).each{
      response=Excon.get(url, :headers => header)
      sleep gap.to_i
      break if response.body!=nil
    }
    return response
  end
  #post ans https://www.zhihu.com/node/QuestionAnswerListV2
  # postbody method=next&params={"url_token":48749292,"pagesize":30,"offset":30}
  def postclient(ques_id,xsrftoken,offset,gap)
    require 'excon'
    url='https://www.zhihu.com/node/QuestionAnswerListV2'
    header={}
    header['X-Xsrftoken']=xsrftoken
    header['Content-Type']='application/x-www-form-urlencoded'
    header['User-Agent']='Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36'
    header['Accept']='*/*'
    header['Accept-Encoding']='utf-8'
    header['Accept-Language']='zh-CN,zh;q=0.8'
    #request_body='method=next&params=%7B%22url_token%22%3A'+ques_id+'%2C%22pagesize%22%3A30%2C%22offset%22%3A'+offset.to_s+'%7D'
    request_body='method=next&params={"url_token":'+ques_id+',"pagesize":30,"offset":'+offset.to_s+'}'
    # require 'uri'
    # request_body=URI::escape request_body
    response=nil
    (0..7).each{
      response=Excon.post(url, :headers => header , :body =>request_body )
      sleep gap.to_i
      break if response.body!=nil
    }
    return response
  end
end
