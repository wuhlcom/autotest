#encoding:utf-8
require 'htmltags'
include HtmlTag::Socket
ip        = "20.20.20.84"
ip        = "10.10.10.65"
# ip        = "30.30.30.99"
port      = "20000"
cip       = "10.10.10.57"
cport     = "30000"
clientmsg = "haha"
len       = "512".to_i
# client = HtmlTag::TestUdpClient.new(cip, cport, ip, port, clientmsg, len)
client    = udp_client(cip, cport, ip, port, clientmsg, len)
p client.udp_state
p client.udp_message
