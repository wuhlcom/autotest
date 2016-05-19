#encoding:utf-8
require 'htmltags'
include HtmlTag::Reporter

stdio("httplogs/http_server,log")
###################
# require 'net/http/server'
# require 'pp'
# ip=ARGV[0]
# port = ARGV[1]
# Net::HTTP::Server.run(:ip=>ip,:port => port) do |request, stream|
# pp request
# [200, {'Content-Type' => 'text/html'}, ['Connect to Http Server succeed']]
# end
HtmlTag::TestHttpServer.new().run