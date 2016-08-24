#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.26", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_lease_error  = "租约时间范围为60-43200"
				@tc_lease_time1  = "0"
				@tc_lease_time2  = "59"
				@tc_lease_time3  = "60" #边界值
				@tc_lease_time4  = "1800" #等价值
				@tc_lease_time5  = "43200" #边界值
				@tc_lease_time6  = "43201"
				@tc_netwait_time = 60
				@tc_sleep_time   = 1 #连续配置相同位置有时无法配置成功
		end

		def process

				operate("1、登陆路由器进入内网设置") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")
				}

				operate("2、更改租约时长输入0秒，59秒，60秒，43200秒，43201秒，43300秒；") {
						puts "修改租期为#{@tc_lease_time1}".encode("GBK")
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time1)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_lease_error, error_info, "未提示租约时间范围")

						puts "修改租期为#{@tc_lease_time2}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time2)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_lease_error, error_info, "未提示租约时间范围")

						puts "修改租期为#{@tc_lease_time3}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time3)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_netwait_time
						rs1 = @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value
						puts "Lease Time :#{rs1}".encode("GBK")
						assert_equal(@tc_lease_time3, rs1, "设置租约时间为#{@tc_lease_time3}失败")

						puts "修改租期为#{@tc_lease_time4}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time4)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_netwait_time
						rs1 = @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value
						puts "Lease Time :#{rs1}".encode("GBK")
						assert_equal(@tc_lease_time4, rs1, "设置租约时间为#{@tc_lease_time4}失败")

						puts "修改租期为#{@tc_lease_time5}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time5)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_netwait_time
						rs1 = @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value
						puts "Lease Time :#{rs1}".encode("GBK")
						assert_equal(@tc_lease_time5, rs1, "设置租约时间为#{@tc_lease_time5}失败")

						puts "修改租期为#{@tc_lease_time6}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time6)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_lease_error, error_info, "未提示租约时间范围")
				}

				operate("3、点击保存") {

				}


		end

		def clearup

		end

}
