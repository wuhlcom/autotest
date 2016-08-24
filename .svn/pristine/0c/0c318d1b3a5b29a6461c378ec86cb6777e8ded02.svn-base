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

				operate("2、输入其他异常值，例如输入字母，汉字，特殊字符，小数，留空，0等值，点击保存，是否能保存成功") {
						#特殊符号
						tc_qos_ip      = "254"
						tc_qos_err_ip2 = "地址" #中文
						tc_qos_err_ip3 = "@" #符号
						tc_qos_err_ip4 = "c" #字母
						puts "输入结束IP地址为:#{tc_qos_ip}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_ip


						puts "输入起始IP地址为：#{tc_qos_err_ip2}".encode("GBK") #中文
						@options_page.bw_ip_min0=tc_qos_err_ip2
            @options_page.save_traffic #保存
            sleep @tc_wait_time
            error_tip = @options_page.error_msg
            puts "ERROR TIP #{error_tip}".encode("GBK")
            assert_equal(@tc_ip_error2, error_tip, "提示信息内容错误!")

						puts "输入起始IP地址为：#{tc_qos_err_ip3}".encode("GBK") #符号
						@options_page.bw_ip_min0=tc_qos_err_ip3
            @options_page.save_traffic #保存
            sleep @tc_wait_time
            error_tip = @options_page.error_msg
            puts "ERROR TIP #{error_tip}".encode("GBK")
            assert_equal(@tc_ip_error2, error_tip, "提示信息内容错误!")

						puts "输入起始IP地址为：#{tc_qos_err_ip4}".encode("GBK") #字母
						@options_page.bw_ip_min0=tc_qos_err_ip4
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
