#encoding:GBK
p t ="["+Time.new.to_s+"]"
p Time.new.strftime("[%Y-%m-%d %H:%M:%S %Z]")
p Time.new.strftime("%Y%m%d%H%M%S")
###################
# t1 = Time.new
# sleep 3
# t2 = Time.new
# p t2-t1

t1=Time.now
p t1
while line=true # Read lines from socket
		puts line # and print them
		# @tcp_message<<line
		t2=Time.now
		break if t2-t1>10
end
p t2
