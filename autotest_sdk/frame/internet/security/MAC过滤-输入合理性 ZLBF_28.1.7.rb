#
# description:
# 用例应 验证格式和及内容由0-9，A-F就可以，无需验证MAC地址类别
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_28.1.7", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time  = 2
				@tc_filter_time= 2
				@tc_mac_error  = "MAC地址格式错误"
				@tc_mac_desc   = "test"
		end

		def process

				operate("1、AP工作在路由方式下，输入MAC地址包含~!@#$%^&*()_+{}|:\"<>?等键盘上33个特殊字符,查看是否允许输入保存；") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "打开WAN状态失败！")
						lanmac_info = @status_iframe.b(:id => @ts_tag_lan_mac).parent.text
						lanmac_info =~ /(\w{2}:\w{2}:\w{2}:\w{2}:\w{2}:\w{2})/
						@tc_lanmac = Regexp.last_match(1)
						puts "LAN MAC #{@tc_lanmac}"

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择安全设置
						security_set = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#选择防火墙设置
						fwset      = @advance_iframe.link(id: @ts_tag_fwset)
						fwset_state= fwset.parent.class_name
						unless fwset_state==@ts_tag_liclass
								fwset.click
						end

						#打开总开关
						fw_switch = @advance_iframe.button(id: @ts_tag_security_sw, class_name: @ts_tag_btn_off)
						if fw_switch.exists?
								fw_switch.click
						end

						#打开mac过滤开关
						mac_switch = @advance_iframe.button(id: @ts_tag_security_mac, class_name: @ts_tag_btn_off)
						if mac_switch.exists?
								mac_switch.click
						end

						#保存
						@advance_iframe.button(id: @ts_tag_security_save).click
						sleep @tc_filter_time

						#打开MAC过滤设置
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end
						fwstatus = @advance_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fwstatus, "防火墙总开关打开失败")
						mac_status = @advance_iframe.span(id: @ts_tag_fwmac).text
						assert_equal(@ts_tag_fw_open, mac_status, "MAC过滤开关打开失败")

						#添加有线客户端过滤条件
						tc_mac1 = ""
						puts "MAC未输入".encode("GBK")
						@advance_iframe.span(id: @ts_tag_additem).click
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac1)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

						#添加有线客户端过滤条件
						tc_mac1 = "$@#"
						puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac1)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

						#添加有线客户端过滤条件
						tc_mac2 = "00:@@:22:33:44:55"
						puts "添加MAC #{tc_mac2}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac2}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac2)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

						#添加有线客户端过滤条件,特殊符号
						tc_mac3 = "00:@@:22:33:44:55"
						puts "添加MAC #{tc_mac3}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac2}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac3)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

						#添加有线客户端过滤条件,字母
						tc_mac4 = "00:11:GG:33:44:55"
						puts "添加MAC #{tc_mac4}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac2}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac4)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

						#添加有线客户端过滤条件,空格
						tc_mac5 = "00:11:22:  :44:55"
						puts "添加MAC #{tc_mac5}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac2}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac5)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
				}

				operate("2、输入MAC地址：00:00:00:00:00:00，查看是否允许输入保存；") {
						#添加有线客户端过滤条件,空格
						tc_mac1 = "00:00:00:00:00:00"
						puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac1}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac1)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
				}

				operate("3、输入MAC地址：FF:FF:FF:FF:FF:FF，查看是否允许输入保存；") {
						#添加有线客户端过滤条件,空格
						tc_mac1 = "FF:FF:FF:FF:FF:FF"
						puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac1}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac1)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
				}

				# operate("4、输入MAC地址：0x:00:00:00:00:01,x=1,3,5,7,9,a,c,f，查看是否允许输入保存；") {		}
				# operate("5、输入MAC地址以01:00:5e开头的MAC地址，如：01:00:5e:00:00:01,查看是否允许输入保存；") {
				# }

				operate("6、输入MAC地址：90:AB:CD:EF:ab:cf，查看是否允许输入保存；") {
						#添加有线客户端过滤条件,空格
						tc_mac1 = "90:AB:CD:EF:ab:cf"
						puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac1}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac1)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						# assert(error_tip.exists?, "未提示MAC地址格式错误")
						#保存成功
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_empty(error_tip.text, "设置正确MAC却提示失败")
				}

				# operate("7、输入MAC地址与AP的LAN MAC或WLAN接口地址一致的地址，查看是否允许输入保存；") {
				#添加有线客户端过滤条件,LAN MAC
				#用例预期结果不明不实现
				# puts "添加LAN MAC #{@tc_lanmac}为过滤条件".encode("GBK")
				# @advance_iframe.span(id: @ts_tag_additem).click
				# @advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(@tc_lanmac)
				# sleep @tc_wait_time
				# @advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
				# select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
				# #设置为生效
				# unless select_list.selected?(@ts_tag_filter_use)
				# 		select_list.select(/#{@ts_tag_filter_use}/)
				# end
				#
				# #保存mac过滤条件
				# @advance_iframe.button(id: @ts_tag_save_filter).click
				# sleep @tc_filter_time
				# error_tip = @advance_iframe.p(id: @ts_tag_band_err)
				# assert(error_tip.exists?, "未提示MAC地址格式错误")
				# puts "ERROR TIP:#{error_tip.text}".encode("GBK")
				# assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
				# }

				# operate("8、输入MAC地址：00-AB-CD-EF-ab-cf格式地址，查看是否允许输入保存；") {
				# 		#不支持，这种输入，用例应该限定要支持还是不要支持
				# }

				# operate("9、输入MAC地址：00ABCDEFabcf格式地址，查看是否允许输入保存；") {
				# 		#不支持，这种输入，用例应该限定要支持还是不要支持
				# }

				operate("10、输入MAC地址：00-AB-CD-EF-ab-cg,00-AB-CD-EF-ab-cG,00-AB-CD-EF-ab-cff,00-AB-CD-EF-ab-c,查看是否允许输入保存；") {
						#xx:yy:xx:yy:xx
						tc_mac1 = "02:11:22:33:44"
						puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
						@advance_iframe.span(id: @ts_tag_additem).click
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac1)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

						#xx:yy:xx:yy:xx:yy:zz
						tc_mac2 = "02:11:22:33:44:55:66"
						puts "添加MAC #{tc_mac2}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac2}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac2)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

						#x:yy:xx:yy:xx:yy:
						tc_mac3 = "0:11:22:33:44:55"
						puts "添加MAC #{tc_mac3}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac3}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac3)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

						#xx:yyx:xx:yy:xx:yy
						tc_mac4 = "00:111:22:33:44:55"
						puts "添加MAC #{tc_mac4}为过滤条件".encode("GBK")
						add_mac = @advance_iframe.text_field(id: @ts_tag_fwmac_mac).exists?
						assert(add_mac, "添加MAC #{tc_mac4}时，未找到设置框")
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac4)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end

						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "未提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
				}


		end

		def clearup

				operate("1、恢复防火墙默认设置") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						#选择安全设置
						security_set    = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#选择防火墙设置
						fwset      = @advance_iframe.link(id: @ts_tag_fwset)
						fwset_state= fwset.parent.class_name
						unless fwset_state==@ts_tag_liclass
								fwset.click
						end

						#关闭总开关
						fw_switch = @advance_iframe.button(id: @ts_tag_security_sw, class_name: @ts_tag_btn_on)
						if fw_switch.exists?
								fw_switch.click
						end

						#关闭mac过滤开关
						mac_switch = @advance_iframe.button(id: @ts_tag_security_mac, class_name: @ts_tag_btn_on)
						if mac_switch.exists?
								mac_switch.click
						end

						#保存
						@advance_iframe.button(id: @ts_tag_security_save).click
						sleep @tc_filter_time

						#打开mac过滤设置
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end
						#删除所有过滤规则
						@advance_iframe.span(id: @ts_tag_alldel).click
						sleep @tc_wait_time
				}

		end

}
