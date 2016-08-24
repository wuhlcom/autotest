#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.56", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_dumpcap_server      = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_pptp_dfault         = "pap,chap,mschap1,mschap2"
				@tc_wait_time           = 3
				@tc_pptp_setting_time   = 50
				@tc_net_time            = 50
				@tc_rebooting_wait_time = 120
		end

		def process

				operate("1、在BAS启动抓包；") {
						#设置ppptp服务的加密为默认配置
						@tc_dumpcap_server.init_routeros_obj(@ts_pptp_server_ip)
						@tc_dumpcap_server.routeros_send_cmd(@ts_pptp_default_set)
						rs = @tc_dumpcap_server.pptp_srv_pri(@pptp_pri)
						p "修改服务器PPTP认证方式为:#{rs["authentication"]}".to_gbk
						assert_equal(@tc_pptp_dfault, rs["authentication"], "修改认证方式失败")
				}

				operate("2、设置DUT的WAN拨号方式为PPTP，DUT上配置相应的PPTP方式接入配置，DNS为自动获取方式，认证方法设为自动，并填写正确的拨号用户名和密码，查看拨号是否成功；") {
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						@option_iframe.link(id: @ts_tag_op_pptp).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_op_pptp).click #pptp设置
						@option_iframe.text_field(id: @ts_tag_pptp_server).wait_until_present(@tc_wait_time)
						@option_iframe.text_field(id: @ts_tag_pptp_server).set(@ts_pptp_server_ip) #服务器IP
						@option_iframe.text_field(id: @ts_tag_pptp_usr).set(@ts_pptp_usr) #用户名
						@option_iframe.text_field(id: @ts_tag_pptp_pw).set(@ts_pptp_pw) #口令
						@option_iframe.button(id: @ts_tag_sbm).click #保存
						sleep @tc_pptp_setting_time
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

						assert_match(@ip_regxp, wan_addr, 'PPTP获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！')
						assert_match(@ip_regxp, mask, 'PPTP获取ip地址掩码失败！')
						assert_match(@ip_regxp, gateway_addr, 'PPTP获取网关ip地址失败！')
						assert_match(@ip_regxp, dns_addr, 'PPTP获取dns ip地址失败！')
				}

				operate("3、在DUT设置页面，点击重启DUT，重启完成后是否一次快速拨号成功，上网业务是否正常，抓包确认点击重启时，DUT是否以当前的call ID发送Call-Clear-Request断开请求；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_reboot).click
						@browser.button(class_name: @ts_tag_reboot_confirm).click
						puts "路由器重启中，请稍后...".to_gbk
						sleep @tc_rebooting_wait_time
						login_no_default_ip(@browser) #重新登录

						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

						assert_match(@ip_regxp, wan_addr, 'PPTP获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！')
						assert_match(@ip_regxp, mask, 'PPTP获取ip地址掩码失败！')
						assert_match(@ip_regxp, gateway_addr, 'PPTP获取网关ip地址失败！')
						assert_match(@ip_regxp, dns_addr, 'PPTP获取dns ip地址失败！')

						response = send_http_request(@ts_web)
						assert(response, "上网业务不正常！")
				}

				# operate("4、直接断电DUT重启，重启完成后是否一次性快速拨号成功，上网业务是否正常，重启拨号之前DUT是否以上一次call ID发送Call-Clear-Request终止前一次连接；") {
				#
				# }


		end

		def clearup
				operate("断开服务器连接") {
						@tc_dumpcap_server.logout_routeros
				}

				operate("恢复默认DHCP接入") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end
						@browser.span(:id => @ts_tag_netset).click
						sleep @tc_wait_time
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						flag        = false
						#设置wan连接方式为网线连接
						@wan_iframe.link(:id => @ts_tag_wired_mode_link).wait_until_present(@tc_wait_time)
						rs1 = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/ #{@ts_tag_select_state}/
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
