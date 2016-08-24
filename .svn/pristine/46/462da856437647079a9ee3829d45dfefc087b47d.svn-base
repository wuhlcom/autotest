#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.56", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_dumpcap_server = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_pptp_dfault    = "pap,chap,mschap1,mschap2"
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
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						wan_addr     = @sys_page.get_wan_ip
						wan_type     = @sys_page.get_wan_type
						mask         = @sys_page.get_wan_mask
						gateway_addr = @sys_page.get_wan_gw
						dns_addr     = @sys_page.get_wan_dns
						assert_match(@ip_regxp, wan_addr, 'PPTP获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！')
						assert_match(@ip_regxp, mask, 'PPTP获取ip地址掩码失败！')
						assert_match(@ip_regxp, gateway_addr, 'PPTP获取网关ip地址失败！')
						assert_match(@ip_regxp, dns_addr, 'PPTP获取dns ip地址失败！')
				}

				operate("3、在DUT设置页面，点击重启DUT，重启完成后是否一次快速拨号成功，上网业务是否正常，抓包确认点击重启时，DUT是否以当前的call ID发送Call-Clear-Request断开请求；") {
						@sys_page.close_systatus_page
						@sys_page.reboot
						rs = @sys_page.login_with_exists(@browser.url)
						assert(rs, "重启路由器失败未跳转到登录页面!")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@sys_page.open_systatus_page(@browser.url)
						wan_addr     = @sys_page.get_wan_ip
						wan_type     = @sys_page.get_wan_type
						mask         = @sys_page.get_wan_mask
						gateway_addr = @sys_page.get_wan_gw
						dns_addr     = @sys_page.get_wan_dns

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
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
