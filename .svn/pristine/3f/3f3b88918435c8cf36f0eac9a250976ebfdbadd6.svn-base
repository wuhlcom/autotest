#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.30", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_lan_ip      = "192.168.90.1"
				@tc_lan_start   = "50"
				@tc_lan_end     = "100"
				@flag           = false
				@tc_wait_time   = 20
		end

		def process

				operate("1、登录DUT管理页面；") {
						p "先恢复出厂设置，查看默认值".to_gbk
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.recover_factory(@browser.url)
						rs_login = @options_page.login_with_exists(@browser.url)

						assert(rs_login, "恢复出厂设置后未跳转到登录界面！")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@status_page = RouterPageObject::SystatusPage.new(@browser)
						@status_page.open_systatus_page(@browser.url)
						@wan_default_type = @status_page.get_wan_type
						p "默认接入方式是：#{@wan_default_type}".to_gbk

						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						@lan_ip_default    = @lan_page.lan_ip
						@lan_start_default = @lan_page.lan_startip
						@lan_end_default   = @lan_page.lan_endip
						p "默认内网IP：#{@lan_ip_default}".to_gbk
						p "默认开始地址池：#{@lan_start_default}".to_gbk
						p "默认结束地址池：#{@lan_end_default}".to_gbk

						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.open_wifi_page(@browser.url)
						@dut_ssid_default = @wifi_page.ssid1
						p "默认ssid：#{@dut_ssid_default}".to_gbk

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@options_page.open_security_page_step(@browser.url)
						@options_page.firewall_click #进入防火墙设置页面
						@fire_wall_default = @options_page.firewall_switch_element.class_name
						@ip_btn_default    = @options_page.ip_filter_switch_element.class_name
						@mac_btn_default   = @options_page.mac_filter_switch_element.class_name
						@url_btn_default   = @options_page.url_filter_switch_element.class_name
						p "默认防火墙开关状态：#{@fire_wall_default}".to_gbk
						p "默认IP过滤开关状态：#{@ip_btn_default}".to_gbk
						p "默认MAC过滤开关状态：#{@mac_btn_default}".to_gbk
						p "默认URL过滤开关状态：#{@url_btn_default}".to_gbk
						@options_page.open_apply_page #打开应用界面
						@options_page.open_vps_page #进入虚拟服务器界面
						@vir_btn_default = @options_page.vps_switch_status
						p "默认虚拟服务器开关状态：#{@vir_btn_default}".to_gbk
				}

				operate("2、配置WAN连接为静态IP地址方式，修改LAN口IP地址，修改地址池范围，修改无线SSID，修改无线安全，修改无线高级参数，添加端口转发规则、端口触发规则、添加URL过滤规则、IP与端口过滤规则、开启UPNP功能、开启DMZ功能、开启DDNS功能、修改登录密码等页面所有可配置的选项；") {
						p "配置WAN连接为静态IP地址方式".to_gbk
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)

						@status_page.open_systatus_page(@browser.url)
						wan_type = @status_page.get_wan_type
						wan_ip   = @status_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_ip}".to_gbk
						assert_equal(@ts_wan_mode_static, wan_type, '接入类型错误！')
						assert_equal(@ts_staticIp, wan_ip, '静态IP配置失败！')

						p "修改系统设置其他配置项".to_gbk
						@options_page.open_security_page_step(@browser.url) #进入安全页面
						@options_page.open_switch("on", "on", "on", "on") #打开防火墙，ip过滤、mac过滤、url过滤总开关
						@options_page.open_apply_page #进入应用设置界面
						@options_page.open_vps_page #进入虚拟服务器界面
						@options_page.open_vps_btn #打开虚拟服务器开关
						@options_page.save_vps
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						p "修改无线ssid".to_gbk
						@wifi_page.modify_ssid_mode_pwd(@browser.url)
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						p "修改LAN口IP地址，修改地址池范围".to_gbk #放最后修改，防止刘改lan侧ip后浏览器连接不上
						@lan_page.open_lan_page(@browser.url)
						@lan_page.lan_ip_set(@tc_lan_ip)
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.btn_save_lanset
				}

				operate("3、使用命令进行复位，查看设置的参数是否全部复位成出厂默认状态；") {
						sleep @tc_wait_time
						rs = ping(@tc_lan_ip)
						assert(rs, "PING修改后的LAN IP #{@tc_lan_ip}失败!")
						telnet_init(@tc_lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						exp_ralink_init #恢复出厂设置
						#做一个标志位，当代码执行到此时，表示脚本已进行了恢复出厂设置，这时不在clearup中恢复出厂设置了，否则就执行clearup代码块，减少脚本执行时间
						@flag = true
						@status_page.clear_cookies #清除cookies
						@status_page.clear_cookies #清除cookies
						@status_page.refresh
						sleep 2
						@status_page.refresh
						sleep 2
						# rs = @status_page.login_with_exists(@browser.url)
						# assert(rs, "命令行恢复出厂设置后，清除cookies重新打开登录页面失败")
						rs_relogin = @status_page.login_with(@ts_default_usr, @ts_defalut_pw, @ts_default_ip)
						assert(rs_relogin, "命令行恢复出厂设置后，清除cookies后重新登录失败")
						p "恢复出厂设置后查看配置是否恢复".to_gbk
						@status_page.open_systatus_page(@browser.url)
						wan_type = @status_page.get_wan_type
						assert_equal(@wan_default_type, wan_type, "恢复出厂设置后，接入类型未恢复成默认接入类型")

						@wifi_page.open_wifi_page(@browser.url)
						dut_ssid = @wifi_page.ssid1
						assert_equal(@dut_ssid_default, dut_ssid, "恢复出厂设置后，ssid未恢复成默认ssid")

						@lan_page.open_lan_page(@browser.url)
						lan_ip    = @lan_page.lan_ip
						lan_start = @lan_page.lan_startip
						lan_end   = @lan_page.lan_endip
						assert_equal(@lan_ip_default, lan_ip, "恢复出厂设置后，局域网ip未恢复成默认ip")
						assert_equal(@lan_start_default, lan_start, "恢复出厂设置后，DHCP开始地址未恢复成默认开始地址")
						assert_equal(@lan_end_default, lan_end, "恢复出厂设置后，DHCP结束地址未恢复成默认结束地址")

						@options_page.open_security_page_step(@browser.url)
						@options_page.firewall_click #进入防火墙设置页面
						fire_wall = @options_page.firewall_switch_element.class_name
						ip_btn    = @options_page.ip_filter_switch_element.class_name
						mac_btn   = @options_page.mac_filter_switch_element.class_name
						url_btn   = @options_page.url_filter_switch_element.class_name
						assert_equal(@fire_wall_default, fire_wall, "恢复出厂设置后，防火墙开关未恢复默认状态")
						assert_equal(@ip_btn_default, ip_btn, "恢复出厂设置后，ip过滤开关未恢复默认状态")
						assert_equal(@mac_btn_default, mac_btn, "恢复出厂设置后，mac过滤开关未恢复默认状态")
						assert_equal(@url_btn_default, url_btn, "恢复出厂设置后，url过滤开关未恢复默认状态")
						@options_page.open_apply_page #打开应用界面
						@options_page.open_vps_page #进入虚拟服务器界面
						vir_btn = @options_page.vps_switch_status
						assert_equal(@vir_btn_default, vir_btn, "恢复出厂设置后，虚拟服务器开关未恢复默认状态")
				}

		end

		def clearup
				operate("1 恢复默认出厂设置") {
						unless @flag
								url = ipconfig[@ts_nicname][:gateway][0]
								telnet_init(url, @ts_unified_platform_user, @ts_unified_platform_pwd)
								exp_ralink_init #恢复出厂设置
						end
				}
		end

}
