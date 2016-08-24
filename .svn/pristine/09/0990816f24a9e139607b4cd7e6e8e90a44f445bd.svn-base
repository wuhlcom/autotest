#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.13", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_sleep_time = 1
				@tc_error_ip_format   = "DHCP地址格式有误"
		end

		def process

				operate("1、登陆路由器进入内网设置") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")
				}

				operate("2、更改DHCP地址池输入中文和英文；") {
						#获取默认的起始地址和结束地址
						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						current_startip  = tc_startip_field.value
						sleep @tc_sleep_time
						tc_endip_field   = @lan_iframe.text_field(id: @ts_tag_lanend)
						current_endip    = tc_endip_field.value
						ip_arr           = current_startip.split(".")
						ip_arr_clone1    = ip_arr.clone
						ip_arr_clone2    = ip_arr.clone
						ip_arr_clone3    = ip_arr.clone
						puts "LAN DHCP Server pool start ip:#{current_startip}"
						puts "LAN DHCP Server pool end ip:#{current_endip}"

						puts "地址输入中文".encode("GBK")
						address_ch = "测试中文"
						puts "修改起始IP为：#{address_ch}".encode("GBK")
						sleep @tc_sleep_time
						#修改起始地址池范围
						tc_startip_field.set(address_ch)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						sleep @tc_sleep_time #增加一秒延迟
						#修改结束地址池范围
						puts "修改结束IP为：#{address_ch}".encode("GBK")
						tc_startip_field.set(current_startip)
						tc_endip_field.set(address_ch)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						#################################################################################
						puts "IP地址输入英文".encode("GBK")
						address_en = "IP Address"
						puts "修改起始IP为：#{address_en}".encode("GBK")
						#修改起始地址池范围
						sleep @tc_sleep_time #增加一秒延迟
						tc_startip_field.set(address_en)
						tc_endip_field.set(current_endip)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{address_en}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						tc_startip_field.set(current_startip)
						tc_endip_field.set(address_en)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
				}

				operate("3、点击保存") {
						#第二步已经实现
				}


		end

		def clearup

		end

}
