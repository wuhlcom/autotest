require 'htmltags'
include HtmlTag::Socket
ip = "10.10.10.20"
port = 9002
home = "/"
p http_client(ip,home,port)