class SinaInitial2
  def new_comment_task(url,cookie)
    require 'net/http'
	  http = Net::HTTP.new(url, 80)
    http.use_ssl = false
    path = '/'
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

    resp, data = http.get(path, header)  
    puts resp.body
  end
end
puts 'hhhh'
si=SinaInitial2.new
url="http://m.weibo.cn/1733879143/EfDYIin2e?from=page_1002061733879143_profile&wvr=6&mod=weibotime&type=comment"
cookie='_T_WM=75bcb18b384e5e152eacc207b0f613fb; ALF=1480677302; SCF=AitoB3iO_zuysigzr-cKzvZSa3Nnf4mwki4ZpdPWy-5gihywZFe4gP3nOu1IV9x8lkvyah64CC7Zr8of4EqyqTk.; SUBP=0033WrSXqPxfM725Ws9jqgMF55529P9D9W5ZEalVgBT13mEVRY0Z_jU35JpX5o2p5NHD95Qp1hqceoqESK-XWs4DqcjAi--fiK.EiKyhi--RiKnRiKyhi--fi-2Xi-zXi--ciK.Ni-27i--fiKnfi-z0i--NiKLWiKnXKGLVdntt; SUHB=0N20Pzoi9xaqHx; WEIBOCN_FROM=feed; SUB=_2A251H0opDeTxGedG7VQT9izJzjiIHXVW4FZhrDV6PUJbktBeLVHBkW2a64vnyDT87Z9eF4nOV_ryJpxTAA..; M_WEIBOCN_PARAMS=featurecode%3D20000180%26oid%3D4037286004378454%26luicode%3D20000061%26lfid%3D4037286004378454%26uicode%3D20000061%26fid%3D4037286004378454'

si.new_comment_task(url,cookie)