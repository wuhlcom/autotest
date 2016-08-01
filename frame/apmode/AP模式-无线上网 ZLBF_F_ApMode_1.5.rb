#
# description:
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
testcase {
		attr = {"id" => "ZLBF_ApMode_1.1.5", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi           = DRbObject.new_with_uri(@ts_drb_server)
				@tc_static_args = {nicname: @ts_nicname, source: "static", ip: "192.168.100.15", mask: "255.255.255.0", gateway: @ts_default_ip}
				@tc_dhcp_args   = {nicname: @ts_nicname, source: "dhcp"}
		end

		def process

				operate("1、PC1通过无线连接DUT的SSID1，查看是否连接成功，是否能获取到上行AP分配的ip地址；") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.save_apmode(@browser.url) #切换到IP模式

						#配置静态IP
						#配置一个lan侧静态ip，用来登录路由器修改ssid
						netsh_if_ip_setip(@tc_static_args)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #重新登录
						@wifi_page    = RouterPageObject::WIFIPage.new(@browser)
						wireless_info = @wifi_page.modify_ssid_mode_pwd(@browser.url, "Wireless0")
						#网卡恢复成动态IP
						#动态IP
						netsh_if_ip_setip(@tc_dhcp_args)
						flag          = "1"
						rs1           = @wifi.connect(wireless_info[:ssid], flag, wireless_info[:pwd])
						assert rs1, 'WIFI连接失败'
						rs = @wifi.ipconfig
						puts "无线网卡获取的IP为：#{rs[@ts_wlan_nicname][:ip]}".to_gbk
						rs2 = @wifi.ping(@ts_web)
						assert rs2, 'WIFI客户端无法ping外网'
				}

				operate("2、PC1通过无线分别连接DUT的SSID1到SSID8，查看是否能获取到上行AP分配的ip地址；") {

				}


		end

		def clearup

				operate("1.恢复默认设置") {
						@wifi.netsh_disc_all
						netsh_if_ip_setip(@tc_static_args)
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #重新登录
						@mode_page.open_mode_page(@browser.url)
						@tc_flag = false
						unless @mode_page.routermode_selected?
								puts "恢复为路由模式".to_gbk
								@tc_flag = true
								@mode_page.set_router_mode
						end
						#动态IP
						netsh_if_ip_setip(@tc_dhcp_args)
				}

				operate("2 恢复默认ssid和密码") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) if @tc_flag #重新登录
						@wifi_page.select_2g_basic(@browser.url)
						#修改第一个SSID密码
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						@wifi_page.save_wifi_config
				}
		end

}
