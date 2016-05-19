require "socket"

def testUDPServer
	@maxlen          =512
	@udp_server_ip   ="127.0.0.1"
	@udp_server_port = 15801
	@udp_server      = UDPSocket.new
	@udp_server.bind(@udp_server_ip, @udp_server_port)
	loop do
		p "1111"
p		recieve           = @udp_server.recvfrom(@maxlen)
		clientmsg, sender = recieve
		if clientmsg != "0"
			remote_host = sender[3]
			client_port = sender[1]
			puts "Recieve message from Client #{remote_host}:#{client_port}"
			puts "Client Message:#{clientmsg}"
			srvmsg ="UDP Server connect to client #{remote_host}:#{client_port} succeed!"
			@udp_server.send(srvmsg, 0, remote_host, client_port) #发到指定的用户端口
			# @udp_server.send("more message", 0, remote_host, client_port) #发到指定的用户端口
		end
	end
end

testUDPServer

