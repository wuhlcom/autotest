#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.10", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_upload_file_current = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_current/i }
				puts "Current version file:#{@tc_upload_file_current}"

				@tc_upload_file_old = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_old/i }
				puts "Old version file:#{@tc_upload_file_old}"

				@tc_new_ssid1   = "Hello9527"
				@tc_new_channel = "2457MHz(Channel 10)"
		end

		def process
				# 1、登录DUT，进入升级页面；
				# 2、在升级页面中，选择浏览，选择正确的测试升级文件,勾选“清除配置，”点击升级，进入升级中，查看升级中提示是否正确；
				# 3、升级成功后，WEB页面是否能实现自动跳转，查看升级成功后版本号是否正确；
				# 4、升级成功后，配置是否为默认配置，DHCP拨号成功；
				operate("1、登录到DUT管理页面,将路由器恢复出厂设置后,再配置WAN，SSID，信道") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@status_page  = RouterPageObject::SystatusPage.new(@browser)

						@options_page.recover_factory(@browser.url)
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "恢复出厂设置后未跳转到路由器登录页面!")

						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@status_page.open_systatus_page(@browser.url)
						p wan_type = @sys_page.get_wan_type
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						@tc_ssid1_default = @wifi_page.ssid1
						@wifi_page.modify_ssid1(@tc_new_ssid1) #修改ssid

						@wifi_page.select_2g_adv
						@tc_default_channel     = @wifi_page.wifi_channel
						@wifi_page.wifi_channel = @tc_new_channel #修改信道
						@wifi_page.save_wifi_config

						@wifi_page.select_2g_basic(@browser.url)
						@tc_ssid1_name = @wifi_page.ssid1

						@wifi_page.select_2g_adv
						@tc_channel = @wifi_page.wifi_channel

						assert_equal(@tc_new_ssid1, @tc_ssid1_name, "SSID修改失败")
						assert_equal(@tc_new_channel, @tc_channel, "信道修改失败")
				}

				operate("2、登录到DUT管理页面，进行到升级页面；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@status_page  = RouterPageObject::SystatusPage.new(@browser)
						p "首先先将测试版本降级到低版本！".to_gbk
						@options_page.update_step(@browser.url, @tc_upload_file_old)

						rs = @login_page.login_with_exists(@browser.url)
						assert(rs, "跳转到登录页面失败!")
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						@status_page.open_systatus_page(@browser.url)
						sysversion     = @status_page.get_current_software_ver
						actual_version = @tc_upload_file_old.slice(/V\d+R\d+C\d+/i)
						assert_equal(sysversion, actual_version, "降级失败！")
				}

				operate("2、在上条用例的基础上，选择当前测试版本的软件，点击升级，查看升级是否成功，升级后版本号是否正确。") {
						p "再讲版本升级到当前测试版本！".to_gbk
						@options_page.update_step(@browser.url, @tc_upload_file_current)

						rs = @login_page.login_with_exists(@browser.url)
						assert(rs, "跳转到登录页面失败!")
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						@status_page.open_systatus_page(@browser.url)
						sysversion     = @status_page.get_current_software_ver
						actual_version = @tc_upload_file_current.slice(/V\d+R\d+C\d+/i)
						assert_equal(sysversion, actual_version, "升级失败！")
				}
		end

		def clearup
				operate("1、恢复到当前版本；") {
						@status_page.open_systatus_page(@browser.url)
						sysversion     = @status_page.get_current_software_ver
						actual_version = @tc_upload_file_current.slice(/V\d+R\d+C\d+/i)
						unless sysversion == actual_version
								options_page = RouterPageObject::OptionsPage.new(@browser)
								options_page.update_step(@browser.url, @tc_upload_file_current)
						end
				}
		end

}
