#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.30", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi          = DRbObject.new_with_uri(@ts_drb_server)
				@tc_default_pw = "12345678"
				@tc_5g_sw_on   = "ON"
				@tc_5g_sw_off  = "OFF"
				@tc_wifi_time  = 40
				@tc_linknum    = "5"
		end

		def process

				operate("1、输入框中输入1，点击保存") {
						@wifi_page   = RouterPageObject::WIFIPage.new(@browser)
						@tc_mac_last = @wifi_page.get_mac_last
						@wifi_page.select_5g_basic(@browser.url)

						new_ssid1 = "wirless1_5g_#{@tc_mac_last}"
						new_ssid2 = "wirless2_5g_#{@tc_mac_last}"
						new_ssid3 = "wirless3_5g_#{@tc_mac_last}"
						new_ssid4 = "wirless4_5g_#{@tc_mac_last}"
						new_ssid5 = "wirless5_5g_#{@tc_mac_last}"
						new_ssid6 = "wirless6_5g_#{@tc_mac_last}"
						new_ssid7 = "wirless7_5g_#{@tc_mac_last}"
						new_ssid8 = "wirless8_5g_#{@tc_mac_last}"
						puts "新SSID1名为#{new_ssid1}".to_gbk
						puts "新SSID2名为#{new_ssid2}".to_gbk
						puts "新SSID3名为#{new_ssid3}".to_gbk
						puts "新SSID4名为#{new_ssid4}".to_gbk
						#ssid1
						@wifi_page.modify_ssid1_5g(new_ssid1)
						ssid_mode = @wifi_page.ssid1_pwmode_5g
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID1密码为#{@tc_default_pw}".to_gbk
								@wifi_page.modify_ssid1_pw_5g(@tc_default_pw)
						end
						puts "修改SSID1无线连接数为#{@ts_linknum_min}".to_gbk
						@wifi_page.modify_ssid1_linknum_5g(@ts_linknum_min)
						status_sw1_5g = @wifi_page.ssid1_sw_5g
						if status_sw1_5g == @tc_5g_sw_off
								puts "修改SSID1无线开关状态为#{@tc_5g_sw_on}".to_gbk
								@wifi_page.ssid1_sw_5g=@tc_5g_sw_on
						end
						#ssid2
						@wifi_page.modify_ssid2_5g(new_ssid2)
						ssid_mode = @wifi_page.ssid2_pwmode_5g
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID2密码为#{@tc_default_pw}".to_gbk
								@wifi_page.modify_ssid2_pw_5g(@tc_default_pw)
						end
						puts "修改SSID2无线连接数为#{@ts_linknum_min}".to_gbk
						@wifi_page.modify_ssid2_linknum_5g(@ts_linknum_min)
						status_sw2_5g = @wifi_page.ssid2_sw_5g
						if status_sw2_5g == @tc_5g_sw_off
								puts "修改SSID2无线开关状态为#{@tc_5g_sw_on}".to_gbk
								@wifi_page.ssid2_sw_5g=@tc_5g_sw_on
						end
						#ssid3
						@wifi_page.modify_ssid3_5g(new_ssid3)
						ssid_mode = @wifi_page.ssid3_pwmode_5g
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID3密码为#{@tc_default_pw}".to_gbk
								@wifi_page.modify_ssid3_pw_5g(@tc_default_pw)
						end
						puts "修改SSID3无线连接数为#{@ts_linknum_min}".to_gbk
						@wifi_page.modify_ssid3_linknum_5g(@ts_linknum_min)
						status_sw3_5g = @wifi_page.ssid3_sw_5g
						if status_sw3_5g == @tc_5g_sw_off
								puts "修改SSID3无线开关状态为#{@tc_5g_sw_on}".to_gbk
								@wifi_page.ssid3_sw_5g=@tc_5g_sw_on
						end
						#ssid4
						@wifi_page.modify_ssid4_5g(new_ssid4)
						ssid_mode = @wifi_page.ssid4_pwmode_5g
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID4密码为#{@tc_default_pw}".to_gbk
								@wifi_page.modify_ssid4_pw_5g(@tc_default_pw)
						end
						puts "修改SSID4无线连接数为#{@ts_linknum_min}".to_gbk
						@wifi_page.modify_ssid4_linknum_5g(@ts_linknum_min)
						status_sw4_5g = @wifi_page.ssid4_sw_5g
						if status_sw4_5g == @tc_5g_sw_off
								puts "修改SSID4无线开关状态为#{@tc_5g_sw_on}".to_gbk
								@wifi_page.ssid4_sw_5g=@tc_5g_sw_on
						end
						#ssid5
						if @wifi_page.ssid5_5g?
								@wifi_page.modify_ssid4_5g(new_ssid5)
								ssid_mode = @wifi_page.ssid5_pwmode_5g
								unless ssid_mode==@ts_sec_mode_wpa
										puts "修改SSID5密码为#{@tc_default_pw}".to_gbk
										@wifi_page.modify_ssid5_pw_5g(@tc_default_pw)
								end
								puts "修改SSID5无线连接数为#{@ts_linknum_min}".to_gbk
								@wifi_page.modify_ssid5_linknum_5g(@ts_linknum_min)
								status_sw5_5g = @wifi_page.ssid5_sw_5g
								if status_sw5_5g == @tc_5g_sw_off
										puts "修改SSID5无线开关状态为#{@tc_5g_sw_on}".to_gbk
										@wifi_page.ssid5_sw_5g=@tc_5g_sw_on
								end
						end

						#ssid6
						if @wifi_page.ssid6_5g?
								@wifi_page.modify_ssid6_5g(new_ssid6)
								ssid_mode = @wifi_page.ssid6_pwmode_5g
								unless ssid_mode==@ts_sec_mode_wpa
										puts "修改SSID6密码为#{@tc_default_pw}".to_gbk
										@wifi_page.modify_ssid6_pw_5g(@tc_default_pw)
								end
								puts "修改SSID6无线连接数为#{@ts_linknum_min}".to_gbk
								@wifi_page.modify_ssid6_linknum_5g(@ts_linknum_min)
								status_sw6_5g = @wifi_page.ssid6_sw_5g
								if status_sw6_5g == @tc_5g_sw_off
										puts "修改SSID6无线开关状态为#{@tc_5g_sw_on}".to_gbk
										@wifi_page.ssid6_sw_5g=@tc_5g_sw_on
								end
						end

						#ssid7
						if @wifi_page.ssid7_5g?
								@wifi_page.modify_ssid7_5g(new_ssid7)
								ssid_mode = @wifi_page.ssid7_pwmode_5g
								unless ssid_mode==@ts_sec_mode_wpa
										puts "修改SSID7密码为#{@tc_default_pw}".to_gbk
										@wifi_page.modify_ssid7_pw_5g(@tc_default_pw)
								end
								puts "修改SSID7无线连接数为#{@ts_linknum_min}".to_gbk
								@wifi_page.modify_ssid7_linknum_5g(@ts_linknum_min)
								status_sw7_5g = @wifi_page.ssid7_sw_5g
								if status_sw7_5g == @tc_5g_sw_off
										puts "修改SSID7无线开关状态为#{@tc_5g_sw_on}".to_gbk
										@wifi_page.ssid7_sw_5g=@tc_5g_sw_on
								end
						end

						#ssid8
						if @wifi_page.ssid8_5g?
								@wifi_page.modify_ssid8_5g(new_ssid8)
								ssid_mode = @wifi_page.ssid8_pwmode_5g
								unless ssid_mode==@ts_sec_mode_wpa
										puts "修改SSID8密码为#{@tc_default_pw}".to_gbk
										@wifi_page.modify_ssid8_pw_5g(@tc_default_pw)
								end
								puts "修改SSID8无线连接数为#{@ts_linknum_min}".to_gbk
								@wifi_page.modify_ssid8_linknum_5g(@ts_linknum_min)
								status_sw8_5g = @wifi_page.ssid8_sw_5g
								if status_sw8_5g == @tc_5g_sw_off
										puts "修改SSID8无线开关状态为#{@tc_5g_sw_on}".to_gbk
										@wifi_page.ssid8_sw_5g=@tc_5g_sw_on
								end
						end
						@wifi_page.save_wifi_config

						puts "无线连接客户端连接SSID1".to_gbk
						curr_ssid_name = @wifi_page.ssid1_5g
						curr_ssid_pw   = @wifi_page.ssid1_pw_5g
						link_num       = @wifi_page.ssid1_link_5g
						assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
						rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
						assert rs1_ssid, 'WIFI连接失败'
						rs2_ssid = @wifi.ping(@ts_default_ip)
						assert rs2_ssid, 'WIFI客户端无法ping通路由器'

						puts "无线连接客户端连接SSID2".to_gbk
						curr_ssid_name = @wifi_page.ssid2_5g
						curr_ssid_pw   = @wifi_page.ssid2_pw_5g
						link_num       = @wifi_page.ssid2_link_5g
						assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
						rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
						assert rs1_ssid, 'WIFI连接失败'
						rs2_ssid = @wifi.ping(@ts_default_ip)
						assert rs2_ssid, 'WIFI客户端无法ping通路由器'

						puts "无线连接客户端连接SSID3".to_gbk
						curr_ssid_name = @wifi_page.ssid3_5g
						curr_ssid_pw   = @wifi_page.ssid3_pw_5g
						link_num       = @wifi_page.ssid3_link_5g
						assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
						rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
						assert rs1_ssid, 'WIFI连接失败'
						rs2_ssid = @wifi.ping(@ts_default_ip)
						assert rs2_ssid, 'WIFI客户端无法ping通路由器'

						puts "无线连接客户端连接SSID4".to_gbk
						curr_ssid_name = @wifi_page.ssid4_5g
						curr_ssid_pw   = @wifi_page.ssid4_pw_5g
						link_num       = @wifi_page.ssid4_link_5g
						assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
						rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
						assert rs1_ssid, 'WIFI连接失败'
						rs2_ssid = @wifi.ping(@ts_default_ip)
						assert rs2_ssid, 'WIFI客户端无法ping通路由器'

						if @wifi_page.ssid5_5g?
								puts "无线连接客户端连接SSID5".to_gbk
								curr_ssid_name = @wifi_page.ssid5_5g
								curr_ssid_pw   = @wifi_page.ssid5_pw_5g
								link_num       = @wifi_page.ssid5_link_5g
								assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
								rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
								assert rs1_ssid, 'WIFI连接失败'
								rs2_ssid = @wifi.ping(@ts_default_ip)
								assert rs2_ssid, 'WIFI客户端无法ping通路由器'
						end

						if @wifi_page.ssid6_5g?
								puts "无线连接客户端连接SSID6".to_gbk
								curr_ssid_name = @wifi_page.ssid6_5g
								curr_ssid_pw   = @wifi_page.ssid6_pw_5g
								link_num       = @wifi_page.ssid6_link_5g
								assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
								rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
								assert rs1_ssid, 'WIFI连接失败'
								rs2_ssid = @wifi.ping(@ts_default_ip)
								assert rs2_ssid, 'WIFI客户端无法ping通路由器'
						end

						if @wifi_page.ssid7_5g?
								puts "无线连接客户端连接SSID7".to_gbk
								curr_ssid_name = @wifi_page.ssid7_5g
								curr_ssid_pw   = @wifi_page.ssid7_pw_5g
								link_num       = @wifi_page.ssid7_link_5g
								assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
								rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
								assert rs1_ssid, 'WIFI连接失败'
								rs2_ssid = @wifi.ping(@ts_default_ip)
								assert rs2_ssid, 'WIFI客户端无法ping通路由器'
						end

						if @wifi_page.ssid8_5g?
								puts "无线连接客户端连接SSID8".to_gbk
								curr_ssid_name = @wifi_page.ssid8_5g
								curr_ssid_pw   = @wifi_page.ssid8_pw_5g
								link_num       = @wifi_page.ssid8_link_5g
								assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
								rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
								assert rs1_ssid, 'WIFI连接失败'
								rs2_ssid = @wifi.ping(@ts_default_ip)
								assert rs2_ssid, 'WIFI客户端无法ping通路由器'
						end
				}

				operate("2、输入框中输入#{@tc_linknum}，点击保存") {
						if @wifi_page.login_with_exists(@browser.url)
								login_no_default_ip(@browser)
								@wifi_page.select_5g_basic(@browser.url)
						end
						@wifi_page.modify_ssid1_linknum_5g(@tc_linknum)
						@wifi_page.modify_ssid2_linknum_5g(@tc_linknum)
						@wifi_page.modify_ssid3_linknum_5g(@tc_linknum)
						@wifi_page.modify_ssid4_linknum_5g(@tc_linknum)
						if @wifi_page.ssid5_5g?
								@wifi_page.modify_ssid5_linknum(@tc_linknum)
						end
						if @wifi_page.ssid6_5g?
								@wifi_page.modify_ssid6_linknum(@tc_linknum)
						end
						if @wifi_page.ssid7_5g?
								@wifi_page.modify_ssid7_linknum(@tc_linknum)
						end
						if @wifi_page.ssid8_5g?
								@wifi_page.modify_ssid8_linknum(@tc_linknum)
						end
						@wifi_page.save_wifi_config
						puts "查询SSID1最大连接数设置".to_gbk
						link_num = @wifi_page.ssid1_link_5g
						assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						puts "查询SSID2最大连接数设置".to_gbk
						link_num = @wifi_page.ssid2_link_5g
						assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						puts "查询SSID3最大连接数设置".to_gbk
						link_num = @wifi_page.ssid3_link_5g
						assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						puts "查询SSID4最大连接数设置".to_gbk
						link_num = @wifi_page.ssid4_link_5g
						assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						if @wifi_page.ssid5_5g?
								puts "查询SSID5最大连接数设置".to_gbk
								link_num = @wifi_page.ssid5_link_5g
								assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						end
						if @wifi_page.ssid6_5g?
								puts "查询SSID6最大连接数设置".to_gbk
								link_num = @wifi_page.ssid6_link_5g
								assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						end
						if @wifi_page.ssid7_5g?
								puts "查询SSID7最大连接数设置".to_gbk
								link_num = @wifi_page.ssid7_link_5g
								assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						end
						if @wifi_page.ssid8_5g?
								puts "查询SSID8最大连接数设置".to_gbk
								link_num = @wifi_page.ssid8_link_5g
								assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						end
				}

				operate("3、输入框中输入#{@ts_linknum_max}，点击保存") {
						@wifi_page.modify_ssid1_linknum_5g(@ts_linknum_max)
						@wifi_page.modify_ssid2_linknum_5g(@ts_linknum_max)
						@wifi_page.modify_ssid3_linknum_5g(@ts_linknum_max)
						@wifi_page.modify_ssid4_linknum_5g(@ts_linknum_max)
						if @wifi_page.ssid5_5g?
								@wifi_page.modify_ssid5_linknum_5g(@ts_linknum_max)
						end
						if @wifi_page.ssid6_5g?
								@wifi_page.modify_ssid6_linknum_5g(@ts_linknum_max)
						end
						if @wifi_page.ssid7_5g?
								@wifi_page.modify_ssid7_linknum_5g(@ts_linknum_max)
						end
						if @wifi_page.ssid8_5g?
								@wifi_page.modify_ssid8_linknum_5g(@ts_linknum_max)
						end
						@wifi_page.save_wifi_config
						puts "查询SSID1最大连接数设置".to_gbk
						link_num = @wifi_page.ssid1_link_5g
						assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						puts "查询SSID2最大连接数设置".to_gbk
						link_num = @wifi_page.ssid2_link_5g
						assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						puts "查询SSID3最大连接数设置".to_gbk
						link_num = @wifi_page.ssid3_link_5g
						assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						puts "查询SSID4最大连接数设置".to_gbk
						link_num = @wifi_page.ssid4_link
						assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						if @wifi_page.ssid5_5g?
								puts "查询SSID5最大连接数设置".to_gbk
								link_num = @wifi_page.ssid5_link_5g
								assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						end
						if @wifi_page.ssid6_5g?
								puts "查询SSID6最大连接数设置".to_gbk
								link_num = @wifi_page.ssid6_link_5g
								assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						end
						if @wifi_page.ssid7_5g?
								puts "查询SSID7最大连接数设置".to_gbk
								link_num = @wifi_page.ssid7_link_5g
								assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						end
						if @wifi_page.ssid8_5g?
								puts "查询SSID8最大连接数设置".to_gbk
								link_num = @wifi_page.ssid8_link_5g
								assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						end
				}

				operate("4、无线SSID1和SSID8都做同样操作；") {

				}


		end

		def clearup
				@options_page = RouterPageObject::OptionsPage.new(@browser)
				if @options_page.login_with_exists(@browser.url)
						login_no_default_ip(@browser)
				end
				@options_page.recover_factory(@browser.url)
		end

}
