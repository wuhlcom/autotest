#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.21", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time   = 3
				@tc_status_time = 5
				@tc_net_time    = 50
				@tc_pppoe_usr   = 'pppoe@163.gd'
				@tc_pppoe_pw    = 'PPPOETEST'

		end

		def process
				operate("1 打开外网连接设置") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开外网设置失败")
				}
				operate("2 设置外网连接方式") {
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						if rs1 !~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								sleep @tc_wait_time
						end
				}
				operate("3 设置外网PPPOE接入") {
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
				}

				operate("4 查看WAN状态") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_pppoe})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk
						mask         = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr     = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe }/, wan_type, '接入类型错误！'
						assert_match @ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
						assert_match @ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
						assert_match @ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
				}

				operate("5 验证业务") {
						rs = ping(@ts_web)
						assert(rs, '无法连接网络')
				}
		end

		def clearup
				operate("1 恢复为默认的接入方式，DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式为网线连接
						rs1         =@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        =false
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag=true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.attribute_value(:checked)

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state == "true"
								dhcp_radio.click
								flag=true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}
		end
}