#
# description:
# 只做输入性测试，无法实现连接数的功能测试
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.22", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi        = DRbObject.new_with_uri(@ts_drb_server)
				@tc_linknum  = 5
				@tc_wifi_on  = "ON"
				@tc_wifi_off = "OFF"
		end

		def process

				operate("1、无线最大连接数为最小值#{@ts_linknum_min}，点击保存") {
						@wifi_page   = RouterPageObject::WIFIPage.new(@browser)
						@tc_mac_last = @wifi_page.get_mac_last
						@wifi_page.select_2g_basic(@browser.url)

						new_ssid1 = "wirless1_#{@tc_mac_last}"
						new_ssid2 = "wirless2_#{@tc_mac_last}"
						new_ssid3 = "wirless3_#{@tc_mac_last}"
						new_ssid4 = "wirless4_#{@tc_mac_last}"
						new_ssid5 = "wirless5_#{@tc_mac_last}"
						new_ssid6 = "wirless6_#{@tc_mac_last}"
						new_ssid7 = "wirless7_#{@tc_mac_last}"
						new_ssid8 = "wirless8_#{@tc_mac_last}"
						puts "新SSID1名为#{new_ssid1}".to_gbk
						puts "新SSID2名为#{new_ssid2}".to_gbk
						puts "新SSID3名为#{new_ssid3}".to_gbk
						puts "新SSID4名为#{new_ssid4}".to_gbk
						#ssid1
						@wifi_page.modify_ssid1(new_ssid1)
						ssid_mode = @wifi_page.ssid1_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID1密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						end
						puts "修改SSID1无线连接数为#{@ts_linknum_min}".to_gbk
						@wifi_page.modify_ssid1_linknum(@ts_linknum_min)
						if @wifi_page.ssid1_sw == @tc_wifi_off
								@wifi_page.ssid1_sw = @tc_wifi_on
						end

						#ssid2
						@wifi_page.modify_ssid2(new_ssid2)
						ssid_mode = @wifi_page.ssid2_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID2密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						end
						puts "修改SSID2无线连接数为#{@ts_linknum_min}".to_gbk
						@wifi_page.modify_ssid2_linknum(@ts_linknum_min)
						if @wifi_page.ssid2_sw == @tc_wifi_off
								@wifi_page.ssid2_sw = @tc_wifi_on
						end

						#ssid3
						@wifi_page.modify_ssid3(new_ssid3)
						ssid_mode = @wifi_page.ssid3_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID3密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						end
						puts "修改SSID3无线连接数为#{@ts_linknum_min}".to_gbk
						@wifi_page.modify_ssid3_linknum(@ts_linknum_min)
						if @wifi_page.ssid3_sw == @tc_wifi_off
								@wifi_page.ssid3_sw = @tc_wifi_on
						end

						#ssid4
						@wifi_page.modify_ssid4(new_ssid4)
						ssid_mode = @wifi_page.ssid4_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID4密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
						end
						puts "修改SSID4无线连接数为#{@ts_linknum_min}".to_gbk
						@wifi_page.modify_ssid4_linknum(@ts_linknum_min)
						if @wifi_page.ssid4_sw == @tc_wifi_off
								@wifi_page.ssid4_sw = @tc_wifi_on
						end

						#ssid5
						if @wifi_page.ssid5?
								@wifi_page.modify_ssid4(new_ssid5)
								ssid_mode = @wifi_page.ssid5_pwmode
								unless ssid_mode==@ts_sec_mode_wpa
										puts "修改SSID5密码为#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid5_pw(@ts_default_wlan_pw)
								end
								puts "修改SSID5无线连接数为#{@ts_linknum_min}".to_gbk
								@wifi_page.modify_ssid5_linknum(@ts_linknum_min)
								if @wifi_page.ssid5_sw == @tc_wifi_off
										@wifi_page.ssid5_sw = @tc_wifi_on
								end
						end

						#ssid6
						if @wifi_page.ssid6?
								@wifi_page.modify_ssid6(new_ssid6)
								ssid_mode = @wifi_page.ssid6_pwmode
								unless ssid_mode==@ts_sec_mode_wpa
										puts "修改SSID6密码为#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid6_pw(@ts_default_wlan_pw)
								end
								puts "修改SSID6无线连接数为#{@ts_linknum_min}".to_gbk
								@wifi_page.modify_ssid6_linknum(@ts_linknum_min)
								if @wifi_page.ssid6_sw == @tc_wifi_off
										@wifi_page.ssid6_sw = @tc_wifi_on
								end
						end

						#ssid7
						if @wifi_page.ssid7?
								@wifi_page.modify_ssid7(new_ssid7)
								ssid_mode = @wifi_page.ssid7_pwmode
								unless ssid_mode==@ts_sec_mode_wpa
										puts "修改SSID7密码为#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid7_pw(@ts_default_wlan_pw)
								end
								puts "修改SSID7无线连接数为#{@ts_linknum_min}".to_gbk
								@wifi_page.modify_ssid7_linknum(@ts_linknum_min)
								if @wifi_page.ssid7_sw == @tc_wifi_off
										@wifi_page.ssid7_sw = @tc_wifi_on
								end
						end

						#ssid8
						if @wifi_page.ssid8?
								@wifi_page.modify_ssid8(new_ssid8)
								ssid_mode = @wifi_page.ssid8_pwmode
								unless ssid_mode==@ts_sec_mode_wpa
										puts "修改SSID8密码为#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid8_pw(@ts_default_wlan_pw)
								end
								puts "修改SSID8无线连接数为#{@ts_linknum_min}".to_gbk
								@wifi_page.modify_ssid8_linknum(@ts_linknum_min)
								if @wifi_page.ssid8_sw == @tc_wifi_off
										@wifi_page.ssid8_sw = @tc_wifi_on
								end
						end
						@wifi_page.save_wifi_config

						puts "无线连接客户端连接SSID1".to_gbk
						curr_ssid_name = @wifi_page.ssid1
						curr_ssid_pw   = @wifi_page.ssid1_pw
						link_num       = @wifi_page.ssid1_link
						assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
						rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
						assert rs1_ssid, 'WIFI连接失败'
						rs2_ssid = @wifi.ping(@ts_default_ip)
						assert rs2_ssid, 'WIFI客户端无法ping通路由器'

						puts "无线连接客户端连接SSID2".to_gbk
						curr_ssid_name = @wifi_page.ssid2
						curr_ssid_pw   = @wifi_page.ssid2_pw
						link_num       = @wifi_page.ssid2_link
						assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
						rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
						assert rs1_ssid, 'WIFI连接失败'
						rs2_ssid = @wifi.ping(@ts_default_ip)
						assert rs2_ssid, 'WIFI客户端无法ping通路由器'

						puts "无线连接客户端连接SSID3".to_gbk
						curr_ssid_name = @wifi_page.ssid3
						curr_ssid_pw   = @wifi_page.ssid3_pw
						link_num       = @wifi_page.ssid3_link
						assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
						rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
						assert rs1_ssid, 'WIFI连接失败'
						rs2_ssid = @wifi.ping(@ts_default_ip)
						assert rs2_ssid, 'WIFI客户端无法ping通路由器'

						puts "无线连接客户端连接SSID4".to_gbk
						curr_ssid_name = @wifi_page.ssid4
						curr_ssid_pw   = @wifi_page.ssid4_pw
						link_num       = @wifi_page.ssid4_link
						assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
						rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
						assert rs1_ssid, 'WIFI连接失败'
						rs2_ssid = @wifi.ping(@ts_default_ip)
						assert rs2_ssid, 'WIFI客户端无法ping通路由器'

						if @wifi_page.ssid5?
								puts "无线连接客户端连接SSID5".to_gbk
								curr_ssid_name = @wifi_page.ssid5
								curr_ssid_pw   = @wifi_page.ssid5_pw
								link_num       = @wifi_page.ssid5_link
								assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
								rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
								assert rs1_ssid, 'WIFI连接失败'
								rs2_ssid = @wifi.ping(@ts_default_ip)
								assert rs2_ssid, 'WIFI客户端无法ping通路由器'
						end

						if @wifi_page.ssid6?
								puts "无线连接客户端连接SSID6".to_gbk
								curr_ssid_name = @wifi_page.ssid6
								curr_ssid_pw   = @wifi_page.ssid6_pw
								link_num       = @wifi_page.ssid6_link
								assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
								rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
								assert rs1_ssid, 'WIFI连接失败'
								rs2_ssid = @wifi.ping(@ts_default_ip)
								assert rs2_ssid, 'WIFI客户端无法ping通路由器'
						end

						if @wifi_page.ssid7?
								puts "无线连接客户端连接SSID7".to_gbk
								curr_ssid_name = @wifi_page.ssid7
								curr_ssid_pw   = @wifi_page.ssid7_pw
								link_num       = @wifi_page.ssid7_link
								assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
								rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
								assert rs1_ssid, 'WIFI连接失败'
								rs2_ssid = @wifi.ping(@ts_default_ip)
								assert rs2_ssid, 'WIFI客户端无法ping通路由器'
						end

						if @wifi_page.ssid8?
								puts "无线连接客户端连接SSID8".to_gbk
								curr_ssid_name = @wifi_page.ssid8
								curr_ssid_pw   = @wifi_page.ssid8_pw
								link_num       = @wifi_page.ssid8_link
								assert_equal(@ts_linknum_min, link_num, "设置连无线接数为#{@ts_linknum_min}失败")
								rs1_ssid = @wifi.connect(curr_ssid_name, @ts_wifi_flag, curr_ssid_pw)
								assert rs1_ssid, 'WIFI连接失败'
								rs2_ssid = @wifi.ping(@ts_default_ip)
								assert rs2_ssid, 'WIFI客户端无法ping通路由器'
						end
				}

				operate("2、设置无线最大连接数为#{@tc_linknum}，点击保存") {
						@wifi_page.modify_ssid1_linknum(@tc_linknum)
						@wifi_page.modify_ssid2_linknum(@tc_linknum)
						@wifi_page.modify_ssid3_linknum(@tc_linknum)
						@wifi_page.modify_ssid4_linknum(@tc_linknum)
						if @wifi_page.ssid5?
								@wifi_page.modify_ssid5_linknum(@tc_linknum)
						end
						if @wifi_page.ssid6?
								@wifi_page.modify_ssid6_linknum(@tc_linknum)
						end
						if @wifi_page.ssid7?
								@wifi_page.modify_ssid7_linknum(@tc_linknum)
						end
						if @wifi_page.ssid8?
								@wifi_page.modify_ssid8_linknum(@tc_linknum)
						end
						@wifi_page.save_wifi_config
						puts "查询SSID1最大连接数设置".to_gbk
						link_num = @wifi_page.ssid1_link
						assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						puts "查询SSID2最大连接数设置".to_gbk
						link_num = @wifi_page.ssid2_link
						assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						puts "查询SSID3最大连接数设置".to_gbk
						link_num = @wifi_page.ssid3_link
						assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						puts "查询SSID4最大连接数设置".to_gbk
						link_num = @wifi_page.ssid4_link
						assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						if @wifi_page.ssid5?
								puts "查询SSID5最大连接数设置".to_gbk
								link_num = @wifi_page.ssid5_link
								assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						end
						if @wifi_page.ssid6?
								puts "查询SSID6最大连接数设置".to_gbk
								link_num = @wifi_page.ssid6_link
								assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						end
						if @wifi_page.ssid7?
								puts "查询SSID7最大连接数设置".to_gbk
								link_num = @wifi_page.ssid7_link
								assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						end
						if @wifi_page.ssid8?
								puts "查询SSID8最大连接数设置".to_gbk
								link_num = @wifi_page.ssid8_link
								assert_equal(@tc_linknum, link_num, "设置连无线接数为#{@tc_linknum}失败")
						end
				}

				operate("3、无线最大连接数配置为#{@ts_linknum_max}，点击保存") {
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
						if @wifi_page.ssid5?
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
						end
						if @wifi_page.ssid6?
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
						end
						if @wifi_page.ssid7?
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
						end
						if @wifi_page.ssid8?
								@wifi_page.modify_ssid8_linknum(@ts_linknum_max)
						end
						@wifi_page.save_wifi_config
						puts "查询SSID1最大连接数设置".to_gbk
						link_num = @wifi_page.ssid1_link
						assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						puts "查询SSID2最大连接数设置".to_gbk
						link_num = @wifi_page.ssid2_link
						assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						puts "查询SSID3最大连接数设置".to_gbk
						link_num = @wifi_page.ssid3_link
						assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						puts "查询SSID4最大连接数设置".to_gbk
						link_num = @wifi_page.ssid4_link
						assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						if @wifi_page.ssid5?
								puts "查询SSID5最大连接数设置".to_gbk
								link_num = @wifi_page.ssid5_link
								assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						end
						if @wifi_page.ssid6?
								puts "查询SSID6最大连接数设置".to_gbk
								link_num = @wifi_page.ssid6_link
								assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						end
						if @wifi_page.ssid7?
								puts "查询SSID7最大连接数设置".to_gbk
								link_num = @wifi_page.ssid7_link
								assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						end
						if @wifi_page.ssid8?
								puts "查询SSID8最大连接数设置".to_gbk
								link_num = @wifi_page.ssid8_link
								assert_equal(@ts_linknum_max, link_num, "设置连无线接数为#{@ts_linknum_max}失败")
						end
				}

		end

		def clearup
				operate("1 恢复默认SSID和密码") {
						#断开无线连接
						@wifi.netsh_disc_all
						#错误的密码格式也能保存的话，这里要等待其保存完成
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#修改第一个SSID密码
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)

						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						if @wifi_page.ssid2_sw == @tc_wifi_on
								@wifi_page.ssid2_sw = @tc_wifi_off
						end

						@wifi_page.modify_ssid3(@ts_wifi_ssid3)
						@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						if @wifi_page.ssid3_sw == @tc_wifi_on
								@wifi_page.ssid3_sw = @tc_wifi_off
						end

						@wifi_page.modify_ssid4(@ts_wifi_ssid4)
						@wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
						if @wifi_page.ssid4_sw == @tc_wifi_on
								@wifi_page.ssid4_sw = @tc_wifi_off
						end

						if @wifi_page.ssid5?
								@wifi_page.modify_ssid5(@ts_wifi_ssid4)
								@wifi_page.modify_ssid5_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
								if @wifi_page.ssid5_sw == @tc_wifi_on
										@wifi_page.ssid5_sw = @tc_wifi_off
								end
						end

						if @wifi_page.ssid6?
								@wifi_page.modify_ssid6(@ts_wifi_ssid4)
								@wifi_page.modify_ssid6_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
								if @wifi_page.ssid6_sw == @tc_wifi_on
										@wifi_page.ssid6_sw = @tc_wifi_off
								end
						end

						if @wifi_page.ssid7?
								@wifi_page.modify_ssid7(@ts_wifi_ssid4)
								@wifi_page.modify_ssid7_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
								if @wifi_page.ssid7_sw == @tc_wifi_on
										@wifi_page.ssid7_sw = @tc_wifi_off
								end
						end

						if @wifi_page.ssid8?
								@wifi_page.modify_ssid8(@ts_wifi_ssid4)
								@wifi_page.modify_ssid8_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid8_linknum(@ts_linknum_max)
								if @wifi_page.ssid8_sw == @tc_wifi_on
										@wifi_page.ssid8_sw = @tc_wifi_off
								end
						end
						@wifi_page.save_wifi_config
				}
		end

}
