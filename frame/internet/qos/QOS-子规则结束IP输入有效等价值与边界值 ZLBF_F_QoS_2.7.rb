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
				@tc_bandwidth_limit = "1024"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
						@options_page.add_item
				}

				operate("2、起始IP地址输入x.x.x.1") {

				}

				operate("3、带宽控制的对规则1的起始结束地址边界进行测试") {
						#边界值测试
						#起始IP地址下边界
						tc_qos_ip  = "1"
						tc_qos_ip2 = "254"
						tc_qos_ip3 = "100"
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")

						#起始IP地址上边界
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")

						# 结束IP地址下边界
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip3}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip3, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")
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
