#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.7", "level" => "P1", "auto" => "n"}

		def prepare

				DRb.start_service
				@wifi = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time        = 3
				@tc_wifi_time       = 30
				@tc_net_reset        = 15
				@tc_lan_ip1 = "172.168.100.1"

		end


		def process

				operate("1 打开内网设置") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
				}

				operate("2 连接路由器wifi") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url)
						@tc_ssid = rs_wifi[:ssid]
						@tc_pwd = rs_wifi[:pwd]

						flag  = "1"
						rs    = @wifi.connect(@tc_ssid, flag, @tc_pwd)
						assert rs, 'wifi连接失败'
				}

				operate("3 查看客户端信息") {
						sleep @tc_net_reset
						ip_info     = ipconfig("all")
						dns_servers = ip_info[@ts_nicname][:dns_server]
						rs1         = dns_servers.any? { |dns_server| dns_server=~/#{@ts_default_ip}/ }
						assert rs1, "DNS地址不正确"

						wifi_info     = @wifi.ipconfig("all")
						wifi_ip       = wifi_info[@ts_wlan_nicname][:ip][0]
						sub_default_ip=@ts_default_ip.sub(/\.\d+$/, "")
						assert_match(/#{sub_default_ip}/, wifi_ip, "wlan客户端地址不正确")
						wifi_gw = wifi_info[@ts_wlan_nicname][:gateway][0]
						assert_equal @ts_default_ip, wifi_gw, "wlan客户端网关地址不正确"
						wifi_dns_servers = wifi_info[@ts_wlan_nicname][:dns_server]
						rs2              = wifi_dns_servers.any? { |wifi_dns_server| wifi_dns_server=~/#{@ts_default_ip}/ }
						assert(rs2, "wifi客户端DNS地址不正确")
				}

				operate("4 修改lan ip为B类地址") {
						@lan_page.lan_ip_config(@tc_lan_ip1, @browser.url)

						@login_page = RouterPageObject::LoginPage.new(@browser)
						login_ui    = @login_page.login_with_exists(@browser.url)
						assert(login_ui, "重启后未跳转到登录页面！")
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
				}

				operate("5 修改为B类地址后pc重新获取ip地址") {
						flag  = "1"
						rs    = @wifi.connect(@tc_ssid, flag, @tc_pwd)
						assert rs, 'wifi连接失败'

						sleep @tc_net_reset
						ip_info     = ipconfig("all")
						dns_servers = ip_info[@ts_nicname][:dns_server]
						rs1         = dns_servers.any? { |dns_server| dns_server=~/#{@tc_lan_ip1}/ }
						assert rs1, "DNS地址不正确"
						wifi_info     = @wifi.ipconfig("all")
						wifi_ip       = wifi_info[@ts_wlan_nicname][:ip][0]
						sub_default_ip=@tc_lan_ip1.sub(/\.\d+$/, "")
						assert_match(/#{sub_default_ip}/, wifi_ip, "wlan客户端地址不正确")

						wifi_gw = wifi_info[@ts_wlan_nicname][:gateway][0]
						assert_equal @tc_lan_ip1, wifi_gw, "wlan客户端网关地址不正确"
						wifi_dns_servers = wifi_info[@ts_wlan_nicname][:dns_server]
						rs2              = wifi_dns_servers.any? { |wifi_dns_server| wifi_dns_server=~/#{@tc_lan_ip1}/ }
						assert rs2, "wifi客户端DNS地址不正确"
				}

				operate("6 恢复Lan默认配置") {
						@lan_page.lan_ip_config(@ts_default_ip, @browser.url)
						@login_page = RouterPageObject::LoginPage.new(@browser)
						login_ui    = @login_page.login_with_exists(@browser.url)
						assert(login_ui, "重启后未跳转到登录页面！")
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
				}

		end

		def clearup

				operate("1 恢复默认配置") {
						@wifi.netsh_disc_all #断开wifi连接
						rs1 = ping(@ts_default_ip)
						if rs1 == true
								puts "路由器已是默认配置".to_gbk
						else
								options_page = RouterPageObject::OptionsPage.new(@browser)
								options_page.recover_factory(@browser.url)

								##采用命令方式回复出厂设置，防止路由器登录失败以至无法恢复默认配置
								# lan_ip = ipconfig[@ts_nicname][:gateway][0]
								# telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
								# exp_ralink_init
						end
				}

		end

}
