#encoding:utf-8
require 'htmltags'
include HtmlTag::Reporter
stdio("udplogs/udp_server,log")
server = HtmlTag::TestUdpServer.new().run