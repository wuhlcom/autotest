# encoding:utf-8
# ipconfig,net config rdr,netsh interface ip admin
module WinCmd

		def self.included(base)
				base.extend(self)
		end

# 以太网适配器 Local:
#
# 连接特定的 DNS 后缀 . . . . . . . :
# 本地链接 IPv6 地址. . . . . . . . : fe80::c01c:5fd7:aae4:241%11
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
				nic_desc        = "描述"

				ip_mach     ="(\d+\.\d+\.\d+\.\d+)"
				mac         ="物理地址"
				ip_addr     = "IPv4 地址"
				ip_regexp   ='\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
				ipinfo      ={}
				str_notunnel=str.strip.sub(/#{tunnel}.*/m, "")
				nics        = str_notunnel.split(/#{eth}|#{wlan}/)
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
										if element=~/#{nic_desc}.*:\s*(.*)/
												value      = Regexp.last_match(1).strip
												info[:desc]=value
										elsif element=~/#{mac}.+\s+\:\s+(\w{2}-\w{2}-\w{2}-\w{2}-\w{2}-\w{2})/
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
				rs_utf8 = rs.encode("UTF-8")
				ipinfo  = parse_ipconfig(rs_utf8)
				fail "nic name is not modified,please check it" if ipinfo=={}
				return ipinfo
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

    #获取网卡instanceID
		def net_cfg_rdr(nicname)
				rs = `net config rdr`
				print rs
				rs_utf8  = rs.encode("UTF-8")
				parse_instanceid_mac(rs_utf8,nicname)
		end

		def parse_instanceid_mac(rs_utf8,nicname)
				ip_info  = ipconfig("all")
				mac_addr = ip_info[nicname][:mac]
				nic_mac  = mac_addr.delete("-")				
				arr      = rs_utf8.split("\n")
				nic_hash ={}
				arr.each { |item|
						item = item.strip
						next if item !~ /NetBT_Tcpip_/i
						%r{NetBT_Tcpip_(?<netcfg_instance_id>\{.+\})\s*\((?<mac_address>\w+)\)}i=~item
						if mac_address==nic_mac
								nic_hash = {netcfg_instance_id: netcfg_instance_id, mac: mac_address}
								break
						end
				}
				nic_hash
		end
end

if __FILE__==$0
		include WinCmd
		# p ipconfig("all")
		nicname = "local"
		p net_cfg_rdr(nicname)
end