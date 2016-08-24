#
# description:
# 使用静态IP接入来测试不使用PPTP接入来测试
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.5", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_vir_tcpsrv_port = 33000
				@tc_vir_udpsrv_port = 34000
				@tc_pub_tcp_port    = 23000
				@tc_pub_udp_port    = 24000
		end

		def process

				operate("1、在AP上配置静态IP接入，启用虚拟服务器功能，新添加一条规则,协议选择TCP/UDP,起始与终止端口设置为5000，服务IP地址设置为PC2地址，保存；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)

						#查看Wan ip地址
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						@tc_static_ip = @sys_page.get_wan_ip
						wan_type      = @sys_page.get_wan_type
						assert_match /#{@ts_staticIp}/, @tc_static_ip, '静态ip配置失败！'
						assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'
				}

				operate("2、重复步骤1分别添加端口号为80，8080，137，139，1024，10000，65535规则；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						#查询PC IP地址
						ip_info       = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip     = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, 1)

						#添加第二条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_udp_port, @tc_vir_udpsrv_port, 2)
						@options_page.save_vps

						#启动服务器
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						#启动tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#启动udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)

						#连接虚拟服务器
						rs      = @tc_wan_drb.tcp_client(@tc_static_ip, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_static_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启虚拟服务器后，UDP连接失败")
				}

				operate("3、重启DUT，查看配置的规则是否存在生效；") {
						@options_page.refresh
						sleep 2
						@options_page.reboot
						rs = @options_page.login_with_exists(@browser.url)
						assert rs, "重启路由器失败未跳转到登录页面!"
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						#查询PC IP地址
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "after router reboot，pc ip addr is: #{@tc_pc_ip}"
						puts "after router reboot，Virtual Server IP is:#{@tc_pc_ip}"
						unless @tc_pc_ip2==@tc_pc_ip
								puts "after router reboot，启动新virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
								#启动udp server
								udp_server(@tc_pc_ip2, @tc_vir_udpsrv_port)
						end

						#连接虚拟服务器
						rs      = @tc_wan_drb.tcp_client(@tc_static_ip, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "after router reboot，开启虚拟服务器后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_static_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "after router reboot，开启虚拟服务器后，UDP连接失败")

						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_vps_page
						rs = @options_page.vps_switch_status
						assert_equal("on", rs, "虚拟服务器开关被关闭")

						virsrv_ip1      = @options_page.vps_ip1
						virsrv_pub_port1= @options_page.vps_common_port1
						vrisrv_port1    = @options_page.vps_private_port1
						assert_equal(@tc_pc_ip, virsrv_ip1, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_tcp_port.to_s, virsrv_pub_port1, "查询不到路由器对外端口#{@tc_pub_tcp_port}")
						assert_equal(@tc_vir_tcpsrv_port.to_s, vrisrv_port1, "查询不到虚拟服务器端口#{@tc_vir_tcpsrv_port}")

						virsrv_ip2      = @options_page.vps_ip2
						virsrv_pub_port2= @options_page.vps_common_port2
						vrisrv_port2    = @options_page.vps_private_port2
						assert_equal(@tc_pc_ip, virsrv_ip2, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_udp_port.to_s, virsrv_pub_port2, "查询不到路由器对外端口#{@tc_pub_udp_port}")
						assert_equal(@tc_vir_udpsrv_port.to_s, vrisrv_port2, "查询不到虚拟服务器端口#{@tc_vir_udpsrv_port}")
				}

				operate("4、复位DUT，查看配置是否完全清空；") {
						@options_page.recover_factory(@browser.url) #恢复出厂设置
						@rs_recover = @options_page.login_with_exists(@browser.url)
						assert @rs_recover, "恢复出厂设置后未跳转到路由器登录页面!"

						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_vps_page
						rs = @options_page.vps_switch_status
						assert_equal("off", rs, "恢复出厂设置后虚拟服务器开关未关闭")

						rs2 = @options_page.vps_ip1_element
						refute(rs2.exists?, "恢复出厂设置后，虚拟服务器配置1未删除")

						rs3 = @options_page.vps_ip2_element
						refute(rs3.exists?, "恢复出厂设置后，虚拟服务器配置2未删除")
				}


		end

		def clearup
				operate("1 恢复默认DHCP接入") {
						unless @rs_recover #如果已进行恢复出厂操作这里不执行
								wan_page = RouterPageObject::WanPage.new(@browser)
								if wan_page.login_with_exists(@browser.url)
										login_recover(@browser, @ts_default_ip)
								end
								wan_page.set_dhcp(@browser, @browser.url)
						end
				}
				operate("2 删除虚拟服务器配置") {
						unless @rs_recover #如果已进行恢复出厂操作这里不执行
								@options_page = RouterPageObject::OptionsPage.new(@browser)
								@options_page.delete_allvps_close_switch_step(@browser.url)
						end
				}
		end

}

