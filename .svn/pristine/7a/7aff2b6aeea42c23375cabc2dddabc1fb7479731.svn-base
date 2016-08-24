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
				@tc_ip1             ="1"
				@tc_ip2             ="254"
				@tc_ip3             ="100"
				#kbps
				@tc_bandwidth_total = "100000"
				@tc_bandwidth_limit = "1024"
		end

		def process
				operate("1、进入DUT流量控制页面") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
				}

				operate("2、勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps") {
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
				}

				operate("3、添加一条流量控制规则") {
						@options_page.add_item
				}

				operate("4、起始IP地址输入x.x.x.1") {

				}
				operate("5、结束IP输入x.x.x.254,带宽为100,其它值为默认值,保存") {
						puts "输入起始IP地址为#{@tc_ip1}".encode("GBK")
						puts "结束地址为#{@tc_ip2}".encode("GBK")
						@options_page.set_client_bw(1, @tc_ip1, @tc_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")
				}
				operate("6、起始IP地址输入x.x.x.254,保存") {
						puts "输入起始IP地址为#{@tc_ip2}".encode("GBK")
						puts "结束地址为#{@tc_ip2}".encode("GBK")
						@options_page.set_client_bw(1, @tc_ip2, @tc_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")
				}

				operate("7、起始IP地址输入x.x.x.100,保存") {
						puts "输入起始IP地址为#{@tc_ip3}".encode("GBK")
						puts "结束地址为#{@tc_ip2}".encode("GBK")
						@options_page.set_client_bw(1, @tc_ip3, @tc_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")
				}
		end

		def clearup

				operate("1 删除流量控制配置") {
						if @options_page.total_bw?
								@options_page.unselect_traffic_sw
								@options_page.save_traffic(10)
						else
								@options_page = RouterPageObject::OptionsPage.new(@browser)
								@options_page.select_traffic_ctl(@browser.url)
								@options_page.unselect_traffic_sw
								@options_page.save_traffic(10)
						end
				}
		end

}
