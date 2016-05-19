#encoding:utf-8
# 封装的命令
# ipconfig ipconfig/release ipconfig/renew
# netsh wlan
# ping
# netsh interface
# author : wuhongliang
# date   : 2015-6-13
module HtmlTag

		module WinCmd
				#admin
				ENABLED      = "enabled"
				DISABLED     = "disabled"
				NO           = "no"
				YES          = "yes"
				WIRELESSNIC  = "wireless"
				WIREDNIC     = "dut"
				AUTO         = "auto"
				WPA2PSK      = "WPA2PSK"
				DHCP         = "dhcp"
				ADDRESSES    = "addresses"
				CONNECTED    = "connected"
				DISCONNECTED = "disconnected"

				def self.included(base)
						base.extend(self)
				end

				def self.arp_clear
						puts "#{self.to_s}->method_name:#{__method__}"
						`arp -d`
						`arp -d`
				end

				def self.ping(ip, count=5)
						puts "#{self.to_s}->method_name:#{__method__}"
						arp_clear
						`ping -n 2 #{ip}`
						rs = `ping -n #{count} #{ip}`
						print rs
						rs_utf8 = rs.encode("utf-8")
						rs_utf8 =~/\s*\((\d+)\%\s*/
						loss = Regexp.last_match(1)
						if !loss.nil?&&loss.to_i<60
								true
						else
								false
						end
				end

				def ping_default(ip, count=5)
						puts "#{self.to_s}->method_name:#{__method__}"
						arp_clear
						`ping -n 2 #{ip}`
						rs = `ping -n #{count} #{ip}`
						print rs
						rs_utf8 = rs.encode("utf-8")
						rs_utf8 =~/\s*\((\d+)\%\s*/
						loss = Regexp.last_match(1)
						if !loss.nil?&&loss.to_i<60
								true
						else
								false
						end
				end

				def ping_lost_pack(ip, count=5)
						puts "#{self.to_s}->method_name:#{__method__}"
						arp_clear
						`ping -n 2 #{ip}`
						rs = `ping -n #{count} #{ip}`
						print rs
						rs_utf8 = rs.encode("utf-8")
						rs_utf8 =~ /\((\d+)%/i
						lost_pack = $1.to_i
				end

				#普通的ping
				def ping(ip, count=5)
						puts "#{self.to_s}->method_name:#{__method__}"
						arp_clear
						`ping -n 2 #{ip}`
						rs = `ping -n #{count} #{ip}`
						print rs
						rs_utf8 = rs.encode("utf-8")
						rs_utf8 =~/\s*\((\d+)\%\s*/
						loss = Regexp.last_match(1)
						if !loss.nil?&&loss.to_i<60
								true
						else
								false
						end
				end

				#有时网卡会无法获取到ip地址
				#ping不通的情况下会尝试启用和禁用网卡并ip release 和ip renew来刷新ip
				#并会把static改为dhcp
				def ping_dhcp(ip, nicname="dut", count=5)
						puts "#{self.to_s}->method_name:#{__method__}"
						nicname=nicname.downcase
						if ping_default(ip, count)
								result=true
						else
								rs = netsh_if_shif(nicname)
								if rs[:admin_state]=="disabled"
										netsh_if_setif_admin(nicname, ENABLED)
								else
										netsh_if_setif_admin(nicname, DISABLED)
										sleep 2
										netsh_if_setif_admin(nicname, ENABLED)
								end
								sleep 10
								args  ={nicname: nicname, type: "addresses"}
								rs_ip = netsh_if_ip_show(args)
								if rs_ip[:dhcp_state]=="no"
										#启用dhcp
										args1={nicname: nicname, source: "dhcp"}
										netsh_if_ip_setip(args1)
										result = ping_default(ip, count)
								elsif rs_ip[:ip].empty?||rs_ip[:ip][0]=~/^169/
										ip_release(nicname)
										sleep 2
										ip_renew(nicname)
										result = ping_default(ip, count)
								else
										result = ping_default(ip, count)
								end
						end
				end

				#ping检查，ping不通时会禁用/启用网卡，但不会修改网卡的模式(不关注是dhcp还是static)
				def ping_admin(ip, nicname="dut", count=5)
						puts "#{self.to_s}->method_name:#{__method__}"
						nicname=nicname.downcase
						if ping_default(ip, count)
								result=true
						else
								rs = netsh_if_shif(nicname)
								if rs[:admin_state]=="disabled"
										netsh_if_setif_admin(nicname, ENABLED)
								else
										netsh_if_setif_admin(nicname, DISABLED)
										sleep 2
										netsh_if_setif_admin(nicname, ENABLED)
								end
								sleep 10
								result = ping_default(ip, count)
						end
						return result
				end

				#ping检查，ping之前先禁用/启用网卡，但不会修改网卡的模式(不关注是dhcp还是static)
				def ping_admin_operate
						puts "#{self.to_s}->method_name:#{__method__}"
						nicname=nicname.downcase
						rs     = netsh_if_shif(nicname)
						if rs[:admin_state]=="disabled"
								netsh_if_setif_admin(nicname, ENABLED)
						else
								netsh_if_setif_admin(nicname, DISABLED)
								sleep 2
								netsh_if_setif_admin(nicname, ENABLED)
						end
						sleep 10
						result = ping_default(ip, count)
						return result
				end

				# 增加ping_rs，当能ping通给定ip时返回true,
				# 不能ping通给定ip时尝试重新获取ip,再ping给定ip,如果仍不能ping通，
				# 则ping当前网卡网关, 如果能ping通侧返回ip信息的hash,如果网关也不能ping通尝试恢复，两者不能ping通时返回false
				# 当ip无法ping通就会尝试ping gateway,gateway能ping通直接返回hash
				# 会把static改为dhcp
				# ping成功返回罗辑值，
				#    true
				# ping失败返回网卡信息的hash
				#   {:ip=>["172.168.0.101"],
				#    :mask=>["255.255.255.0"],
				#    :dns_server=>[],
				#    :gateway=>["172.168.0.1"],
				#    :dhcp_state=>"yes"}
				def ping_rs(ip, nicname="dut", count=5)
						puts "#{self.to_s}->method_name:#{__method__}"
						nicname      =nicname.downcase
						args_address ={nicname: nicname, type: ADDRESSES}
						args_dhcp    ={nicname: nicname, source: DHCP}
						result       =ping_default(ip, count)
						if result==true
								result=true
						else
								#如果ping不通
								rs_ip = netsh_if_ip_show(args_address)
								#如果为静态ip侧修改为动态ip地址
								if rs_ip[:dhcp_state]==NO
										#启用dhcp
										netsh_if_ip_setip(args_dhcp)
										sleep 5
										result = ping_admin(ip, nicname, count)
										#启用/禁用网卡后，如果不能ping通则返回当网卡ip信息
										unless result
												result = netsh_if_ip_show(args_address)
										end
								else
										#如果已经是dhcp模式,则禁用和启用一下网卡
										#查询网卡是否被禁用
										rs = netsh_if_shif(nicname)
										if rs[:admin_state]==DISABLED
												netsh_if_setif_admin(nicname, ENABLED)
										else
												netsh_if_setif_admin(nicname, DISABLED)
												sleep 2
												netsh_if_setif_admin(nicname, ENABLED)
										end
										sleep 10
										#如能ping通返回true,如果不能ping通则返回当网卡ip信息
										result = ping_default(ip, count)
										unless result
												#启用网卡后查询ip地址情况
												result = netsh_if_ip_show(args_address)
										end
								end
						end
						return result
				end

				#
				#目的
				#  解决dhcp获取地址时网关和ip不在同一网段的问题
				#实现过程
				#   1.检查网卡是否启用,未启用则启用
				#   1.1启用后查看是否断开连接（即是否连网线）
				#   1.1.1如果未连线则返回false
				#   1.1.2如果连线了，判断是否启用dhcp
				#   1.1.2.1如果没有启用dhcp则启用dhcp，再ping
				#   1.1.2.2如果启用了dhcp则直接ping
				#   2.如果网卡启用
				#   2.1查看是否断开连接
				#   2.1.1如果断开则返回false
				#   2.1.2如果连接了，判断是否启用dhcp
				#   2.1.2.1 如果没有启用dhcp则启用dhcp，并判断网关是否跟ip地同一网段，
				#   2.1.2.1.1在同网段，再ping
				#   2.1.2.1.2不在同网段，禁用/启用后再ping
				#   2.1.2.2 如果启用dhcp则启用dhcp，并判断网关是否跟ip地同一网段
				#   2.1.2.2.1在同网段，再ping
				#   2.1.2.2.2不在同网段，禁用/启用后再ping
				# ping失败返回网卡信息的hash
				#   {:ip=>["172.168.0.101"],
				#    :mask=>["255.255.255.0"],
				#    :dns_server=>[],
				#    :gateway=>["172.168.0.1"],
				#    :dhcp_state=>"yes"}
				def ping_recover(ip, nicname="dut", count=5)
						puts "#{self.to_s}->method_name:#{__method__}"
						nicname      =nicname.downcase
						args_address ={nicname: nicname, type: ADDRESSES}
						args_dhcp    ={nicname: nicname, source: DHCP}
						rs_ip        =""
						#查询网卡是否被禁用
						rs           = netsh_if_shif(nicname)
						#如果网卡被初始状态为禁用
						if rs[:admin_state]==DISABLED
								puts "NIC state is disabled"
								#启用网卡
								netsh_if_setif_admin(nicname, ENABLED)
								puts "Enable NIC #{nicname}"
								sleep 10
								#启用后再查询一次查看网卡是否未连线
								puts "After enabled,check #{nicname} state "
								rs1 = netsh_if_shif(nicname)
								#如果网卡是disconnected就是等10后再查询一次
								if rs1[:state]==DISCONNECTED
										sleep 10
										rs = netsh_if_shif(nicname)
								end
								if rs[:state]==DISCONNECTED
										puts "After enabled,NIC is disconneted"
										result=false
								else
										#启用后连接状态正常
										puts "After enabled,NIC is connected"
										rs_ip = netsh_if_ip_show(args_address)
										#如果网卡未开启DHCP
										if rs_ip[:dhcp_state]==NO
												puts "After enabled,NIC dhcp turn off, turn it on!"
												#启用dhcp
												netsh_if_ip_setip(args_dhcp)
										end
										#等待DHCP客户端获取ip
										rs_ip  = wait_for_dhcp_client(args_address)
										#如能ping通返回true,如果不能ping通则返回当网卡ip信息
										result = ping_default(ip, count)
										unless result
												#启用网卡后查询ip地址情况
												result = rs_ip
										end
								end
						else
								puts "NIC state is enabled"
								#如果网卡初始状态为启用
								#如果未连接再等10s，再查询一次
								if rs[:state]==DISCONNECTED
										sleep 10
										rs = netsh_if_shif(nicname)
								end
								if rs[:state]==DISCONNECTED
										puts "NIC is disconneted"
										result=false
								else
										#先查询ip信息
										rs_ip = netsh_if_ip_show(args_address)
										#如果网卡未开启DHCP
										if rs_ip[:dhcp_state]==NO
												puts "NIC dhcp turn off, turn it on!"
												#启用dhcp
												netsh_if_ip_setip(args_dhcp)
												# 等待DHCP客户端获取ip
												rs_ip = wait_for_dhcp_client(args_address)
												#判断网关与ip是否同网段
												rs_ip[:ip][0]=~/(\d{1,3}\.\d{1,3}\.\d{1,3})/
												ip_pre = Regexp.last_match(1)
												if !(rs_ip[:gateway][0]=~/#{ip_pre}/)
														puts "disable and enable NIC"
														#禁用后启用
														netsh_if_setif_admin(nicname, DISABLED)
														sleep 2
														netsh_if_setif_admin(nicname, ENABLED)
														# 等待DHCP客户端获取ip
														rs_ip = wait_for_dhcp_client(args_address)
												end
												result = ping(ip, count)
												#如果不能ping通则返回当网卡ip信息
												unless result
														result = rs_ip
												end
										else
												#如果网卡开启DHCP
												#目前只处理掩码为255.255.255.0的地址，其它暂不考虑
												#在dhcp模式下有时会出现网关与ip不在同一段的情况，导致无法连接路由器，
												#这时要再禁用和启用一次，恢复正常																				
												rs_ip[:ip][0]=~/(\d{1,3}\.\d{1,3}\.\d{1,3})/
												ip_pre = Regexp.last_match(1)
												if rs_ip[:gateway][0]!~/#{ip_pre}/
														puts "disable and enable NIC"
														#禁用后启用
														netsh_if_setif_admin(nicname, DISABLED)
														sleep 2
														netsh_if_setif_admin(nicname, ENABLED)
														# 等待DHCP客户端获取ip
														rs_ip = wait_for_dhcp_client(args_address)
												end

												#如能ping通返回true,如果不能ping通则返回当网卡ip信息
												result = ping_default(ip, count)
												unless result
														#启用网卡后查询ip地址情况
														result = rs_ip
												end
										end #end of 	if rs_ip[:dhcp_state]==NO
								end #end of if rs[:state]==DISCONNECTED
						end #rs[:admin_state]==DISABLED
						return result
				end

				# args_address ={nicname: "dut", type: ADDRESSES}
				def wait_for_dhcp_client(args_address, time=25)
						puts "#{self.to_s}->method_name:#{__method__}"
						rs_ip=""
						3.times { |t|
								puts "Waited for dhcp #{(t+1)*time} seconds......"
								sleep time
								rs_ip = netsh_if_ip_show(args_address)
								rs_ip[:ip][0]=~/^169/ || break
						}
						rs_ip
				end

				def arp_clear
						puts "#{self.to_s}->method_name:#{__method__}"
						`arp -d`
						sleep 1
						`arp -d`
				end

				def arp_show
						puts "#{self.to_s}->method_name:#{__method__}"
						rs = `arp -a`
						print rs
						rs_utf8=rs.encode("utf-8")
				end

				# 以太网适配器 Local:
				#
				# 		 连接特定的 DNS 后缀 . . . . . . . :
				# 		本地链接 IPv6 地址. . . . . . . . : fe80::c01c:5fd7:aae4:241%11
				# IPv4 地址 . . . . . . . . . . . . : 192.168.10.105
				# 子网掩码  . . . . . . . . . . . . : 255.255.255.0
				# IPv4 地址 . . . . . . . . . . . . : 192.168.100.55
				# 子网掩码  . . . . . . . . . . . . : 255.255.255.0
				# 默认网关. . . . . . . . . . . . . : 192.168.10.1
				def parse_ipconfig(str)
						puts "#{self.to_s}->method_name:#{__method__}"
						eth             = "以太网适配器"
						wlan            = "无线局域网适配器"
						tunnel          = "隧道适配器"
						mask            = "子网掩码"
						default_gw      = "默认网关"
						dhcp_rent_get   = "获得租约的时间"
						dhcp_rent_lease = "租约过期的时间"
						dhcp_server     = "DHCP 服务器"
						dhcp_state      = "DHCP 已启用"
						dns_server      = "DNS 服务器"

						ip_mach     ="(\d+\.\d+\.\d+\.\d+)"
						mac         ="物理地址"
						ip_addr     = "IPv4 地址"
						ip_regexp   ='\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
						ipinfo      ={}
						str_notunnel=str.strip.sub(/#{tunnel}.*/m, "")
						unless str_notunnel.nil?
								nics = str_notunnel.split(/#{eth}|#{wlan}/)
								nics.each_index do |index|
										next if index == 0
										info             ={}
										info[:ip]        =[]
										info[:dns_server]=[]
										info[:gateway]   =[]
										nic              = nics[index]
										nic_arr          = nic.strip.split("\n")
										nic_arr.delete("")
										if nic_arr[0]=~/\s*(.+)\:\s*/
												nicname = Regexp.last_match(1).strip.downcase
												nic_arr.each_with_index do |element, i|
														next if i == 0
														element=element.strip
														if element=~/#{mac}.+\s+\:\s+(\w{2}-\w{2}-\w{2}-\w{2}-\w{2}-\w{2})/
																value     = Regexp.last_match(1).strip
																info[:mac]=value unless value.nil?
														elsif element=~/#{ip_addr}.+\:\s*(#{ip_regexp})/
																value = Regexp.last_match(1).strip
																info[:ip]<<value unless value.nil?
														elsif element=~/#{mask}.+\s+\:\s+(\d+\.\d+\.\d+\.\d+)/
																value      = Regexp.last_match(1).strip
																info[:mask]=value unless value.nil?
														elsif element=~/#{dhcp_rent_get}.+\:\s+(.+)/ # 获得租约的时间  . . . . . . . . . : 2015年10月13日 21:31:08
																value           = Regexp.last_match(1).strip
																rented_time_arr = value.scan(/\d+/)
																if rented_time_arr[1].to_i<10 #10月以下的月份前添加字符串0
																		rented_time_arr[1]=("0#{rented_time_arr[1].to_i}")
																end
																if rented_time_arr[2].to_i<10 #小于10的日添加字符串0
																		rented_time_arr[2]=("0#{rented_time_arr[2].to_i}")
																end
																if rented_time_arr[3].to_i<10 #小于10的小时添加字符串0
																		rented_time_arr[3]=("0#{rented_time_arr[3].to_i}")
																end
																rented_time     = rented_time_arr.join("")
																info[:rent_time]=rented_time unless value.nil?
														elsif element=~/#{dhcp_rent_lease}.+\:\s+(.+)/ # 租约过期的时间  . . . . . . . . . : 2015年10月15日 3:31:07
																value           = Regexp.last_match(1).strip
																leased_time_arr = value.scan(/\d+/)
																if leased_time_arr[1].to_i<10
																		leased_time_arr[1]=("0#{leased_time_arr[1].to_i}")
																end
																if leased_time_arr[2].to_i<10
																		leased_time_arr[2]=("0#{leased_time_arr[2].to_i}")
																end
																if leased_time_arr[3].to_i<10
																		leased_time_arr[3]=("0#{leased_time_arr[3].to_i}")
																end
																leased_time      = leased_time_arr.join("")
																info[:lease_time]=leased_time unless value.nil?
														elsif element=~/#{default_gw}.+\:\s+(#{ip_regexp})/
																value = Regexp.last_match(1).strip
																info[:gateway]<<value unless value.nil?
														elsif element=~/\A(#{ip_regexp})\Z/i
																value = Regexp.last_match(1).strip
																info[:dns_server]<<value unless value.nil?
														elsif element=~/#{dns_server}.+\:\s+(#{ip_regexp})/
																value = Regexp.last_match(1).strip
																info[:dns_server]<<value unless value.nil?
														elsif element=~/#{dhcp_server}.+\:\s+(#{ip_regexp})/
																value             = Regexp.last_match(1).strip
																info[:dhcp_server]=value unless value.nil?
														elsif element=~/#{dhcp_state}.+\:\s+(.*)/
																unless Regexp.last_match(1).nil?
																		if Regexp.last_match(1)=~/是/
																				info[:dhcp_state]="yes"
																		else
																				info[:dhcp_state]="no"
																		end
																end
														end #end of if
												end #end of nic_arr.each_with_index do |element, i|
										end #end of if nic_arr[0]=~/\s*(.+)\:\s*/
										ipinfo[nicname]=info
								end
						end
						return ipinfo
				end

				#暂未考虑静态ip的影响
				def ipconfig(args="")
						puts "#{self.to_s}->method_name:#{__method__}"
						if args==""
								cmd = "ipconfig"
						elsif args=="all"
								cmd = "ipconfig /#{args}"
						else
								fail "ipconfig cmd params error,please check!"
						end
						rs = `#{cmd}`
						print rs
						rs_utf8 = rs.to_utf8
						ipinfo  = parse_ipconfig(rs_utf8)
						fail "nic name is not modified,please check it" if ipinfo=={}
						return ipinfo
				end

				#暂未考虑静态ip的影响
				def ip_release(args="")
						no_dhcp_adapter="没有为 DHCP 启用适配器"
						no_relation    ="地址仍未与网络终结点关联"
						puts "#{self.to_s}->method_name:#{__method__}"
						args = args.downcase
						if args==""
								cmd = "ipconfig /release"
								rs  = `#{cmd}`
								print rs
								rs_utf8 = rs.to_utf8
								sleep 5
								if rs_utf8=~/#{no_relation}/
										puts "connect to dhcp server failed"
										return false
								elsif rs_utf8=~/#{no_dhcp_adapter}/
										fail "adapter dhcp function is not enabled"
								end

								rs1 = ipconfig
								if !rs1["dut"].nil? && rs1["wireless"].nil?
										if rs1["dut"][:ip][0].nil? || rs1["dut"][:ip][0]=~/^169/
												return true
										else
												puts "DUT ip addr release failed"
												return false
										end
								elsif rs1["dut"].nil? && !rs1["wireless"].nil?
										if rs1["wireless"][:ip][0].nil? || rs1["wireless"][:ip][0]=~/^169/
												return true
										else
												puts "wireless ip addr release failed"
												return false
										end
								elsif !rs1["dut"].nil? && !rs1["wireless"].nil?
										if (rs1["dut"][:ip][0].nil?||rs1["dut"][:ip][0]=~/^169/) && (rs1["wireless"][:ip][0].nil? ||rs1["wireless"][:ip][0]=~/^169/)
												return true
										elsif (rs1["dut"][:ip][0].nil?||rs1["dut"][:ip][0]=~/^169/) && (!rs1["wireless"][:ip][0].nil?&&rs1["wireless"][:ip][0] !~ /^169/)
												puts "wireless ip addr release failed"
												return false
										elsif (!rs1["dut"][:ip][0].nil?&&rs1["dut"][:ip][0] !~ /^169/) && (rs1["wireless"][:ip][0].nil?||rs1["wireless"][:ip][0]=~/^169/)
												puts "dut ip addr release failed"
												return false
										else
												return true
										end
								else
										return true
								end
						elsif args=~/dut/i || args=~/wireless/i
								cmd = "ipconfig /release *#{args}*"
								rs  = `#{cmd}`
								sleep 5
								print rs
								rs_utf8 = rs.to_utf8

								if rs_utf8=~/#{no_relation}/
										puts "connect to dhcp server failed"
										return false
								elsif rs_utf8=~/#{no_dhcp_adapter}/
										fail "adapter dhcp function is not enabled"
								end

								rs1 =ipconfig()
								if !rs1["dut"].nil?&&(!rs1["dut"][:ip][0].nil?&&rs1["dut"][:ip][0] !~/^169/)
										puts "#{args} ip addr release failed"
										return false
								elsif !rs1["wireless"].nil?&&(!rs1["wireless"][:ip][0].nil?&&rs1["wireless"][:ip][0] !~/^169/)
										puts "#{args} ip addr release failed"
										return false
								else
										return true
								end
						else
								fail "ipconfig release nic name error,please check!"
						end
				end

				#暂未考虑静态ip的影响
				def ip_renew(args="")
						puts "#{self.to_s}->method_name:#{__method__}"
						error           = "已断开媒体连接"
						no_dhcp_adapter = "没有为 DHCP 启用适配器"
						no_relation     = "无法联系 DHCP 服务器"
						args            =args.downcase
						if args==""
								cmd = "ipconfig /renew"
								rs  =`#{cmd}`
								print rs
								rs_utf8 = rs.to_utf8
								fail "disconnected:#{rs_utf8}" if rs_utf8 =~/#{error}/i
								rs1 = parse_ipconfig(rs_utf8)

								if rs_utf8=~/#{no_relation}/
										puts "connect to dhcp server failed"
										return false
								elsif rs_utf8=~/#{no_dhcp_adapter}/
										puts "adapter dhcp function is not enabled"
										return false
								elsif !rs1["dut"].nil? && rs1["wireless"].nil?
										if rs1["dut"][:ip][0].nil? || rs1["dut"][:ip][0]=~/^169/
												puts "DUT ip addr renew failed"
												return false
										else
												return true
										end
								elsif rs1["dut"].nil? && !rs1["wireless"].nil?
										if rs1["wireless"][:ip][0].nil? || rs1["wireless"][:ip][0]=~/^169/
												puts "wireless ip addr renew failed"
												return false
										else
												return true
										end
								elsif !rs1["dut"].nil? && !rs1["wireless"].nil?
										if (rs1["dut"][:ip][0].nil?||rs1["dut"][:ip][0]=~/^169/) && (rs1["wireless"][:ip][0].nil? ||rs1["wireless"][:ip][0]=~/^169/)
												puts "DUT and wireless ip addr renew failed"
												return false
										elsif (rs1["dut"][:ip][0].nil?||rs1["dut"][:ip][0]=~/^169/) && (!rs1["wireless"][:ip][0].nil?&&rs1["wireless"][:ip][0] !~ /^169/)
												puts "DUT ip addr renew failed"
												return false
										elsif (!rs1["dut"][:ip][0].nil?&&rs1["dut"][:ip][0] !~ /^169/) && (rs1["wireless"][:ip][0].nil?||rs1["wireless"][:ip][0]=~/^169/)
												puts "wireless ip addr renew failed"
												return false
										else
												return true
										end
								end
						elsif args=~/dut/i || args=~/wireless/i
								cmd = "ipconfig /renew *#{args}*"
								rs  =`#{cmd}`
								print rs
								rs_utf8 = rs.to_utf8
								fail "disconnected:#{rs_utf8}" if rs_utf8 =~/#{error}/i
								rs1 = parse_ipconfig(rs_utf8)

								if rs_utf8=~/#{no_relation}/
										puts "connect to dhcp server failed"
										return false
								elsif rs_utf8=~/#{no_dhcp_adapter}/
										puts "adapter dhcp function is not enabled"
										return false
								elsif !rs1["dut"].nil? && (!rs1["dut"][:ip][0].nil?&&rs1["dut"][:ip][0]=~/^169/)
										puts "#{args} ip addr ip_renew failed"
										return false
								elsif !rs1["wireless"].nil? && (!rs1["wireless"][:ip][0].nil?&&rs1["wireless"][:ip][0]=~/^169/)
										puts "#{args} ip addr ip_renew failed"
										retrun false
								else
										return true
								end
						else
								fail "ipconfig renew nic name error,please check!"
						end
				end

				def ipconfig_flushdns
						flush_success = "已成功刷新 DNS 解析缓存"
						rs            = ""
						flush_result  =false
						2.times {
								rs = `ipconfig /flushdns`
						}
						rs_utf8=rs.encode("UTF-8")
						if rs_utf8=~/#{flush_success}/im
								flush_result=true
						end
						flush_result
				end

				#show interfacec
				def netsh_wlan_si
						puts "#{self.to_s}->method_name:#{__method__}"
						rs =`netsh wlan show interfaces`
						print rs
						rs_utf8 = rs.to_utf8
				end

				# 名称                   : wireless
				# 描述                   : Atheros 11G USB wireless Network Adapter
				# GUID                   : 03ad312c-3e4c-4843-a684-513a5149d65c
				# 物理地址               : 5c:63:bf:30:95:16
				# 状态                   : 已断开连接
				#
				#---------------------------------------------------------
				#系统上有 1 个接口:

				# 名称                   : wireless
				# 描述                   : Qualcomm Atheros AR9485 wireless Network Adapter
				# GUID                   : a9e73df9-2768-459d-98f9-38146d60734b
				# 物理地址               : 48:5a:b6:7c:82:ae
				# 状态                   : 已连接
				# SSID                   : WIFI_206887
				# BSSID                  : a8:80:38:20:68:86
				# 网络类型               : 结构
				# 无线电类型             : 802.11n
				# 身份验证               : WPA2 - 个人
				# 密码                   : CCMP
				# 连接模式               : 自动连接
				# 信道                   : 11
				# 接收速率(Mbps)         : 150
				# 传输速率 (Mbps)        : 150
				# 信号                   : 86%
				# 		配置文件               : WIFI_206887
				#
				# 承载网络状态  : 不可用
				def parse_wlan_si(rs)
						puts "#{self.to_s}->method_name:#{__method__}"
						no_interface1 = "系统上没有无线接口"
						no_interface2 = "系统上没有此类无线接口"
						fail "no wireless nic found,please check !" if rs=~/#{no_interface1}|#{no_interface2}/
						disconnected  = "已断开连接"
						dis_state     = "disconnected"
						connected     = "已连接"
						conn_state    = "connected"
						name          = "名称" #: wireless
						desc          = "描述" #: Qualcomm Atheros AR9485 wireless Network Adapter
						guid          = "GUID" #: a9e73df9-2768-459d-98f9-38146d60734b
						mac           = "物理地址" #: 48:5a:b6:7c:82:ae
						status        = "状态" #: 已连接
						ssid          = "SSID" #: WIFI_002A11
						bssid         = "BSSID" #: 2c:ad:13:00:1c:4e
						net_type      = "网络类型" #: 结构
						wifi_type     = "无线电类型" #: 802.11n
						au_type       = "身份验证" #: WPA2 - 个人
						pass_type     = "密码" #: CCMP
						conn_type     = "连接模式" #: 自动连接
						channel       = "信道" #: 11
						rx_rate       = "接收速率(Mbps)" #: 150
						tx_rate       = "传输速率 (Mbps)" #: 150
						signal        = "信号" #: 100%
						config        = "配置文件" #: WIFI_002A11
						interfacenum1 = "系统上有"
						interfacenum2 = "个接口"
						rs=~/#{interfacenum1}\s*(\d+)\s*#{interfacenum2}\s*/
						nic_num    = $1.strip unless Regexp.last_match(1).nil?
						nic_name   = ""
						wlan_nic   = {}
						nicinfo    = {}
						interfaces = rs.split(/#{name}/)
						interfaces.each_with_index do |interface, index|
								next if index==0
								interface=interface.strip
								interface=~/#{status}\s*\:\s*(.+)\s*/
								unless Regexp.last_match(1).nil?
										if Regexp.last_match(1)==connected
												current_state=conn_state
										else
												current_state=dis_state
										end
								end
								interface_arr = interface.strip.split("\n")
								interface_arr.delete("")
								if current_state==conn_state
										nicinfo[:status]=current_state
										interface_arr.each_with_index do |intf, _|
												intf=intf.strip
												if intf=~/\A\:\s*(.+)/
														value    = Regexp.last_match(1)
														nic_name = value.strip.downcase unless value.nil?
												elsif intf=~/#{desc}\s*\:\s*(.+)/
														value         = Regexp.last_match(1)
														nicinfo[:desc]=value.strip unless value.nil?
												elsif intf=~/#{guid}\s*\:\s*(\w+\-\w+\-\w+\-\w+\-\w+)/
														value         = Regexp.last_match(1)
														nicinfo[:guid]=value.strip unless value.nil?
												elsif intf=~/#{mac}\s*\:\s*(\w+\:\w+\:\w+\:\w+\:\w+\:\w+)/
														value        = Regexp.last_match(1)
														nicinfo[:mac]=value.strip unless value.nil?
												elsif intf=~/^#{ssid}\s*\:\s*(.+)/
														value         = Regexp.last_match(1)
														nicinfo[:ssid]=value.strip unless value.nil?
												elsif intf=~/^#{bssid}\s*\:\s*(\w{2}\:\w{2}\:\w{2}\:\w{2}\:\w{2}\:\w{2})/
														value          = Regexp.last_match(1)
														nicinfo[:bssid]=value.strip unless value.nil?
												elsif intf=~/#{net_type}\s*\:\s*(.*)/
														unless Regexp.last_match(1).nil?
																value             = Regexp.last_match(1)
																type              = (value =~/结构/ ? "struct" : value)
																nicinfo[:net_type]=type
														end
												elsif intf=~/#{wifi_type}\s*\:\s*(\w+\.\w+)/
														value              = Regexp.last_match(1)
														nicinfo[:wifi_type]=value.strip unless value.nil?
												elsif intf=~/#{au_type}\s*\:\s*(.*)/
														unless Regexp.last_match(1).nil?
																value            = Regexp.last_match(1)
																type             = (value =~/WPA2\s*\-\s*\u4E2A\u4EBA/ ? "WPA2PSK" : value)
																nicinfo[:au_type]=type
														end
														#nicinfo[:au_type]=Regexp.last_match(1).strip unless Regexp.last_match(1).nil?
												elsif intf=~/#{pass_type}\s*\:\s*(\w+)/
														value              = Regexp.last_match(1)
														nicinfo[:pass_type]=value.strip unless value.nil?
												elsif intf=~/#{conn_type}\s*\:\s*(.*)/
														unless Regexp.last_match(1).nil?
																value              = Regexp.last_match(1)
																type               = (value =~/自动连接/ ? "auto" : value)
																nicinfo[:conn_type]=type
														end
												elsif intf=~/#{channel}\s*\:\s*(\d+)/
														value            = Regexp.last_match(1)
														nicinfo[:channel]=value.strip unless value.nil?
												elsif intf=~/#{rx_rate}\s*\:\s*(\w+)/
														value            = Regexp.last_match(1)
														nicinfo[:rx_rate]=value.strip unless value.nil?
												elsif intf=~/#{tx_rate}\s*\:\s*(\w+)/
														value            = Regexp.last_match(1)
														nicinfo[:tx_rate]=value.strip unless value.nil?
												elsif intf=~/#{signal}\s*\:\s*(\w+)/
														value           = Regexp.last_match(1)
														nicinfo[:signal]=value.strip unless value.nil?
												elsif intf=~/#{config}\s*\:\s*(\w+)/
														value           = Regexp.last_match(1)
														nicinfo[:config]=value.strip unless value.nil?
												end #end of if intf=~/\s*:\s*(.+)/
										end #end of interface_arr.each_with_index do |intf, _i|p nicinfo

								else
										nicinfo[:status]=current_state
										interface_arr.each_with_index do |intf, _|
												intf=intf.strip
												if intf=~/\A\:\s*(.+)/
														value    = Regexp.last_match(1)
														nic_name = value.strip.downcase unless value.nil?
												elsif intf=~/#{desc}\s*\:\s*(.+)/
														value          = Regexp.last_match(1)
														nicinfo[:desc] = value.strip unless value.nil?
												elsif intf=~/#{guid}\s*\:\s*(\w+\-\w+\-\w+\-\w+\-\w+)/
														value          = Regexp.last_match(1)
														nicinfo[:guid] = value.strip unless value.nil?
												elsif intf=~/#{mac}\s*\:\s*(\w+\:\w+\:\w+\:\w+\:\w+\:\w+)/
														value         = Regexp.last_match(1)
														nicinfo[:mac] = value.strip unless value.nil?
												elsif intf=~/#{ssid}\s*\:\s*(\w+)/
														value          = Regexp.last_match(1)
														nicinfo[:ssid] = value.strip unless value.nil?
												end #end of if intf=~/\s*:\s*(.+)/
										end #end of interface_arr.each_with_index do |intf, _i|

								end #if current_state==conn_state
								wlan_nic[nic_name]=nicinfo
						end

						return wlan_nic
				end

				def show_interfaces()
						puts "#{self.to_s}->method_name:#{__method__}"
						rs=netsh_wlan_si
						parse_wlan_si(rs)
				end

				#netsh wlan show networks
				def netsh_sn(nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						rs=`netsh wlan show networks interface="#{nicname.downcase}"`
						print rs
						rs_utf8=rs.encode('utf-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
				end

				def parse_sn(rs)
						puts "#{self.to_s}->method_name:#{__method__}"
						no_interface1 = "系统上没有无线接口"
						no_interface2 ="系统上没有此类无线接口"
						fail "no wireless nic found,please check !" if rs=~/#{no_interface1}|#{no_interface2}/
						networks     = rs.strip.split(/SSID/)
						network_type = "Network type" #: 结构
						au_type      ="身份验证" #: WPA2 - 个人
						pass_type    = "加密" #: CCMP
						interface    = "接口名称" #: wireless
						###当前有 38 个网络可见
						networknum1  = "当前有"
						networknum2  = "个网络可见"
						rs=~/#{networknum1}\s*(\d+)\s*#{networknum2}\s*/
						networknum=Regexp.last_match(1).strip
						rs=~/#{interface}\s*\:\s*(.+)\s*/
						interface_name = Regexp.last_match(1).strip.downcase
						wifi_netinfo   ={}
						scaned_netinfo ={}
						networks.each_with_index do |network, index|
								next if index == 0
								network=network.strip
								network=~/(\d+)\s*\:\s*(.*)\s*#{network_type}/
								ssid_index=Regexp.last_match(1)
								ssid      =Regexp.last_match(2)
								unless ssid.nil?
										ssid_name=ssid.strip
										ssid_name="no_ssid_#{ssid_index}" if ssid_name==""
								end

								wifi_netinfo[ssid_name]={}
								nets                   = network.split("\n")
								nets.each_with_index do |net, i|
										next if i==0
										net=net.strip
										if net=~/#{network_type}\s*\:\s*(.*)/
												value                                 =Regexp.last_match(1)
												net_type                              =(value=~/结构/ ? "struct" : value)
												wifi_netinfo[ssid_name][:network_type]=net_type
										elsif net=~/#{au_type}\s*\:\s*(.*)/
												value=Regexp.last_match(1)
												if value=~/WPA2\s*-\s*\u4E2A\u4EBA/
														#\u4E2A\u4EBA->个人的unicode
														authentication_type="WPA2PSK"
												elsif value=~/WPA\s*-\s*\u4E2A\u4EBA/
														#\u4E2A\u4EBA->个人的unicode
														authentication_type="WPAPSK"
												elsif value=~/\u5F00\u653E\u5F0F/
														#开放式 \u5F00\u653E\u5F0F
														authentication_type="open"
												else
														authentication_type=value
												end
												wifi_netinfo[ssid_name][:au_type] = authentication_type
										elsif net=~/#{pass_type}\s*\:\s*(.*)/
												#无 \u65E0
												value                               =Regexp.last_match(1)
												value                               ="none" if value=~/\u65E0/
												wifi_netinfo[ssid_name][:pass_type] = value
										end
								end

								# if network=~/\s*\d+\s*\:\s*(.*)\s*#{network_type}/
								# 	unless Regexp.last_match(1).nil?
								# 		ssid_name=Regexp.last_match(1).strip
								# 		if ssid_name==""
								# 			ssid_name="no_ssid_name#{index}"
								# 		end
								# 	end
								# elsif network=~/\s*#{network_type}\s*\:\s*(.*)\s*/
								# 	value = Regexp.last_match(1)
								# 	network_info[:network_type]= value.strip unless value.nil?
								# elsif network=~/\s*#{au_type}\s*\:\s*(.*)\s*/
								# 	network_info[:au_type]= value.strip unless value.nil?
								# elsif network=~/\s*#{pass_type}\s*\:\s*(.*)\s*/
								# 	network_info[:pass_type]= value.strip unless value.nil?
								# elsif network_ssid[ssid_name]=network_info
								# 	wifi_network[interface_name]=network_ssid
								# end
						end
						scaned_netinfo[interface_name]=wifi_netinfo
						return scaned_netinfo
				end

				def show_networks(nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						rs = netsh_sn(nicname.downcase)
						parse_sn(rs)
				end

				#add profile
				#"已将配置文件 WIFI_002A11 添加到接口 wireless。\n"
				def netsh_ap(path, nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						rs = `netsh wlan add profile filename="#{path}" interface="#{nicname.downcase}"`
						print rs
						rs    = rs.to_utf8
						result="已将配置文件"
						if rs=~/#{result}/
								return true
						else
								puts rs
								return false
						end
				end

				# netsh wlan delete profile name="*" interface="wireless"
				def netsh_dp(profile_name, nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						result= "删除配置文件"
						rs    =`netsh wlan delete profile name="#{profile_name}" interface="#{nicname.downcase}"`
						print rs
						rs = rs.to_utf8
						if rs=~/#{result}/
								return true
						else
								puts rs
								return false
						end
				end

				#删除所有
				def netsh_dp_all
						puts "#{self.to_s}->method_name:#{__method__}"
						succ= "删除配置文件"
						fail="找不到配置文件"
						rs  =`netsh wlan delete profile name="*"`
						print rs
						rs = rs.to_utf8
						if rs=~/#{succ}/
								return true
						else
								puts rs
								return false
						end
				end

				#删除部分
				def netsh_dp_some(profile_profix, nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						result= "删除配置文件"
						rs    =`netsh wlan delete profile name="*#{profile_profix}*" interface="#{nicname.downcase}"`
						print rs
						rs = rs.to_utf8
						if rs=~/#{result}/
								return true
						else
								puts rs
								return fase
						end
				end

				#show profiles
				def netsh_sp(nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						# `netsh wlan show profiles`
						rs = `netsh wlan show profiles interface="#{nicname.downcase}"`
						print rs
						rs = rs.to_utf8
				end

				def parse_sp(rs)
						no_interface1 = "系统上没有无线接口"
						no_interface2 ="系统上没有此类无线接口"
						interface1    ="接口"
						interface2    ="上的配置文件"
						config_head   = "所有用户配置文件"
						fail "no wireless nic find!" if rs=~/#{no_interface1}|#{no_interface2}/
						rs=~/\s*#{interface1}\s*(.+)\s*#{interface2}\s*\:/
						interface_name = Regexp.last_match(1).strip.downcase
						configs        = rs.split(/#{config_head}/)
						config_info    ={}
						config_files   =[]
						configs.each_index { |index|
								next if index==0
								config=configs[index]
								config=~/\s*\:\s*(.+)\s*/
								config_files<<Regexp.last_match(1).strip
						}
						config_info[interface_name]=config_files
						return config_info
				end

				def show_profiles(nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						rs= netsh_sp(nicname.downcase)
						parse_sp(rs)
				end

				# netsh wlan show profiles interface="#{nicname}"
				#netsh wlan show profiles name=#{config_name} key=clear interface="#{nicname}
				def netsh_sp_detail(config_name, nicname="wireless")
						rs =`netsh wlan show profiles name=#{config_name} key=clear interface="#{nicname.downcase}"`
						print rs
						rs = rs.to_utf8
				end

				def parse_sp_detail(rs)

				end

				# netsh wlan  connect name="WIFI_002A11" ssid="WIFI_002A11"
				# netsh wlan  connect name="WIFI_002A11" ssid="WIFI_002A11" interface="wireless"
				# netsh wlan  connect name="WIFI_002A11" interface="wireless"
				# parameter
				# -profile_name ,这里要传入配置文件名是指密码配置文件中的name属性值，通常是路由器SSID，而不是密码文件的名字
				def netsh_conn(profile_name, nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						result= "已成功完成连接请求"
						rs    = `netsh wlan connect name="#{profile_name}" interface="#{nicname.downcase}"`
						print rs.to_gbk
						rs_utf8 = rs.to_utf8
						if rs_utf8 =~ /#{result}/
								return true
						else
								puts "连接失败：#{rs_utf8}".to_gbk
								return false
						end
				end

				# disconnect
				# disconnect interface="wireless Network Connection"
				def netsh_disc(nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						rs = `netsh wlan disconnect interface="#{nicname.downcase}"`
						print rs
						rs     = rs.to_utf8
						result ="已成功完成接口"
						if rs=~/#{result}/
								return true
						else
								puts "Disconnect failed or not connected"
								return false
						end
				end

				def netsh_disc_all
						puts "#{self.to_s}->method_name:#{__method__}"
						rs     = `netsh wlan disconnect`
						result ="已成功完成接口"
						print rs
						rs = rs.to_utf8
						if rs=~/#{result}/
								return true
						else
								puts "Disconnect failed or not connected"
								return false
						end
				end

				def netsh_disc_some(nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						rs = `netsh wlan disconnect interface="*#{nicname.downcase}*"`
						print rs
						rs     = rs.to_utf8
						result ="已成功完成接口"
						if rs=~/#{result}/
								return true
						else
								puts "Disconnect failed or not connected"
								return false
						end
				end

				# set autoconfig [enabled=]yes|no [interface=]<string>
				def netsh_sa(flag="yes", nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						rs = `netsh wlan set autoconfig enabled=#{flag} interface="#{nicname.downcase}"`
						print rs
						rs_utf8 = rs.to_utf8
				end

				# set profileparameter [name=]<string> [[interface=]<string>]
				# [SSIDname=<string>] [ConnectionType=ESS|IBSS] [autoSwitch=yes|no]
				# [ConnectionMode=auto|manual] [nonBroadcast=yes|no]
				# [authentication=open|shared|WPA|WPA2|WPAPSK|WPA2PSK]
				# [encryption=none|WEP|TKIP|AES] [keyType=networkKey|passphrase]
				# [keyIndex=1-4] [keyMaterial=<string>] [PMKCacheMode=yes|no]
				# [PMKCacheSize=1-255] [PMKCacheTTL=300-86400] [preAuthMode=yes|no]
				# [preAuthThrottle=1-16 [FIPS=yes|no]
				# [useOneX=yes|no] [authMode=machineOrUser|machineOnly|userOnly|guest]
				# [ssoMode=preLogon|postLogon|none] [maxDelay=1-120]
				# [allowDialog=yes|no] [userVLAN=yes|no]
				# [heldPeriod=1-3600] [AuthPeriod=1-3600] [StartPeriod=1-3600]
				# [maxStart=1-100] [maxAuthFailures=1-100] [cacheUserData = yes|no]
				#change pw
				#修改加密连接的密码
				def netsh_modify_pass(profile_name, passwd, ssid="", nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						if ssid==""
								rs =`netsh wlan  set  profileparameter name="#{profile_name}" SSIDname="#{ssid}" interface="#{nicname.downcase}" KeyMaterial="#{passwd}"`
						else
								rs =`netsh wlan  set  profileparameter name="#{profile_name}" interface="#{nicname.downcase}" KeyMaterial="#{passwd}"`
						end
						print rs
						rs     = rs.to_utf8
						result ="已成功更新"
						if rs=~/#{result}/
								return true
						else
								print rs
								puts "Update profile failed"
								return false
						end
				end

				#使用不加密方式连接
				def netsh_set_none(profile_name, ssid="", nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						if ssid==""
								rs = `netsh wlan set profileparameter name="#{profile_name}" authentication="open" encryption="none" interface="#{nicname.downcase}"`
						else
								rs = `netsh wlan set profileparameter name="#{profile_name}" SSIDname="#{ssid}" authentication="open" encryption="none" interface="#{nicname.downcase}"`
						end
						print rs
						rs     = rs.to_utf8
						result ="已成功更新"
						if rs=~/#{result}/
								return true
						else
								puts "Update profile failed"
								return false
						end
				end

				#将空密码的设置为WAP2-psk,aes,方式加密
				def netsh_modify_none_pass(profile_name, passwd, ssid="", nicname="wireless")
						puts "#{self.to_s}->method_name:#{__method__}"
						if ssid==""
								rs =`netsh wlan  set  profileparameter name="#{profile_name}" interface="#{nicname.downcase}" authentication="WPA2PSK" encryption="AES" keyType="passphrase" KeyMaterial="#{passwd}"`
						else
								rs =`netsh wlan  set  profileparameter name="#{profile_name}" SSIDname="#{ssid}" interface="#{nicname.downcase}" authentication="WPA2PSK" encryption="AES" keyType="passphrase" KeyMaterial="#{passwd}"`
						end
						print rs
						rs     = rs.to_utf8
						result ="已成功更新"
						if rs=~/#{result}/
								return true
						else
								print rs
								puts "Update profile failed"
								return false
						end
				end

				#netsh interface set interface name="new" newname="dut"
				def netsh_if_setname(old_name, new_name)
						puts "#{self.to_s}->method_name:#{__method__}"
						`netsh interface set interface name="#{old_name}" newname="#{new_name}"`
				end

				#netsh interface show interface
				#查询网卡启用和禁用状态
				def netsh_if_shif(args="")
						puts "#{self.to_s}->method_name:#{__method__}"
						admin_state1="已启用"
						admin_state2="已禁用"
						state1      ="已连接"
						state2      ="已断开连接"
						type        ="专用"
						nonic       ="此名称的接口未与路由器一起注册"
						nic_state   ={}

						if args != ""
								# 我------------------>（网卡名）
								# 种类:     专用
								# 管理状态: 已启用
								# 连接状态: 已断开连接
								args_GBK=args.encode("GBK")
								rs      = `netsh interface show interface "#{args_GBK}"`
								print rs
								rs_utf8      =rs.strip.encode("utf-8")
								# railse "no nic found!" if rs_utf8=~/#{nonic}/
								nic_arr_utf8 = rs_utf8.strip.encode("utf-8").split("\n")

								if nic_arr_utf8[1]=~/#{type}/
										card_type="dedicated"
								else
										card_type=nic_arr_utf8[1]
								end

								if nic_arr_utf8[2]=~/#{admin_state1}/
										admin_state="enabled"
								elsif nic_arr_utf8[2]=~/#{admin_state2}/
										admin_state="disabled"
								else
										admin_state= nic_arr_utf8[2]
								end

								if nic_arr_utf8[3]=~/#{state1}/
										state="connected"
								elsif nic_arr_utf8[3]=~/#{state2}/
										state="disconnected"
								else
										state=nic_arr_utf8[3]
								end
								#nic_state[nic_arr_utf8[0].strip]={:admin_state => admin_state, :state => state, :type => card_type}
								#这样处理当只有唯一一个nic_arr_utf8[0]时，nic_state最终会返回如下
								#{:admin_state=>"enabled", :state=>"connected", :type=>"dedicated"}
								#而不是返回以下这种结构，但这里还是不使用这种用法以免产生理解上的歧义
								#{"dut"=>{:admin_state=>"enabled", :state=>"connected", :type=>"dedicated"}}
								nic_state={:admin_state => admin_state, :state => state, :type => card_type}
						else
								#查询所有网卡
								# 管理员状态     状态           类型             接口名称
								# -------------------------------------------------------------------------
								# 已启用            已连接            专用               Local
								# 已启用            已断开连接          专用               wireless
								# 已禁用            已断开连接          专用               VMware Network Adapter VMnet1
								# 已禁用            已断开连接          专用               VMware Network Adapter VMnet8
								# 已启用            已断开连接          专用               我

								rs = `netsh interface show interface`
								print rs
								#转码
								rs_utf8 = rs.encode("utf-8")
								#去除和两头空白（\n）-----------------
								rs_utf8 =rs_utf8.strip.gsub(/\n-+\n/, "\n")

								rs_utf8_arr=rs_utf8.split("\n")
								rs_utf8_arr.each_with_index { |nic, index|
										next if index==0

										m    =/(\p{Han}+)\s+(\p{Han}+)\s+(\p{Han}+)\s+(\p{Han}+|\w+)\s*/u.match(nic)
										m_arr=m.captures

										if m_arr[0]=~/#{admin_state1}/
												admin_state="enabled"
										elsif m_arr[0]=~/#{admin_state2}/
												admin_state="disabled"
										else
												admin_state= m_arr[0]
										end

										if m_arr[1]=~/#{state1}/
												state="connected"
										elsif m_arr[1]=~/#{state2}/
												state="disconnected"
										else
												state=m_arr[1]
										end

										if m_arr[2]=~/#{type}/
												card_type="dedicated"
										else
												card_type=m_arr[2]
										end
										nic_state[m_arr.last.downcase]={admin_state: admin_state, state: state, type: card_type}
								}
								return nic_state
						end
				end

				#启用或禁用网卡
				#set interface name="Local Area Connection" admin=DISABLED
				#set interface name="Local Area Connection" newname="Connection 1"
				def netsh_if_setif_admin(nic_name, state)
						puts "#{self.to_s}->method_name:#{__method__}"
						nonic1        ="系统找不到指定的文件"
						nonic2        ="此名称的接口未与路由器一起注册"
						phy_disconnect="此网络连接不存在" #网线被拔
						/disabled|enabled/i =~state || fail("parameter errors:state error!")
						nic_name_gbk=nic_name.downcase.encode("GBK")
						rs          = `netsh interface set interface name="#{nic_name_gbk}" admin="#{state}"`
						rs_utf8     =rs.strip.encode("utf-8")
						sleep 2
						return true if rs_utf8==""
				end

				#设置网卡模式为DHCP或Static
				#可配置静态ip
				#ip地址唯一
				#netsh interface ipv4 set address name="dut" source="dhcp"
				#netsh interface ipv4 set address name="dut" source="static" 10.0.0.2 255.0.0.0 10.0.0.1
				def netsh_if_ip_setip(args)
						puts "#{self.to_s}->method_name:#{__method__}"
						dhcp_result ="已在此接口上启用 DHCP"
						nic_name    = args[:nicname].downcase
						nic_name_gbk=nic_name.encode("GBK")
						source      = args[:source]
						ip_adrr     = args[:ip]
						mask        = args[:mask]
						gw          = args[:gateway]
						rs          = if source=~/^dhcp$/i
								              puts "set nic '#{nic_name_gbk}' dhcp mode".encode("GBK")
								              `netsh interface ipv4 set address name="#{nic_name_gbk}" source="#{source}"`
								          elsif source=~/^static$/i
										          puts "set nic '#{nic_name_gbk}' static mode".encode("GBK")
										          `netsh interface ipv4 set address name="#{nic_name_gbk}" source="#{source}" #{ip_adrr} #{mask} #{gw}`
								          else
										          fail "ip source mode error!"
						              end
						print rs
						#等待ip地址生效
						sleep 10
						rs_utf8 =rs.strip.encode("utf-8")
						return true if rs_utf8=="" || rs_utf8=~/#{dhcp_result}/i
				end

				#netsh interface ipv4 set dnsservers name="wireless" source="static" address="none" register="primary"
				#netsh interface ipv4 set dnsservers name="wireless" source="static" address="8.8.8.8" register="primary"
				#netsh interface ipv4 set dnsservers name="wireless" source="dhcp" register="primary"
				def netsh_if_ip_setdns(args)
						puts "#{self.to_s}->method_name:#{__method__}"
						nonedns        ="该计算机上没有配置域名服务器(DNS)"
						nic_name       = args[:nicname].downcase
						nic_name_gbk   =nic_name.encode("GBK")
						source         = args[:source]
						dns_addr       = args[:dns_addr]
						# args[:register]="primary" if args[:register].nil?
						args[:register]||="primary"
						register       =args[:register]

						rs     = if source=~/\Adhcp\z/i
								         r `netsh interface ipv4 set dnsservers name="#{nic_name_gbk}" source="#{source}" register="#{register}"`
								     elsif source=~/\Astatic\z/i
										     #dns_addr=="none"表未取消dns设置
										     `netsh interface ipv4 set dnsservers name="#{nic_name_gbk}" source="#{source}"  address="#{dns_addr}" register="#{register}"`
								     else
										     fail "dns source mode error!"
						         end
						rs_utf8=rs.strip.encode("utf-8")
						if rs_utf8==""
								return true
						elsif rs_utf8=~/#{nonedns}/
								puts "清除静态DNS设置".encode("GBK")
								return true
						else
								fail "Set dns server error!"
						end
				end

				def netsh_if_ip_setip_dns(args)
						puts "#{self.to_s}->method_name:#{__method__}"
						netsh_if_ip_setip(args)
						netsh_if_ip_setdns(args)
				end

				# add address "Local Area Connection" 10.0.0.2  255.0.0.0
				# netsh interface ipv4 add address name="wireless" address="192.168.10.4" mask="255.255.255.0" gateway="192.168.10.1"
				# add address "Local Area Connection" gateway=10.0.0.3 gwmetric=2
				def netsh_if_ip_ipadd(args)
						puts "#{self.to_s}->method_name:#{__method__}"
						ip_error     = "对象已存在"
						nic_name     = args[:nicname].downcase
						nic_name_gbk = nic_name.encode("GBK")
						ip           = args[:ip]
						mask         = args[:mask]
						gw           = args[:gateway]
						nic_name || fail("nicname error！")
						rs     = if ip && mask && gw.nil?
								         `netsh interface ipv4 add address name="#{nic_name_gbk}" address="#{ip}" mask="#{mask}"`
								     elsif ip.nil? && mask.nil? && gw
										     `netsh interface ipv4 add address name="#{nic_name_gbk}" gateway="#{gw}"`
								     elsif ip && mask && gw
										     `netsh interface ipv4 add address name="#{nic_name_gbk}" address="#{ip}" mask="#{mask}" gateway="#{gw}"`
								     else
										     fail("ip,mask or gw error！")
						         end
						rs_utf8=rs.strip.encode("utf-8")
						rs_utf8 == "" && true
						/#{ip_error}/ =~ /#{rs_utf8}/ && fail("ip地址重复或同网段".encode("GBK"))
				end

				#netsh interface ipv4 delete address name="wireless" address="192.168.110.6"
				#netsh interface ipv4 delete address name="wireless" address="192.168.110.6" gateway="192.168.10.1"
				#netsh interface ipv4 delete address name="wireless" address="192.168.110.6" gateway="all"
				def netsh_if_ip_ipdel(args)
						puts "#{self.to_s}->method_name:#{__method__}"
						nic_name     = args[:nicname].downcase
						nic_name_gbk = nic_name.encode("GBK")
						ip           = args[:ip]
						gw           = args[:gateway]
						nic_name || fail("nicname error！")
						# netsh interface ipv4 delete address name="wireless" address="192.168.110.6" gateway="192.168.10.1"
						rs      = if ip && gw.nil?
								          `netsh interface ipv4 delete address name="#{nic_name_gbk}" address="#{ip}"`
								      elsif ip.nil? && gw
										      `netsh interface ipv4 delete address name="#{nic_name_gbk}" gateway="#{gw}"`
								      elsif ip && gw
										      `netsh interface ipv4 delete address name="#{nic_name_gbk}" address="#{ip}" gateway="#{gw}"`
						          end
						rs_utf8 = rs.strip.encode("utf-8")
						rs_utf8 == "" && true
				end

				# netsh interface ipv4 add  dnsservers name="wireless" address="2.2.2.2" index=1
				def netsh_if_ip_dnsadd(args)
						puts "#{self.to_s}->method_name:#{__method__}"
						dns_error   = "配置的 DNS 服务器不正确或不存在"
						nic_name    = args[:nicname].downcase
						nic_name_gbk=nic_name.encode("GBK")
						dns         = args[:dns_server]
						index       = args[:index]
						nic_name || fail("nicname error！")
						rs      = if index
								          `netsh interface ipv4 add  dnsservers name="#{nic_name_gbk}" address="#{dns}" index=#{index}`
								      else
										      `netsh interface ipv4 add  dnsservers name="#{nic_name_gbk}" address="#{dns}"`
						          end
						rs_utf8 = rs.strip.encode("utf-8")
						rs_utf8 == "" && true
						/#{dns_error}/ =~ /#{rs_utf8}/ && fail("DNS地址错误".encode("GBK"))
				end

				# delete dnsservers "Local Area Connection" 10.0.0.1
				# delete dnsservers "Local Area Connection" all
				def netsh_if_ip_dnsdel(args)
						puts "#{self.to_s}->method_name:#{__method__}"
						nic_name          = args.fetch(:nicname).downcase
						nic_name_gbk      =nic_name.encode("GBK")
						args[:dns_server] = "all" if args[:dns_server].nil?
						dns               = args.fetch(:dns_server)
						rs                = `netsh interface ipv4 delete dnsservers name="#{nic_name_gbk}" address="#{dns}"`
						rs_utf8           = rs.strip.encode("utf-8")
						rs_utf8 == "" && true
				end

				#netsh interface ipv4 show config name="wireless"
				#netsh interface ipv4 show addresses name ="wireless"
				def netsh_if_ip_show(args)
						puts "#{self.to_s}->method_name:#{__method__}"
						ip_flag         = "IP 地址"
						mask_flag       = "掩码"
						dns_flag_static = "静态配置的 DNS 服务器"
						dns_flag_dhcp   = "通过 DHCP 配置的 DNS 服务器"
						dhcp_flag       = "DHCP 已启用"
						gw_flag         = "默认网关"
						nic_name        = args.fetch(:nicname).downcase
						nic_name_gbk    = nic_name.encode("GBK")
						args[:type]     ="config" if args[:type].nil?
						type            = args.fetch(:type)
						type=~/\Aconfig|addresses|dnsservers\Z/i || fail("show type error!")
						ip_info             ={}
						ip_info[:ip]        =[]
						ip_info[:mask]      =[]
						ip_info[:dns_server]=[]
						ip_info[:gateway]   =[]
						rs                  = if type=~/\Aconfig\Z/
								                      `netsh interface ipv4 show config name="#{nic_name_gbk}"`
								                  elsif type=~/\Aaddresses\Z/
										                  `netsh interface ipv4 show addresses name="#{nic_name_gbk}"`
								                  elsif type=~/\Adnsservers\Z/
										                  `netsh interface ipv4 show dnsservers name="#{nic_name_gbk}"`
						                      end
						print rs
						rs_utf8    =rs.strip.encode("utf-8")
						ip_add_arr = rs_utf8.split("\n")
						ip_add_arr.delete("")
						ip_regexp = '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
						ip_add_arr.each_with_index do |ip, _index|
								ip=ip.strip
								if ip=~/#{dhcp_flag}\s*\:\s+(.+)/
										unless Regexp.last_match(1).nil?
												if Regexp.last_match(1)=~/是/
														ip_info[:dhcp_state]="yes"
												else
														ip_info[:dhcp_state]="no"
												end
										end
										# ip_info[:dhcp_state]=Regexp.last_match(1)
								elsif ip=~/#{ip_flag}\s*\:\s*(#{ip_regexp})/
										ip_info[:ip]<< Regexp.last_match(1)
								elsif ip=~/#{mask_flag}\s*(#{ip_regexp})/
										ip_info[:mask]<< Regexp.last_match(1)
								elsif ip=~/#{gw_flag}\s*\:\s*(#{ip_regexp})/
										ip_info[:gateway]<< Regexp.last_match(1)
								elsif ip=~/[#{dns_flag_static}|#{dns_flag_dhcp}]\s*\:\s*(#{ip_regexp})/
										ip_info[:dns_server]<< Regexp.last_match(1)
								elsif ip.strip=~/^(#{ip_regexp})$/
										ip_info[:dns_server]<< Regexp.last_match(1)
								end
						end
						ip_info
				end

				#获取本地计算机名
				def get_host_name
						rs = `hostname`.strip
						return rs.encode("UTF-8")
				end

				#PC上超过三张网卡，两张有线，一张无线
				#无论有线还是无线网卡，禁用标记为false，启用标记为true
				#一台业务PC上至少安装两一张有线网卡用于控制一张无线网卡用作无线客户端
				#禁用非管理的有线网卡启用无线网卡
				def enable_wireless_nic
						nicstate     = netsh_if_shif
						enabled      = "enabled"
						disabled     = "disabled"
						wirless_flag = true
						wired_flag   = false
						if nicstate.keys.size>2
								#禁用有线网卡，启用无线网卡
								nicstate.each { |key, value|
										next if key=~/control/i
										if key=~/wireless/i
												if value[:admin_state]==disabled
														netsh_if_setif_admin(key, enabled)
												end
										else
												if value[:admin_state]==enabled
														netsh_if_setif_admin(key, disabled)
												end
										end
								}
								#操作后查询网卡状态
								new_nicstate = netsh_if_shif
								#判断无线网卡状态
								new_nicstate.each { |key, value|
										next if key !~ /wireless/i
										if value[:admin_state]==disabled
												wirless_flag=false #如果无线网卡处于禁用状态则标为false，启用状态则标为true
												break
										end
								}

								#判断有线网卡状态
								new_nicstate.each { |key, value|
										next if key=~/control|wireless/i
										if value[:admin_state]==enabled
												wired_flag=true #如果有线网卡处于禁用状态则标为false，启用状态则标为true
												break
										end
								}
								flag= wirless_flag && !wired_flag #无线启用，有线禁用返回true
						else
								if nicstate.keys.any? { |key| key=~/wireless/i }
										puts "NO wireless NIC found"
										wirless_flag=false
								else
										nicstate.each { |key, value|
												next if key=~/control/i
												if key=~/wireless/i
														if value[:admin_state]==disabled
																netsh_if_setif_admin(key, enabled)
														end
												end
										}
										#查询网卡状态
										new_nicstate = netsh_if_shif
										new_nicstate.each { |key, value|
												next if key !~ /wireless/i
												if value[:admin_state]==disabled
														wirless_flag=false
														break
												end
										}
										flag= wirless_flag
								end
						end
						return flag
				end

				#启用有线网卡
				def enable_wired_nic
						nicstate     = netsh_if_shif
						enabled      = "enabled"
						disabled     = "disabled"
						wirless_flag = false
						wired_flag   = true
						if nicstate.keys.size>2
								#禁用无线网卡，启用有线网卡
								nicstate.each { |key, value|
										next if key=~/control/i
										if key=~/wireless/i
												if value[:admin_state]==enabled
														netsh_if_setif_admin(key, disabled)
												end
										else
												if value[:admin_state]==disabled
														netsh_if_setif_admin(key, enabled)
												end
										end
								}
								#操作后查询状态
								new_nicstate = netsh_if_shif
								new_nicstate.each { |key, value|
										next if key=~/control/i
										if key=~/wireless/
												if value[:admin_state]==enabled
														wirless_flag=true
														break
												end
										end
								}
								new_nicstate.each { |key, value|
										next if key=~/control|wireless/i
										if value[:admin_state]==disabled
												wired_flag=false
												break
										end
								}
								flag= !wirless_flag&&wired_flag
						else
								key_arr     = nicstate.keys
								new_key_arr = key_arr.delete_if { |key| key=~/control|wireless/i }
								if new_key_arr.empty?
										puts "NO extra wired NIC found!"
										wired_flag = false
								else
										nicstate.each { |key, value|
												next if key=~/control|wireless/i
												if value[:admin_state]==disabled
														netsh_if_setif_admin(key, enabled)
												end
										}
										new_nicstate.each { |key, value|
												next if key=~/control|wireless/i
												if value[:admin_state]==disabled
														wired_flag=false
														break
												end
										}
								end
								flag= wired_flag
						end
						return flag
				end

		end
end

