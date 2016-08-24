# A more usable server (serving multiple clients):
require 'socket'
# Sequential echo server.
# It services only one client at a time.
server_ip   = "10.10.10.55"
server_port = 16807
Socket.tcp_server_loop(server_ip, server_port) { |sock, client_addrinfo|
	begin
		# puts "T connected"
		# p sock
		# p IO.copy_stream(sock, sock)
		puts sock.read
		# puts sock.local_address
		# p sock.local_address
		# p sock.local_address.protocol
		srv_ip   = sock.local_address.ip_address
		srv_port = sock.local_address.ip_port
		# p sock.local_address.ip_port
		# puts sock.local_address.class
		# sock.puts "Hello!"
		sock.puts "Time is #{Time.now},TCP connection is established"
		sock.puts "Server IP:#{srv_ip},Server Port:#{srv_port}"
	ensure
		puts "#{sock} is closed!"
		sock.close
	end
}

