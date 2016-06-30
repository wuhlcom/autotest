#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.6", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time      = 3
				@tc_wifi_time      = 30
				@tc_ssid_name1     = " test123"
				@tc_ssid_name2     = "test123 "
				@tc_ssid_name3     = "test 123"
				@tc_ssid_name4     = "tes t 123"
				@tc_error_msg_text = "SSID������,����,��ĸ�������ַ�(~!@\#$*()_{}<>?.[]-=`^+:),����Ϊ1-32λ,һ������ռ3λ"
		end

		def process

				operate("1����������SSID��һ���ַ�Ϊ�ո�") {
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

				operate("2����������SSID���һ���ַ�Ϊ�ո�") {
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name2)
						puts "�޸�SSID1����Ϊ:'#{@tc_ssid_name2}'".to_gbk
						@wifi_page.save_wifi
						sleep @tc_wait_time
						error_info = @wifi_page.wifi_error
						puts "ERROR TIP #{error_info}".to_gbk
						unless @tc_error_msg_text==error_info
								@tc_flag=true
						end
						assert_equal(@tc_error_msg_text, error_info, "����ո��β�ķǷ�SSIDδ��ʾ����")
				}

				operate("3����������SSID�м�����һ���ո���123 abc") {
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name3)
						puts "�޸�SSID1����Ϊ:'#{@tc_ssid_name3}'".to_gbk
						@wifi_page.save_wifi
						sleep @tc_wait_time
						error_info = @wifi_page.wifi_error
						puts "ERROR TIP #{error_info}".to_gbk
						unless @tc_error_msg_text==error_info
								@tc_flag=true
						end
						assert_equal(@tc_error_msg_text, error_info, "�����м��пո��β�ķǷ�SSIDδ��ʾ����")
				}

				operate("4����������SSID�������һ�����Ͽո���123 abc 123") {
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name4)
						puts "�޸�SSID1����Ϊ:'#{@tc_ssid_name4}'".to_gbk
						@wifi_page.save_wifi
						sleep @tc_wait_time
						error_info = @wifi_page.wifi_error
						puts "ERROR TIP #{error_info}".to_gbk
						unless @tc_error_msg_text==error_info
								@tc_flag=true
						end
						assert_equal(@tc_error_msg_text, error_info, "�����м��пո��β�ķǷ�SSIDδ��ʾ����")
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
