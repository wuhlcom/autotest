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
				@tc_qos_time        = 2
				@tc_rule_time       = 1

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
				@tc_rule5_ip1       = "90"
				@tc_rule5_ip2       = "120"
				@tc_rule_error      = "IP地址段有交集"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {
						#打开高级设置
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						#打开流量管理
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end
						sleep @tc_wait_time #流量管理界面响应较慢，增加延迟
						#打开流量控制
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end
						sleep @tc_wait_time #流量管理界面响应较慢，增加延迟
						####开启总开关
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
						####设置总带宽
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
				}

				operate("2、假设当前LAN口地址为192.168.100.1，设置规则1地址段为192.168,100.2到192.168,100.2") {
						#设置规则1，流量控制的IP,设置ip范围
						puts "rule 1 ip start ip #{@tc_rule1_ip1},end ip #{@tc_rule1_ip2}"
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_rule1_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_rule1_ip2)
						#选择受限最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_rule_time

						puts "rule 2 ip start ip #{@tc_rule2_ip1},end ip #{@tc_rule2_ip2}"
						#设置规则2，流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_rule2_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_rule2_ip2)
						#选择受限最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(:id, @ts_tag_band_err)
						assert(error_tip.exists?, "错误提示信息未出现!")
						puts "ERROR TIP :#{error_tip.text}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip.text, "提示信息内容错误!")
				}

				operate("3、设置规则2地址段也为192.168,100.2到192.168,100.2，是否能设置成功") {
						#删除规则2
						@advance_iframe.td(text: "2").parent.tds[5].link.click
						#设置规则1，流量控制的IP,设置ip范围
						puts "rule 1 ip start ip #{@tc_rule1_ip1},end ip #{@tc_rule1_ip2}"
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_rule1_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_rule1_ip2)
						sleep @tc_rule_time
						#选择受限最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_rule_time
						
						puts "rule 3 ip start ip #{@tc_rule3_ip1},end ip #{@tc_rule3_ip2}"
						#设置规则3，流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min3).set(@tc_rule3_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max3).set(@tc_rule3_ip2)
						sleep @tc_rule_time
						#选择受限最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode3)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size3).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(:id, @ts_tag_band_err)
						assert(error_tip.exists?, "错误提示信息未出现!")
						puts "ERROR TIP :#{error_tip.text}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip.text, "提示信息内容错误!")
				}

				operate("4、重新设置规则1地址段为192.168,100.2到192.168,100.3，设置规则2地址段为192.168,100.3到192.168,100.4，是否能设置成功") {
						#删除规则3
						@advance_iframe.td(text: "3").parent.tds[5].link.click
						#设置规则1，流量控制的IP,设置ip范围
						puts "rule 1 ip start ip #{@tc_rule1_ip1},end ip #{@tc_rule1_ip2}"
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_rule1_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_rule1_ip2)
						sleep @tc_rule_time
						#选择受限最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_rule_time

						puts "rule 5 ip start ip #{@tc_rule5_ip1},end ip #{@tc_rule5_ip2}"
						#设置规则5，流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min5).set(@tc_rule5_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max5).set(@tc_rule5_ip2)
						#选择受限最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode5)
						mode_select.select(@ts_tag_bandlimit)
						sleep @tc_rule_time
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size5).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(:id, @ts_tag_band_err)
						assert(error_tip.exists?, "错误提示信息未出现!")
						puts "ERROR TIP :#{error_tip.text}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip.text, "提示信息内容错误!")
				}


		end

		def clearup

				operate("删除带宽控制配置") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

						#打开流量管理
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end

						#打开流量控制
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end

						#删除规则1，2，3，5
						@advance_iframe.td(text: "1").parent.tds[5].link.click
						@advance_iframe.td(text: "2").parent.tds[5].link.click
						@advance_iframe.td(text: "3").parent.tds[5].link.click
						@advance_iframe.td(text: "5").parent.tds[5].link.click

						####关闭总开关
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						if qos_sw.checked?
								qos_sw.click
								#提交
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_qos_time
						end
				}
		end

}
