#encoding:utf-8
require 'net/http'
# s =  Net::HTTP.get('www.baidu.com', '/index.html') # => String
p s =  Net::HTTP.get('10.10.10.57', '/',"80") # => String
# print s.encode("GBK",{:invalid => :replace, :undef => :replace, :replace => '?'})

# require 'open-uri'
#  open("http://locahost:8082/"){|f|
#  print	f.read
#  }