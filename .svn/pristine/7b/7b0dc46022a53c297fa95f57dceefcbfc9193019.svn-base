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
				@tc_qos_time         = 3
				@tc_wait_time = 5
				@tc_bandwidth_err    = "保障带宽总和不能大于申请带宽"
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

				operate("2、假设当前LAN口地址为192.168.100.1，设置规则1地址段为192.168,100.2到192.168,100.2，规则为保障最小带宽，带宽为800kbps；设置规则2地址段为192.168,100.3到192.168,100.3，规则为保障最小带宽，带宽为400kbps，点击保存") {
						#设置规则1，流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_qos_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_qos_ip1)
						#选择保障最小宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandensure)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit1)

						#设置规则2，流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_qos_ip2)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_qos_ip2)
						#选择保障最小宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandensure)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit2)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
						error_tip = @advance_iframe.span(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示错误信息")
						puts "ERROR TIP : #{error_tip.text}".encode("GBK")
						assert_equal(@tc_bandwidth_err, error_tip.text, "提示信息内容错误")
				}


		end

		def clearup
				operate("1 删除qos配置") {
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

						#删除规则1
						@advance_iframe.td(text: "1").parent.tds[5].link.click
						#删除规则2
						@advance_iframe.td(text: "2").parent.tds[5].link.click

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
