#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.10", "level" => "P4", "auto" => "n"}

		def prepare
				#kbps
				@tc_bandwidth_total  = 1000
				@tc_bandwidth_limit1 = 800
				@tc_bandwidth_limit2 = 400
				@tc_qos_ip1          = "200"
				@tc_qos_ip2          = "201"
				@tc_bandwidth_err    = "最小带宽和不能超过总带宽！"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
				}

				operate("2、假设当前LAN口地址为192.168.100.1，设置规则1地址段为192.168,100.2到192.168,100.2，规则为保障最小带宽，带宽为800kbps；设置规则2地址段为192.168,100.3到192.168,100.3，规则为保障最小带宽，带宽为400kbps，点击保存") {
						puts "设置规则1保障最小带宽为#{@tc_bandwidth_limit1}".encode("GBK")
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip1, @ts_tag_bandensure, @tc_bandwidth_limit1)
						puts "设置规则2保障最小带宽为#{@tc_bandwidth_limit2}".encode("GBK")
						@options_page.add_item
						@options_page.set_client_bw(2, @tc_qos_ip2, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit2)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						puts "ERROR TIP : #{error_tip}".encode("GBK")
						assert_equal(@tc_bandwidth_err, error_tip, "提示信息内容错误")
				}

		end

		def clearup

				operate("1 删除带宽控制配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存
				}

		end

}
