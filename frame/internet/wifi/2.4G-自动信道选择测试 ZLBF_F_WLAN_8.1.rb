#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.2", "level" => "P3", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_sssid            = "Wireless0"
				@tc_wait_time        = 2
				@tc_wifi_on          = "on"
				@tc_ap_channel_value = "2412MHz(Channel 1)"
				@tc_channel          = "1"
				@tc_ap_channel_auto  = "自动选择"
		end

		def process

				operate("1、AP开启2.4G频段的无线功能；") {
				}

				operate("2、修改信道为1信道，查看状态；") {
						@wifi_page   = RouterPageObject::WIFIPage.new(@browser)
						@tc_mac_last = @wifi_page.get_mac_last
						@tc_ssid_name= "#{@tc_sssid}_#{@tc_mac_last}"
						@wifi_page.select_2g_advance(@browser.url)
						#无线打开无线开关
						unless @wifi_page.wifi_sw_element.class_name==@tc_wifi_on
								@wifi_page.wifi_sw
						end
						@wifi_page.wifi_channel=@tc_ap_channel_value #修改信道
						@wifi_page.save_wifi_config

						@wifi_page.select_2g_set
						puts "SSID为#{@tc_ssid_name}".to_gbk
						@wifi_page.modify_ssid1(@tc_ssid_name) #修改SSID
						@wifi_page.save_wifi_config

						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						channel = @systatus_page.get_wifi_channel
						puts "修改后信道为:'#{channel}'".to_gbk
						assert_equal(@tc_channel, channel, "信道修改失败！")
						# 扫描信道
						wifichannel = @wifi.get_wlan_channel(@tc_ssid_name)
						puts "扫描到信道为:'#{wifichannel}'".to_gbk
						assert_equal(@tc_channel, wifichannel, "扫描到信道不正确")
				}

				operate("3、修改信道为自动信道，查看状态；") {
						@wifi_page.select_2g_advance(@browser.url)
						@wifi_page.wifi_channel=@tc_ap_channel_auto
						@wifi_page.save_wifi_config
						@browser.refresh #针对页面卡死现象，刷新一次页面
						@systatus_page.open_systatus_page(@browser.url)
						channel = @systatus_page.get_wifi_channel
						puts "修改后信道为:#{channel}".to_gbk
						assert_match(/\d+/, channel, "信道修改失败！") #不再显示"自动信道"
				}
		end

		def clearup

				operate("1 恢复默认配置") {
						#打开无线开关
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
						unless @wifi_page.wifi_channel==@tc_ap_channel_auto
								@wifi_page.wifi_channel=@tc_ap_channel_auto
								@wifi_page.save_wifi_config
						end

						@wifi_page.select_2g_set
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.save_wifi_config
				}

		end

}
