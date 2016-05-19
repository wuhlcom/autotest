#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.9", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time      = 3
				@tc_wifi_time      = 30
				@tc_ssid_name1     = "1234567890ASDFGHJKLMqwertyuiop123"
				@tc_ssid_name2     = ""
				@tc_error_msg_text = "SSID������,����,��ĸ�������ַ�(~!@\#$*()_{}<>?.[]-=`^+:),����Ϊ1-32λ,һ������ռ3λ"
				@tc_error_msg      = "������SSID"
		end

		def process

				operate("1����������SSIDΪ��#{@tc_ssid_name1}��,#{@tc_ssid_name1.size}���ַ���") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name1)
						puts "�޸�SSID1����Ϊ:'#{@tc_ssid_name1}'".to_gbk
						@wifi_page.save_wifi
						sleep @tc_wait_time
						error_info = @wifi_page.wifi_error
						puts "ERROR TIP #{error_info}".to_gbk
						unless @tc_error_msg_text==error_info
								@tc_flag=true
						end
						assert_equal(@tc_error_msg_text, error_info, "����ո�ͷ�ķǷ�SSIDδ��ʾ����")
				}

				operate("2����������SSIDΪ�գ��������κ�ֵ��") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid2(@tc_ssid_name2)
						puts "�޸�SSID1����Ϊ:'#{@tc_ssid_name2}'".to_gbk
						@wifi_page.save_wifi
						sleep @tc_wait_time
						error_info = @wifi_page.wifi_error
						puts "ERROR TIP #{error_info}".to_gbk
						unless @tc_error_msg_text==error_info
								@tc_flag=true
						end
						assert_equal(@tc_error_msg, error_info, "����ո�ͷ�ķǷ�SSIDδ��ʾ����")
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
						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						@wifi_page.save_wifi_config
				}
		end

}
