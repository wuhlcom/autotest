#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.39", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_clonemac_tip = "请输入正确的MAC地址"
				@tc_wait_time    = 2
				@tc_net_time     = 30
		end

		def process

				operate("1、登录路由器,打开MAC克隆界面") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择网络设置
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#选择mac克隆
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end

						#打开克隆开关
						clone_switch = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_off)
						#clone_switch.enabled?
						if clone_switch.exists?
								clone_switch.click
						end
						clone_switch_on = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						assert(clone_switch_on.exists?, "克隆开关未打开!")
				}

				operate("2、输入MAC地址：00:00:00:00:00:00，查看是否允许输入保存；") {
						tc_mac = "00:00:00:00:00:00"
						puts "Clone MAC address: #{tc_mac}"
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(id: @ts_tag_errormsg)
						assert(error_tip.exists?, "未提示出错")
						@tc_error = error_tip.text
						puts "ERROR TIP:#{@tc_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, @tc_error, "提示内容错误!")
				}

				operate("3、输入MAC地址：FF:FF:FF:FF:FF:FF，查看是否允许输入保存；") {
						tc_mac = "FF:FF:FF:FF:FF:FF"
						puts "Clone MAC address: #{tc_mac}"
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(id: @ts_tag_errormsg)
						assert(error_tip.exists?, "未提示出错")
						@tc_error = error_tip.text
						puts "ERROR TIP:#{@tc_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, @tc_error, "提示内容错误!")
				}

				operate("4、输入MAC地址以01:00:5e开头的MAC地址，如：01:00:5e:00:00:01,查看是否允许输入保存；") {
						tc_mac = "01:00:5e:00:00:01"
						puts "Clone MAC address: #{tc_mac}"
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(id: @ts_tag_errormsg)
						assert(error_tip.exists?, "未提示出错")
						@tc_error = error_tip.text
						puts "ERROR TIP:#{@tc_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, @tc_error, "提示内容错误!")
				}

				operate("5、输入MAC地址为空，查看是否允许输入保存；") {
						tc_mac = ""
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(id: @ts_tag_errormsg)
						assert(error_tip.exists?, "未提示出错")
						@tc_error = error_tip.text
						puts "ERROR TIP:#{@tc_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, @tc_error, "提示内容错误!")
				}

				operate("6、输入MAC地址含有特殊符号，查看是否允许输入保存；") {
						tc_mac = "00:@F:5e:00:00:01"
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(id: @ts_tag_errormsg)
						assert(error_tip.exists?, "未提示出错")
						@tc_error = error_tip.text
						puts "ERROR TIP:#{@tc_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, @tc_error, "提示内容错误!")
				}

				operate("7、输入MAC地址含有非16进制字母G，查看是否允许输入保存；") {
						tc_mac = "00:33:5G:00:00:01"
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(id: @ts_tag_errormsg)
						assert(error_tip.exists?, "未提示出错")
						@tc_error = error_tip.text
						puts "ERROR TIP:#{@tc_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, @tc_error, "提示内容错误!")
				}

				operate("8、输入MAC地址有非16进制字母Z，查看是否允许输入保存；") {
						tc_mac = "00:33:5E:1Z:00:01"
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(id: @ts_tag_errormsg)
						assert(error_tip.exists?, "未提示出错")
						@tc_error = error_tip.text
						puts "ERROR TIP:#{@tc_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, @tc_error, "提示内容错误!")
				}

				operate("9、输入MAC地址格式有缺失，查看是否允许输入保存；") {
						tc_mac = "00:33:5E:10:0:01"
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(id: @ts_tag_errormsg)
						assert(error_tip.exists?, "未提示出错")
						@tc_error = error_tip.text
						puts "ERROR TIP:#{@tc_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, @tc_error, "提示内容错误!")
				}

				operate("10、输入MAC地址格式不正确，查看是否允许输入保存；") {
						tc_mac = "00:33:5E:10:00:001"
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(id: @ts_tag_errormsg)
						assert(error_tip.exists?, "未提示出错")
						@tc_error = error_tip.text
						puts "ERROR TIP:#{@tc_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, @tc_error, "提示内容错误!")
				}

				operate("11、输入MAC地址包含大小写：90:AB:CD:EF:ab:cf，查看是否允许输入保存；") {
						tc_mac = "90:AB:CD:EF:ab:cf"
						puts "Clone MAC address: #{tc_mac}"
						#克隆地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(tc_mac)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
						#查看克隆后mac地址信息
						@browser.refresh
						system_ver = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						@ts_wan_mac_pattern1 =~system_ver
						@tc_wan_mac = Regexp.last_match(1)
						puts "Current WAN MAC :#{@tc_wan_mac}".encode("GBK")
						assert_equal(tc_mac.upcase, @tc_wan_mac, "WAN MAC与设置的克隆MAC不一致,克隆失败!")
				}


		end

		def clearup
				operate("1 取消克隆") {
						#如果配置错误的MAC保存成功了，就会重启网络，重启网络需要等待路由器起来
						#这里增加等待
						unless @tc_error.nil? || @tc_error.empty?
								puts "等待网络重启...".encode("GBK")
								sleep @tc_net_time
						end

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

						#选择网络设置
						networking      = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#选择mac克隆
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end

						#关闭克隆开关
						clone_switch = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						clone_switch.exists?
						if clone_switch.exists?
								clone_switch.click
								@advance_iframe.button(id: @ts_tag_sbm).click
								puts "waiting for net resting..."
								sleep @tc_net_time #修改mac后要重启网络，等待网络重启
						end
				}
		end

}
