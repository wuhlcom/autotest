require 'socket'
server_ip   = "50.50.50.55"
server_port = 2001
begin
	 srv = TCPSocket.new server_ip,server_port
	while line = srv.gets # Read lines from socket
		puts line # and print them
	end
ensure
	srv.close if srv.kind_of?(TCPSocket) # close socket when done
end
