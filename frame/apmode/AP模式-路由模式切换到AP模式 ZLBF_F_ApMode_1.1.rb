#
# description:
# ap模式，WAN和LAN设置不能点击
# 高级设置中只有系统设置->固件升级，配置恢复，日志，定时重起，文件共享
# 系统状态也做了相应的更改
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
testcase {

		attr = {"id" => "ZLBF_ApMode_1.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time   = 2
				@tc_static_args = {nicname: @ts_nicname, source: "static", ip: "192.168.100.121", mask: "255.255.255.0", gateway: @ts_default_ip}
				@tc_dhcp_args   = {nicname: @ts_nicname, source: "dhcp"}
		end

		def process

				operate("1、路由器切换到AP模式，点击保存，查看提示是否正确；") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.save_apmode(@browser.url)
						#配置静态IP
						netsh_if_ip_setip(@tc_static_args)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #重新登录
				}

				operate("2、查看AP模式页面；") {
						#查看WAN设置和LAN是应该无法点击的
						@mode_page.lan_span_obj.click
						sleep @tc_wait_time
						lan_set = @browser.iframe(src: @ts_tag_lan_src).exists?
						refute(lan_set, "LAN设置应该不能打开")

						@mode_page.wan_span_obj.click
						sleep @tc_wait_time
						wan_set = @browser.iframe(src: @ts_tag_netset_src).exists?
						refute(wan_set, "WAN设置应该不能打开")

						@mode_page.open_mode_page(@browser.url)
						#查看路由器模式是否正确
						assert(@mode_page.apmode_selected?, "AP模式设置失败")
						@apoptions_page = RouterPageObject::APOptionsPage.new(@browser)
						#ap模式高级设置里只有系统设置的功能，查看打开高级设置后还有哪些功能
						@apoptions_page.open_options_page(@browser.url)
						refute(@apoptions_page.apply_settings_element.visible?, "切换到AP模式后应用设置功能不应该存在")
						refute(@apoptions_page.network_element.visible?, "切换到AP模式后网络设置功能不应该存在")
						refute(@apoptions_page.security_settings_element.visible?, "切换到AP模式后安全设置功能不应该存在")
						refute(@apoptions_page.traffic_manage_element.visible?, "切换到AP模式后流量管理功能不应该存在")
						assert(@apoptions_page.sysset_element.visible?, "切换到AP模式后系统设置功能应该存在")
				}
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
