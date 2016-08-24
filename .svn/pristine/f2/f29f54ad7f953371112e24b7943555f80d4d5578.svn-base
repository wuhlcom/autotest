require 'socket'
require 'pp'
# Socket.tcp("www.baidu.com", 80) { |sock|
# 	sock.print "GET / HTTP/1.0\r\nHost: www.ruby-lang.org\r\n\r\n"
# 	sock.close_write
# 	puts sock.read
# }
server_addr = "10.10.10.57"
server_addr = "localhost"
server_addr = "10.10.10.55"
server_port = 16807
Socket.tcp(server_addr, server_port) { |sock|
	# sock.print "ftp_test the socket"
	# p sock
	# p sock.local_address
	# p sock.local_address.protocol
	cip   = sock.local_address.ip_address
	cport = sock.local_address.ip_port
	p "my ip #{cip},my port #{cport}"
	sock.puts "ChatClient info ChatClient IP:#{cip},ChatClient Port:#{cport}"
	sock.close_write
	puts sock.read
}
