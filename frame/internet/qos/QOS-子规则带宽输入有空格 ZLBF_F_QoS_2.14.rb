#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.6", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time        = 2
				#kbps
				@tc_bandwidth_total  = "1000"
				@tc_bandwidth_limit1 = "10 1"
				@tc_bandwidth_limit2 = " 101"
				@tc_bandwidth_limit3 = "101 "
				@tc_qos_ip1          = "100"
				@tc_qos_ip2          = "200"
				@tc_qos_err_msg      = "只允许输入正数"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
						@options_page.add_item
				}

				operate("2、起始IP地址输入100，结束地址输入200") {
				}

				operate("3、受限最大带宽分别设置为\"10 1\"，\" 101\"，\"101 \"") {
						p "受限最大带宽设置为:#{@tc_bandwidth_limit1}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit1)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg, error_tip, "提示信息内容错误!")

						p "受限最大带宽设置为:#{@tc_bandwidth_limit2}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit2)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg, error_tip, "提示信息内容错误!")

						p "受限最大带宽设置为:#{@tc_bandwidth_limit3}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit3)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg, error_tip, "提示信息内容错误!")
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
