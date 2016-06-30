#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.6", "level" => "P3", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_vir_tcpsrv_port = 10000
				@tc_vir_udpsrv_port = 20000
				@tc_pub_tcp_port    = 10000
				@tc_pub_udp_port    = 20000
				@tc_wait_time       = 3
				@tc_tcp             = "TCP"
				@tc_udp             = "UDP"
		end

		def process

				operate("1、AP的接入类型选择为DHCP，保存配置；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp_mode(@browser.url)
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						@tc_dhcp_ip = @sys_page.get_wan_ip
						wan_type = @sys_page.get_wan_type
						puts "WAN DHCPC IP ADDR #{@tc_dhcp_ip}"
						assert_match(@ts_tag_ip_regxp, @tc_dhcp_ip, 'dhcp获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！')
				}

				operate("2、添加一条虚拟服务器规则,协议选择TCP,起始端口设置为10000，终止端口设置为10000，服务IP地址设置为PC2地址，保存；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						#查询PC IP地址
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"
						#设置虚拟服务器
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, 1, @tc_tcp)
						@options_page.save_vps
						sleep @tc_wait_time

						#查看服务器配置的网卡信息是否正确
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						# 启动tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#启动udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)
				}

				operate("3、在PC1上打开IPTEST工具，网络模式选择“客户端模式”，网络类型选择“TCP”，远程端口号设置为10000，远程IP地址设置为“AP WAN口IP地址”，点击“开始连接”，分别在PC1，PC2网卡上抓包观察；") {
						#使用ruby socket来实现
						#TCP连接访问虚拟服务器
						rs1     = @tc_wan_drb.tcp_client(@tc_dhcp_ip, @tc_pub_tcp_port)
						tcp_msg = rs1.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启TCP虚拟服务器后，tcp连接失败")
						#udp 连接会失败，因为只开发TCP协议
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_dhcp_ip, @tc_pub_tcp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						refute_match(/#{@ts_conn_state}/, udp_msg, "开启TCP虚拟服务器后，UDP连接成功")
				}

				operate("4、选择步骤2中添加的规则，更改协议为UDP,起始端口设置为20000，终止端口设置为20000，服务IP地址设置为PC2地址，是否能对已选择的规则进行修改，保存；") {
						#修改规则
						@options_page.vps_input(@tc_pc_ip, @tc_pub_udp_port, @tc_vir_udpsrv_port, 1, @tc_udp)
						@options_page.save_vps
						sleep @tc_wait_time+5 #修改后的规则要生效需要多等几秒
				}

				operate("5、在PC1上打开IPTEST工具，网络模式选择“客户端模式”，网络类型选择“UDP”，远程端口号设置为20000，远程IP地址设置为“AP WAN口IP地址”，点击“开始连接”,输入要发送的内容，点击“发送”，分别在PC1，PC2网卡上抓包观察；") {
						#使用ruby socket来实现
						# #TCP连接访问虚拟服务器会失败,因为只开启了UDP协议
						rs1     = @tc_wan_drb.tcp_client(@tc_dhcp_ip, @tc_pub_udp_port)
						tcp_msg = rs1.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						print "\n"
						refute_match(/#{@ts_conn_state}/, tcp_msg, "开启UDP虚拟服务器后，TCP连接成功")
						#udp 连接成功，
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_dhcp_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启UDP虚拟服务器后，UDP连接失败")
				}
		end

		def clearup
				operate("1 删除虚拟服务器配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}
		end

}
