#
# description:
# tcp服务容易出现启动失败的问题
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.9", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#动态生成服务端口
				@tc_vir_tcpsrv_port = 53581 #rand_port(50000, 65534)
				@tc_pub_tcp_port    = 30001
				@tc_vir_udpsrv_port = 40448 #rand_port(40000, 49999)
				@tc_pub_udp_port    = 20001
				@tc_wait_time       = 3
				@tc_udp_data_time   = 30
		end

		def process

				operate("1、在AP上配置一条PPPoE内置拨号，自动获取IP地址和网关，启用虚拟服务器功能；") {
						@sys_page     = RouterPageObject::SystatusPage.new(@browser)
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@wan_page     = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
						#查看Wan ip地址
						@sys_page.open_systatus_page(@browser.url)
						@tc_pppoe_addr = @sys_page.get_wan_ip
						puts "WAN状态显示获取的IP地址为：#{@tc_pppoe_addr}".to_gbk
				}

				operate("2、在AP上依次添加服务FTP(TCP端口为20，21)，HTTP(TCP端口为80)，TELNET(TCP端口为23)，TFTP(UDP端口为69)等,服务器IP地址设置为PC2的IP地址等规则,保存；") {
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "Virtual Server IP #{@tc_pc_ip}"
						# 添加一条虚拟服务器规则
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, 1)
						# 添加第二条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_udp_port, @tc_vir_udpsrv_port, 2)
						@options_page.save_vps
				}

				operate("3、PC1访问PC2上面的FTP、HTTP、TELNET/TFTP服务器；") {
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_pppoe_addr=~/#{new_net}/
						}

						#如果路由不存在侧添加路由
						unless temp
								dst  = @tc_pppoe_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #网关为pptp服务地址
								@tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#启动tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#启动udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)
						sleep @tc_wait_time

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						puts tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						puts udp_msg
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启虚拟服务器后，UDP连接失败")
				}

				operate("4、关闭AP虚拟服务器开关，PC1访问PC2上面的FTP、HTTP、TELNET/TFTP服务器；") {
						@options_page.close_vps_btn #关闭开关
						@options_page.save_vps
						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================After close portmapping Message from TCP server==============="
						puts tcp_msg
						refute_match(/#{@ts_conn_state}/, tcp_msg, "关闭虚拟服务器后，tcp连接成功")
						#已经建立的udp连接在服务关闭后一定时间内仍能通信，但在一定义时间后就无法通信了
						puts "Waiting for UDP...."
						sleep @tc_udp_data_time
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================After close portmapping Message from UDP server==============="
						puts udp_msg
						refute_match(/#{@ts_conn_state}/, udp_msg, "关闭虚拟服务器后，UDP连接成功 ")
				}

				operate("5、重启AP，PC1访问PC2上面的FTP、HTTP、TELNET/TFTP服务器。") {
						@options_page.refresh
						sleep 2
						@options_page.reboot
						#重新登录路由器
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "重启后未跳转到登录界面")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						#查看Wan ip地址
						@sys_page.open_systatus_page(@browser.url)
						@tc_pppoe_addr = @sys_page.get_wan_ip
						puts "重启后WAN状态显示获取的IP地址为：#{@tc_pppoe_addr}".to_gbk

						#重启路由器后如果PC 获取IP与原来不同则要重新启动tcp服务
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip2}"
						unless (@tc_pc_ip2==@tc_pc_ip)
								puts "重启路由器后， 启动新Virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
								#启动udp server
								udp_server(@tc_pc_ip2, @tc_vir_udpsrv_port)
						end

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================After reboot, Message from TCP server==============="
						print tcp_msg
						refute_match(/#{@ts_conn_state}/, tcp_msg, "关闭虚拟服务器后，tcp连接成功")
						#关闭
						puts "Waiting for UDP...."
						sleep @tc_udp_data_time
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================After reboot,Message from UDP server==============="
						puts udp_msg
						refute_match(/#{@ts_conn_state}/, udp_msg, "关闭虚拟服务器后，UDP连接成功")
				}

		end

		def clearup
				operate("1 删除虚拟服务器配置") {
						# sleep
						rs = @options_page.login_with_exists(@browser.url)
						if rs
								rs_login = login_no_default_ip(@browser) #重新登录
								p rs_login[:flag]
								p rs_login[:message]
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}

				operate("2 恢复为默认的接入方式，DHCP接入") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
