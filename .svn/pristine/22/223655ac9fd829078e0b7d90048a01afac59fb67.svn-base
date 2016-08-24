#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.24", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_wifi_time = 40
				@tc_flag      = false
				@tc_linknum   = ""
				@tc_error_tip = "最大连接数范围应在1到30之间"
		end

		def process

				operate("1、输入框中不输入任何值，点击保存") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						puts "修改SSID1无线连接数为空".to_gbk
						@wifi_page.modify_ssid1_linknum(@tc_linknum)
						puts "修改SSID2无线连接数为空".to_gbk
						@wifi_page.modify_ssid2_linknum(@tc_linknum)
						puts "修改SSID3无线连接数为空".to_gbk
						@wifi_page.modify_ssid3_linknum(@tc_linknum)
						puts "修改SSID4无线连接数为空".to_gbk
						@wifi_page.modify_ssid4_linknum(@tc_linknum)
						if @wifi_page.ssid5?
								puts "修改SSID5无线连接数为空".to_gbk
								@wifi_page.modify_ssid5_linknum(@tc_linknum)
						end
						if @wifi_page.ssid6?
								puts "修改SSID6无线连接数为空".to_gbk
								@wifi_page.modify_ssid6_linknum(@tc_linknum)
						end
						if @wifi_page.ssid7?
								puts "修改SSID5无线连接数为空".to_gbk
								@wifi_page.modify_ssid7_linknum(@tc_linknum)
						end
						if @wifi_page.ssid8?
								puts "修改SSID5无线连接数为空".to_gbk
								@wifi_page.modify_ssid8_linknum(@tc_linknum)
						end
						@wifi_page.save_wifi_config

						link_num = @wifi_page.ssid1_link
						puts "查询到SSID1最大连接数为#{link_num}".to_gbk
						assert_equal(@ts_linknum_max, link_num, "SSID1设置无线连接数为空时未自动填充最大值")

						link_num = @wifi_page.ssid2_link
						puts "查询到SSID2最大连接数为#{link_num}".to_gbk
						assert_equal(@ts_linknum_max, link_num, "SSID2设置无线连接数为空时未自动填充最大值")

						link_num = @wifi_page.ssid3_link
						puts "查询到SSID3最大连接数为#{link_num}".to_gbk
						assert_equal(@ts_linknum_max, link_num, "SSID3设置无线连接数为空时未自动填充最大值")

						link_num = @wifi_page.ssid4_link
						puts "查询到SSID4最大连接数为#{link_num}".to_gbk
						assert_equal(@ts_linknum_max, link_num, "SSID4设置无线连接数为空时未自动填充最大值")

						if @wifi_page.ssid5?
								link_num = @wifi_page.ssid5_link
								puts "查询到SSID5最大连接数为#{link_num}".to_gbk
								assert_equal(@ts_linknum_max, link_num, "SSID6设置无线连接数为空时未自动填充最大值")
						end

						if @wifi_page.ssid6?
								link_num = @wifi_page.ssid6_link
								puts "查询到SSID6最大连接数为#{link_num}".to_gbk
								assert_equal(@ts_linknum_max, link_num, "SSID6设置无线连接数为空时未自动填充最大值")
						end
						if @wifi_page.ssid7?
								link_num = @wifi_page.ssid7_link
								puts "查询到SSID6最大连接数为#{link_num}".to_gbk
								assert_equal(@ts_linknum_max, link_num, "SSID7设置无线连接数为空时未自动填充最大值")
						end

						if @wifi_page.ssid8?
								link_num = @wifi_page.ssid8_link
								puts "查询到SSID7最大连接数为#{link_num}".to_gbk
								assert_equal(@ts_linknum_max, link_num, "SSID8设置无线连接数为空时未自动填充最大值")
						end
				}

				operate("2、无线SSID1和SSID8都做同样操作；") {
						#
				}


		end

		def clearup

		end

}
