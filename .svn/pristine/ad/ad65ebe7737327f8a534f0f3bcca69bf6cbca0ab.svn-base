#
# description:
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
testcase {
		attr = {"id" => "ZLBF_ApMode_2.1.7", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_static_args = {nicname: @ts_nicname, source: "static", ip: "192.168.100.121", mask: "255.255.255.0", gateway: @ts_default_ip}
				@tc_dhcp_args   = {nicname: @ts_nicname, source: "dhcp"}
		end

		def process

				operate("1、查看状态页面的WAN口状态信息") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.save_apmode(@browser.url)
				}

				operate("2、连接类型是否为“AP模式”") {
						#配置静态IP
						netsh_if_ip_setip(@tc_static_args)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #重新登录
						@mode_page.open_mode_page(@browser.url)
						#查看路由器模式是否正确
						assert(@mode_page.apmode_selected?, "AP模式设置失败")

						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						#查看系统状态页面的变化
						@systatus_page.open_systatus_page(@browser.url)
						puts "#{@systatus_page.version_info}".to_gbk
						verinfo = @systatus_page.version_info_element.visible?
						assert(verinfo, "未显示版本信息")
						puts "系统状态页面显示的信息有:".to_gbk
						puts "#{@systatus_page.wan_info}".to_gbk
						wanifo = @systatus_page.wan_info_element.visible?
						refute(wanifo, "不应该显示WAN信息")

						puts "#{@systatus_page.lan_info}".to_gbk
						laninfo = @systatus_page.lan_info_element.visible?
						assert(laninfo, "未显示LAN信息")

						puts "#{@systatus_page.wifi_info}".to_gbk
						wifi_info = @systatus_page.wifi_info_element.visible?
						assert(wifi_info, "未显示WIFI信息")
				}

				# operate("3、IP地址、子网掩码、网关、DNS服务器是否都为空") {
				#
				# }


		end

		def clearup

				operate("1.恢复默认设置") {
						#配置静态IP
						netsh_if_ip_setip(@tc_static_args)
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #重新登录
						@mode_page.open_mode_page(@browser.url)
						unless @mode_page.routermode_selected?
								@mode_page.set_router_mode
						end
						#动态IP
						netsh_if_ip_setip(@tc_dhcp_args)
				}
		end

}
