#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi               = DRbObject.new_with_uri(@ts_drb_server) #无线客户端
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2) #WAN侧druby服务
				#动态生成服务端口
				@tc_dmz_tcpsrv_port = rand_port(50000, 65534)
				@tc_dmz_udpsrv_port = rand_port(40000, 49999)

		end

		def process
				operate("1、在AP上配置一条PPPoE内置拨号，自动获取IP地址和网关，启用DMZ功能，设置DMZ目标IP为下挂PC2的IP地址；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url) #pppoe

						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						@tc_wan_addr = @sys_page.get_wan_ip
						wan_type     = @sys_page.get_wan_type
						puts "WAN IP:#{@tc_wan_addr}"
						puts "WAN TYPE:#{wan_type}"
						assert_match @ip_regxp, @tc_wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						rs = ping(@ts_web)
						assert(rs, "无法连接外网")
				}

				operate("2、在PC2上建立FTP服务器，tftp服务器；") {
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "DMZ Server IP #{@tc_pc_ip}"
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.set_dmz(@tc_pc_ip, @browser.url)
				}

				operate("3、在PC1上开启TFTP、 FTP客户端访问AP的WAN口IP地址,并进行相应的业务下载或者上传，分别在PC2网卡上，Server上抓包观察；") {
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_wan_addr=~/#{new_net}/
						}

						#如果WAN侧服务器上路由不存在侧添加路由
						unless temp
								dst  = @tc_wan_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #网关为pptp服务地址
								@tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#启动tcp_server
						puts "启动TCP服务端口为#{@tc_dmz_tcpsrv_port}".to_gbk
						@tc_tcp_thr = tcp_multi_server(@tc_pc_ip, @tc_dmz_tcpsrv_port)
						#启动udp server
						puts "启动UDP服务端口为#{@tc_dmz_udpsrv_port}".to_gbk
						@tc_udp_thr = udp_server(@tc_pc_ip, @tc_dmz_udpsrv_port)

						#从WAN侧访问DMZ主机
						rs          = @tc_wan_drb.tcp_client(@tc_wan_addr, @tc_dmz_tcpsrv_port)
						tcp_msg     = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启dmz后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_wan_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启dmz后，UDP连接失败")
				}

				operate("4、在LAN侧PC3开启TFTP、 FTP客户端访问AP的WAN口IP地址,并进行相应的业务下载或者上传，分别在PC2网卡上，Server上抓包观察；") {
						p "获取路由器SSID跟密码".to_gbk
						@wifi_page  = RouterPageObject::WIFIPage.new(@browser)
						wifi_config = @wifi_page.modify_ssid_mode_pwd(@browser.url, "autotest")
						#连接无线网卡
						puts "wifi ssid: #{wifi_config[:ssid]},passwd:#{wifi_config[:pwd]}"
						rs1 = @wifi.connect(wifi_config[:ssid], @ts_wifi_flag, wifi_config[:pwd])
						assert rs1, 'wifi连接失败'
						http_get = @wifi.http_client(@ts_wan_pppoe_httpip)
						puts "=================第二个客户端面获取到Message from HTTP server===============".encode("GBK")
						puts http_get
						assert_match(/#{@ts_conn_state}/, http_get, "开启dmz后，其它客户端连接到WAN侧http服务失败")
				}

				operate("5、在PC2上访问PC1的WEB服务是否成功。") {
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=========================第一个客户端获取到Http Server Message========================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "开启dmz后，客户端1连接到WAN侧http服务失败")
				}

				operate("6、重启后，检测DMZ功能是否生效；") {
						@wifi_page.close_wifi_page
						@wifi_page.reboot
						rs = @wifi_page.login_with_exists(@browser.url)
						assert rs, "跳转到登录页面失败!"
						#重新登录
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@sys_page.open_systatus_page(@browser.url)
						@tc_wan_addr = @sys_page.get_wan_ip
						puts "重启后WAN状态显示获取的IP地址为：#{@tc_wan_addr}".to_gbk

						rs      = @tc_wan_drb.tcp_client(@tc_wan_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================重起后Message from TCP server===============".encode("GBK")
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "重启路由器后，tcp连接失败")

						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_wan_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================重启后Message from UDP server===============".encode("GBK")
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "重启路由器后，UDP连接失败")

						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "================重启后第一个客户端获取到Http Server Message==============".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "开启dmz后，客户端1连接到WAN侧http服务失败")
				}

				operate("7、从PC1 ping WAN口 IP.") {
						#即从WAN侧服务器ping路由器WAN IP
						rs = @tc_wan_drb.ping(@tc_wan_addr)
						assert(rs, "从WAN侧PING路由器成功")
				}

		end

		def clearup

				operate("1 停止tcp udp server") {
						@wifi.netsh_disc_all #断开wifi连接
						begin
								#停止tcp udp server
								@tc_tcp_thr.kill if !@tc_tcp_thr.nil?&&@tc_tcp_thr.alive?
								@tc_udp_thr.kill if !@tc_tcp_thr.nil?&&@tc_udp_thr.alive?
						rescue => ex
								p ex.message.to_s
						end
				}

				operate("2 恢复为默认SSID") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						if @wifi_page.login_with_exists(@browser.url)
								rs_login = login_no_default_ip(@browser) #重新登录
								p rs_login[:flag]
								p rs_login[:message]
						end
						@wifi_page.modify_default_ssid(@browser.url)
						sleep 10
				}

				operate("3 取消DMZ") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.dmz_page(@browser.url)
						dmz_switch_status = @options_page.dmz_switch_status #得到dmz开关状态
						if dmz_switch_status == "on"
								@options_page.click_dmz_switch
								@options_page.save_dmz
						end
				}

				operate("4 恢复为默认的接入方式，DHCP接入") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

		end
}
