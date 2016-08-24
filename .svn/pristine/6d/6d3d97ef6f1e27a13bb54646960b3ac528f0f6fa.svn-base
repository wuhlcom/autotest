#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.15", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time       = 2
				@tc_static_time     = 30
				@tc_net_time        = 50
		end

		def process

				operate("1、DUT启动完成，检查静态接入配置页面各个按钮，在点击相关按钮后会跳转至相关页面。") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')
				}

				operate("2、设置WAN接入为静态接入方式；") {
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						static_radio = @wan_iframe.radio(:id => @ts_tag_wired_static)
						static_radio.click
						sleep @tc_wait_time
				}

				operate("3、输入IP地址为10.0.0.10，掩码为255.255.255.0，网关为10.0.0.1，DNS为10.0.0.1，点击保存；") {
						puts "设置静态IP地址为：#{@ts_staticIp}".to_gbk
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns )
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_static_time

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


		end

		def clearup
				operate("1 恢复默认DHCP接入") {
						if !@wan_iframe.exists? && @browser.span(:id => @ts_tag_netset).exists?
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						flag = false
						#设置wan连接方式为网线连接
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/#{@ts_tag_select_state}/
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
								puts "sleep #{@tc_net_time} seconds for net reseting..."
								sleep @tc_net_time
						end
				}

		end

}
