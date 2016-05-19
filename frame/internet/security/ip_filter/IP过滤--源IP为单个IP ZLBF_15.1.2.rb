#
# description:
# author:liluping
# date:2015-09-16
#
testcase {

		attr = {"id" => "ZLBF_15.1.2", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_wifi_flag   = "1"
				@tc_wait_time   = 2
				@tc_wifi_wait   = 10
				@tc_wifi_time   = 30
				@tc_ping_num    = 5
		end

		def process

				operate("1、DUT的接入类型选择为DHCP，保存配置，PC1设置为自动获取IP地址，如：192.168.100.100；") {
						#查看WAN接入方式是否为DHCP
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
						rs = ping(@ts_web)
						assert(rs, "设置源IP过滤前有线客户端无法ping通#{@ts_web}")

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						#连接无线网卡
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						mac_last   = @wifi_page.get_mac_last
						@wifi_page.open_wifi_page(@browser.url)
						@tc_ssid1_name = @wifi_page.ssid1
						puts "当前SSID1名为#{@tc_ssid1_name}".to_gbk
						puts "当前SSID1 加密方式为#{@wifi_page.ssid1_pwmode}".to_gbk
						#判断加密方式是否为WPA,如果不是则设置为WPA
						flag = false
						if @wifi_page.ssid1_pwmode != @ts_sec_mode_wpa
								@wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
								@wifi_page.ssid1_pw     = @ts_default_wlan_pw
								flag                    = true
						end
						unless @tc_ssid1_name=~/#{mac_last}/i
								@tc_ssid1_name   = "#{@tc_ssid1_name}_#{mac_last}"
								@wifi_page.ssid1 = @tc_ssid1_name
								puts "修改SSID1名为#{@tc_ssid1_name}".to_gbk
								flag = true
						end
						if flag
								@wifi_page.save_wifi
								puts "sleep #{@tc_wifi_time} second for wifi config changing..."
								sleep @tc_wifi_time
						end

						puts "Dut ssid: #{@tc_ssid1_name},passwd:#{@ts_default_wlan_pw}"
						p "PC2连接DUT".to_gbk
						rs1 = @tc_dumpcap_pc2.connect(@tc_ssid1_name, @tc_wifi_flag, @ts_default_wlan_pw, @ts_wlan_nicname)
						assert rs1, 'wifi连接失败'

						rs2 =@tc_dumpcap_pc2.ping(@ts_web)
						assert(rs2, "设置IP过滤前WIFI客户端无法ping#{@ts_web}")
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、先进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_security_setting(@browser.url)
						@options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
				}

				operate("3、添加一条IP过滤规则，设置源IP为192.168.100.100，端口为1~65535，协议为TCP/UDP，目的地址和目的端口不填，保存配置；") {
						@tc_pc_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
						p "设置过滤源IP：#{@tc_pc_ip}".to_gbk
						@options_page.ipfilter_click #打开IP过滤页面
						@options_page.ip_add_item_element.click #添加新条目
						@options_page.ip_filter_src_ip_input(@tc_pc_ip, @tc_pc_ip)
						@options_page.ip_filter_save
				}

				operate("4、从PC向服务器作ping操作，ping的IP为过滤网段内的地址，然后在服务器查看是否能抓到数据包；") {
						p "获取#{@ts_web}对应的网络IP".to_gbk
						ns     = Addrinfo.ip(@ts_web) #查询该url对应的ip
						net_ip = ns.ip_address
						p "#{@ts_web}的对应的网络IP为：#{net_ip}".to_gbk

						rs = ping(net_ip, @tc_ping_num)
						refute(rs, "IP过滤失败，本机IP在过滤之后仍能ping通外网")

						puts "在pc2上ping #{@ts_web}".to_gbk
						wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
						ts          = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
						assert(ts, "IP过滤失败，PC2的IP未过滤但不能ping通外网")
						#为防止无线网卡重启后获取的IP是被过滤的IP，重启前先断开无线连接
						p "断开wifi连接".to_gbk
						@tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
				}

				operate("5、重启DUT，查看过滤规则是否生效") {
						@options_page.refresh
						sleep 2
						@options_page.reboot
						login_ui    = @options_page.login_with_exists(@browser.url)
						assert(login_ui, "重启后未跳转到登录页面！")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@options_page.open_security_setting(@browser.url) #进入安全设置页面
						@options_page.ipfilter_click #打开IP过滤页面

						#验证重启后ip过滤规则是否生效
						ns     = Addrinfo.ip(@ts_web) #查询该url对应的ip
						net_ip = ns.ip_address
						p "获取#{@ts_web}对应的网络IP为#{net_ip}".to_gbk

						tc_dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
						puts "重启后有线网卡IP为#{tc_dut_ip}".to_gbk

						puts "重启后无线网卡重新连接".to_gbk
						@tc_dumpcap_pc2.netsh_conn(@tc_ssid1_name)
						sleep @tc_wifi_wait
						wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
						puts "重启后查看无线网卡IP为#{wireless_ip}".to_gbk

						#重启后可能有线获得的是过滤设置的IP，也有可能无线是过滤IP,也有可能获取的IP都不是过滤IP
						if tc_dut_ip==@tc_pc_ip
								puts "执行PC网卡被过滤".to_gbk
								rs = ping(net_ip)
								refute(rs, "重启后源IP过滤失败，本机IP被过滤后仍能ping通外网！")
								puts "在PC2上ping #{net_ip}".to_gbk
								ts = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
								assert(ts, "重启IP过滤失败，PC2ip未过滤却不能ping通外网！")
						elsif wireless_ip==@tc_pc_ip
								puts "无线网卡被过滤".to_gbk
								rs = ping(net_ip)
								assert(rs, "重启后源IP过滤失败,本机ip未过滤却不能ping通外网!")
								puts "在PC2上ping #{@ts_web}".to_gbk
								ts = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
								refute(ts, "重启源IP过滤失败，PC2ip被过滤后仍能ping通外网！")
						else
								puts "都未被过滤".to_gbk
								assert(false, "脚本需要适配")
						end
				}


		end

		def clearup

				operate("1 恢复默认配置") {
						p "断开wifi连接".to_gbk
						@tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
						sleep @tc_wait_time

						options_page = RouterPageObject::OptionsPage.new(@browser)
						login_ui     = options_page.login_with_exists(@browser.url)
						if login_ui
								rs_login = login_no_default_ip(@browser) #重新登录
								p rs_login[:flag]
								p rs_login[:message]
						end
						options_page.ipfilter_close_sw_del_all_step(@browser.url)

						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.save_wifi_config
				}

		end

}
