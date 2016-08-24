#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.14", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_error_no_startip  = "请输入DHCP开始地址"
				@tc_error_no_endip    = "请输入DHCP结束地址"
				@tc_error_not_same_seg= "DHCP地址和局域网IP不在同一网段"
				@tc_error_ip_format   = "DHCP地址格式有误"
		end

		def process

				operate("1、登陆路由器进入内网设置") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")
				}

				operate("2、更改DHCP地址池输入特殊字符；") {
						#获取默认的起始地址和结束地址
						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						current_startip  = tc_startip_field.value
						tc_endip_field   = @lan_iframe.text_field(id: @ts_tag_lanend)
						current_endip    = tc_endip_field.value
						ip_arr           = current_startip.split(".")
						ip_arr_clone1    = ip_arr.clone
						ip_arr_clone2    = ip_arr.clone
						ip_arr_clone3    = ip_arr.clone
						puts "LAN DHCP Server pool start ip:#{current_startip}"
						puts "LAN DHCP Server pool end ip:#{current_endip}"

						puts "输入特殊字符-".encode("GBK")
						ip_new1 = current_startip.sub(".", "-")
						puts "修改起始IP为：#{ip_new1}".encode("GBK")
						#修改起始地址池范围
						tc_startip_field.set(ip_new1)
						tc_startip_field.set(ip_new1) unless tc_startip_field.value == ip_new1
						tc_endip_field.set(current_endip)
						tc_endip_field.set(current_endip) unless tc_endip_field.value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{ip_new1}".encode("GBK")
						tc_startip_field.set(current_startip)
						tc_startip_field.set(current_startip) unless tc_startip_field.value == current_startip
						tc_endip_field.set(ip_new1)
						tc_endip_field.set(ip_new1) unless tc_endip_field.value == ip_new1
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						##############################################################################################################
						puts "修改IP地址格式x..x.x.x".encode("GBK")
						ip_new2 = ip_arr_clone2[0]+".."+ip_arr_clone2[1]+"."+ip_arr_clone2[2]+"."+ip_arr_clone2[3]
						puts "修改起始IP为：#{ip_new2}".encode("GBK")
						#修改起始地址池范围
						tc_startip_field.set(ip_new2)
						tc_startip_field.set(ip_new2) unless tc_startip_field.value == ip_new2
						tc_endip_field.set(current_endip)
						tc_endip_field.set(current_endip) unless tc_endip_field.value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{ip_new2}".encode("GBK")
						tc_startip_field.set(current_startip)
						tc_startip_field.set(current_startip) unless tc_startip_field.value == current_startip
						tc_endip_field.set(ip_new2)
						tc_endip_field.set(ip_new2) unless tc_endip_field.value == ip_new2
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						#################################################################################################################
						p "修改IP地址格为x.x.x-x".encode("GBK")
						ip_new3 = ip_arr_clone3[0]+"."+ip_arr_clone3[1]+"."+ip_arr_clone3[2]+"-"+ip_arr_clone3[3]
						puts "修改起始IP为：#{ip_new3}".encode("GBK")
						tc_startip_field.set(ip_new3)
						tc_startip_field.set(ip_new3) unless tc_startip_field.value == ip_new3
						tc_endip_field.set(current_endip)
						tc_endip_field.set(current_endip) unless tc_endip_field.value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")


						puts "修改结束IP为：#{ip_new3}".encode("GBK")
						tc_startip_field.set(current_startip)
						tc_startip_field.set(current_startip) unless tc_startip_field.value == current_startip
						tc_endip_field.set(ip_new3)
						tc_endip_field.set(ip_new3) unless tc_endip_field.value == ip_new3
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						#############################################################################
						p "修改IP地址格式为x.x.x.@".encode("GBK")
						ip_new4 = ip_arr_clone3[0]+"."+ip_arr_clone3[1]+"."+ip_arr_clone3[2]+"-"+ip_arr_clone3[3]
						puts "修改起始IP为：#{ip_new4}".encode("GBK")
						#修改起始地址池范围
						tc_startip_field.set(ip_new4)
						tc_startip_field.set(ip_new4) unless tc_startip_field.value == ip_new4
						tc_endip_field.set(current_endip)
						tc_endip_field.set(current_endip) unless tc_endip_field.value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{ip_new4}".encode("GBK")
						tc_startip_field.set(current_startip)
						tc_startip_field.set(current_startip) unless tc_startip_field.value == current_startip
						tc_endip_field.set(ip_new4)
						tc_endip_field.set(ip_new4) unless tc_endip_field.value == ip_new4
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						##########################################################################################
				}

				operate("3、点击保存") {

				}


		end

		def clearup

		end

}
