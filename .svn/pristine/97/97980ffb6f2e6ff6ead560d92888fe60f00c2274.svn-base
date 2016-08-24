require "socket"

def testUdpClient
	@maxlen          = 512
	@udp_client_port = 15701
	@udp_server_port = 15801
	@udp_server_ip   ="127.0.0.1"
	@udp_server_ip   ="10.10.10.57"
	@udp_client_ip   ="192.168.100.101"
	@udp_client      = UDPSocket.new
	@udp_client.bind(@udp_client_ip, @udp_client_port)
	@clientmsg = "client"
	2.times do
		# s.send(msg, 0, 'localhost', server_port)
		# srvmsg       = s.recvfrom(512)
		# text, sender = srvmsg
		# remote_host  = sender[3]
		# srv_port     = sender[1]
		# puts "UDP Server #{remote_host}:#{srv_port} responsed: #{text}"
		@udp_client.send(@clientmsg, 0, @udp_server_ip, @udp_server_port)
		recieve        = @udp_client.recvfrom(@maxlen)
		srvmsg, sender = recieve
		remote_host    = sender[3]
		srv_port       = sender[1]
		puts "Recieved messsage from UDP Server:#{remote_host}:#{srv_port}!"
		puts "Server message:#{srvmsg}"
	end
end

testUdpClient