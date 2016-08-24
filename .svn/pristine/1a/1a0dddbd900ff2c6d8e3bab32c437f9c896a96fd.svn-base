# A more usable server (serving multiple clients):
require 'socket'
# Sequential echo server.
# It services only one client at a time.
Socket.tcp_server_loop(16807) { |sock, client_addrinfo|
		begin
				puts "Tcp connected"
				# p client_addrinfo
				# p sock
				# p IO.copy_stream(sock, sock)
				puts sock.read
				# sock.close_read
				sock.puts "Hello !"
				sock.puts "Time is #{Time.now}"
		ensure
				puts "#{sock} is cloed"
				sock.close
		end
}

