# A more usable server (serving multiple clients):
require 'socket'
# Threaded echo server
# It services multiple clients at a time.
# Note that it may accept connections too much.
server_ip   = "10.10.10.55"
server_port = 16807
Socket.tcp_server_loop(server_ip, server_port) {|sock, client_addrinfo|
	thr = Thread.new {
		begin
			# IO.copy_stream(sock, sock)
			# sock.puts "Hello !"
			# sock.puts "Time is #{Time.now}"
			srv_ip   = sock.local_address.ip_address
			srv_port = sock.local_address.ip_port
			sock.puts "Time is #{Time.now},TCP connection is established"
			sock.puts "Server IP:#{srv_ip},Server Port:#{srv_port}"
		ensure
			puts "#{sock} is closed!"
			sock.close
		end
	}
	thr.join
}
