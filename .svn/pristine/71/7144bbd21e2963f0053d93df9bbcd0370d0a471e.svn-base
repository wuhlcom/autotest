#encoding:utf-8
 p file_path =File.expand_path('../../lib/htmltags', __FILE__)
 require file_path
# require 'htmltags'
###############################
# ip     = "192.168.100.100"
# port   = "4002"
# server = HtmlTag::TestTcpServer.new(ip, port)
# server.multi_run
#################################################
include HtmlTag::Socket
@tc_srv_ip      = "192.168.100.100"
@tc_normal_port = "53581"
tcp_multi_server(@tc_srv_ip, @tc_normal_port)
# sleep
