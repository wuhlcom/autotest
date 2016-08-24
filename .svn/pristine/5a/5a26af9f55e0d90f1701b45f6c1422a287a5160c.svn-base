#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.12", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time    = 3
				@tc_clone_time   = 40
				@tc_reboot_time  = 120
				@tc_relogin_time = 60
		end

		def process

				operate("1、登录DUT，设置WAN接入为DHCPC方式；") {
						@browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_netset).click #外网
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						flag        = false
						#设置wan连接方式为网线连接
						rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
						unless rs1 =~/ #{@ts_tag_select_state}/
								@wan_iframe.span(id: @ts_tag_wired_mode_span).click #网线连接
								flag = true
						end
						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						#设置WIRE WAN为DHCP模式
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end
						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
						end
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、选择“使用计算机MAC地址”克隆，保存；") {
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						#网络设置
						network_set = @option_iframe.link(id: @ts_tag_op_network)
						network_set.wait_until_present(@tc_wait_time)
						network_set.click
						#MAC克隆
						@option_iframe.link(id: @ts_tag_clone_mac).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_clone_mac).click
						clone_sw = @option_iframe.button(id: @ts_tag_clone_sw)
						clone_sw.wait_until_present(@tc_wait_time)
						#打开克隆开关
						if clone_sw.class_name == "off"
								clone_sw.click
						end
						#点击克隆MAC
						mac_clone = @option_iframe.button(id: @ts_tag_fillmac)
						mac_clone.click
						#提交克隆
						@option_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_clone_time
				}

				operate("3、复位DUT到默认配置状态；") {
						@option_iframe.link(id: @ts_tag_op_system).click #系统设置
						recover_sys = @option_iframe.link(id: @ts_tag_recover)
						recover_sys.wait_until_present(@tc_wait_time)
						recover_sys.click
						#点击恢复出厂设置
						recover_btn = @option_iframe.button(id: @ts_tag_reset_factory)
						recover_btn.wait_until_present(@tc_wait_time)
						recover_btn.click
						#确认恢复出厂
						@option_iframe.button(class_name: @ts_tag_reboot_confirm).click
						sleep @tc_reboot_time
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "复位后路由器后未跳转到登录页面!"
						login_no_default_ip(@browser) #重新登录
				}

				operate("4、查看DUT的DHCP配置是否被复位到默认状态；") {
						@browser.span(id: @tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @tag_status).click
						@state_iframe = @browser.iframe(src: @tag_status_iframe_src)
						assert(@state_iframe.exists?, "打开状态设置失败！")
						sleep @tc_wait_time
						wan_type = @state_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
						assert_equal(@ts_wan_mode_dhcp, wan_type,"DHCP配置未恢复默认！")
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						#打开网络设置
						network_set = @option_iframe.link(id: @ts_tag_op_network)
						network_set.click
						#查看MAC克隆开关状态
						@option_iframe.link(id: @ts_tag_clone_mac).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_clone_mac).click
						clone_sw = @option_iframe.button(id: @ts_tag_clone_sw)
						clone_sw.wait_until_present(@tc_wait_time)
						assert(clone_sw.class_name == "off", "mac克隆未恢复默认配置！")
				}


		end

		def clearup
				operate("恢复默认配置") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						@option_iframe.link(id: @ts_tag_clone_mac).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_clone_mac).click
						clone_sw = @option_iframe.button(id: @ts_tag_clone_sw)
						clone_sw.wait_until_present(@tc_wait_time)
						if clone_sw.class_name == "on"
								clone_sw.click
								@option_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_clone_time
						end
				}
		end

}
