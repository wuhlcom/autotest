# At first, how to create your client. See initialize for more detail.
#
#    Create simple client.
#                      clnt = HTTPClient.new
#  Accessing resources through HTTP proxy. You can use environment variable 'http_proxy' or 'HTTP_PROXY' instead.
#      clnt = HTTPClient.new('http://myproxy:8080')
#  How to retrieve web resources
#
#  See get and get_content.
#
#  Get content of specified URL. It returns HTTP::Message object and calling 'body' method of it returns a content String.
#       puts clnt.get('http://dev.ctor.org/').body
#  For getting content directly, use get_content. It follows redirect response and returns a String of whole result.
#       puts clnt.get_content('http://dev.ctor.org/')
#  You can pass :follow_redirect option to follow redirect response in get.
#      puts clnt.get('http://dev.ctor.org/', :follow_redirect => true)
#  Get content as chunks of String. It yields chunks of String.
#      clnt.get_content('http://dev.ctor.org/') do |chunk|
#    puts chunk
#  end
require 'httpclient'
clnt = HTTPClient.new
p clnt.get("http://10.10.10.57:80")
p "==============================="
p clnt.get("http://localhost:8082").body