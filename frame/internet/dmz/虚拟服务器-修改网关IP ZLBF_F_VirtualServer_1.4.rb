#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.4", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#动态生成服务端口
				@tc_vir_tcpsrv_port = 41000
				@tc_pub_tcp_port    = 21000
				@tc_wait_time       = 3
				@tc_lan_sameseg_ip  = "192.168.100.2"
				@tc_lan_ip_new      = "192.168.123.1"

		end

		def process

				operate("1、恢复DUT默认配置，设置接入类型为PPTP；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						#配置PPTP接入
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url) #设置pptp连接

						#查询PPTP拨号状态
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						@tc_pptp_ip = @sys_page.get_wan_ip
						puts "PPTP获取的IP地址为：#{@tc_pptp_ip}".to_gbk

						wan_type = @sys_page.get_wan_type
						puts "查询到接入类型为：#{wan_type}".to_gbk

						assert_match @ts_tag_ip_regxp, @tc_pptp_ip, 'PPTP获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！'
				}

				operate("2、添加一条虚拟服务器规则，保存配置，验证规则是否生效；") {
						#查询PC IP地址
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"
						@options_page.add_vps_step(@browser.url, @tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port,1) #添加一条虚拟服务器规则
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						#查询服务器上默认路由是否存在
						routes = @tc_wan_drb.cmd_route_print()
						puts "WAN Server permanetn route info:"
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_pptp_ip=~/#{new_net}/
						}

						#如果路由不存在侧添加路由
						unless temp
								dst  = @tc_pptp_ip.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #网关为pptp服务地址
								cmd_route_add(dst, mask, gw)
						end

						# 启动tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						# #TCP连接访问虚拟服务器
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
				}

				operate("3、修改网关地址为与默认地址同网段的其他地址，验证步骤2中添加的规则是否生效；") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.lan_ip_config(@tc_lan_sameseg_ip, @browser.url)

						#重新登录路由器
						unless @browser.text_field(:name, @ts_tag_aduser).exist?
								@browser.cookies.clear
								@browser.goto(@tc_lan_sameseg_ip)
								rs = @browser.text_field(:name, @ts_tag_aduser).exist?
								assert(rs, '路由器无法登录！')
						end
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						#重启路由器后如果PC 获取IP与原来不同则要重新启动tcp服务
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip2}"
						unless @tc_pc_ip2==@tc_pc_ip
								puts "修改LAN IP 为#{@tc_lan_sameseg_ip}后， 启动新Virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
						end

						#TCP连接访问虚拟服务器
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
				}

				operate("4、修改网关地址为与默认地址不同网段的地址，规则中服务IP地址是否能修改成相应网段的IP地址，若修改成功，验证规则是否生效；") {
						@lan_page.lan_ip_config(@tc_lan_ip_new, @browser.url)
						#重新登录路由器
						unless @browser.text_field(:name, @ts_tag_aduser).exist?
								@browser.cookies.clear
								@browser.goto(@tc_lan_ip_new)
								rs = @browser.text_field(:name, @ts_tag_aduser).exist?
								assert(rs, '路由器无法登录！')
						end
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						#重启路由器后如果PC 获取IP与原来不同则要重新启动tcp服务
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip3 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip3}"
						unless (@tc_pc_ip3==@tc_pc_ip) && (@tc_pc_ip3==@tc_pc_ip2)
								puts "修改LAN IP 为#{@tc_lan_ip_new}后， 启动新Virtual Server IP #{@tc_pc_ip3}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip3, @tc_vir_tcpsrv_port)
						end
						#TCP连接访问虚拟服务器
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
				}

				operate("5、在步骤4，修改成功的基础上，再将网关地址修改成默认网段的IP地址，验证规则是否生效；") {
						@lan_page.lan_ip_config(@ts_default_ip, @browser.url)
						#重新登录路由器
						rs = @browser.text_field(:name, @ts_tag_aduser).wait_until_present(@tc_wait_time)
						assert rs, '跳转到登录页面失败！'
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						#重启路由器后如果PC 获取IP与原来不同则要重新启动tcp服务
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip4 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip4}"
						unless (@tc_pc_ip4==@tc_pc_ip) && (@tc_pc_ip4==@tc_pc_ip2) && (@tc_pc_ip4==@tc_pc_ip3)
								puts "修改LAN IP 为#{@ts_default_ip}后， 启动新Virtual Server IP #{@tc_pc_ip4}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip4, @tc_vir_tcpsrv_port)
						end

						#TCP连接访问虚拟服务器
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
				}

		end

		def clearup
				operate("1 恢复为默认设置") {
						# rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.recover_factory(@browser.url)
						# #采用命令方式回复出厂设置，防止路由器登录失败以至无法恢复默认配置
						# lan_ip = ipconfig[@ts_nicname][:gateway][0]
						# telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						# exp_ralink_init
				}
		end

}
