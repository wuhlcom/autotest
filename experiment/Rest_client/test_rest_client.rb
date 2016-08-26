require 'rest-client'
url = 'http://example.com/resource'
url = "www.baidu.com"
# p RestClient.get url
#
# RestClient.get url, {:params => {:id => 50, 'foo' => 'bar'}}
#
# RestClient.get url, {:accept => :json}
#
# RestClient.post url, :param1 => 'one', :nested => { :param2 => 'two' }
#
# RestClient.post url, { 'x' => 1 }.to_json, :content_type => :json, :accept => :json
#
# RestClient.delete url
# curl -X POST http://192.168.10.9:8082/mobileCode/13823 652367
url  = "http://192.168.10.9:8082/mobileCode/1382365 2367"
# p RestClient.post url,""
p res = RestClient::Request.execute(method: :post, url: url,
                            timeout: 10)
p res.code
p res.body


# response = RestClient.get url
# response.code
# #? 200
# response.cookies
# #? {"Foo"=>"BAR", "QUUX"=>"QUUUUX"}
# response.headers
# #? {:content_type=>"text/html; charset=utf-8", :cache_control=>"private" ...
#     response.to_str
# #? \n<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n   \"http://www.w3.org/TR/html4/strict.dtd\">\n\n<html ....
#
# RestClient.post( url,
#   {
#     :transfer => {
#       :path => '/foo/bar',
#       :owner => 'that_guy',
#       :group => 'those_guys'
#     },
#      :upload => {
#       :file => File.new(path, 'rb')
#     }
#   })