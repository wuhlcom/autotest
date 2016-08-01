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
				@tc_bandwidth_limit1 = "10.1"
				@tc_bandwidth_limit2 = "0.56"
				@tc_bandwidth_limit3 = "@100"
				@tc_bandwidth_limit4 = "1&00"
				@tc_bandwidth_limit5 = "10-1"
				@tc_bandwidth_limit6 = "5\6"
				@tc_bandwidth_limit7 = "10=0"
				@tc_bandwidth_limit8 = "10#0"
				@tc_bandwidth_limit9 = ""
				@tc_qos_ip1          = "100"
				@tc_qos_ip2          = "200"
				@tc_qos_err_msg1     = "只允许输入正数"
				@tc_qos_err_msg2     = "请完整输入带宽限制"
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

				operate("3、受限最大带宽分别设置为10.1，0.56，@100，1&00") {
						p "受限最大带宽设置为:#{@tc_bandwidth_limit1}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit1)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "提示信息内容错误!")

						p "受限最大带宽设置为:#{@tc_bandwidth_limit2}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit2)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "提示信息内容错误!")

						p "受限最大带宽设置为:#{@tc_bandwidth_limit3}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit3)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "提示信息内容错误!")

						p "受限最大带宽设置为:#{@tc_bandwidth_limit4}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit4)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "提示信息内容错误!")
				}

				operate("4、保障最小带宽分别设置为10-1，5\6，10=0，10#0") {
						p "保障最小带宽设置为:#{@tc_bandwidth_limit5}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit5)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "提示信息内容错误!")

						p "保障最小带宽设置为:#{@tc_bandwidth_limit6}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit6)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "提示信息内容错误!")

						p "保障最小带宽设置为:#{@tc_bandwidth_limit7}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit7)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "提示信息内容错误!")

						p "保障最小带宽设置为:#{@tc_bandwidth_limit8}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit8)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "提示信息内容错误!")
				}

				operate("5、带宽设置为空，保存") {
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit9)
						@options_page.save_traffic #保存
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg2, error_tip, "提示信息内容错误!")
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
