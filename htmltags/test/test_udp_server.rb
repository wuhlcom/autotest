#encoding:utf-8
p file =File.expand_path('../../lib/htmltags', __FILE__)
require file
ip     = "192.168.100.100"
port   = "40448"
# Thread.abort_on_exception=true
# t                        = Thread.new do
server = HtmlTag::TestUdpServer.new(ip, port).run
# end
# t.join
