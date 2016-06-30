#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wifi_flag    = "1"
				@wifi            = DRbObject.new_with_uri(@ts_drb_server)
				@tc_conn_time    = 10
				@tc_num_letter   = "123"*10+"Adf"*10+"12k"
				@tc_wlan_pw_arr1 = ["ABCDEFGH", "AyzkEDXf", "51d2A3bck", @tc_num_letter]
		end

		def process

				operate("1 打开网络连接设置") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
				}

				operate("2 连接路由器WIFI") {
						@wifi_page     = RouterPageObject::WIFIPage.new(@browser)
						rs_wifi        = @wifi_page.modify_ssid_mode_pwd(@browser.url)
						@tc_ssid1_name = rs_wifi[:ssid]
						rs             = @wifi.connect(@tc_ssid1_name, @tc_wifi_flag, @ts_default_wlan_pw)
						assert rs, "WIFI连接失败"
				}

				operate("3 修改WIFI密码后重新连接") {
						@tc_wlan_pw_arr1.each do |pw|
								puts("修改密码为：#{pw}".to_gbk)
								@wifi_page.change_ssid1_pw(pw, @browser.url)
								#只修改密码不会进行页面跳转 wuhongliang 2015-8-19
								puts("连接wifi".to_gbk)
								rs1 = @wifi.connect(@tc_ssid1_name, @tc_wifi_flag, pw)
								assert rs1, "WIFI连接失败"
								puts("ping IP地址：#{@ts_default_ip}".to_gbk)
								rs2 = @wifi.ping(@ts_default_ip)
								assert rs2, "WIFI连接失败未获取IP地址"
								@wifi.netsh_disc_all #断开wifi连接
								sleep @tc_conn_time
						end
				}
		end

		def clearup
				operate("1 恢复默认密码") {
						@wifi.netsh_disc_all #断开wifi连接
						wifi_page = RouterPageObject::WIFIPage.new(@browser)
						if wifi_page.login_with_exists(@browser.url)
								rs_login = login_no_default_ip(@browser) #重新登录
								p rs_login[:flag]
								p rs_login[:message]
						end
						wifi_page.modify_default_ssid(@browser.url)
				}
		end

}
