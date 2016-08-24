#
# description:
# 由于只有一个无线客户端，所以这里测试无线客户端分别连接每个SSId时的连接是不是正确即可
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_5.1.39", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi         = DRbObject.new_with_uri(@ts_drb_server)
				@tc_linkednum = "1"
				@tc_linkednone= "0"
				@tc_flag5     = false
				@tc_flag6     = false
				@tc_flag7     = false
				@tc_flag8     = false
				@tc_wifi_on    = "ON"
				@tc_wifi_off   = "OFF"
		end

		def process

				# operate("1、SSID1连接2个终端，SSID2连接3个终端；") {
				operate("1、修改无线配置") {
						@wifi_page   = RouterPageObject::WIFIPage.new(@browser)
						@tc_mac_last = @wifi_page.get_mac_last
						@wifi_page.select_2g_basic(@browser.url)
						###############################ssid1#######################
						ssid1_name = @wifi_page.ssid1
						puts "当前SSID1名为#{ssid1_name}".to_gbk
						@new_ssid1 = "autotest1_#{@tc_mac_last}"
						puts "新SSID1名为#{@new_ssid1}".to_gbk
						@wifi_page.modify_ssid1(@new_ssid1)
						unless @wifi_page.ssid1_pw==@ts_default_wlan_pw
								puts "修改SSID1密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid1_sw==@tc_wifi_off
								@wifi_page.ssid1_sw=@tc_wifi_on
						end
						###############################ssid2#######################
						ssid2_name = @wifi_page.ssid2
						puts "当前SSID2名为#{ssid2_name}".to_gbk
						@new_ssid2 = "autotest2_#{@tc_mac_last}"
						puts "新SSID2名为#{@new_ssid2}".to_gbk
						@wifi_page.modify_ssid2(@new_ssid2)
						unless @wifi_page.ssid2_pw==@ts_default_wlan_pw
								puts "修改SSID2密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid2_sw==@tc_wifi_off
								@wifi_page.ssid2_sw=@tc_wifi_on
						end
						###############################ssid3#######################
						ssid3_name = @wifi_page.ssid3
						puts "当前SSID3名为#{ssid3_name}".to_gbk
						@new_ssid3 = "autotest3_#{@tc_mac_last}"
						puts "新SSID3名为#{@new_ssid3}".to_gbk
						@wifi_page.modify_ssid3(@new_ssid3)
						unless @wifi_page.ssid3_pw==@ts_default_wlan_pw
								puts "修改SSID3密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid3_sw==@tc_wifi_off
								@wifi_page.ssid3_sw=@tc_wifi_on
						end
						###############################ssid4#######################
						ssid4_name = @wifi_page.ssid4
						puts "当前SSID4名为#{ssid4_name}".to_gbk
						@new_ssid4 = "autotest4_#{@tc_mac_last}"
						puts "新SSID4名为#{@new_ssid4}".to_gbk
						@wifi_page.modify_ssid4(@new_ssid4)
						unless @wifi_page.ssid4_pw==@ts_default_wlan_pw
								puts "修改SSID4密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid4_sw==@tc_wifi_off
								@wifi_page.ssid4_sw=@tc_wifi_on
						end

						if @wifi_page.ssid5?
								@tc_flag5  = true
								ssid5_name = @wifi_page.ssid5
								puts "当前SSID5名为#{ssid5_name}".to_gbk
								@new_ssid5 = "autotest5_#{@tc_mac_last}"
								puts "新SSID5名为#{@new_ssid5}".to_gbk
								@wifi_page.modify_ssid5(@new_ssid5)
								unless @wifi_page.ssid5_pw==@ts_default_wlan_pw
										puts "修改SSID5密码为#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid5_pw(@ts_default_wlan_pw)
								end
								if @wifi_page.ssid5_sw==@tc_wifi_off
										@wifi_page.ssid5_sw=@tc_wifi_on
								end
						end

						if @wifi_page.ssid6?
								@tc_flag6  = true
								ssid6_name = @wifi_page.ssid6
								puts "当前SSID6名为#{ssid6_name}".to_gbk
								@new_ssid6 = "autotest6_#{@tc_mac_last}"
								puts "新SSID6名为#{@new_ssid6}".to_gbk
								@wifi_page.modify_ssid6(@new_ssid6)
								unless @wifi_page.ssid6_pw==@ts_default_wlan_pw
										puts "修改SSID6密码为#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid6_pw(@ts_default_wlan_pw)
								end
								if @wifi_page.ssid6_sw==@tc_wifi_off
										@wifi_page.ssid6_sw=@tc_wifi_on
								end
						end

						if @wifi_page.ssid7?
								@tc_flag7  = true
								ssid7_name = @wifi_page.ssid7
								puts "当前SSID7名为#{ssid7_name}".to_gbk
								@new_ssid7 = "autotest7_#{@tc_mac_last}"
								puts "新SSID7名为#{@new_ssid7}".to_gbk
								@wifi_page.modify_ssid7(@new_ssid7)
								unless @wifi_page.ssid7_pw==@ts_default_wlan_pw
										puts "修改SSID7密码为#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid7_pw(@ts_default_wlan_pw)
								end
								if @wifi_page.ssid7_sw==@tc_wifi_off
										@wifi_page.ssid7_sw=@tc_wifi_on
								end
						end

						if @wifi_page.ssid8?
								@tc_flag8  = true
								ssid8_name = @wifi_page.ssid8
								puts "当前SSID8名为#{ssid8_name}".to_gbk
								@new_ssid8 = "autotest8_#{@tc_mac_last}"
								puts "新SSID8名为#{@new_ssid8}".to_gbk
								@wifi_page.modify_ssid8(@new_ssid8)
								unless @wifi_page.ssid8_pw==@ts_default_wlan_pw
										puts "修改SSID8密码为#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid8_pw(@ts_default_wlan_pw)
								end
								if @wifi_page.ssid8_sw==@tc_wifi_off
										@wifi_page.ssid8_sw=@tc_wifi_on
								end
						end
						@wifi_page.save_wifi_config
				}

				operate("2、连接SSID,分别查看系统状态-无线状态详情，终端数是否显示正确；") {
						puts "连接#{@new_ssid1}".to_gbk
						rs1_ssid1 = @wifi.connect(@new_ssid1, @ts_wifi_flag, @ts_default_wlan_pw)
						assert rs1_ssid1, 'WIFI连接失败'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI客户端无法ping通路由器'
						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询无线详细信息".to_gbk
						linked = @wifi_detail.ssid1_linked
						puts "查询到SSID1已连接数为：#{linked}".to_gbk
						assert_equal(@tc_linkednum, linked, "SSID1已连接数统计错误")

						puts "连接#{@new_ssid2}".to_gbk
						@wifi.netsh_disc_all
						rs1_ssid1 = @wifi.connect(@new_ssid2, @ts_wifi_flag, @ts_default_wlan_pw)
						assert rs1_ssid1, 'WIFI连接失败'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI客户端无法ping通路由器'

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询无线详细信息".to_gbk
						linked1 = @wifi_detail.ssid1_linked
						linked  = @wifi_detail.ssid2_linked
						puts "查询到SSID1已连接数为：#{linked1}".to_gbk
						puts "查询到SSID2已连接数为：#{linked}".to_gbk
						assert_equal(@tc_linkednone, linked1, "SSID1已连接数统计错误")
						assert_equal(@tc_linkednum, linked, "SSID2已连接数统计错误")

						puts "连接#{@new_ssid3}".to_gbk
						@wifi.netsh_disc_all
						rs1_ssid1 = @wifi.connect(@new_ssid3, @ts_wifi_flag, @ts_default_wlan_pw)
						assert rs1_ssid1, 'WIFI连接失败'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI客户端无法ping通路由器'

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询无线详细信息".to_gbk
						linked1 = @wifi_detail.ssid1_linked
						linked2 = @wifi_detail.ssid2_linked
						linked  = @wifi_detail.ssid3_linked
						puts "查询到SSID1已连接数为：#{linked1}".to_gbk
						puts "查询到SSID2已连接数为：#{linked2}".to_gbk
						puts "查询到SSID3已连接数为：#{linked}".to_gbk
						assert_equal(@tc_linkednone, linked1, "SSID1已连接数统计错误")
						assert_equal(@tc_linkednone, linked2, "SSID2已连接数统计错误")
						assert_equal(@tc_linkednum, linked, "SSID3已连接数统计错误")

						puts "连接#{@new_ssid4}".to_gbk
						@wifi.netsh_disc_all
						rs1_ssid1 = @wifi.connect(@new_ssid4, @ts_wifi_flag, @ts_default_wlan_pw)
						assert rs1_ssid1, 'WIFI连接失败'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI客户端无法ping通路由器'

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询无线详细信息".to_gbk
						linked1 = @wifi_detail.ssid1_linked
						linked2 = @wifi_detail.ssid2_linked
						linked3 = @wifi_detail.ssid3_linked
						linked  = @wifi_detail.ssid4_linked
						puts "查询到SSID1已连接数为：#{linked1}".to_gbk
						puts "查询到SSID2已连接数为：#{linked2}".to_gbk
						puts "查询到SSID3已连接数为：#{linked3}".to_gbk
						puts "查询到SSID4已连接数为：#{linked}".to_gbk
						assert_equal(@tc_linkednone, linked1, "SSID1已连接数统计错误")
						assert_equal(@tc_linkednone, linked2, "SSID2已连接数统计错误")
						assert_equal(@tc_linkednone, linked3, "SSID3已连接数统计错误")
						assert_equal(@tc_linkednum, linked, "SSID4已连接数统计错误")

						if @tc_flag5
								@wifi.netsh_disc_all
								rs1_ssid1 = @wifi.connect(@new_ssid5, @ts_wifi_flag, @ts_default_wlan_pw)
								assert rs1_ssid1, 'WIFI连接失败'
								rs2_ssid1 = @wifi.ping(@ts_default_ip)
								assert rs2_ssid1, 'WIFI客户端无法ping通路由器'
								@wifi_detail.open_wifidetail_page(@browser.url)
								puts "查询无线详细信息".to_gbk
								linked4 = @wifi_detail.ssid4_linked
								linked  = @wifi_detail.ssid5_linked
								puts "查询到SSID4已连接数为：#{linked4}".to_gbk
								puts "查询到SSID5已连接数为：#{linked}".to_gbk
								assert_equal(@tc_linkednone, linked3, "SSID4已连接数统计错误")
								assert_equal(@tc_linkednum, linked, "SSID5已连接数统计错误")
						end

						if @tc_flag6
								@wifi.netsh_disc_all
								rs1_ssid1 = @wifi.connect(@new_ssid6, @ts_wifi_flag, @ts_default_wlan_pw)
								assert rs1_ssid1, 'WIFI连接失败'
								rs2_ssid1 = @wifi.ping(@ts_default_ip)
								assert rs2_ssid1, 'WIFI客户端无法ping通路由器'
								@wifi_detail.open_wifidetail_page(@browser.url)
								puts "查询无线详细信息".to_gbk
								linked5 = @wifi_detail.ssid5_linked
								linked  = @wifi_detail.ssid6_linked
								puts "查询到SSID5已连接数为：#{linked5}".to_gbk
								puts "查询到SSID6已连接数为：#{linked}".to_gbk
								assert_equal(@tc_linkednone, linked5, "SSID5已连接数统计错误")
								assert_equal(@tc_linkednum, linked, "SSID6已连接数统计错误")
						end

						if @tc_flag7
								@wifi.netsh_disc_all
								rs1_ssid1 = @wifi.connect(@new_ssid7, @ts_wifi_flag, @ts_default_wlan_pw)
								assert rs1_ssid1, 'WIFI连接失败'
								rs2_ssid1 = @wifi.ping(@ts_default_ip)
								assert rs2_ssid1, 'WIFI客户端无法ping通路由器'

								@wifi_detail.open_wifidetail_page(@browser.url)
								puts "查询无线详细信息".to_gbk
								linked6 = @wifi_detail.ssid6_linked
								linked  = @wifi_detail.ssid7_linked
								puts "查询到SSID6已连接数为：#{linked6}".to_gbk
								puts "查询到SSID7已连接数为：#{linked}".to_gbk
								assert_equal(@tc_linkednone, linked6, "SSID6已连接数统计错误")
								assert_equal(@tc_linkednum, linked, "SSID7已连接数统计错误")
						end

						if @tc_flag8
								@wifi.netsh_disc_all
								rs1_ssid1 = @wifi.connect(@new_ssid8, @ts_wifi_flag, @ts_default_wlan_pw)
								assert rs1_ssid1, 'WIFI连接失败'
								rs2_ssid1 = @wifi.ping(@ts_default_ip)
								assert rs2_ssid1, 'WIFI客户端无法ping通路由器'

								@wifi_detail.open_wifidetail_page(@browser.url)
								puts "查询无线详细信息".to_gbk
								linked7 = @wifi_detail.ssid7_linked
								linked  = @wifi_detail.ssid8_linked
								puts "查询到SSID6已连接数为：#{linked7}".to_gbk
								puts "查询到SSID7已连接数为：#{linked}".to_gbk
								assert_equal(@tc_linkednone, linked7, "SSID7已连接数统计错误")
								assert_equal(@tc_linkednum, linked, "SSID8已连接数统计错误")
						end
				}

				# operate("4、分别查看系统状态-无线状态详情，终端数是否显示正确；") {}

		end

		def clearup
				operate("1 恢复默认设置") {
						@wifi.netsh_disc_all
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#修改SSID1
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)
						if @wifi_page.ssid1_sw==@tc_wifi_off
								@wifi_page.ssid1_sw=@tc_wifi_on
						end
						#修改SSID2
						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						if @wifi_page.ssid2_sw==@tc_wifi_on
								@wifi_page.ssid2_sw=@tc_wifi_off
						end
						#修改SSID3
						@wifi_page.modify_ssid3(@ts_wifi_ssid3)
						@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						if @wifi_page.ssid3_sw==@tc_wifi_on
								@wifi_page.ssid3_sw=@tc_wifi_off
						end
						#修改SSID4
						@wifi_page.modify_ssid4(@ts_wifi_ssid4)
						@wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
						if @wifi_page.ssid4_sw==@tc_wifi_on
								@wifi_page.ssid4_sw=@tc_wifi_off
						end
						if @tc_flag5
								@wifi_page.modify_ssid5(@ts_wifi_ssid5)
								@wifi_page.modify_ssid5_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
								if @wifi_page.ssid5_sw==@tc_wifi_on
										@wifi_page.ssid5_sw=@tc_wifi_off
								end
						end
						if @tc_flag6
								@wifi_page.modify_ssid6(@ts_wifi_ssid6)
								@wifi_page.modify_ssid6_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
								if @wifi_page.ssid6_sw==@tc_wifi_on
										@wifi_page.ssid6_sw=@tc_wifi_off
								end
						end
						if @tc_flag7
								@wifi_page.modify_ssid7(@ts_wifi_ssid7)
								@wifi_page.modify_ssid7_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
								if @wifi_page.ssid7_sw==@tc_wifi_on
										@wifi_page.ssid7_sw=@tc_wifi_off
								end
						end
						if @tc_flag8
								@wifi_page.modify_ssid8(@ts_wifi_ssid8)
								@wifi_page.modify_ssid8_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid8_linknum(@ts_linknum_max)
								if @wifi_page.ssid7_sw==@tc_wifi_on
										@wifi_page.ssid7_sw=@tc_wifi_off
								end
						end
						#保存
						@wifi_page.save_wifi_config
				}
		end

}
