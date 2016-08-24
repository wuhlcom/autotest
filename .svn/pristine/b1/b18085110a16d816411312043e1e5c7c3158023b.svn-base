#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {

		attr = {"id" => "ZLBF_6.1.22", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_pppoe_pap  = "pap"
				@tc_net_time   = 50
				@tc_wait_time  = 2
		end

		def process

				operate("1、BAS开启抓包；") {
						#设置pppoe服务的加密为pap
						@tc_server_obj.init_routeros_obj(@ts_routeros_ip)
						@tc_server_obj.routeros_send_cmd(@ts_pppoe_pap_set)
						rs = @tc_server_obj.pppoe_srv_pri(@ts_pppoe_srv_pri)
						puts "修改服务器PPPOE认证为:#{rs["authentication"]}".encode("GBK")
						assert_equal(@tc_pppoe_pap, rs["authentication"], "修改认证方式失败")
				}

				operate("2、设置DUT的WAN拨号方式为PPPoE，DNS为自动获取方式，BAS认证强制设置为PAP，并填写正确的拨号用户名和密码，提交；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
				}

				operate("3、抓包确认在PPP LCP过程中，BAS与DUT协商是否采用PAP认证，拨号是否成功，查看WAN连接，IP，路由，DNS等信息统计页面显示信息是否正确；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						p wan_addr     = @sys_page.get_wan_ip
						p wan_type     = @sys_page.get_wan_type
						p mask         = @sys_page.get_wan_mask
						p gateway_addr = @sys_page.get_wan_gw
						p dns_addr     = @sys_page.get_wan_dns

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
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
