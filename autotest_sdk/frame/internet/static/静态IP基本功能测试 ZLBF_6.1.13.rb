#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_6.1.13", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time     = 2
				@tc_net_time      = 50
				@tc_net_conn_time = 15
				@tc_tag_iframe_close  = "aui_close"
				@tc_tag_net_reset_tip = "aui_state_noTitle aui_state_focus aui_state_lock"
		end

		def process

				operate("1 打开外网连接设置") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						assert_match /#{@ts_tag_netset_src}/i, @wan_iframe.src, '打开外网设置失败！'
				}

				operate("2 设置外网连接方式") {
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
				}

				operate("3 设置外网静态接入") {
						static_radio       = @wan_iframe.radio(id: @ts_tag_wired_static)
						static_radio_state = static_radio.checked?
						unless static_radio_state
								static_radio.click
								sleep @tc_wait_time
						end

						puts "设置静态IP地址为：#{@ts_staticIp}".to_gbk
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_net_conn_time, "等待网络重启提示出现".to_gbk) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
						}
						Watir::Wait.while(@tc_net_time, "正在重启网络配置".to_gbk) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present?
						}
						sleep @tc_net_conn_time #等待网络连接成功
				}

				operate("4 查看WAN状态") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep(@tc_wait_time+8) #状态页面有时刷新较慢这里增加8s延迟
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						Watir::Wait.until(@tc_wait_time, "打开WAN状态失败".to_gbk) {
								@status_iframe.present?
						}

						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_static})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

						mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						mask =~@ts_tag_ip_regxp
						puts "WAN状态显示的掩码地址为：#{Regexp.last_match(1)}".to_gbk

						gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						gateway_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示的网关IP地址为：#{Regexp.last_match(1)}".to_gbk

						dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
						dns_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示的DNS IP地址为：#{Regexp.last_match(1)}".to_gbk

						assert_match /#{@ts_staticIp}/, wan_addr, '静态ip配置失败！'
						assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'
						assert_match /#{@ts_staticNetmask}/, mask, '静态ip掩码配置失败！'
						assert_match /#{@ts_staticGateway}/, gateway_addr, '静态配置网关ip地址失败！'
						assert_match /#{@ts_staticPriDns}/, dns_addr, '静态配置dns ip地址失败！'

				}
				operate("5 验证业务") {
						rs = ping(@ts_web)
						assert(rs, '无法连接网络')
				}
		end

		def clearup

				operate("恢复默认DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						rs          = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name

						flag = false
						#设置wan连接方式为网线连接
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
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
								puts "Waiting for net reset..."
								sleep @tc_net_time
						end
				}

		end
}