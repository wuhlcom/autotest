
require 'socket'
UDPSocket.new                   #=> #<UDPSocket:fd 3>
UDPSocket.new(Socket::AF_INET6) #=> #<UDPSocket:fd 4>

s1 = UDPSocket.new
s1.bind("127.0.0.1", 0)
s2 = UDPSocket.new
s2.bind("127.0.0.1", 0)
s2.connect(*s1.addr.values_at(3,1))
s1.connect(*s2.addr.values_at(3,1))
s1.send "aaa", 0
begin # emulate blocking recvfrom
	p s2.recvfrom_nonblock(10)  #=> ["aaa", ["AF_INET", 33302, "localhost.localdomain", "127.0.0.1"]]
rescue IO::WaitReadable
	IO.select([s2])
	retry
end

