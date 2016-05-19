#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.3", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wifi_on         = "on"
				@tc_wifi_status_off = "OFF"
				@tc_wifi_status_on  = "ON"
		end

		def process

				operate("1、AP开启2.4G频段的无线功能，查看状态页面无线开关状态；") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.close_2g_sw(@browser.url)
						@wifi_page.save_wifi_config
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						systatus = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_status_off, systatus, "无线开关关闭失败！")
				}

				operate("2、AP关闭2.4G频段的无线功能，查看状态页面无线开关状态；") {
						@wifi_page.open_2g_sw(@browser.url)
						@wifi_page.save_wifi_config
						@systatus_page.open_systatus_page(@browser.url)
						systatus = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_status_on, systatus, "无线开关关闭失败！")
				}

		end

		def clearup

				operate("1 恢复默认配置") {
						#打开无线开关
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
						unless @wifi_page.wifi_sw_element.class_name==@tc_wifi_on
								@wifi_page.wifi_sw
								@wifi_page.save_wifi_config
						end
				}

		end

}
