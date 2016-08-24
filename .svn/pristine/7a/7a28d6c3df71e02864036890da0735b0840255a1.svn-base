#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.53", "level" => "P3", "auto" => "n"} #该脚本需要测试性能相关，暂时不写

		def prepare
				@tc_dumpcap_server = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_pptp_dfault    = "pap,chap,mschap1,mschap2"
		end

		def process

				operate("1、设置DUT的WAN拨号方式为PPTP，DUT上配置相应的PPTP方式接入配置，DNS为自动获取方式，认证方法设为自动，并填写正确的拨号用户名和密码，提交；") {
						#设置ppptp服务的认证为默认配置
						@tc_dumpcap_server.init_routeros_obj(@ts_pptp_server_ip)
						@tc_dumpcap_server.routeros_send_cmd(@ts_pptp_default_set)
						rs = @tc_dumpcap_server.pptp_srv_pri(@pptp_pri)
						p "修改服务器PPTP认证方式为:#{rs["authentication"]}".to_gbk
						assert_equal(@tc_pptp_dfault, rs["authentication"], "修改认证方式失败")

						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
				}

				operate("2、查看DUT是否拨号成功；") {
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

				# operate("3、断电重启设备5次，查看DUT拨号是否成功，DUT是否出现异常；") {
				#
				# }

				operate("4、软件重启DUT 5次，查看DUT拨号是否成功，DUT是否出现异常。") {
						for n in 1..5
								p "第#{n}次重启".to_gbk
								@browser.refresh
								@options_page.reboot
								rs = @options_page.login_with_exists(@browser.url)
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
								p "判断能否上网".to_gbk
								response = ping(@ts_web)
								assert(response, "上网失败，不可以访问#{@ts_web}".to_gbk)
						end
				}

				# operate("备注：步骤4可以采用SecureCRT脚本自动控制反复重启。") {
				#
				# }
				#
				# operate("5、设置DUT的WAN拨号方式为PPTP，DUT上配置相应的PPTP方式接入配置，DNS为自动获取方式，认证方法设为自动，并填写错误的拨号用户名和密码，提交；") {
				#
				# }
				#
				# operate("6、查看是否会重复拨号，查看内存情况（剩余内存），cat /proc/meminfo；") {
				#
				# }
				#
				# operate("7、12小时后，DUT是否异常，登录DUT管理页面是否正常，查看内存情况（剩余内存），cat /proc/meminfo，内存是否会出现泄漏溢出。") {
				#
				# }
				#
				# operate("8、ps查看进程信息是否正常；") {
				#
				# }


		end

		def clearup
				operate("断开服务器连接") {
						@tc_dumpcap_server.logout_routeros
				}

				operate("恢复默认DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
