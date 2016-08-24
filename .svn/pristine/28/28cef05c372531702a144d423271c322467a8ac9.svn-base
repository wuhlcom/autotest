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
				@tc_error_msg_text = "SSID是中文,数字,字母和特殊字符(~!@\#$*()_{}<>?.[]-=`^+:),长度为1-32位,一个中文占3位"
		end

		def process

				operate("1、设置无线SSID第一个字符为空格；") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name1)
						puts "修改SSID1名字为:'#{@tc_ssid_name1}'".to_gbk
						@wifi_page.save_wifi
						sleep @tc_wait_time
						error_info = @wifi_page.wifi_error
						puts "ERROR TIP #{error_info}".to_gbk
						unless @tc_error_msg_text==error_info
								@tc_flag=true
						end
						assert_equal(@tc_error_msg_text, error_info, "输入空格开头的非法SSID未提示错误")
				}

				operate("2、设置无线SSID最后一个字符为空格；") {
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name2)
						puts "修改SSID1名字为:'#{@tc_ssid_name2}'".to_gbk
						@wifi_page.save_wifi
						sleep @tc_wait_time
						error_info = @wifi_page.wifi_error
						puts "ERROR TIP #{error_info}".to_gbk
						unless @tc_error_msg_text==error_info
								@tc_flag=true
						end
						assert_equal(@tc_error_msg_text, error_info, "输入空格结尾的非法SSID未提示错误")
				}

				operate("3、设置无线SSID中间输入一个空格；如123 abc") {
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name3)
						puts "修改SSID1名字为:'#{@tc_ssid_name3}'".to_gbk
						@wifi_page.save_wifi
						sleep @tc_wait_time
						error_info = @wifi_page.wifi_error
						puts "ERROR TIP #{error_info}".to_gbk
						unless @tc_error_msg_text==error_info
								@tc_flag=true
						end
						assert_equal(@tc_error_msg_text, error_info, "输入中间有空格结尾的非法SSID未提示错误")
				}

				operate("4、设置无线SSID间隔输入一个以上空格；如123 abc 123") {
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name4)
						puts "修改SSID1名字为:'#{@tc_ssid_name4}'".to_gbk
						@wifi_page.save_wifi
						sleep @tc_wait_time
						error_info = @wifi_page.wifi_error
						puts "ERROR TIP #{error_info}".to_gbk
						unless @tc_error_msg_text==error_info
								@tc_flag=true
						end
						assert_equal(@tc_error_msg_text, error_info, "输入中间有空格结尾的非法SSID未提示错误")
				}

		end

		def clearup

				operate("1、恢复无线默认配置") {
						if @tc_flag
								sleep @tc_wifi_time
						end
						#错误的密码格式也能保存的话，这里要等待其保存完成
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#修改SSID
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.save_wifi_config
				}

		end

}
