#encoding:utf-8
#TCP server and TCP client,udp serer,udp client
#author:wuhongliang
#time:2015-9-22
#
require 'socket'
require 'net/http'
require 'net/http/server'
require 'pp'
#file_path =File.expand_path('../wincmd', __FILE__)
# require file_path
module HtmlTag
	TCPSERVERPORT = 16801
	UDPSERVERPORT = 15801
	HTTPSERVERPORT= 80
	class TestTcpServer
		# include WinCmd
		def initialize(server_ip=nil, server_port=nil)
			@single_thr  =""
			@server_ip   = server_ip
			@server_port = server_port

			if @server_port.nil? || @server_ip ==""
				@server_ip =ARGV[0]
			end

			if @server_port.nil? || @server_port ==""
				@server_port =ARGV[1]
			end
			@server_port||=TCPSERVERPORT
			fail "[SERVER] TCP Server config error" if (@server_ip.nil?|| @server_ip==""||@server_port.nil?|| @server_port=="")
			puts "[SERVER] Initialize TCP Server #{@server_ip}!"
			@tcp_server = TCPServer.new @server_ip, @server_port
			# run
		end

		#支持多用户，适于ip地址固定长期开启服务
		def multi_run
			loop do
				Thread.start(@tcp_server.accept) do |client|
					begin
						t = Time.now
						puts "[SERVER] TCP server started!"
						puts "[SERVER] TCP server time is #{t}!"
						puts "[SERVER] TCP server address #{@server_ip},port #{@server_port}"
						client.puts "[SERVER] TCP server time is #{t}!"
						client.puts "[SERVER] TCP server IP #{@server_ip},server port #{@server_port}"
						client.puts "[SERVER] TCP client connect to tcp server succeed!"
					ensure
						puts "[SERVER] TCP client disconnect tcp"
						client.close
					end
				end
			end
		end

		def single_run
			loop do
				begin
					t = Time.now
					puts "[SERVER] TCP server started!"
					puts "[SERVER] TCP server time is #{t}!"
					puts "[SERVER] TCP server address #{@server_ip},port #{@server_port}"
					client.puts "[SERVER] TCP server time is #{t}!"
					client.puts "[SERVER] TCP server IP #{@server_ip},server port #{@server_port}"
					client.puts "[SERVER] TCP client connect to tcp server succeed!"
				ensure
					puts "[SERVER] TCP client disconnect tcp"
					client.close
				end
			end
		end

		def simple_run
			begin
				t = Time.now
				puts "[SERVER] TCP server started!"
				puts "[SERVER] TCP server time is #{t}!"
				puts "[SERVER] TCP server address #{@server_ip},port #{@server_port}"
				client.puts "[SERVER] TCP server time is #{t}!"
				client.puts "[SERVER] TCP server IP #{@server_ip},server port #{@server_port}"
				client.puts "[SERVER] TCP client connect to tcp server succeed!"
			ensure
				puts "[SERVER] TCP client disconnect tcp"
				client.close
			end
		end

	end

	class TestTcpClient

		attr_reader :tcp_message, :tcp_state

		def initialize(ip, port, waittime = 5)
			@server_ip   = ip
			@server_port = port
			@server_port ||=TCPSERVERPORT
			@tcp_message =""
			@tcp_state   = true
			sleep waittime #tcp客户端连接前等待waittime 秒
			begin
				@srv_connect = TCPSocket.new @server_ip, @server_port
			rescue => e
				puts e.message.to_s
				@tcp_state=false
			end
			if @srv_connect.kind_of?(TCPSocket)
				connect
			end
		end

		def connect
			begin
				while line = @srv_connect.gets # Read lines from socket
					puts line # and print them
					@tcp_message<<line
				end
			ensure
				puts "[CLIENT] TCP client disconnect tcp"
				@srv_connect.close # close socket when done
			end
		end

	end

	class TestUdpServer

		def initialize(server_ip=nil, server_port=nil, maxlen=512)
			t = Time.now
			puts "[SERVER] Initialize UCP Server!"
			@maxlen = maxlen

			@udp_server_ip   = server_ip
			@udp_server_port = server_port

			if @udp_server_ip.nil? || @udp_server_ip ==""
				@udp_server_ip =ARGV[0]
			end

			if @udp_server_port.nil? || @udp_server_port ==""
				@udp_server_port =ARGV[1]
			end

			@udp_server_port||=UDPSERVERPORT
			fail "[SERVER] UDP server config error" if (@udp_server_ip.nil?|| @udp_server_ip==""||@udp_server_port.nil?|| @udp_server_port=="")
			puts "[SERVER] UDP server started!"
			puts "[SERVER] UDP server ime is #{t}!"
			puts "[SERVER] UDP server address #{@udp_server_ip},port #{@udp_server_port}"
			@udp_server = UDPSocket.new
			@udp_server.bind(@udp_server_ip, @udp_server_port)
			# run
		end

		def run
			loop do
				recieve           = @udp_server.recvfrom_nonblock(@maxlen)
				clientmsg, sender = recieve
				if clientmsg != "0"
					remote_host = sender[3]
					client_port = sender[1]
					puts "[SERVER] UDP server recieved message from udp client #{remote_host}:#{client_port}"
					puts "[SERVER] UDP client message:#{clientmsg}"
					srvmsg ="[SERVER] UDP server connect to client #{remote_host}:#{client_port} succeed!"
					@udp_server.send(srvmsg, 0, remote_host, client_port) #发到指定的用户端口
				end
			end
		end
	end

	class TestUdpClient
		attr_reader :udp_message, :udp_state

		def initialize(clientip, clientport, srvip, srvport, clientmsg="UDP Client", maxlen=512, waittime = 5)
			@udp_message =""
			@maxlen      = maxlen
			unless clientmsg.size<=maxlen
				fail "[CLIENT] UDP client message length must less than maxlen #{maxlen}"
			end
			@udp_client_ip   = clientip
			@udp_client_port = clientport
			@udp_server_ip   = srvip
			@udp_server_port = srvport
			@udp_server_port ||=UDPSERVERPORT
			@udp_state       = true
			@udp_client      = UDPSocket.new
			sleep waittime #tcp客户端连接前等待waittime 秒
			@udp_client.bind(@udp_client_ip, @udp_client_port)
			@clientmsg = clientmsg
			connect
		end

		def connect()
			begin
				@udp_client.send(@clientmsg, 0, @udp_server_ip, @udp_server_port)
				recieve        = @udp_client.recvfrom_nonblock(@maxlen)
				srvmsg, sender = recieve
				remote_host    = sender[3]
				srv_port       = sender[1]
				puts "[CLIENT] UDP client recieved messsage from UDP server #{remote_host}:#{srv_port}!"
				puts "[CLIENT] UDP client get UDP server message:#{srvmsg}"
				@udp_message<<srvmsg
			rescue => e
				puts e.message.to_s
				@udp_state=false
			end
		end
	end

	class TestHttpServer

		def initialize(ip=nil, port=nil, content="Hello World!")
			@http_server_ip   = ip
			@http_server_port = port
			if @http_server_ip.nil? || @http_server_ip ==""
				@http_server_ip =ARGV[0]
			end

			if @http_server_port.nil? || @http_server_port ==""
				@http_server_port =ARGV[1]
			end
			@http_server_port ||= HTTPSERVERPORT
			str               = "[SERVER]  Connected to HTTP server #{@http_server_ip}:#{@http_server_port} succeed!\n#{content}"
			@http_content     = str
			t                 = Time.new
			fail "[SERVER] HTTP server config error" if (@http_server_ip.nil?|| @http_server_ip==""||@http_server_port.nil?|| @http_server_port=="")
			puts "[SERVER] HTTP server started!"
			puts "[SERVER] HTTP server current time is #{t}!"
			puts "[SERVER] HTTP server address #{@http_server_ip},port #{@http_server_port}"
		end

		def run
			Net::HTTP::Server.run(:ip => @http_server_ip, :port => @http_server_port) do |request, stream|
				pp request
				[200, {'Content-Type' => 'text/html'}, [@http_content]]
			end
		end

	end

	class TestHttpClient
		def initialize(ip, page="/", port=80, waittime=2)
			@http_ip  = ip
			@http_page= page
			@http_port= port
			@waittime = waittime
		end

		# Net::HTTP.get('10.10.10.57', '/', "80") # => String
		def get
			sleep @waittime #tcp客户端连接前等待waittime 秒
			Net::HTTP.get(@http_ip, @http_page, @http_port) # => String
		end
	end

	module Socket
		attr_reader :tcp_message, :udp_message, :tcp_srvthr, :udp_srvthr, :http_srvthr

		def self.included(base)
			base.extend(self)
		end

		def tcp_multi_server(ip, port)
			@tcp_srvthr = Thread.new do
				server = TestTcpServer.new(ip, port)
				server.multi_run
				sleep 2
			end
			@tcp_srvthr
		end

		def tcp_simple_server(ip, port)
			@tcp_srvthr = Thread.new do
				server = TestTcpServer.new(ip, port)
				server.simple_run
				sleep 2
			end
			@tcp_srvthr
		end

		def tcp_client(ip, port)
			TestTcpClient.new(ip, port)
		end

		def udp_server(ip, port, maxlenth=512)
			@udp_srvthr = Thread.new do
				TestUdpServer.new(ip, port, maxlenth).run
			end
			@udp_srvthr
		end

		def udp_client(clientip, clientport, srvip, srvport, clientmsg="UDP client", maxlen=512)
			TestUdpClient.new(clientip, clientport, srvip, srvport, clientmsg, maxlen)
		end

		#start server
		#client connect
		def tcp_cs_test(ip, port)
			begin
				thr = Thread.new do
					server = TestTcpServer.new(ip, port)
					server.multi_run
				end
				sleep 2
				client     = TestTcpClient.new(ip, port)
				conn_state = client.tcp_state
			ensure
				thr.kill if thr.alive?
			end
			conn_state
		end

		#start server
		#clinet connect
		def udp_cs_test(cip, cport, srvip, srvport, cmsg="client", maxlen=512)
			begin
				thr = Thread.new do
					HtmlTag::TestUdpServer.new(srvip, srvport, maxlen).run
				end
				sleep 2
				client     = HtmlTag::TestUdpClient.new(cip, cport, srvip, srvport, cmsg, maxlen)
				conn_state = client.udp_state
			ensure
				thr.kill if thr.alive?
			end
			conn_state
		end

		def http_server(ip, port=80, content="Hello World!")
			@http_srvthr =Thread.new do
				TestHttpServer.new(ip, port, content).run
			end
			@http_srvthr
		end

		def http_client(ip, page="/", port=80)
			TestHttpClient.new(ip, page, port).get
		end
	end
end


if __FILE__==$0
	include HtmlTag::Socket
	ip        = "127.0.0.1"
	port      = 15801
	cip       = "127.0.0.1"
	cport     = 15321
	clientmsg = "Client"
	cmsg      = "Test"
	# tcp_cs_test(ip, port)
	p "=*"*70
	udp_cs_test(cip, cport, ip, port, cmsg)
	# t = Thread.new do
	# # HtmlTag::TestUdpServer.new(ip, port).run
	# sleep 2
	# end
	# p udp_server(ip, port)
	# rs = udp_client(cip, cport, ip, port, cmsg)
	# p rs.udp_state
	# t.kill
end