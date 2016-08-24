#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_5.1.36", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time    = 5
				@tc_ssid1        = "abcd_5678"
				@tc_ssid2        = "ABCD_5678"
				@tc_pw           = "12345678"
				@tc_channel_5g   = "5805MHz(Channel 161)"
				@tc_channel_auto = "自动选择"
				@tc_wifi_on      = "ON"
				@tc_wifi_5g_on   = "on"
				@tc_wifi_off     = "OFF"
				@tc_flag1        = false
		end

		def process

				operate("1、查看默认5G无线配置是否正确；") {

				}

				operate("2、在wifi设置页面设置5G无线SSID第一个为abcd_5678，加密类型选择WPA-PSK/WPA2-PSK，密码为12345678，无线开关开启，无线信道修改为6信道，设置完成后查看系统状态中无线状态；") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_5g_basic(@browser.url)
						#修改SSID1
						puts "修改ssid为#{@tc_ssid1}".to_gbk
						@wifi_page.modify_ssid1_5g(@tc_ssid1)
						@wifi_page.modify_ssid1_pw_5g(@tc_pw)
						if @wifi_page.ssid1_sw_5g==@tc_wifi_off
								@wifi_page.ssid1_sw_5g=@tc_wifi_on #打开此ssid wiif开关
						end

						@wifi_page.select_5g_advance(@browser.url)
						unless @wifi_page.wifi_sw_5g_element.class_name==@tc_wifi_5g_on
								@wifi_page.wifi_sw_5g #打开5g射频开关
						end
						#修改信道
						puts "修改信道为#{@tc_channel_5g}".to_gbk
						@wifi_page.wifi_channel_5g=@tc_channel_5g
						#保存
						@wifi_page.save_wifi_config

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_systatus_page(@browser.url)
						tc_sw = @wifi_detail.get_wifi_switch_5g
						tc_ch = @wifi_detail.get_wifi_channel_5g
						assert_equal(tc_sw, @tc_wifi_5g_on, "5G开状态显示异常")
						assert_match(/#{tc_ch}/, @tc_channel_5g, "信道修改失败")
						@wifi_detail.more_obj.click
						sleep @tc_wait_time
						puts "查询SSID1详细信息".to_gbk
						ssid    = @wifi_detail.ssid1_name_5g
						ssid_pw = @wifi_detail.ssid1_pwmode_5g
						ssid_rf = @wifi_detail.ssid1_rf_5g
						ssid_sw = @wifi_detail.ssid1_sw_5g
						puts "查询到SSID1名为：#{ssid}".to_gbk
						puts "查询到SSID1加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID1射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID1无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid1, ssid, "设置SSID1为#{@tc_ssid1}失败")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "设置SSID1加密方式为#{@ts_sec_mode_wpa}失败")
						assert_equal(@tc_wifi_on, ssid_sw, "SSID1开关状态错误")
				}

				operate("3、在wifi设置页面设置5G无线SSID第一个为ABCD-5678，加密类型为None，无线开关关闭，无线信道为自动信道，设置完成后查看系统状态中无线状态；") {
						@wifi_page.select_5g_basic(@browser.url)
						#修改SSID1
						puts "修改ssid为#{@tc_ssid2}".to_gbk
						@wifi_page.modify_ssid1_5g(@tc_ssid2)
						@wifi_page.modify_ssid1_pw_5g(@tc_pw)
						if @wifi_page.ssid1_sw_5g==@tc_wifi_off
								@wifi_page.ssid1_sw_5g=@tc_wifi_on #打开此ssid wiif开关
						end

						@wifi_page.select_5g_advance(@browser.url)
						if @wifi_page.wifi_sw_5g_element.class_name==@tc_wifi_5g_on
								@wifi_page.wifi_sw_5g #关闭5g射频开关
						end
						#修改信道
						puts "修改信道为#{@tc_channel_auto}".to_gbk
						@wifi_page.wifi_channel_5g=@tc_channel_auto
						#保存
						@wifi_page.save_wifi_config

						@wifi_detail.open_systatus_page(@browser.url)
						tc_sw = @wifi_detail.get_wifi_switch_5g
						tc_ch = @wifi_detail.get_wifi_channel_5g
						assert_equal(tc_sw, @tc_wifi_5g_on, "5G开状态显示异常")
						assert_equal(@tc_channel_auto, tc_ch, "信道修改失败")
						@wifi_detail.more_obj.click
						sleep @tc_wait_time
						puts "查询SSID1详细信息".to_gbk
						ssid    = @wifi_detail.ssid1_name_5g
						ssid_pw = @wifi_detail.ssid1_pwmode_5g
						ssid_rf = @wifi_detail.ssid1_rf_5g
						ssid_sw = @wifi_detail.ssid1_sw_5g
						puts "查询到SSID1名为：#{ssid}".to_gbk
						puts "查询到SSID1加密方式为：#{ssid_pw}".to_gbk
						puts "查询到SSID1射频为：#{ssid_rf}".to_gbk
						puts "查询到SSID1无线开关状态为：#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid2, ssid, "设置SSID1为#{@tc_ssid1}失败")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "设置SSID1加密方式为#{@ts_tag_wifi_open}失败")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID1开关状态错误")
				}


		end

		def clearup
				operate("1 恢复默认设置") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_5g_basic(@browser.url)
						#修改SSID1
						@wifi_page.modify_ssid1_5g(@ts_wifi_ssid1_5g)
						@wifi_page.modify_ssid1_pw_5g(@ts_default_wlan_pw)
						if @wifi_page.ssid1_sw_5g==@tc_wifi_off
								@wifi_page.ssid1_sw_5g=@tc_wifi_on
						end
						#保存
						@wifi_page.save_wifi_config
				}
		end

}
