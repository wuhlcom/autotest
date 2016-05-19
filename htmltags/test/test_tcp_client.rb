#encoding:utf-8
file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
#########################################
# ip   = "127.0.0.1"
# port = "16801"
# # Thread.abort_on_exception=true
# t    = Thread.new do
# 	server = HtmlTag::TestTcpServer.new(ip, port)
# 	server.single_run
# 	# server.single_thr.kill
# end
# sleep 2
# client = HtmlTag::TestTcpClient.new(ip, port)
# p client.message
# p client.state
# t.kill
#########################################################
@tc_vir_tcpsrv_port = rand_port(50000, 65534)
ip   = "192.168.100.100"
port = "16801"
client = HtmlTag::TestTcpClient.new(ip, port)
 p client.tcp_message
 p client.tcp_state
