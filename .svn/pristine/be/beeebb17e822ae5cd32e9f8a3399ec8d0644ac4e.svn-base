#encoding:utf-8
file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
# Thread.abort_on_exception=true
####++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ip        = "127.0.0.1"
# port      = "15801"
# cip       = "127.0.0.1"
# cport     = "15321"
# clientmsg = "Client"
# len       = "512".to_i
# t         = Thread.new do
# 	HtmlTag::TestUdpServer.new(ip, port, len).run
# end
# sleep 2
# client = HtmlTag::TestUdpClient.new(cip, cport, ip, port, clientmsg, len)
# p client.udp_state
# p client.udp_message
# t.kill

####++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ip        = "192.168.100.100"
port      = "44950"
cip       = "192.168.100.100"
cport     = "23251"
clientmsg = "haha"
len       = "512".to_i
client = HtmlTag::TestUdpClient.new(cip, cport, ip, port, clientmsg, len)
p client.udp_state
p client.udp_message
