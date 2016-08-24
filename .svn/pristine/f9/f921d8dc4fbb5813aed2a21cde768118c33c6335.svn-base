#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.2", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#动态生成服务端口
				@tc_dmz_tcpsrv_port = rand_port(50000, 65534)
				@tc_dmz_udpsrv_port = rand_port(40000, 49999)
				@tc_wait_time       = 3
				#dmz关闭后，已经传送过udp数据的端口需要等待几分钟才生效
				#但其它端口立即生效
				@tc_udp_data_time   = 180
		end

		def process

				operate("1、在AP上配置一条PPTP内置拨号，自动获取IP地址和网关，启用DMZ功能，设置DMZ目标IP为下挂PC2的IP地址；") {
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@login_page = RouterPageObject::LoginPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						lan_ip = @sys_page.get_lan_ip
						#如果路由器不是默认lanip先恢复为默认ip
						unless lan_ip =~/#{@ts_default_ip}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@options_page.recover_factory(@browser.url) #恢复出厂设置
								rs = @login_page.login_with_exists(@browser.url)
								assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
								rs_login = login_no_default_ip(@browser) #重新登录
								assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						end
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@options_page.set_pptp(@ts_pptp_server_ip,@ts_pptp_usr,@ts_pptp_pw,@browser.url) #设置pptp连接
				}

				operate("2、在PC2上建立FTP服务器，tftp服务器；") {
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@pc_ip_addr = ip_info[:ip][0]
						puts "DMZ Server IP #{@pc_ip_addr}"
						@options_page.set_dmz(@pc_ip_addr, @browser.url)
				}

				operate("3、在PC1上开启TFTP、 FTP客户端访问AP的WAN口IP地址,并进行相应的业务下载或者上传，分别在PC2网卡上，Server上抓包观察；") {
						#查看Wan ip地址
						@sys_page.open_systatus_page(@browser.url)
						@tc_ppptp_addr = @sys_page.get_wan_ip
						puts "WAN状态显示获取的IP地址为：#{@tc_ppptp_addr}".to_gbk

						#lan访问wan
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=================客户端获取到Http Server Message=================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "开启dmz后，客户端1连接到WAN侧http服务失败")

						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  =ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_ppptp_addr=~/#{new_net}/
						}

						#如果路由不存在侧添加路由
						unless temp
								dst  = @tc_ppptp_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip
								@tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#启动tcp_server
						@tc_tcp_srvthr = tcp_multi_server(@pc_ip_addr, @tc_dmz_tcpsrv_port)
						#启动udp server
						@tc_udp_srvthr = udp_server(@pc_ip_addr, @tc_dmz_udpsrv_port)
				}

				operate("4、在PC2上访问PC1的WEB服务是否成功；") {
						#wan访问lan dmz
						rs      = @tc_wan_drb.tcp_client(@tc_ppptp_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						puts tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启dmz后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_ppptp_addr, @tc_dmz_udpsrv_port, "PPTP")
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						puts udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启dmz后，UDP连接失败")
				}

				operate("5、禁用DMZ，重复步骤3，4；") {
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_dmz_page
						dmz_switch_status = @options_page.dmz_switch_status #得到dmz开关状态
						if dmz_switch_status == "on"
								@options_page.click_dmz_switch
								@options_page.save_dmz
								sleep @tc_wait_time
						end

						rs      = @tc_wan_drb.tcp_client(@tc_ppptp_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================After closed DMZ,Message from TCP server==============="
						puts "no message: #{tcp_msg}"
						refute_match(/#{@ts_conn_state}/, tcp_msg, "关闭dmz后，tcp仍能连接")

						#udp客户端口也动态生成rand_port
						sleep @tc_udp_data_time
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_ppptp_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================After closed DMZ,Message from UDP server==============="
						puts "no message: #{udp_msg}"
						refute_match(/#{@ts_conn_state}/, udp_msg, "关闭dmz后，UDP仍能连接")
				}

				operate("6、反复禁用启用DMZ 3次以上，AP工作是否正常；") {
						2.times.each do |i|
								puts "Repeat open and close DMZ #{i} time"
								#打开dmz开关
								dmz_switch_status = @options_page.dmz_switch_status #得到dmz开关状态
								if dmz_switch_status == "off"
										@options_page.click_dmz_switch
										@options_page.dmz_input(@pc_ip_addr)
										@options_page.save_dmz
										sleep @tc_wait_time
								end
								#关闭DMZ
								if dmz_switch_status == "on"
										@options_page.click_dmz_switch
										@options_page.save_dmz
										sleep @tc_wait_time
								end
						end
						rs=ping(@ts_web)
						assert(rs, "路由器无法访问外网")
				}


		end

		def clearup

				operate("1 关闭DMZ服务器上的服务") {
						@tc_tcp_srvthr.kill if !@tc_tcp_srvthr.nil? && @tc_tcp_srvthr.alive?
						@tc_udp_srvthr.kill if !@tc_udp_srvthr.nil? && @tc_udp_srvthr.alive?
				}

				operate("2 取消DMZ") {
						unless @browser.span(:id => @ts_tag_netset).exists?
							rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_dmz_page
						dmz_switch_status = @options_page.dmz_switch_status #得到dmz开关状态
						if dmz_switch_status == "on"
								@options_page.click_dmz_switch
								@options_page.save_dmz
						end
				}

				operate("3 恢复为默认的接入方式，DHCP接入") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
