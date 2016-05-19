require 'socket'
s1 = UDPSocket.new
s1.bind("127.0.0.1", 0)
s1.addr.values_at(3, 1)
s2 = UDPSocket.new
s2.bind("127.0.0.1", 0)
s2.addr.values_at(3, 1)
s2.connect(*s1.addr.values_at(3, 1))
s1.connect(*s2.addr.values_at(3, 1))
str = "1"*100
p str.size
s1.send str, 0
begin # emulate blocking recvfrom
	p "111111111111111111"
	p s2.recvfrom(100)
	p "222222222222222222"
	# p s2.recvfrom_nonblock(100)
	# p s2.recvfrom_nonblock(100) #=> ["aaa", ["AF_INET", 33302, "localhost.localdomain", "127.0.0.1"]]
rescue IO::WaitReadable
	IO.select([s2])
	retry
end

# a = %w{ a b c qos e f }
# p a.values_at(1, 3, 5)
# a.values_at(1, 3, 5, 7)
# a.values_at(-1, -3, -5, -7)
# a.values_at(1..3, 2...5)
