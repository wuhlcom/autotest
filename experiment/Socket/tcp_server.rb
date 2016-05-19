require 'socket'
##############################无循环情况下执行一次tcp会话就会停止
# A simple TCP server may look like:
# server_ip = "50.50.50.55"
# port      = 2000
# server    = TCPServer.new server_ip, port # Server bind to port 2000
# client    = server.accept # Wait for a client to connect
# client.puts "Hello !"
# client.puts "Time is #{Time.now}"
# client.close

##############################有循环的情况下可以接受单个用户连接
# server_ip = "50.50.50.55"
# port      = 2000
# server    = TCPServer.new server_ip, port # Server bind to port 2000
# loop do
# 	client = server.accept # Wait for a client to connect
# 	client.puts "Hello !"
# 	client.puts "Time is #{Time.now}"
# 	client.close
# end

##############################有循环的情况下可以接受单个用户连接
server_ip = "50.50.50.55"
port      = 2001
server    = TCPServer.new server_ip, port # Server bind to port 2000
t         = Thread.new(server) do |server|
	loop do
		client = server.accept # Wait for a client to connect
		client.puts "Hello !"
		client.puts "Time is #{Time.now}"
		client.close
	end
end
t.join
#######################多客户端来连接
# server_ip = "50.50.50.55"
# port      = 2000
# server    = TCPServer.new server_ip, port # Server bind to port 2000
# loop do
# 	Thread.new(server) do |server|
# 		client = server.accept # Wait for a client to connect
# 		client.puts "Hello !"
# 		client.puts "Time is #{Time.now}"
# 		client.close
# 	end
# end