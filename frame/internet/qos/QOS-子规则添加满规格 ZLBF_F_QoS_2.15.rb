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
				@tc_bandwidth_total = "1000"
				@tc_bandwidth_limit = "10"
				@tc_qos_ip          = 1
				@tc_qos_ip2         = "2"
				@tc_qos_err_msg     = "超出限制"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
						@options_page.add_item
				}

				operate("2、逐条添加规则直到达到满规格（8条），保存") {
						@options_page.set_client_bw(1, @tc_qos_ip.to_s, (@tc_qos_ip+1).to_s, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.add_item
						@options_page.set_client_bw(2, (@tc_qos_ip+2).to_s, (@tc_qos_ip+3).to_s, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.add_item
						@options_page.set_client_bw(3, (@tc_qos_ip+4).to_s, (@tc_qos_ip+5).to_s, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.add_item
						@options_page.set_client_bw(4, (@tc_qos_ip+6).to_s, (@tc_qos_ip+7).to_s, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.add_item
						@options_page.set_client_bw(5, (@tc_qos_ip+8).to_s, (@tc_qos_ip+9).to_s, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.add_item
						@options_page.set_client_bw(6, (@tc_qos_ip+10).to_s, (@tc_qos_ip+11).to_s, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.add_item
						@options_page.set_client_bw(7, (@tc_qos_ip+12).to_s, (@tc_qos_ip+13).to_s, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.add_item
						@options_page.set_client_bw(8, (@tc_qos_ip+14).to_s, (@tc_qos_ip+15).to_s, @ts_tag_bandlimit, @tc_bandwidth_limit)
				}

				operate("3、再额外添加一条") {
						@options_page.add_item
						sleep @tc_wait_time
						error_tip = @options_page.error_aui
						assert_equal(@tc_qos_err_msg, error_tip, "提示信息不正确")
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
