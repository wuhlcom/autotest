#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.7", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_net_time   = "60"
				@tc_error_info = "IP 设置有误，WAN口和LAN口不允许在同一网段"
		end

		def process

				operate("1、登陆路由器进入内网设置；") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "打开WAN状态失败！")
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_ip   = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_ip=~@ts_tag_ip_regxp
						@tc_wan_ip = Regexp.last_match(1)
						#先判断是否为dhcp模式如果不是则设置为dhcp模式
						unless wan_type=~/#{@ts_wan_mode_dhcp}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end

								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert_match(@wan_iframe.exists?, '打开外网设置失败！')

								rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
								unless rs1=~/#{@ts_tag_select_state}/
										@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								end

								#如果不是dhcp接入就先设置为dhcp接入
								dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
								dhcp_radio_state = dhcp_radio.checked?
								unless dhcp_radio_state
										dhcp_radio.click
										@wan_iframe.button(:id, @ts_tag_sbm).click
										sleep @tc_net_time
								end
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end

								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, "打开WAN状态失败！")
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
								wan_ip   = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
								wan_ip=~@ts_tag_ip_regxp
								@tc_wan_ip = Regexp.last_match(1)
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
						end
						assert_match(@ts_tag_ip_regxp, @tc_wan_ip, "WAN口未获取到IP地址")
				}

				operate("2、DHCP地址输入和wan口地址在同一段；") {
						ip_arr = @tc_wan_ip.split(".")
						if ip_arr.last.to_i<254
								new_serverip=@tc_wan_ip.succ
						else
								new_serverip=@tc_wan_ip.sub(/\.\d+$/, ".20")
						end
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")

						tc_serverip_field = @lan_iframe.text_field(id: @ts_tag_lanip)
						current_serverip  = tc_serverip_field.value
						puts "当前DHCP服务器地址为：#{current_serverip}".encode("GBK")
						puts "修改DHCP服务器地址为：#{new_serverip}".encode("GBK")
						tc_serverip_field = @lan_iframe.text_field(id: @ts_tag_lanip).set(new_serverip)
						@lan_iframe.button(id: @ts_tag_sbm).click
				}

				operate("3、点击保存") {
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "未提示设置错误")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_info, error_info, "地址池设置错误提示内容不正确")
				}


		end

		def clearup

		end

}
