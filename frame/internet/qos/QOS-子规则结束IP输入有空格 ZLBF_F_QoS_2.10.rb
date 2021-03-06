#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.6", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time       = 2
				#kbps
				@tc_bandwidth_total = "100000"
        @tc_ip_error2       = "只允许输入正数"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
						@options_page.add_item
				}

				operate("2、起始IP输入x.x.x.1,带宽为100,其它值为默认值保存") {
						tc_qos_ip      = "1"
						puts "输入起始IP地址为:#{tc_qos_ip}".encode("GBK")
						@options_page.bw_ip_min0=tc_qos_ip
				}

				operate("3、结束IP地址输入有空格如\"2 5\",\" 25\",\"25 \"") {
						tc_qos_err_ip1 = "2 5"
						tc_qos_err_ip2 = " 25"
						tc_qos_err_ip3 = "25 "

						puts "输入结束IP地址为：#{tc_qos_err_ip1}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_err_ip1
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error2, error_tip, "提示信息内容错误!")

						puts "输入结束IP地址为：#{tc_qos_err_ip2}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_err_ip2
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error2, error_tip, "提示信息内容错误!")

						puts "输入结束IP地址为：#{tc_qos_err_ip3}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_err_ip3
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error2, error_tip, "提示信息内容错误!")
				}


		end

		def clearup

				operate("1 删除流量控制配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.delete_item_all
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存
				}
		end

}
