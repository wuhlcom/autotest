require 'socket'

server_ip   = "50.50.50.55"
server_port = 16801
server      = TCPServer.new server_ip, server_port
loop do
		# Thread.start(server.accept) do |client|
		begin
				client =server.accept
				client.puts "Time is #{Time.now}!"
				client.puts "TCP server IP #{server_ip},server port #{server_port}"
		ensure
				client.close
				# end
		end
end

