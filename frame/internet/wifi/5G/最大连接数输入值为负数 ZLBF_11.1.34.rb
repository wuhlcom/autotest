#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.34", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_linknum  = "-30"
				@tc_link_num = "30"
		end

		def process

				operate("1、输入框中输入负数，例如输入“-1”，点击保存") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_5g_basic(@browser.url)
						puts "修改SSID1无线连接数为#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid1_linknum_5g(@tc_linknum)
						link_num = @wifi_page.ssid1_link_5g
						puts "查询到最大连接数为#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID1设置无线连接数为负数未自动去除负号")

						puts "修改SSID2无线连接数为#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid2_linknum_5g(@tc_linknum)
						link_num = @wifi_page.ssid2_link_5g
						puts "查询到最大连接数为#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID2设置设置无线连接数为负数未自动去除负号")

						puts "修改SSID3无线连接数为#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid3_linknum_5g(@tc_linknum)
						link_num = @wifi_page.ssid3_link_5g
						puts "查询到最大连接数为#{link_num}"
						assert_equal(@tc_link_num, link_num, "SSID3设置无线连接数为负数未自动去除负号")

						puts "修改SSID4无线连接数为#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid4_linknum_5g(@tc_linknum)
						link_num = @wifi_page.ssid4_link_5g
						puts "查询到最大连接数为#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID4设置无线连接数为负数未自动去除负号")

						if @wifi_page.ssid5_5g?
								puts "修改SSID5无线连接数为#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid5_linknum_5g(@tc_linknum)
								link_num = @wifi_page.ssid5_link_5g
								puts "查询到最大连接数为#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID5设置无线连接数为负数未自动去除负号")
						end

						if @wifi_page.ssid6_5g?
								puts "修改SSID6无线连接数为#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid6_linknum_5g(@tc_linknum)
								link_num = @wifi_page.ssid6_link_5g
								puts "查询到最大连接数为#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID6设置无线连接数为负数未自动去除负号")
						end

						if @wifi_page.ssid7_5g?
								puts "修改SSID7无线连接数为#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid7_linknum_5g(@tc_linknum)
								link_num = @wifi_page.ssid7_link_5g
								puts "查询到最大连接数为#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID7设置无线连接数为负数未自动去除负号")
						end

						if @wifi_page.ssid8_5g?
								puts "修改SSID8无线连接数为#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid8_linknum_5g(@tc_linknum)
								link_num = @wifi_page.ssid8_link_5g
								puts "查询到最大连接数为#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID8设置无线连接数为负数未自动去除负号")
						end
				}

				operate("2、无线SSID1和SSID8都做同样操作；") {

				}


		end

		def clearup

		end

}
