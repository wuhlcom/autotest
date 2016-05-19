#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#动态生成服务端口
				@tc_vir_tcpsrv_port = rand_port(50000, 65534)
				@tc_pub_tcp_port    = 30000
				@tc_vir_udpsrv_port = rand_port(40000, 49999)
				@tc_pub_udp_port    = 20000

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
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_ip_addr = ip_info[:ip][0]
						puts "Virtual Server IP #{@tc_ip_addr}"
						#添加一条虚拟服务器规则
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_ip_addr, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, 1)
						#添加第二条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_ip_addr, @tc_pub_udp_port, @tc_vir_udpsrv_port, 2)
						@options_page.save_vps
				}

				operate("3、在PC2上开启HTTP、 FTP、TELNET、TFTP等服务，在PC1上开启HTTP服务；") {
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  =ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						#查询服务器上默认路由是否存在
						routes = @tc_wan_drb.cmd_route_print()
						puts "WAN SERVER Permannet Route Info"
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
						tcp_multi_server(@tc_ip_addr, @tc_vir_tcpsrv_port)
						#启动udp server
						udp_server(@tc_ip_addr, @tc_vir_udpsrv_port)
				}

				operate("4、PC1通过WAN口访问PC2上的HTTP、 FTP、TELNET、TFTP等服务，并在PC2网卡上，Server上抓包观察；") {
						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启虚拟服务器后，UDP连接失败")
				}

				operate("5、在PC2上访问PC1的HTTP服务是否成功，并在PC1上抓包观察；") {
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=========================客户端获取到Http Server Message========================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "开启虚拟服务器后，客户端1连接到WAN侧http服务失败")
				}


		end

		def clearup

				operate("1 删除虚拟服务器配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}

				operate("2 恢复为默认的接入方式，DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

		end

}
