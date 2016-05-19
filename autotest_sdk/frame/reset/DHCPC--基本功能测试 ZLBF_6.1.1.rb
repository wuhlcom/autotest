#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
	attr = {"id" => "ZLBF_6.1.1", "level" => "P1", "auto" => "n"}

	def prepare
		@tc_wait_time     = 3
		@tc_dispear_time  = 15
		@tc_wait_lan      = 100
		@tc_net_wait_time = 30
		@tc_tag_wan_span  = "set_network"
		@tc_tag_lan_span  = "set_wifi"

		@wan_iframe_src       = "netset"
		@tc_tag_status_iframe = "setstatus"
		@lan_iframe_src       = "lanset"

		@tc_tag_wan_mode_span = "wire"
		@tc_tag_wan_mode_link = "tab_ip"

		@tc_tag_lan_ip = "lan_ip"
		@tc_lan_ip     = "192.168.22.1"

		@tc_wire_mode           = "DHCP"
		@tc_tag_wire_mode_label = "wire-dhcp"
		@tc_tag_wire_mode_radio = "ip_type_dhcp"
		@tc_tag_btn             = "submit_btn"
		@tc_tag_iframe_close    = "aui_close"

		@tc_tag_net_resset_tip = "aui_state_noTitle aui_state_focus aui_state_lock"
		@tc_tag_lan_resset_tip = "aui_state_noTitle aui_state_focus aui_state_lock"
		@tc_tag_lan_reset      = "aui_content"
		@tc_tag_select_state   = "selected"

	end

	def process

		operate("1 打开外网连接设置") {
			@browser.span(:id => @tc_tag_wan_span).click
			@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
			assert(@wan_iframe.exists?, '打开外网设置失败！')
		}

		operate("2 设置外网连接方式") {
			rs1=@wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
			unless rs1 =~/#{@tc_tag_select_state}/
				@wan_iframe.span(:id => @tc_tag_wan_mode_span).click
			end
		}
		operate("3 设置外网DHCP接入") {
			dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio)
			dhcp_radio_state = dhcp_radio.attribute_value(:checked)

			if dhcp_radio_state != "true"
				dhcp_radio.click
				@wan_iframe.button(:id, @tc_tag_btn).click
				sleep 2
				net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
				Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
					net_reset_div.visible?
				}
				Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
					net_reset_div.present?
				}
			end
		}
		operate("4 查看WAN状态") {
			#关闭WAN设置
			if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
				@browser.execute_script(@ts_close_div)
			end
			@browser.span(:id => @tc_tag_status_iframe).wait_until_present(@tc_wait_time)
			@browser.span(:id => @tc_tag_status_iframe).click
			@status_iframe = @browser.iframe
			assert_match /#{@tc_tag_status_iframe}/i, @status_iframe.src, '打开WAN状态失败！'
			sleep @tc_wait_time
			Watir::Wait.until(@tc_wait_time, "等待dhcp拨号成功") {
				wan_addr     = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
				wan_type     = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
				mask         = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
				gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
				dns_addr     = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

				assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
				assert_match /#{@tc_wire_mode}/, wan_type, '接入类型错误！'
				assert_match @ts_tag_ip_regxp, mask, 'dhcp获取ip地址掩码失败！'
				assert_match @ts_tag_ip_regxp, gateway_addr, 'dhcp获取网关ip地址失败！'
				assert_match @ts_tag_ip_regxp, dns_addr, 'dhcp获取dns ip地址失败！'
			}

		}
		operate("5 验证业务") {
			rs = ping(@ts_web)
			assert(rs, '无法连接网络')
		}

		operate("6 打开内网设置") {
			lanset = @browser.span(:id => @tc_tag_lan_span).wait_until_present(@tc_wait_time)
			if lanset
				@browser.span(:id => @tc_tag_lan_span).click
			else
				assert(false, '打开内网设置失败！')
			end
			@lan_iframe = @browser.iframe
			assert_match /#{@lan_iframe_src}/i, @lan_iframe.src, '打开内网设置失败！'
		}

		operate("7 修改lan ip") {
			@lan_iframe.text_field(:id, @tc_tag_lan_ip).set(@tc_lan_ip)
			@lan_iframe.button(:id, @tc_tag_btn).click

			#<div class="aui_content" style="padding: 20px 25px;">设置成功，请稍候......重置网络，如果网络断连，请重新连接。</div>
			Watir::Wait.until(@tc_wait_time, "等待重启LAN网络出现失败") {
				lan_reseting = @lan_iframe.div(class_name: @tc_tag_lan_reset, text: @ts_tag_lan_reset_text)
				lan_reseting.present?
			}
			rs = @browser.text_field(:name, @usr_text_id).wait_until_present(@tc_wait_lan)
			assert rs, '跳转到登录页面失败！'
		}

		operate("8 修改lan设置后重新验证业务") {
			rs1 = ping(@tc_lan_ip)
			assert(rs1, '路由器无法登录')
			rs2 = ping(@web)
			assert(rs2, '无法连接网络')
		}

	end

	def clearup

		operate("1 恢复路由器默认lan ip") {
			rs1 = ping(@ts_default_ip)
			if rs1 == true
				puts "路由器已是默认配置".to_gbk
			else
				login_recover(@browser, @ts_default_ip)
			end
		}

	end

}