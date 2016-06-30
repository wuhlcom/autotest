#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.5", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time       = 2
				@tc_wifi_time       = 30
				@tc_ssid_name       = "~!@\#$*()_{}<>?.[]-=`^+:"
				@tc_special_illegal = %w(% & ; ' " | \\ \/)
				@tc_error_msg_text  = "SSID������,����,��ĸ�������ַ�(~!@\#$*()_{}<>?.[]-=`^+:),����Ϊ1-32λ,һ������ռ3λ"
				@tc_flag            = false
		end

		def process

				operate("1����������SSIDΪ32�������ַ���~!@#$%^&*()_+-={}:\"<>?[]|\; ',./`�����Ƿ�������óɹ���") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name)
						puts "�޸�SSID1����Ϊ#{@tc_ssid_name}".to_gbk
						@wifi_page.save_wifi_config

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯSSID1��ϸ��Ϣ".to_gbk
						ssid1 = @wifi_detail.ssid1_name
						assert_equal(@tc_ssid_name, ssid1, "SSID1����ʧ��")
						@wifi_page.select_2g_basic(@browser.url)

						@tc_special_illegal.each do |item|
								ssid_name = "wifitest#{item}"
								puts "�޸�SSID1����Ϊ��#{ssid_name}".to_gbk
								@wifi_page.modify_ssid1(ssid_name)
								@wifi_page.save_wifi
								sleep @tc_wait_time
								error_info = @wifi_page.wifi_error
								puts "ERROR TIP #{error_info}".to_gbk
								unless @tc_error_msg_text==error_info
										@tc_flag=true
								end
								assert_equal(@tc_error_msg_text, error_info, "����Ƿ������ַ�δ��ʾ����")
						end

				}
		end

		def clearup
				operate("1���ָ�����Ĭ������") {
						if @tc_flag
								sleep @tc_wifi_time
						end
						#����������ʽҲ�ܱ���Ļ�������Ҫ�ȴ��䱣�����
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#�޸�SSID
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.save_wifi_config
				}
		end

}
