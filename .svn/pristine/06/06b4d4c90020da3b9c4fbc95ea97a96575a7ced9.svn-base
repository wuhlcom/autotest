#encoding:utf-8
require "htmltags"
require 'socket'
server_ip   = "10.10.10.55"
server_port = 16801
server      = TCPServer.new server_ip, server_port
loop do
		Thread.start(server.accept) do |client|
				begin
						client.puts "Time is #{Time.now}! TCP server IP #{server_ip},server port #{server_port}"
				ensure
						client.close
				end
		end
end
