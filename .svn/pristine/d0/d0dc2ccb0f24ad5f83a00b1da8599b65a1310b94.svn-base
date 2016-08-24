#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.4", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time    = 3
				@tc_net_time     = 50
		end

		def process

				operate("1 打开外网连接设置") {
				}

				operate("2 设置外网连接方式") {
				}
				operate("3 设置外网DHCP接入") {
						#查看WAN接入方式是否为DHCP
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#如果不是DHCP则修改为DHCP
						unless wan_type =~ /#{@ts_wan_mode_dhcp}/
								puts "切换为DHCP接入方式".to_gbk
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "打开外网设置失败")
								@wan_iframe.link(:id => @ts_tag_wired_mode_link).click #选择网线连接
								dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
								unless dhcp_radio.checked?
										dhcp_radio.click
								end
								#保存设置，切换为DHCP模式
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "sleep #{@tc_net_time} second for net reseting..."
								sleep @tc_net_time
						end
				}
				operate("4 查看WAN状态") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						wan_addr     = @status_iframe.b(:id => @tag_wan_ip).parent.text
						wan_type     = @status_iframe.b(:id => @tag_wan_type).parent.text
						mask         = @status_iframe.b(:id => @tag_wan_mask).parent.text
						gateway_addr = @status_iframe.b(:id => @tag_wan_gw).parent.text
						dns_addr     = @status_iframe.b(:id => @tag_wan_dns).parent.text

						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
						assert_match @ts_tag_ip_regxp, mask, 'dhcp获取ip地址掩码失败！'
						assert_match @ts_tag_ip_regxp, gateway_addr, 'dhcp获取网关ip地址失败！'
						assert_match @ts_tag_ip_regxp, dns_addr, 'dhcp获取dns ip地址失败！'
				}
				operate("6 验证业务") {
						rs1 = ping(@ts_default_ip)
						assert(rs1, '路由器无法登录')
						rs2 = ping(@ts_web)
						assert(rs2, '无法连接网络')
				}

		end

		def clearup


		end

}
