#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.16", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_telnet_usr    = "root"
				@tc_telnet_pw     = "zl4321"
				@tc_signal_strong = "强"
				@tc_dbm_strong    = "20"
				@tc_signal_middle = "中"
				@tc_dbm_middle    = "17"
				@tc_signal_weak   = "弱"
				@tc_dbm_weak      = "14"
		end

		def process

				operate("1、进入高级设置-wifi高级设置页面；") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
				}

				operate("2、设置信号强度为强，点击保存，查看是否保存成功，STA是否连接成功；") {
						sig = @wifi_page.wifi_signal
						puts "当前信号强度设置值为:#{sig}".to_gbk
						unless sig == @tc_signal_strong
								puts "修改信号强度设置值为:#{@tc_signal_strong}".to_gbk
								@wifi_page.modify_wifi_signal(@tc_signal_strong)
								@wifi_page.save_wifi_config
						end
						init_router_obj(@ts_default_ip, @tc_telnet_usr, @tc_telnet_pw)
						iwinfo = router_iwconfig
						logout_router
						signal = iwinfo[3]
						puts "查询到信号强度为#{signal}dBm".to_gbk
						assert_equal(@tc_dbm_strong, signal, "信号强度设置不正确")
				}

				operate("3、设置信号强度为中，点击保存，查看是否保存成功，STA是否连接成功；") {
						@wifi_page.select_2g_advset
						sig = @wifi_page.wifi_signal
						puts "当前信号强度设置值为:#{sig}".to_gbk
						unless sig == @tc_signal_middle
								puts "修改信号强度设置值为:#{@tc_signal_middle}".to_gbk
								@wifi_page.modify_wifi_signal(@tc_signal_middle)
								@wifi_page.save_wifi_config
						end
						init_router_obj(@ts_default_ip, @tc_telnet_usr, @tc_telnet_pw)
						iwinfo = router_iwconfig
						logout_router
						signal = iwinfo[3]
						puts "查询到信号强度为#{signal}dBm".to_gbk
						assert_equal(@tc_dbm_middle, signal, "信号强度设置不正确")
				}

				operate("4、设置信号强度为弱，点击保存，查看是否保存成功，STA是否连接成功；") {
						@wifi_page.select_2g_advset
						sig = @wifi_page.wifi_signal
						puts "当前信号强度设置值为:#{sig}".to_gbk
						unless sig == @tc_signal_weak
								puts "修改信号强度设置值为:#{@tc_signal_weak}".to_gbk
								@wifi_page.modify_wifi_signal(@tc_signal_weak)
								@wifi_page.save_wifi_config
						end
						init_router_obj(@ts_default_ip, @tc_telnet_usr, @tc_telnet_pw)
						iwinfo = router_iwconfig
						logout_router
						signal = iwinfo[3]
						puts "查询到信号强度为#{signal}dBm".to_gbk
						assert_equal(@tc_dbm_weak, signal, "信号强度设置不正确")
				}

		end

		def clearup
				operate("1 恢复默认信号强度设置") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
						unless @wifi_page.wifi_signal == @tc_signal_strong
								@wifi_page.modify_wifi_signal(@tc_signal_strong)
								@wifi_page.save_wifi_config
						end
				}
		end

}
