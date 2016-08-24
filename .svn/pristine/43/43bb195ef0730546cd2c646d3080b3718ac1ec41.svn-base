#
# description:
#只要测试以下几种情况就可以覆盖到所有可能的异常
#基本原则:新规则的起始和结束IP要么都小于已有规则的下边界，要么都大于已有规则的上边界
#于是可得出以下三种情况，a,b为规则1,从左到右从大到小排列数字
# 1--(x,a)(a b) ,2--(a b) (b,y),3--x (a b) y
#规则1为一个IP范围，规则2为IP范围，上边界，下边界与规则1重叠或规则1在规则2的范围内
#规则1为一个IP地址是特例，只要IP范围的测试通过这种特例也是通过的
#2015 12 17 bug 未对上边界的合法性做检查
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.14", "level" => "P4", "auto" => "n"}

		def prepare
				#kpbs
				@tc_bandwidth_total = 100000
				@tc_bandwidth_limit = 8000
				@tc_wait_time       = 2

				#rule1@tc_rule1_ip1
				@tc_rule1_ip1       = "100"
				@tc_rule1_ip2       = "110"
				#上边界与tc_rule1_ip1与一样
				@tc_rule2_ip1       = "50"
				@tc_rule2_ip2       = "100"
				#下边界与tc_rule1_ip1与一样
				@tc_rule3_ip1       = "110"
				@tc_rule3_ip2       = "120"
				#rule1在范围内
				@tc_rule4_ip1       = "90"
				@tc_rule4_ip2       = "120"
				@tc_rule_error      = "存在相交的IP段"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total)
				}

				operate("2、假设当前LAN口地址为192.168.100.1，设置规则1地址段为192.168,100.2到192.168,100.2") {
						#第二条的结束范围与第一条的起始范围相等
						#设置规则1，流量控制的IP,设置ip范围
						puts "rule 1 ip start ip #{@tc_rule1_ip1},end ip #{@tc_rule1_ip2}"
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_rule1_ip1, @tc_rule1_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)

						puts "rule 2 ip start ip #{@tc_rule2_ip1},end ip #{@tc_rule2_ip2}"
						#设置规则2，流量控制的IP,设置ip范围
						@options_page.add_item
						@options_page.set_client_bw(2, @tc_rule1_ip1, @tc_rule1_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip, "提示信息内容错误!")
				}

				operate("3、设置规则2地址段也为192.168,100.2到192.168,100.2，是否能设置成功") {
						#第二条起始范围与第一条的结束范围相等
						@options_page.set_client_bw(2, @tc_rule3_ip1, @tc_rule3_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #提交
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip, "提示信息内容错误!")
				}

				operate("4、重新设置规则1地址段为192.168,100.2到192.168,100.3，设置规则2地址段为192.168,100.3到192.168,100.4，是否能设置成功") {
						#第二条范围包含第一条范围
						@options_page.set_client_bw(2, @tc_rule4_ip1, @tc_rule4_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #提交
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip, "提示信息内容错误!")
				}

		end

		def clearup

				operate("1 删除带宽控制配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #提交
				}

		end

}
