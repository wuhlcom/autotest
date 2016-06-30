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
				@tc_error_msg_text  = "SSID是中文,数字,字母和特殊字符(~!@\#$*()_{}<>?.[]-=`^+:),长度为1-32位,一个中文占3位"
				@tc_flag            = false
		end

		def process

				operate("1、设置无线SSID为32个特殊字符“~!@#$%^&*()_+-={}:\"<>?[]|\; ',./`”，是否可以设置成功；") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name)
						puts "修改SSID1名字为#{@tc_ssid_name}".to_gbk
						@wifi_page.save_wifi_config

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询SSID1详细信息".to_gbk
						ssid1 = @wifi_detail.ssid1_name
						assert_equal(@tc_ssid_name, ssid1, "SSID1配置失败")
						@wifi_page.select_2g_basic(@browser.url)

						@tc_special_illegal.each do |item|
								ssid_name = "wifitest#{item}"
								puts "修改SSID1名字为：#{ssid_name}".to_gbk
								@wifi_page.modify_ssid1(ssid_name)
								@wifi_page.save_wifi
								sleep @tc_wait_time
								error_info = @wifi_page.wifi_error
								puts "ERROR TIP #{error_info}".to_gbk
								unless @tc_error_msg_text==error_info
										@tc_flag=true
								end
								assert_equal(@tc_error_msg_text, error_info, "输入非法特殊字符未提示错误")
						end

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
