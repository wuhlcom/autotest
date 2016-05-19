#
# description:
# 当要操作同一个tag多次时，每次需要重新定位一下这个tag
# author:wuhongliang
# date:2015-11-05 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.12", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_sleep_time        = 1
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

				operate("2、更改DHCP地址如：192.168.0，19216811， 192.168.101，192168.10.10，192.168-1.10；") {
						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						current_startip  = tc_startip_field.value
						tc_endip_field   = @lan_iframe.text_field(id: @ts_tag_lanend)
						current_endip    = tc_endip_field.value
						ip_arr           = current_startip.split(".")
						ip_arr_clone1    = ip_arr.clone
						ip_arr_clone2    = ip_arr.clone
						ip_arr_clone3    = ip_arr.clone
						ip_arr_clone4    = ip_arr.clone
						ip_arr_clone5    = ip_arr.clone
						puts "LAN DHCP Server pool start ip:#{current_startip}"
						puts "LAN DHCP Server pool end ip:#{current_endip}"

						puts "修改ip地址第一个分段为非法地址224，使地址池与dhcp服务器不在同网段".encode("GBK")
						not_same_seg_ip = current_startip.sub(/\d+\./, "224.")
						puts "修改起始IP为：#{not_same_seg_ip}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						#修改起始地址池范围
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(not_same_seg_ip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(not_same_seg_ip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == not_same_seg_ip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{not_same_seg_ip}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == current_startip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(not_same_seg_ip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(not_same_seg_ip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == not_same_seg_ip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						#################################################################################
						puts "修改ip地址第一个分段为非法地址0，使地址池与dhcp服务器不在同网段".encode("GBK")
						not_same_seg_ip = current_startip.sub(/\d+\./, "0.")
						puts "修改起始IP为：#{not_same_seg_ip}".encode("GBK")
						#修改起始地址池范围
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(not_same_seg_ip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(not_same_seg_ip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == not_same_seg_ip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{not_same_seg_ip}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == current_startip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(not_same_seg_ip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(not_same_seg_ip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == not_same_seg_ip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						###########################################################################################################
						puts "修改ip地址第二个分段为非法地址，使地址池与dhcp服务器不在同网段".encode("GBK")
						ip_arr_clone1[1] = "256"
						ip_new1          = ip_arr_clone1.join(".")
						puts "修改起始IP为：#{ip_new1}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						#修改起始地址池范围
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new1)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new1) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == ip_new1
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{ip_new1}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == current_startip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new1)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new1) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == ip_new1
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						##############################################################################################################
						puts "修改ip地址第三个分段为非法地址，使地址池与dhcp服务器不在同网段".encode("GBK")
						ip_arr_clone2[2] = "256"
						ip_new2          = ip_arr_clone2.join(".")
						puts "修改起始IP为：#{ip_new2}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						#修改起始地址池范围
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new2)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new2) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == ip_new2
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{ip_new2}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == current_startip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new2)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new2) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == ip_new2
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						#################################################################################################################
						p "起始ip为最后一个分段为0".encode("GBK")
						start_ip = current_startip.sub(/\d+$/, "0")
						puts "修改起始IP为：#{start_ip}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(start_ip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(start_ip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == start_ip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						##############################################################################
						p "结束ip为最后一个分段为255".encode("GBK")
						end_ip = current_startip.sub(/\d+$/, "255")
						puts "修改结束IP为：#{end_ip}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == current_startip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(end_ip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(end_ip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == end_ip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")
						#############################################################################
						p "修改ip地址第一个分段，使地址池与dhcp服务器不在同网段".encode("GBK")
						num              = rand_not_spec_less(0, ip_arr[0].to_i, 223)
						ip_arr_clone3[0] = num
						ip_new3          = ip_arr_clone3.join(".")
						puts "修改起始IP为：#{ip_new3}".encode("GBK")
						#修改起始地址池范围
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new3)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new3) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == ip_new3
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_not_same_seg, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{ip_new3}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == current_startip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new3)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new3) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == ip_new3
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_not_same_seg, error_info, "地址池设置错误提示内容不正确")
						##########################################################################################
						p "修改ip地址第二个分段，使地址池与dhcp服务器不在同网段".encode("GBK")
						num              = rand_not_spec_less(0, ip_arr[1].to_i, 254)
						ip_arr_clone4[1] = num
						ip_new4          = ip_arr_clone4.join(".")
						puts "修改起始IP为：#{ip_new4}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						#修改起始地址池范围
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new4)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new4) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == ip_new4
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_not_same_seg, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{ip_new4}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == current_startip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new4)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new4) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == ip_new4
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_not_same_seg, error_info, "地址池设置错误提示内容不正确")
						###########################################################################
						p "修改ip地址第三个分段，使地址池与dhcp服务器不在同网段".encode("GBK")
						num              = rand_not_spec_less(0, ip_arr[2].to_i, 254)
						ip_arr_clone5[2] = num
						ip_new5          = ip_arr_clone5.join(".")
						puts "修改起始IP为：#{ip_new5}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						#修改起始地址池范围
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new5)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(ip_new5) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == ip_new5
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_not_same_seg, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{ip_new5}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == current_startip
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new5)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(ip_new5) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == ip_new5
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_not_same_seg, error_info, "地址池设置错误提示内容不正确")
						#####################################################
						p "只输入一个分段的地址".encode("GBK")
						current_startip =~/(\d+)\./
						error_one_ip1 = Regexp.last_match(1)
						puts "修改起始IP为：#{error_one_ip1}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						#修改起始地址池范围
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(error_one_ip1)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(error_one_ip1) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == error_one_ip1
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{error_one_ip1}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						#如果设置起IP地址失败就多设置几次，最多三次
						3.times do
								break if @lan_iframe.text_field(id: @ts_tag_lanstart)!= ""
								@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						end
						@lan_iframe.text_field(id: @ts_tag_lanend).set(error_one_ip1)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(error_one_ip1) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == error_one_ip1
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						p "只有三个分段的地址".encode("GBK")
						current_startip =~/(\d+\.\d+\.\d+)/
						error_three_ip1 = Regexp.last_match(1)
						puts "修改起始IP为：#{error_three_ip1}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						#修改起始地址池范围
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(error_three_ip1)
						#如果设置起IP地址失败就多设置几次，最多三次
						3.times do
								break if @lan_iframe.text_field(id: @ts_tag_lanstart) != ""
								@lan_iframe.text_field(id: @ts_tag_lanstart).set(error_three_ip1)
						end
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为：#{error_three_ip1}".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						#如果设置起IP地址失败就多设置几次，最多三次
						3.times do
								break if @lan_iframe.text_field(id: @ts_tag_lanstart) != ""
								@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						end
						@lan_iframe.text_field(id: @ts_tag_lanend).set(error_three_ip1)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(error_three_ip1) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == error_three_ip1
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "地址池设置错误提示内容不正确")

						p "IP地址为空".encode("GBK")
						empty = ""
						puts "修改起始IP为空".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						#修改起始地址池范围
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(empty)
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(empty) unless @lan_iframe.text_field(id: @ts_tag_lanstart).value == empty
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(current_endip) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_no_startip, error_info, "地址池设置错误提示内容不正确")

						#修改结束地址池范围
						puts "修改结束IP为空".encode("GBK")
						sleep @tc_sleep_time #增加一秒延迟
						@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						#如果设置起IP地址失败就多设置几次，最多三次
						3.times do
								break if @lan_iframe.text_field(id: @ts_tag_lanstart)!= ""
								@lan_iframe.text_field(id: @ts_tag_lanstart).set(current_startip)
						end
						@lan_iframe.text_field(id: @ts_tag_lanend).set(empty)
						@lan_iframe.text_field(id: @ts_tag_lanend).set(empty) unless @lan_iframe.text_field(id: @ts_tag_lanend).value == empty
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_no_endip, error_info, "地址池设置错误提示内容不正确")

				}

				operate("3、点击保存") {

				}


		end

		def clearup

		end

}
