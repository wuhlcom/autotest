require 'socket'
p Socket.getaddrinfo("www.baidu.com", "http", nil, :STREAM)
p Socket.ip_address_list
# p Socket.getservbyport(80) #=> "www"
# p Socket.getservbyport(514, "tcp") #=> "shell"
# p Socket.getservbyport(514, "udp") #=> "syslog"
# p Socket.getservbyname("smtp") #=> 25
# p Socket.getservbyname("shell") #=> 514
# p Socket.getservbyname("cmd") #=> 514
# p Socket.getservbyname("syslog", "udp") #=> 514
# p Socket.getnameinfo(Socket.sockaddr_in(80, "127.0.0.1")) #=> ["localhost", "www"]
# p Socket.getnameinfo(["AF_INET", 80, "127.0.0.1"]) #=> ["localhost", "www"]
# p Socket.getnameinfo(["AF_INET", 80, "localhost", "127.0.0.1"]) #=> ["localhost", "www"]
p Socket.gethostname #=> "hal"
#p Socket.new(:INET, :STREAM) # TCP socket
# p Socket.new(:INET, :DGRAM) # UDP socket
# p Socket.new(:UNIX, :STREAM) # UNIX stream socket
# p Socket.new(:UNIX, :DGRAM)  # UNIX datagram socket


# a

def method_missing
	define_method :a, a do |x|
		dddddddd
	end
	super
end

# class Test
# 	# attr_accessor :x
# 	def initialize
# 		@x=1
# 	end
#
# end
# p a = Test.new






