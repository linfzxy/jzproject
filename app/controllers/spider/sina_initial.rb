class SinaInitial
  def new_comment_task(url,cookie)
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

    response=Excon.get(url, :headers => header)
  end
end
puts 'hhhh'
si=SinaInitial.new
url="http://m.weibo.cn/1733879143/EfDYIin2e?from=page_1002061733879143_profile&wvr=6&mod=weibotime&type=comment"
cookie='WEIBOCN_FROM=feed; _T_WM=4300e7652c976cddeb576468de4d79e4; ALF=1481087890; SCF=AitoB3iO_zuysigzr-cKzvZSa3Nnf4mwki4ZpdPWy-5ggKmi-obpUyH-M6ZETxzQeWcGiJBcvRFtaKqqRTQsmoQ.; SUB=_2A251JH7PDeTxGedG7VQT9izJzjiIHXVW5wKHrDV6PUJbktBeLUz6kW0wPc-Q8h4g2_wyyV6ljZ1PQNZj8Q..; SUBP=0033WrSXqPxfM725Ws9jqgMF55529P9D9W5ZEalVgBT13mEVRY0Z_jU35JpX5o2p5NHD95Qp1hqceoqESK-XWs4DqcjAi--fiK.EiKyhi--RiKnRiKyhi--fi-2Xi-zXi--ciK.Ni-27i--fiKnfi-z0i--NiKLWiKnXKGLVdntt; SUHB=0BLpvZL_iUOtmD; SSOLoginState=1478495903; M_WEIBOCN_PARAMS=from%3Dpage_1005051876156855_profile%26featurecode%3D20000180%26oid%3D4038955773177601%26luicode%3D20000061%26lfid%3D4038955773177601%26uicode%3D20000061%26fid%3D4038955773177601'

response=si.new_comment_task(url,cookie)
puts response.status
s=response.body
i=s.index 'text',s.index('idstr')
j=s.index 'textLength'
str=s[i+7..j-4]
result=eval('"'+str+'"')
puts result.encode 'utf-8'

#找mid
i= s.index 'mid',s.index('mblog')
j= s.index 'idstr',s.index('mblog')
mid= s[i+6..j-4]
#http://m.weibo.cn/single/rcList?format=cards&id=4037286004378454&type=comment&hot=0&page=3