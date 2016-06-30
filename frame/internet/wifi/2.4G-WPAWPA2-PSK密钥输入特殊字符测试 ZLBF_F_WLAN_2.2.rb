#
# description:
# html,javascipt,td等html页面代码做为密码应该不能输入或能输入但不会出异常·
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.11", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wifi_time = 40
				@tc_wait_time = 2
				@tc_wpa_pw    = "~!@\#$*()_{}<>?.[]-=`^+:"
				@tc_flag      = false
		end

		def process

				operate("1、进入AP的管理页面，进入无线基本功能页面，加密选择为WPA-PSK/WPA2-PSK混合加密；") {
				}

				operate("2、秘钥输入32个特殊字符“~!@#$%^&*()_+-={}:\"<>?[]|\; ',./`”，是否可以设置成功，STA是否可以连接成功；") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#逐个SSID测试以排除SSID之间的影响
						#输入允许输入的特殊字符保存成功
						puts "修改第一个SSID密码为#{@tc_wpa_pw}".to_gbk
						@wifi_page.modify_ssid1_pw(@tc_wpa_pw)
						@wifi_page.save_wifi_config
						error_tip = @wifi_page.wifi_error
						if error_tip == @ts_wifi_pw_err
								assert(false, "特殊字符#{@tc_wpa_pw}设置为密码失败") #特殊字符保存失败
						else
								puts "特殊字符#{@tc_wpa_pw}设置成密码成功".to_gbk #特殊字符保存成功
						end

						curr_pw = @wifi_page.ssid1_pw
						assert_equal(@tc_wpa_pw, curr_pw, "设置密码失败!")

						#输入非法特殊字符
						@ts_special_char_notallow.each do |item|
								tc_wpa_pw = "abyz#{item}0189"
								puts "修改第一个SSID密码为#{tc_wpa_pw}".to_gbk
								@wifi_page.modify_ssid1_pw(tc_wpa_pw)
								@wifi_page.save_wifi
								sleep @tc_wait_time
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP #{error_tip}".to_gbk
								if error_tip == @ts_wifi_pw_err
										puts "无线密码中不能有特殊字符#{item}".to_gbk
								else
										@tc_flag =true
										assert(false, "特殊字符#{item}设置为密码时出现异常")
								end
						end

						#输入允许输入的特殊字符保存成功
						puts "修改第二个SSID密码为#{@tc_wpa_pw}".to_gbk
						@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid2_pw(@tc_wpa_pw)
						@wifi_page.save_wifi_config
						error_tip = @wifi_page.wifi_error
						if error_tip == @ts_wifi_pw_err
								assert(false, "特殊字符#{@tc_wpa_pw}设置为密码失败")
						else
								puts "特殊字符#{@tc_wpa_pw}设置成密码成功".to_gbk
						end

						curr_pw = @wifi_page.ssid2_pw
						assert_equal(@tc_wpa_pw, curr_pw, "设置密码失败!")
						#输入非法特殊字符
						@ts_special_char_notallow.each do |item|
								tc_wpa_pw = "abyz#{item}0189"
								puts "修改第二个SSID密码为#{tc_wpa_pw}".to_gbk
								@wifi_page.modify_ssid2_pw(tc_wpa_pw)
								@wifi_page.save_wifi
								sleep @tc_wait_time
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP #{error_tip}".to_gbk
								if error_tip == @ts_wifi_pw_err
										puts "无线密码中不能有特殊字符#{item}".to_gbk
								else
										@tc_flag = true
										assert(false, "特殊字符#{item}设置为密码时出现异常")
								end
						end

						#退出路由器登录重新登录,以免路由器登录超时
						@wifi_page.close_wifi
						@wifi_page.refresh
						@wifi_page.logout
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						#输入允许输入的特殊字符保存成功
						puts "修改第三个SSID密码为#{@tc_wpa_pw}".to_gbk
						@wifi_page.select_2g_basic(@browser.url)
						@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid3_pw(@tc_wpa_pw)
						@wifi_page.save_wifi_config
						error_tip = @wifi_page.wifi_error
						if error_tip == @ts_wifi_pw_err
								assert(false, "特殊字符#{@tc_wpa_pw}设置为密码失败")
						else
								puts "特殊字符#{@tc_wpa_pw}设置成密码成功".to_gbk
						end
						curr_pw = @wifi_page.ssid3_pw
						assert_equal(@tc_wpa_pw, curr_pw, "设置密码失败!")
						#输入非法特殊字符
						@ts_special_char_notallow.each do |item|
								tc_wpa_pw = "abyz#{item}0189"
								puts "修改第三个SSID密码为#{tc_wpa_pw}".to_gbk
								@wifi_page.modify_ssid3_pw(tc_wpa_pw)
								@wifi_page.save_wifi
								sleep @tc_wait_time
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP #{error_tip}".to_gbk
								if error_tip == @ts_wifi_pw_err
										puts "无线密码中不能有特殊字符#{item}".to_gbk
								else
										@tc_flag = true
										assert(false, "特殊字符#{item}设置为密码时出现异常")
								end
						end

						#输入允许输入的特殊字符保存成功
						puts "修改第四个SSID密码为#{@tc_wpa_pw}".to_gbk
						@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid4_pw(@tc_wpa_pw)
						@wifi_page.save_wifi_config
						error_tip = @wifi_page.wifi_error
						if error_tip == @ts_wifi_pw_err
								assert(false, "特殊字符#{@tc_wpa_pw}设置为密码失败")
						else
								puts "特殊字符#{@tc_wpa_pw}设置成密码成功".to_gbk
						end

						curr_pw = @wifi_page.ssid4_pw
						assert_equal(@tc_wpa_pw, curr_pw, "设置密码失败!")
						#输入非法特殊字符
						@ts_special_char_notallow.each do |item|
								tc_wpa_pw = "abyz#{item}0189"
								puts "修改第四个SSID密码为#{tc_wpa_pw}".to_gbk
								@wifi_page.modify_ssid4_pw(tc_wpa_pw)
								@wifi_page.save_wifi
								sleep @tc_wait_time
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP #{error_tip}".to_gbk
								if error_tip == @ts_wifi_pw_err
										puts "无线密码中不能有特殊字符#{item}".to_gbk
								else
										@tc_flag = true
										assert(false, "特殊字符#{item}设置为密码时出现异常")
								end
						end
				}

		end

		def clearup
				operate("1 恢复默认密码") {
						#错误的密码格式也能保存的话，这里要等待其保存完成
						if @tc_flag
								puts "sleep #{@tc_wifi_time}"
								sleep @tc_wifi_time
						end
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						unless @wifi_page.lan?
								@wifi_page.refresh
								sleep 1
								@wifi_page.refresh
						end
						@wifi_page.select_2g_basic(@browser.url)
						#修改第一个SSID密码
						@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
						@wifi_page.save_wifi_config
				}
		end

}
