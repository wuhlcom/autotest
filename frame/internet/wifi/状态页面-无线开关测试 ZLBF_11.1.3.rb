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

				operate("1��AP����2.4GƵ�ε����߹��ܣ��鿴״̬ҳ�����߿���״̬��") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.close_2g_sw(@browser.url)
						@wifi_page.save_wifi_config
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						systatus = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_status_off, systatus, "���߿��عر�ʧ�ܣ�")
				}

				operate("2��AP�ر�2.4GƵ�ε����߹��ܣ��鿴״̬ҳ�����߿���״̬��") {
						@wifi_page.open_2g_sw(@browser.url)
						@wifi_page.save_wifi_config
						@systatus_page.open_systatus_page(@browser.url)
						systatus = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_status_on, systatus, "���߿��عر�ʧ�ܣ�")
				}

		end

		def clearup

				operate("1 �ָ�Ĭ������") {
						#�����߿���
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
						unless @wifi_page.wifi_sw_element.class_name==@tc_wifi_on
								@wifi_page.wifi_sw
								@wifi_page.save_wifi_config
						end
				}

		end

}
