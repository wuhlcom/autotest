#
# description:
# 产品问题:租约可以输入60@等数字开头+特殊符号的租约
# author:wuhongliang
# date:2015-10-29 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.27", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_lease_time1 = "60@"
				@tc_lease_time2 = "!823"
				@tc_lease_time3 = "*****"
				@tc_lease_error = "租用时间只能是正整数"#"租约时间范围为60-43200"
				@tc_net_time    = 30
				@tc_sleep_time  = 2
		end

		def process

				operate("1、登陆路由器进入内网设置") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")
				}

				operate("2、更改租约时长输入特殊字符；") {
						puts "修改租期为#{@tc_lease_time1}".encode("GBK")
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time1)
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time1) unless @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value == @tc_lease_time1
						@lan_iframe.button(id: @ts_tag_sbm).click
						@error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{@error_info}".encode("GBK")
						assert_equal(@tc_lease_error, @error_info, "未提示租约时间范围错误")

						puts "修改租期为#{@tc_lease_time2}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time2)
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time2) unless @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value == @tc_lease_time2
						@lan_iframe.button(id: @ts_tag_sbm).click
						@error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{@error_info}".encode("GBK")
						assert_equal(@tc_lease_error, @error_info, "未提示租约时间范围错误")

						puts "修改租期为#{@tc_lease_time3}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time3)
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time3) unless @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value == @tc_lease_time3
						@lan_iframe.button(id: @ts_tag_sbm).click
						@error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{@error_info}".encode("GBK")
						assert_equal(@tc_lease_error, @error_info, "未提示租约时间范围错误")
				}

				operate("3、点击保存") {
						#第二步已实现
				}


		end

		def clearup
				operate("1 增加非法输入也能保存的异常处理") {
						if !@error_info.nil? && @error_info.empty?
								puts "sleep #{@tc_net_time} for net reseting..."
								sleep @tc_net_time
						end
				}
		end

}
