#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.23", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wifi_time = 40
				@tc_flag      = false
				@tc_error_tip = "最大连接数范围应在1到30之间"
		end

		def process

				operate("1、输入框中输入#{@ts_linknum_less}，点击保存") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						puts "修改SSID1无线连接数为#{@ts_linknum_less}".to_gbk
						@wifi_page.modify_ssid1_linknum(@ts_linknum_less)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID1设置无线连接数为#{@ts_linknum_less}也能保存")
						end

						puts "修改SSID2无线连接数为#{@ts_linknum_less}".to_gbk
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_less)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID2设置无线连接数为#{@ts_linknum_less}也能保存")
						end

						puts "修改SSID3无线连接数为#{@ts_linknum_less}".to_gbk
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_less)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID3设置无线连接数为#{@ts_linknum_less}也能保存")
						end

						puts "修改SSID4无线连接数为#{@ts_linknum_less}".to_gbk
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_less)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID4设置无线连接数为#{@ts_linknum_less}也能保存")
						end

						if @wifi_page.ssid5?
								puts "修改SSID5无线连接数为#{@ts_linknum_less}".to_gbk
								@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid5_linknum(@ts_linknum_less)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID5设置无线连接数为#{@ts_linknum_less}也能保存")
								end
						end

						if @wifi_page.ssid6?
								puts "修改SSID6无线连接数为#{@ts_linknum_less}".to_gbk
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid6_linknum(@ts_linknum_less)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID6设置无线连接数为#{@ts_linknum_less}也能保存")
								end
						end

						if @wifi_page.ssid7?
								puts "修改SSID7无线连接数为#{@ts_linknum_less}".to_gbk
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid7_linknum(@ts_linknum_less)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID7设置无线连接数为#{@ts_linknum_less}也能保存")
								end
						end

						if @wifi_page.ssid8?
								puts "修改SSID8无线连接数为#{@ts_linknum_less}".to_gbk
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid8_linknum(@ts_linknum_less)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID8设置无线连接数为#{@ts_linknum_less}也能保存")
								end
						end
				}

				operate("2、输入框中输入#{@ts_linknum_more}，点击保存；") {
						@browser.refresh
						@wifi_page.select_2g_basic(@browser.url)
						puts "修改SSID1无线连接数为#{@ts_linknum_more}".to_gbk
						@wifi_page.modify_ssid1_linknum(@ts_linknum_more)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID1设置无线连接数为#{@ts_linknum_more}也能保存")
						end

						puts "修改SSID2无线连接数为#{@ts_linknum_more}".to_gbk
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_more)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID2设置无线连接数为#{@ts_linknum_more}也能保存")
						end

						puts "修改SSID3无线连接数为#{@ts_linknum_more}".to_gbk
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_more)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID3设置无线连接数为#{@ts_linknum_more}也能保存")
						end

						puts "修改SSID4无线连接数为#{@ts_linknum_more}".to_gbk
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_more)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID4设置无线连接数为#{@ts_linknum_more}也能保存")
						end

						if @wifi_page.ssid5?
								puts "修改SSID5无线连接数为#{@ts_linknum_more}".to_gbk
								@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid5_linknum(@ts_linknum_more)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID5设置无线连接数为#{@ts_linknum_more}也能保存")
								end
						end

						if @wifi_page.ssid6?
								puts "修改SSID6无线连接数为#{@ts_linknum_more}".to_gbk
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid6_linknum(@ts_linknum_more)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID6设置无线连接数为#{@ts_linknum_more}也能保存")
								end
						end

						if @wifi_page.ssid7?
								puts "修改SSID7无线连接数为#{@ts_linknum_more}".to_gbk
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid7_linknum(@ts_linknum_more)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID7设置无线连接数为#{@ts_linknum_more}也能保存")
								end
						end

						if @wifi_page.ssid8?
								puts "修改SSID8无线连接数为#{@ts_linknum_more}".to_gbk
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid8_linknum(@ts_linknum_more)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID8设置无线连接数为#{@ts_linknum_more}也能保存")
								end
						end
				}

				operate("3、无线SSID1和SSID8都做同样操作；") {
						#
				}

		end

		def clearup

				operate("1 恢复默认配置") {
						if @tc_flag
								sleep @tc_wifi_time
						end
						#错误的密码格式也能保存的话，这里要等待其保存完成
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#修改第一个SSID密码
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
						if @wifi_page.ssid5?
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
						end
						if @wifi_page.ssid6?
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
						end
						if @wifi_page.ssid7?
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
						end
						if @wifi_page.ssid8?
								@wifi_page.modify_ssid8_linknum(@ts_linknum_max)
						end
						@wifi_page.save_wifi_config
				}

		end

}
