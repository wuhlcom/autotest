#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.24", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_pppoe_mschap1 = "mschap1"
				@tc_net_time   = 50
				@tc_wait_time  = 2
		end

		def process

				operate("1、BAS开启抓包；") {
						#设置pppoe服务的加密为pap
						@tc_server_obj.init_routeros_obj(@ts_routeros_ip)
						@tc_server_obj.routeros_send_cmd(@ts_pppoe_mschap1_set)
						rs = @tc_server_obj.pppoe_srv_pri(@ts_pppoe_srv_pri)
						puts "修改服务器PPPOE认证为:#{rs["authentication"]}".encode("GBK")
						assert_equal(@tc_pppoe_mschap1, rs["authentication"], "修改认证方式失败")
				}

				operate("2、设置DUT的WAN拨号方式为PPPoE，DNS为自动获取方式，BAS认证强制设置为CHAPv1，并填写正确的拨号用户名和密码，提交；") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开外网设置失败")
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
				}

				operate("3、抓包确认在PPP LCP过程中，BAS与DUT协商是否采用CHAPv1认证，拨号是否成功，查看WAN连接，IP，路由，DNS等信息统计页面显示信息是否正确；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
						assert_match @ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
						assert_match @ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
						assert_match @ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
				}

				operate("4、LAN PC与STA PC上网业务是否正常；") {
						rs = ping(@ts_web)
						assert(rs, "PPPOE拨号成功但业务异常")
				}

		end

		def clearup

				operate("1 恢复服务器默认配置") {
						@tc_server_obj.routeros_send_cmd(@ts_pppoe_default_set)
						rs = @tc_server_obj.pppoe_srv_pri(@ts_pppoe_srv_pri)
						puts "恢复服务器认证方式为:#{rs["authentication"]}".encode("GBK")
						@tc_server_obj.logout_routeros
				}

				operate("2 恢复默认DHCP接入") {
						if  @browser.span(:id => @ts_tag_netset).exists?
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
						unless rs1.class_name =~/#{@tc_tag_select_state}/
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
