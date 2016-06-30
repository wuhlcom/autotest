#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_5.1.37", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_ssid1     = "Wireless0"
				@tc_ssid2     = "Wireless1"
				@tc_ssid3     = "Wireless2"
				@tc_ssid4     = "Wireless3"
				@tc_ssid5     = "Wireless4"
				@tc_ssid6     = "Wireless5"
				@tc_ssid7     = "Wireless6"
				@tc_ssid8     = "Wireless7"
				@tc_pw        = "12345678"
				@tc_linkmax1  = "20"
				@tc_ssid1_cn  = "知路自动测试1"
				@tc_ssid2_cn  = "知路自动测试2"
				@tc_ssid3_cn  = "知路自动测试3"
				@tc_ssid4_cn  = "知路自动测试4"
				@tc_ssid5_cn  = "知路自动测试5"
				@tc_ssid6_cn  = "知路自动测试6"
				@tc_ssid7_cn  = "知路自动测试7"
				@tc_ssid8_cn  = "知路自动测试8"
				@tc_linkmax2  = "10"
				@tc_wifi_on   = "ON"
				@tc_wifi_off  = "OFF"
				@tc_rf_mode   = "2.4G"
				@tc_linkednum = "0"
				@tc_flag1     = false
				@tc_flag2     = false
				@tc_flag3     = false
				@tc_flag4     = false
		end

		def process

				operate("1、查看默认无线2.4G更多状态是否正确；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.recover_factory(@browser.url) #恢复出厂设置
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "恢复出厂设置后未跳转到登录界面")
						@options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url) #重新登录

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询SSID1默认详细信息".to_gbk
						ssid    = @wifi_detail.ssid1_name
						ssid_pw = @wifi_detail.ssid1_pwmode
						linkmax = @wifi_detail.ssid1_linknum
						linked  = @wifi_detail.ssid1_linked
						ssid_rf = @wifi_detail.ssid1_rf
						ssid_sw = @wifi_detail.ssid1_sw
						# puts "查询到SSID1名为：#{ssid}".to_gbk
						puts "查询到SSID1加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID1最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID1已连接数为：#{linked}".to_gbk
						puts "查询到SSID1射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID1无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid1, ssid, "查询到默认SSID1不为#{@ts_wifi_ssid1}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "查询到默认SSID1加密方式不为#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "查询到默认SSID1最大连接数不为#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "查询到默认SSID1已连接数不为#{@tc_linkednum}")
						assert_equal(@tc_wifi_on, ssid_sw, "查询到默认SSID1开关状态未打开")

						puts "查询SSID2默认详细信息".to_gbk
						ssid    = @wifi_detail.ssid2_name
						ssid_pw = @wifi_detail.ssid2_pwmode
						linkmax = @wifi_detail.ssid2_linknum
						linked  = @wifi_detail.ssid2_linked
						ssid_rf = @wifi_detail.ssid2_rf
						ssid_sw = @wifi_detail.ssid2_sw
						puts "查询到SSID2名为：#{ssid}".to_gbk
						puts "查询到SSID2加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID2最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID2已连接数为：#{linked}".to_gbk
						puts "查询到SSID2射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID2无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid2, ssid, "查询到默认SSID2不为#{@ts_wifi_ssid2}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "查询到默认SSID2加密方式不为#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "查询到默认SSID2最大连接数不为#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "查询到默认SSID2已连接数不为#{@tc_linkednum}")
						assert_equal(@tc_wifi_off, ssid_sw, "查询到默认SSID2开关状态未打开")

						puts "查询SSID3默认详细信息".to_gbk
						ssid    = @wifi_detail.ssid3_name
						ssid_pw = @wifi_detail.ssid3_pwmode
						linkmax = @wifi_detail.ssid3_linknum
						linked  = @wifi_detail.ssid3_linked
						ssid_rf = @wifi_detail.ssid3_rf
						ssid_sw = @wifi_detail.ssid3_sw
						puts "查询到SSID3名为：#{ssid}".to_gbk
						puts "查询到SSID3加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID3最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID3已连接数为：#{linked}".to_gbk
						puts "查询到SSID3射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID3无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid3, ssid, "查询到默认SSID3不为#{@ts_wifi_ssid3}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "查询到默认SSID3加密方式不为#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "查询到默认SSID3最大连接数不为#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "查询到默认SSID3已连接数不为#{@tc_linkednum}")
						assert_equal(@tc_wifi_off, ssid_sw, "查询到默认SSID3开关状态未打开")

						puts "查询SSID4默认详细信息".to_gbk
						ssid    = @wifi_detail.ssid4_name
						ssid_pw = @wifi_detail.ssid4_pwmode
						linkmax = @wifi_detail.ssid4_linknum
						linked  = @wifi_detail.ssid4_linked
						ssid_rf = @wifi_detail.ssid4_rf
						ssid_sw = @wifi_detail.ssid4_sw
						puts "查询到SSID4名为：#{ssid}".to_gbk
						puts "查询到SSID4加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID4最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID4已连接数为：#{linked}".to_gbk
						puts "查询到SSID4射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID4无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid4, ssid, "查询到默认SSID4不为#{@ts_wifi_ssid4}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "查询到默认SSID4加密方式不为#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "查询到默认SSID4最大连接数不为#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "查询到默认SSID4已连接数不为#{@tc_linkednum}")
						assert_equal(@tc_wifi_off, ssid_sw, "查询到默认SSID4开关状态未打开")

						if @wifi_detail.ssid5_name?
								puts "查询SSID5默认详细信息".to_gbk
								ssid    = @wifi_detail.ssid5_name
								ssid_pw = @wifi_detail.ssid5_pwmode
								linkmax = @wifi_detail.ssid5_linknum
								linked  = @wifi_detail.ssid5_linked
								ssid_rf = @wifi_detail.ssid5_rf
								ssid_sw = @wifi_detail.ssid5_sw
								puts "查询到SSID5名为：#{ssid}".to_gbk
								puts "查询到SSID5加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID5最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID5已连接数为：#{linked}".to_gbk
								puts "查询到SSID5射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID5无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@ts_wifi_ssid5, ssid, "查询到默认SSID5不为#{@ts_wifi_ssid5}")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "查询到默认SSID5加密方式不为#{@ts_sec_mode_wpa}")
								assert_equal(@ts_linknum_max, linkmax, "查询到默认SSID5最大连接数不为#{@ts_linknum_max}")
								assert_equal(@tc_linkednum, linked, "查询到默认SSID5已连接数不为#{@tc_linkednum}")
								assert_equal(@tc_wifi_off, ssid_sw, "查询到默认SSID5开关状态未打开")
						end

						if @wifi_detail.ssid6_name?
								puts "查询SSID6默认详细信息".to_gbk
								ssid    = @wifi_detail.ssid6_name
								ssid_pw = @wifi_detail.ssid6_pwmode
								linkmax = @wifi_detail.ssid6_linknum
								linked  = @wifi_detail.ssid6_linked
								ssid_rf = @wifi_detail.ssid6_rf
								ssid_sw = @wifi_detail.ssid6_sw
								puts "查询到SSID6名为：#{ssid}".to_gbk
								puts "查询到SSID6加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID6最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID6已连接数为：#{linked}".to_gbk
								puts "查询到SSID6射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID6无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@ts_wifi_ssid6, ssid, "查询到默认SSID6不为#{@ts_wifi_ssid6}")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "查询到默认SSID6加密方式不为#{@ts_sec_mode_wpa}")
								assert_equal(@ts_linknum_max, linkmax, "查询到默认SSID6最大连接数不为#{@ts_linknum_max}")
								assert_equal(@tc_linkednum, linked, "查询到默认SSID6已连接数不为#{@tc_linkednum}")
								assert_equal(@tc_wifi_off, ssid_sw, "查询到默认SSID6开关状态未打开")
						end

						if @wifi_detail.ssid7_name?
								puts "查询SSID7默认详细信息".to_gbk
								ssid    = @wifi_detail.ssid7_name
								ssid_pw = @wifi_detail.ssid7_pwmode
								linkmax = @wifi_detail.ssid7_linknum
								linked  = @wifi_detail.ssid7_linked
								ssid_rf = @wifi_detail.ssid7_rf
								ssid_sw = @wifi_detail.ssid7_sw
								puts "查询到SSID7名为：#{ssid}".to_gbk
								puts "查询到SSID7加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID7最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID7已连接数为：#{linked}".to_gbk
								puts "查询到SSID7射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID7无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@ts_wifi_ssid7, ssid, "查询到默认SSID7不为#{@ts_wifi_ssid7}")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "查询到默认SSID7加密方式不为#{@ts_sec_mode_wpa}")
								assert_equal(@ts_linknum_max, linkmax, "查询到默认SSID7最大连接数不为#{@ts_linknum_max}")
								assert_equal(@tc_linkednum, linked, "查询到默认SSID7已连接数不为#{@tc_linkednum}")
								assert_equal(@tc_wifi_off, ssid_sw, "查询到默认SSID7开关状态未打开")
						end

						if @wifi_detail.ssid8_name?
								puts "查询SSID8默认详细信息".to_gbk
								ssid    = @wifi_detail.ssid8_name
								ssid_pw = @wifi_detail.ssid8_pwmode
								linkmax = @wifi_detail.ssid8_linknum
								linked  = @wifi_detail.ssid8_linked
								ssid_rf = @wifi_detail.ssid8_rf
								ssid_sw = @wifi_detail.ssid8_sw
								puts "查询到SSID8名为：#{ssid}".to_gbk
								puts "查询到SSID8加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID8最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID8已连接数为：#{linked}".to_gbk
								puts "查询到SSID8射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID8无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@ts_wifi_ssid8, ssid, "查询到默认SSID8不为#{@ts_wifi_ssid8}")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "查询到默认SSID8加密方式不为#{@ts_sec_mode_wpa}")
								assert_equal(@ts_linknum_max, linkmax, "查询到默认SSID8最大连接数不为#{@ts_linknum_max}")
								assert_equal(@tc_linkednum, linked, "查询到默认SSID8已连接数不为#{@tc_linkednum}")
								assert_equal(@tc_wifi_off, ssid_sw, "查询到默认SSID8开关状态未打开")
						end
				}

				operate("2、在wifi设置页面设置2.4G的8个SSID分别为open1到Open8，加密模式WPA/WPA2混合，密码为88888888，最大连接数20，开关ON，点击保存；") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#修改SSID1
						@wifi_page.modify_ssid1(@tc_ssid1)
						@wifi_page.modify_ssid1_pw(@tc_pw)
						@wifi_page.modify_ssid1_linknum(@tc_linkmax1)
						if @wifi_page.ssid1_sw==@tc_wifi_off
								@wifi_page.ssid1_sw=@tc_wifi_on
						end
						#修改SSID2
						@wifi_page.modify_ssid2(@tc_ssid2)
						@wifi_page.modify_ssid2_pw(@tc_pw)
						@wifi_page.modify_ssid2_linknum(@tc_linkmax1)
						if @wifi_page.ssid2_sw==@tc_wifi_off
								@wifi_page.ssid2_sw=@tc_wifi_on
						end
						#修改SSID3
						@wifi_page.modify_ssid3(@tc_ssid3)
						@wifi_page.modify_ssid3_pw(@tc_pw)
						@wifi_page.modify_ssid3_linknum(@tc_linkmax1)
						if @wifi_page.ssid3_sw==@tc_wifi_off
								@wifi_page.ssid3_sw=@tc_wifi_on
						end
						#修改SSID4
						@wifi_page.modify_ssid4(@tc_ssid4)
						@wifi_page.modify_ssid4_pw(@tc_pw)
						@wifi_page.modify_ssid4_linknum(@tc_linkmax1)
						if @wifi_page.ssid4_sw==@tc_wifi_off
								@wifi_page.ssid4_sw=@tc_wifi_on
						end

						#修改SSID5
						if @wifi_page.ssid5?
								@tc_flag1 = true
								@wifi_page.modify_ssid5(@tc_ssid5)
								@wifi_page.modify_ssid5_pw(@tc_pw)
								@wifi_page.modify_ssid5_linknum(@tc_linkmax1)
								if @wifi_page.ssid5_sw==@tc_wifi_off
										@wifi_page.ssid5_sw=@tc_wifi_on
								end
						end
						#修改SSID6
						if @wifi_page.ssid6?
								@tc_flag2 = true
								@wifi_page.modify_ssid6(@tc_ssid6)
								@wifi_page.modify_ssid6_pw(@tc_pw)
								@wifi_page.modify_ssid6_linknum(@tc_linkmax1)
								if @wifi_page.ssid6_sw==@tc_wifi_off
										@wifi_page.ssid6_sw=@tc_wifi_on
								end
						end
						#修改SSID7
						if @wifi_page.ssid7?
								@tc_flag3 = true
								@wifi_page.modify_ssid7(@tc_ssid7)
								@wifi_page.modify_ssid7_pw(@tc_pw)
								@wifi_page.modify_ssid7_linknum(@tc_linkmax1)
								if @wifi_page.ssid7_sw==@tc_wifi_off
										@wifi_page.ssid7_sw=@tc_wifi_on
								end
						end
						#修改SSID8
						if @wifi_page.ssid8?
								@tc_flag4 = true
								@wifi_page.modify_ssid8(@tc_ssid8)
								@wifi_page.modify_ssid8_pw(@tc_pw)
								@wifi_page.modify_ssid8_linknum(@tc_linkmax1)
								if @wifi_page.ssid8_sw==@tc_wifi_off
										@wifi_page.ssid8_sw=@tc_wifi_on
								end
						end
						#保存
						@wifi_page.save_wifi_config

						# @wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询SSID1详细信息".to_gbk
						ssid    = @wifi_detail.ssid1_name
						ssid_pw = @wifi_detail.ssid1_pwmode
						linkmax = @wifi_detail.ssid1_linknum
						linked  = @wifi_detail.ssid1_linked
						ssid_rf = @wifi_detail.ssid1_rf
						ssid_sw = @wifi_detail.ssid1_sw
						puts "查询到SSID1名为：#{ssid}".to_gbk
						puts "查询到SSID1加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID1最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID1已连接数为：#{linked}".to_gbk
						puts "查询到SSID1射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID1无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid1, ssid, "设置SSID1为#{@tc_ssid1}失败")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "设置SSID1加密方式为#{@ts_sec_mode_wpa}失败")
						assert_equal(@tc_linkmax1, linkmax, "设置SSID1最大连接数为#{@tc_linkmax1}失败")
						assert_equal(@tc_linkednum, linked, "SSID1已连接数统计错误")
						assert_equal(@tc_wifi_on, ssid_sw, "SSID1开关状态错误")

						puts "查询SSID2详细信息".to_gbk
						ssid    = @wifi_detail.ssid2_name
						ssid_pw = @wifi_detail.ssid2_pwmode
						linkmax = @wifi_detail.ssid2_linknum
						linked  = @wifi_detail.ssid2_linked
						ssid_rf = @wifi_detail.ssid2_rf
						ssid_sw = @wifi_detail.ssid2_sw
						puts "查询到SSID2名为：#{ssid}".to_gbk
						puts "查询到SSID2加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID2最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID2已连接数为：#{linked}".to_gbk
						puts "查询到SSID2射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID2无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid2, ssid, "设置SSID2为#{@tc_ssid2}失败")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "设置SSID2加密方式为#{@ts_sec_mode_wpa}失败")
						assert_equal(@tc_linkmax1, linkmax, "设置SSID2最大连接数为#{@tc_linkmax1}失败")
						assert_equal(@tc_linkednum, linked, "SSID2已连接数统计错误")
						assert_equal(@tc_wifi_on, ssid_sw, "SSID2开关状态错误")

						puts "查询SSID3详细信息".to_gbk
						ssid    = @wifi_detail.ssid3_name
						ssid_pw = @wifi_detail.ssid3_pwmode
						linkmax = @wifi_detail.ssid3_linknum
						linked  = @wifi_detail.ssid3_linked
						ssid_rf = @wifi_detail.ssid3_rf
						ssid_sw = @wifi_detail.ssid3_sw
						puts "查询到SSID3名为：#{ssid}".to_gbk
						puts "查询到SSID3加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID3最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID3已连接数为：#{linked}".to_gbk
						puts "查询到SSID3射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID3无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid3, ssid, "设置SSID3为#{@tc_ssid3}失败")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "设置SSID3加密方式为#{@ts_sec_mode_wpa}失败")
						assert_equal(@tc_linkmax1, linkmax, "设置SSID3最大连接数为#{@tc_linkmax1}失败")
						assert_equal(@tc_linkednum, linked, "SSID3已连接数统计错误")
						assert_equal(@tc_wifi_on, ssid_sw, "SSID3开关状态错误")

						puts "查询SSID4详细信息".to_gbk
						ssid    = @wifi_detail.ssid4_name
						ssid_pw = @wifi_detail.ssid4_pwmode
						linkmax = @wifi_detail.ssid4_linknum
						linked  = @wifi_detail.ssid4_linked
						ssid_rf = @wifi_detail.ssid4_rf
						ssid_sw = @wifi_detail.ssid4_sw
						puts "查询到SSID4名为：#{ssid}".to_gbk
						puts "查询到SSID4加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID4最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID4已连接数为：#{linked}".to_gbk
						puts "查询到SSID4射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID4无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid4, ssid, "设置SSID4为#{@tc_ssid4}失败")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "设置SSID4加密方式为#{@ts_sec_mode_wpa}失败")
						assert_equal(@tc_linkmax1, linkmax, "设置SSID4最大连接数为#{@tc_linkmax1}失败")
						assert_equal(@tc_linkednum, linked, "SSID4已连接数统计错误")
						assert_equal(@tc_wifi_on, ssid_sw, "SSID4开关状态错误")

						if @tc_flag1
								puts "查询SSID5详细信息".to_gbk
								ssid    = @wifi_detail.ssid5_name
								ssid_pw = @wifi_detail.ssid5_pwmode
								linkmax = @wifi_detail.ssid5_linknum
								linked  = @wifi_detail.ssid5_linked
								ssid_rf = @wifi_detail.ssid5_rf
								ssid_sw = @wifi_detail.ssid5_sw
								puts "查询到SSID5名为：#{ssid}".to_gbk
								puts "查询到SSID5加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID5最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID5已连接数为：#{linked}".to_gbk
								puts "查询到SSID5射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID5无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid5, ssid, "设置SSID5为#{@tc_ssid5}失败")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "设置SSID5加密方式为#{@ts_sec_mode_wpa}失败")
								assert_equal(@tc_linkmax1, linkmax, "设置SSID5最大连接数为#{@tc_linkmax1}失败")
								assert_equal(@tc_linkednum, linked, "SSID5已连接数统计错误")
								assert_equal(@tc_wifi_on, ssid_sw, "SSID5开关状态错误")
						end

						if @tc_flag2
								puts "查询SSID6详细信息".to_gbk
								ssid    = @wifi_detail.ssid6_name
								ssid_pw = @wifi_detail.ssid6_pwmode
								linkmax = @wifi_detail.ssid6_linknum
								linked  = @wifi_detail.ssid6_linked
								ssid_rf = @wifi_detail.ssid6_rf
								ssid_sw = @wifi_detail.ssid6_sw
								puts "查询到SSID6名为：#{ssid}".to_gbk
								puts "查询到SSID6加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID6最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID6已连接数为：#{linked}".to_gbk
								puts "查询到SSID6射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID6无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid6, ssid, "设置SSID6为#{@tc_ssid6}失败")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "设置SSID6加密方式为#{@ts_sec_mode_wpa}失败")
								assert_equal(@tc_linkmax1, linkmax, "设置SSID6最大连接数为#{@tc_linkmax1}失败")
								assert_equal(@tc_linkednum, linked, "SSID6已连接数统计错误")
								assert_equal(@tc_wifi_on, ssid_sw, "SSID6开关状态错误")
						end

						if @tc_flag3
								puts "查询SSID7详细信息".to_gbk
								ssid    = @wifi_detail.ssid7_name
								ssid_pw = @wifi_detail.ssid7_pwmode
								linkmax = @wifi_detail.ssid7_linknum
								linked  = @wifi_detail.ssid7_linked
								ssid_rf = @wifi_detail.ssid7_rf
								ssid_sw = @wifi_detail.ssid7_sw
								puts "查询到SSID7名为：#{ssid}".to_gbk
								puts "查询到SSID7加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID7最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID7已连接数为：#{linked}".to_gbk
								puts "查询到SSID7射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID7无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid4, ssid, "设置SSID7为#{@tc_ssid4}失败")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "设置SSID7加密方式为#{@ts_sec_mode_wpa}失败")
								assert_equal(@tc_linkmax1, linkmax, "设置SSID7最大连接数为#{@tc_linkmax1}失败")
								assert_equal(@tc_linkednum, linked, "SSID7已连接数统计错误")
								assert_equal(@tc_wifi_on, ssid_sw, "SSID7开关状态错误")
						end

						if @tc_flag4
								puts "查询SSID8详细信息".to_gbk
								ssid    = @wifi_detail.ssid8_name
								ssid_pw = @wifi_detail.ssid8_pwmode
								linkmax = @wifi_detail.ssid8_linknum
								linked  = @wifi_detail.ssid8_linked
								ssid_rf = @wifi_detail.ssid8_rf
								ssid_sw = @wifi_detail.ssid8_sw
								puts "查询到SSID8名为：#{ssid}".to_gbk
								puts "查询到SSID8加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID8最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID8已连接数为：#{linked}".to_gbk
								puts "查询到SSID8射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID8无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid8, ssid, "设置SSID4为#{@tc_ssid8}失败")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "设置SSID4加密方式为#{@ts_sec_mode_wpa}失败")
								assert_equal(@tc_linkmax1, linkmax, "设置SSID4最大连接数为#{@tc_linkmax1}失败")
								assert_equal(@tc_linkednum, linked, "SSID4已连接数统计错误")
								assert_equal(@tc_wifi_on, ssid_sw, "SSID4开关状态错误")
						end
				}

				operate("3、在wifi设置页面设置2.4G的8个SSID分别为中文1到中文8，加密模式为None，最大连接数10，开关OFF，点击保存；") {
						@wifi_page.select_2g_basic(@browser.url)
						#修改ssid1为open
						@wifi_page.modify_ssid1(@tc_ssid1_cn)
						@wifi_page.set_ssid1_open
						@wifi_page.modify_ssid1_linknum(@tc_linkmax2)
						@wifi_page.ssid1_sw=@tc_wifi_off
						#修改ssid2为open
						@wifi_page.modify_ssid2(@tc_ssid2_cn)
						@wifi_page.set_ssid2_open
						@wifi_page.modify_ssid2_linknum(@tc_linkmax2)
						@wifi_page.ssid2_sw=@tc_wifi_off
						#修改ssid3为open
						@wifi_page.modify_ssid3(@tc_ssid3_cn)
						@wifi_page.set_ssid3_open
						@wifi_page.modify_ssid3_linknum(@tc_linkmax2)
						@wifi_page.ssid3_sw=@tc_wifi_off
						#修改ssid4为open
						@wifi_page.modify_ssid4(@tc_ssid4_cn)
						@wifi_page.set_ssid4_open
						@wifi_page.modify_ssid4_linknum(@tc_linkmax2)
						@wifi_page.ssid4_sw=@tc_wifi_off

						#修改ssid5为open
						if @tc_flag1
								@wifi_page.modify_ssid4(@tc_ssid5_cn)
								@wifi_page.set_ssid4_open
								@wifi_page.modify_ssid4_linknum(@tc_linkmax2)
								@wifi_page.ssid4_sw=@tc_wifi_off
						end
						#修改ssid6为open
						if @tc_flag2
								@wifi_page.modify_ssid6(@tc_ssid6_cn)
								@wifi_page.set_ssid6_open
								@wifi_page.modify_ssid6_linknum(@tc_linkmax2)
								@wifi_page.ssid6_sw=@tc_wifi_off
						end
						#修改ssid7为open
						if @tc_flag3
								@wifi_page.modify_ssid7(@tc_ssid7_cn)
								@wifi_page.set_ssid7_open
								@wifi_page.modify_ssid7_linknum(@tc_linkmax2)
								@wifi_page.ssid7_sw=@tc_wifi_off
						end
						#修改ssid8为open
						if @tc_flag4
								@wifi_page.modify_ssid8(@tc_ssid8_cn)
								@wifi_page.set_ssid8_open
								@wifi_page.modify_ssid8_linknum(@tc_linkmax2)
								@wifi_page.ssid8_sw=@tc_wifi_off
						end
						#保存
						@wifi_page.save_wifi_config

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询SSID1详细信息".to_gbk
						ssid    = @wifi_detail.ssid1_name
						ssid_pw = @wifi_detail.ssid1_pwmode
						linkmax = @wifi_detail.ssid1_linknum
						linked  = @wifi_detail.ssid1_linked
						ssid_rf = @wifi_detail.ssid1_rf
						ssid_sw = @wifi_detail.ssid1_sw
						puts "查询到SSID1名为：#{ssid}".to_gbk
						puts "查询到SSID1加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID1最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID1已连接数为：#{linked}".to_gbk
						puts "查询到SSID1射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID1无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid1_cn, ssid, "设置SSID1为#{@tc_ssid1_cn}失败")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "设置SSID1加密方式为#{@ts_tag_wifi_open}失败")
						assert_equal(@tc_linkmax2, linkmax, "设置SSID1最大连接数为#{@tc_linkmax2}失败")
						assert_equal(@tc_linkednum, linked, "SSID1已连接数统计错误")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID1开关状态错误")

						puts "查询SSID2详细信息".to_gbk
						ssid    = @wifi_detail.ssid2_name
						ssid_pw = @wifi_detail.ssid2_pwmode
						linkmax = @wifi_detail.ssid2_linknum
						linked  = @wifi_detail.ssid2_linked
						ssid_rf = @wifi_detail.ssid2_rf
						ssid_sw = @wifi_detail.ssid2_sw
						puts "查询到SSID2名为：#{ssid}".to_gbk
						puts "查询到SSID2加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID2最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID2已连接数为：#{linked}".to_gbk
						puts "查询到SSID2射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID2无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid2_cn, ssid, "设置SSID2为#{@tc_ssid2_cn}失败")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "设置SSID2加密方式为#{@ts_tag_wifi_open}失败")
						assert_equal(@tc_linkmax2, linkmax, "设置SSID2最大连接数为#{@tc_linkmax2}失败")
						assert_equal(@tc_linkednum, linked, "SSID2已连接数统计错误")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID2开关状态错误")

						puts "查询SSID3详细信息".to_gbk
						ssid    = @wifi_detail.ssid3_name
						ssid_pw = @wifi_detail.ssid3_pwmode
						linkmax = @wifi_detail.ssid3_linknum
						linked  = @wifi_detail.ssid3_linked
						ssid_rf = @wifi_detail.ssid3_rf
						ssid_sw = @wifi_detail.ssid3_sw
						puts "查询到SSID3名为：#{ssid}".to_gbk
						puts "查询到SSID3加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID3最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID3已连接数为：#{linked}".to_gbk
						puts "查询到SSID3射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID3无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid3_cn, ssid, "设置SSID3为#{@tc_ssid3_cn}失败")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "设置SSID3加密方式为#{@ts_tag_wifi_open}失败")
						assert_equal(@tc_linkmax2, linkmax, "设置SSID3最大连接数为#{@tc_linkmax2}失败")
						assert_equal(@tc_linkednum, linked, "SSID3已连接数统计错误")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID3开关状态错误")

						puts "查询SSID4详细信息".to_gbk
						ssid    = @wifi_detail.ssid4_name
						ssid_pw = @wifi_detail.ssid4_pwmode
						linkmax = @wifi_detail.ssid4_linknum
						linked  = @wifi_detail.ssid4_linked
						ssid_rf = @wifi_detail.ssid4_rf
						ssid_sw = @wifi_detail.ssid4_sw
						puts "查询到SSID4名为：#{ssid}".to_gbk
						puts "查询到SSID4加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID4最大连接数为：#{linkmax}".to_gbk
						puts "查询到SSID4已连接数为：#{linked}".to_gbk
						puts "查询到SSID4射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID4无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid4_cn, ssid, "设置SSID4为#{@tc_ssid4_cn}失败")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "设置SSID4加密方式为#{@ts_tag_wifi_open}失败")
						assert_equal(@tc_linkmax2, linkmax, "设置SSID4最大连接数为#{@tc_linkmax2}失败")
						assert_equal(@tc_linkednum, linked, "SSID4已连接数统计错误")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID4开关状态错误")

						if @tc_flag1
								puts "查询SSID5详细信息".to_gbk
								ssid    = @wifi_detail.ssid5_name
								ssid_pw = @wifi_detail.ssid5_pwmode
								linkmax = @wifi_detail.ssid5_linknum
								linked  = @wifi_detail.ssid5_linked
								ssid_rf = @wifi_detail.ssid5_rf
								ssid_sw = @wifi_detail.ssid5_sw
								puts "查询到SSID5名为：#{ssid}".to_gbk
								puts "查询到SSID5加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID5最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID5已连接数为：#{linked}".to_gbk
								puts "查询到SSID5射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID5无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid5_cn, ssid, "设置SSID5为#{@tc_ssid5_cn}失败")
								assert_equal(@ts_tag_wifi_open, ssid_pw, "设置SSID5加密方式为#{@ts_tag_wifi_open}失败")
								assert_equal(@tc_linkmax2, linkmax, "设置SSID5最大连接数为#{@tc_linkmax2}失败")
								assert_equal(@tc_linkednum, linked, "SSID5已连接数统计错误")
								assert_equal(@tc_wifi_off, ssid_sw, "SSID5开关状态错误")
						end

						if @tc_flag2
								puts "查询SSID5详细信息".to_gbk
								ssid    = @wifi_detail.ssid6_name
								ssid_pw = @wifi_detail.ssid6_pwmode
								linkmax = @wifi_detail.ssid6_linknum
								linked  = @wifi_detail.ssid6_linked
								ssid_rf = @wifi_detail.ssid6_rf
								ssid_sw = @wifi_detail.ssid6_sw
								puts "查询到SSID6名为：#{ssid}".to_gbk
								puts "查询到SSID6加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID6最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID6已连接数为：#{linked}".to_gbk
								puts "查询到SSID6射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID6无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid6_cn, ssid, "设置SSID6为#{@tc_ssid6_cn}失败")
								assert_equal(@ts_tag_wifi_open, ssid_pw, "设置SSID6加密方式为#{@ts_tag_wifi_open}失败")
								assert_equal(@tc_linkmax2, linkmax, "设置SSID6最大连接数为#{@tc_linkmax2}失败")
								assert_equal(@tc_linkednum, linked, "SSID6已连接数统计错误")
								assert_equal(@tc_wifi_off, ssid_sw, "SSID6开关状态错误")
						end

						if @tc_flag3
								puts "查询SSID5详细信息".to_gbk
								ssid    = @wifi_detail.ssid7_name
								ssid_pw = @wifi_detail.ssid7_pwmode
								linkmax = @wifi_detail.ssid7_linknum
								linked  = @wifi_detail.ssid7_linked
								ssid_rf = @wifi_detail.ssid7_rf
								ssid_sw = @wifi_detail.ssid7_sw
								puts "查询到SSID7名为：#{ssid}".to_gbk
								puts "查询到SSID7加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID7最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID7已连接数为：#{linked}".to_gbk
								puts "查询到SSID7射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID7无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid7_cn, ssid, "设置SSID7为#{@tc_ssid7_cn}失败")
								assert_equal(@ts_tag_wifi_open, ssid_pw, "设置SSID7加密方式为#{@ts_tag_wifi_open}失败")
								assert_equal(@tc_linkmax2, linkmax, "设置SSID7最大连接数为#{@tc_linkmax2}失败")
								assert_equal(@tc_linkednum, linked, "SSID7已连接数统计错误")
								assert_equal(@tc_wifi_off, ssid_sw, "SSID7开关状态错误")
						end

						if @tc_flag4
								puts "查询SSID8详细信息".to_gbk
								ssid    = @wifi_detail.ssid8_name
								ssid_pw = @wifi_detail.ssid8_pwmode
								linkmax = @wifi_detail.ssid8_linknum
								linked  = @wifi_detail.ssid8_linked
								ssid_rf = @wifi_detail.ssid8_rf
								ssid_sw = @wifi_detail.ssid8_sw
								puts "查询到SSID8名为：#{ssid}".to_gbk
								puts "查询到SSID8加密方式为：#{ssid_pw}".to_gbk
								puts "查询到SSID8最大连接数为：#{linkmax}".to_gbk
								puts "查询到SSID8已连接数为：#{linked}".to_gbk
								puts "查询到SSID8射频为：#{ssid_rf}".to_gbk
								puts "查询到SSID8无线开关状态为：#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid8_cn, ssid, "设置SSID8为#{@tc_ssid8_cn}失败")
								assert_equal(@ts_tag_wifi_open, ssid_pw, "设置SSID8加密方式为#{@ts_tag_wifi_open}失败")
								assert_equal(@tc_linkmax2, linkmax, "设置SSID8最大连接数为#{@tc_linkmax2}失败")
								assert_equal(@tc_linkednum, linked, "SSID8已连接数统计错误")
								assert_equal(@tc_wifi_off, ssid_sw, "SSID8开关状态错误")
						end
				}


		end

		def clearup

				operate("1 恢复默认设置") {
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
						if @tc_flag1
								@wifi_page.modify_ssid5(@ts_wifi_ssid5)
								@wifi_page.modify_ssid5_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
								if @wifi_page.ssid5_sw==@tc_wifi_on
										@wifi_page.ssid5_sw=@tc_wifi_off
								end
						end
						if @tc_flag2
								@wifi_page.modify_ssid6(@ts_wifi_ssid6)
								@wifi_page.modify_ssid6_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
								if @wifi_page.ssid6_sw==@tc_wifi_on
										@wifi_page.ssid6_sw=@tc_wifi_off
								end
						end
						if @tc_flag3
								@wifi_page.modify_ssid7(@ts_wifi_ssid4)
								@wifi_page.modify_ssid7_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
								if @wifi_page.ssid7_sw==@tc_wifi_on
										@wifi_page.ssid7_sw=@tc_wifi_off
								end
						end
						if @tc_flag4
								@wifi_page.modify_ssid8(@ts_wifi_ssid7)
								@wifi_page.modify_ssid8_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid8_linknum(@ts_linknum_max)
								if @wifi_page.ssid8_sw==@tc_wifi_on
										@wifi_page.ssid8_sw=@tc_wifi_off
								end
						end
						#保存
						@wifi_page.save_wifi_config
				}
		end

}
