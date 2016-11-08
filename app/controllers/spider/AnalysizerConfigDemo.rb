# encoding: utf-8
require 'HTTPClient'
client=HTTPClient.new
analyzer_url='http://api.bosonnlp.com/tag/analysis?space_mode=0&oov_level=4&t2s=0&&special_char_conv=0'
header=[['X-Token', 'YvAMLWML.10329.7L42JkIazPUk'], ['Content-Type', 'application/json'], ['Accept', 'application/json']]
body='["美人师兄"]'
puts client.post(analyzer_url, body, header).body.inspect