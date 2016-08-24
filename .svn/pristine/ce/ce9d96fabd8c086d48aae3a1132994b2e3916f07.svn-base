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
				@tc_tag_lan      = "set_wifi"
				@tc_pw_errinfo   = "密码只能是数字,字母和特殊字符(~!@\#$*()_{}<>?.[]-=`^+:),长度为8-63个字符"
				@tc_num_letter   = "123"*10+"Adf"*10+"12k"
				@tc_pw_64        = "1"*64
				@tc_pw_7         = "a"*7
				@tc_pw_space1    = " 25678df"
				@tc_pw_space2    = "25678df "
				@tc_pw_space3    = "25678 df"
				@tc_pw_specail   = "25678%df"
				@tc_wlan_pw_arr1 = ["ABCDEFGH", "AyzkEDXf", "51d2A3bck", @tc_num_letter]
				@tc_wlan_pw_arr2 = [@tc_pw_7, @tc_pw_space1, @tc_pw_space2, @tc_pw_space3, @tc_pw_specail, @tc_pw_64]

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

				operate("4 非法用户名和密码无法保存") {
						@tc_wlan_pw_arr2.each do |pw|
								unless @wifi_page.ssid1?
										@wifi_page.select_2g_basic(@browser.url)
								end
								puts("修改密码为：#{pw}".to_gbk)
								@wifi_page.modify_ssid1_pw(pw)
								@wifi_page.save_wifi

								errinfo = @wifi_page.wifi_error
								puts("ERROR:#{errinfo}".to_gbk)
								assert_equal(@tc_pw_errinfo, errinfo, "非密码也能保存")
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
