# require 'htmltags'
require 'drb/drb'

SERVER_URI="druby://50.50.50.57:8787"
DRb.start_service
p @tc_wan_drb = DRbObject.new_with_uri(SERVER_URI)
# p @tc_wan_drb.ipconfig
@tc_srv_addr = "30.30.30.84"
@tc_srv_port = "21000"
i            = 1
loop do
		# p @tc_wan_drb.ping(@tc_srv_addr)
		# p rs = @tc_wan_drb.tcp_client(@tc_srv_addr, @tc_srv_port)
		# ip   = "30.30.30.84"
		# port = 21000
		# p rs   = @tc_wan_drb.tcp_client(ip, port)
		# tcp_msg = rs.tcp_message
		# puts "=================Message from TCP server #{i}==============="
		# print tcp_msg
		# # sleep 5

		ip   = "30.30.30.84"
		port = 21000
		p rs = @tc_wan_drb.tcp_client(ip, port)
		print rs.tcp_message
		p rs.tcp_state

		i+=1
		# p rs.tcp_state
		break if i==2
end