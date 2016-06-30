#
# description:
# 当输入的最大连接数中有小数，会自动清除小数点
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.25", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_linknum   = "1.2"
				@tc_link_num  = "12"
				@tc_wifi_time = 40
		end

		def process

				operate("1、输入框中输入小数点，例如输入#{@tc_linknum}，点击保存") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						puts "修改SSID1无线连接数为#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid1_linknum(@tc_linknum)
						link_num = @wifi_page.ssid1_link
						puts "查询到最大连接数为#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID1设置无线连接数为小数未自动清除小数点")

						puts "修改SSID2无线连接数为#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid2_linknum(@tc_linknum)
						link_num = @wifi_page.ssid2_link
						puts "查询到最大连接数为#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID2设置无线连接数为小数未自动清除小数点")

						puts "修改SSID3无线连接数为#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid3_linknum(@tc_linknum)
						link_num = @wifi_page.ssid3_link
						puts "查询到最大连接数为#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID3设置无线连接数为小数未自动清除小数点")

						puts "修改SSID4无线连接数为#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid4_linknum(@tc_linknum)
						link_num = @wifi_page.ssid4_link
						puts "查询到最大连接数为#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID4设置无线连接数为小数未自动清除小数点")

						if @wifi_page.ssid5?
								puts "修改SSID5无线连接数为#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid5_linknum(@tc_linknum)
								link_num = @wifi_page.ssid5_link
								puts "查询到最大连接数为#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID5设置无线连接数为小数未自动清除小数点")
						end

						if @wifi_page.ssid6?
								puts "修改SSID6无线连接数为#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid6_linknum(@tc_linknum)
								link_num = @wifi_page.ssid6_link
								puts "查询到最大连接数为#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID6设置无线连接数为小数未自动清除小数点")
						end

						if @wifi_page.ssid7?
								puts "修改SSID7无线连接数为#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid7_linknum(@tc_linknum)
								link_num = @wifi_page.ssid7_link
								puts "查询到最大连接数为#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID7设置无线连接数为小数未自动清除小数点")
						end

						if @wifi_page.ssid8?
								puts "修改SSID8无线连接数为#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid8_linknum(@tc_linknum)
								link_num = @wifi_page.ssid8_link
								puts "查询到最大连接数为#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID8设置无线连接数为小数未自动清除小数点")
						end
				}

				operate("2、无线SSID1和SSID8都做同样操作；") {
						#
				}
		end

		def clearup

		end

}
