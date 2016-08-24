#encoding:utf-8
require 'pp'
require 'htmltags'
class Netstat
	def packet_statics
		rs      = `netstat -e`
		rs_utf8 = rs.encode("UTF-8")
		parse_statics(rs_utf8)
	end

	def parse_statics(rs_utf8)
		byte         = "字节"
		unicast      = "单播数据包"
		multicast    = "非单播数据包"
		drop         = "丢弃"
		errors       = "错误"
		statics_hash ={}
		statics_arr  =rs_utf8.split("\n")
		statics_arr.delete("")
		statics_arr.each do |statics|
			statics=statics.strip
			case statics
				when /#{byte}/
					statics_byte       = statics.split(" ")
					statics_hash[:byte]={recieved: statics_byte[1].strip, send: statics_byte[2].strip}
				when /#{unicast}/
					statics_unicast       = statics.split(" ")
					statics_hash[:unicast]={recieved: statics_unicast[1].strip, send: statics_unicast[2].strip}
				when /#{multicast}/
					statics_multicast       = statics.split(" ")
					statics_hash[:multicast]={recieved: statics_multicast[1].strip, send: statics_multicast[2].strip}
				when /#{drop}/
					statics_drop       = statics.split(" ")
					statics_hash[:drop]={recieved: statics_drop[1].strip, send: statics_drop[2].strip}
				when /#{errors}/
					statics_errors       = statics.split(" ")
					statics_hash[:errors]={recieved: statics_errors[1].strip, send: statics_errors[2].strip}
			end
		end
		statics_hash
	end

	#字节
	def byte_bandwith(time=10)
		puts "Start time #{Time.new}"
		start = packet_statics
		sleep time
		puts "Finished time #{Time.new}"
		finish = packet_statics
	p	start[:byte][:recieved]
		start[:byte][:send]
	p	finish[:byte][:recieved]
		finish[:byte][:send]
		recived_value = finish[:byte][:recieved].to_i-start[:byte][:recieved].to_i
		send_value    = finish[:byte][:send].to_i-start[:byte][:send].to_i
		#Byte/s
		recived_speed = recived_value.to_f/time
		recived_speed = recived_speed.roundf(2) #保留两位小数，四舍五入
		#Byte/s
		send_speed    = send_value.to_f/time
		send_speed    = send_speed.roundf(2) #保留两位小数，四舍五入
		{rx_value: recived_value, rx_speed: recived_speed, tx_speed: send_speed, tx_value: send_value}
	end
end
# pp Netstat.new.packet_statics
rs = Netstat.new.byte_bandwith(10)
#KB/s
speed = rs[:rx_speed]
p speed/1024
