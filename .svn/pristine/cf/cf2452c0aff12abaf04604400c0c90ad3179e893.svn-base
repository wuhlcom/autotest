#
#description:
# 1 断电重启，脚本无法实现
# 2 改用软件重启，执行过程无法换SIM卡这里，只能测试一种卡
# 3 产品缺陷导致重启后不能自动跳转的登录界面，产品功能正常后再重新适配
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_7.1.29", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_dial_time = 90
				@tc_wan_type  = "3G/4G"
		end

		def process
				operate("1 打开外网连接设置") {

				}

				operate("2 设置3/4G连接方式") {

				}
				operate("3 设置自动接入") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_3g_auto_dial(@browser.url)
				}
				operate("4 查看WAN状态") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@status_page = RouterPageObject::SystatusPage.new(@browser)
						@status_page.open_systatus_page(@browser.url)
						wan_addr     = @status_page.get_wan_ip
						wan_type     = @status_page.get_wan_type
						mask         = @status_page.get_wan_mask
						gateway_addr = @status_page.get_wan_gw
						dns_addr     = @status_page.get_wan_dns
						puts "WAN IP:#{wan_addr}"
						puts "WAN TYEP:#{wan_type}"
						puts "WAN Mask:#{mask}"
						puts "WAN Gateway:#{gateway_addr}"
						puts "WAN DNS:#{dns_addr}"
						assert_match @ip_regxp, wan_addr, '3G获取ip地址失败！'
						assert_match /#{@tc_wan_type}/, wan_type, '接入类型错误！'
						assert_match @ip_regxp, gateway_addr, '3G获取网关ip地址失败！'
						assert_match @ip_regxp, mask, '3G获取ip地址掩码失败！'
						assert_match @ip_regxp, dns_addr, '3G获取dns ip地址失败！'

						sim_status = @status_page.sim_status_element.element.image(src: @ts_tag_img_normal)
						assert(sim_status.exists?, "SIM卡状态不正常")
						signal_status = @status_page.signal_strength_element.element.image(src: @ts_tag_signal_normal)
						assert(signal_status.exists?, "SIM卡信号不稳定")
						signal = signal_status.alt
						puts "信号强度为：#{signal}".to_gbk
						reg_status = @status_page.reg_status_element.element.image(src: @ts_tag_img_normal)
						assert(reg_status.exists?, "SIM卡注册不正常")
						net_status = @status_page.net_stauts_element.element.image(src: @ts_tag_img_normal)
						assert(net_status.exists?, "SIM卡网络不正常")
						net_type = @status_page.get_net_type
						puts "接入类型为：#{net_type}".to_gbk
						isp_type = @status_page.get_isp_name
						puts "运营商类型为：#{isp_type}".to_gbk
				}

				operate("5 验证业务") {
						rs = ping(@ts_web)
						assert(rs, '无法连接网络')
				}

				operate("6 重启路由器") {
						@main_page = RouterPageObject::MainPage.new(@browser)
						@main_page.reboot
				}

				operate("7 重启路由器后重新登录路由器") {
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						#等待SIM卡注册成功
						sleep @tc_dial_time
						@status_page.open_systatus_page(@browser.url)
						wan_addr     = @status_page.get_wan_ip
						wan_type     = @status_page.get_wan_type
						mask         = @status_page.get_wan_mask
						gateway_addr = @status_page.get_wan_gw
						dns_addr     = @status_page.get_wan_dns
						puts "WAN IP:#{wan_addr}"
						puts "WAN TYEP:#{wan_type}"
						puts "WAN Mask:#{mask}"
						puts "WAN Gateway:#{gateway_addr}"
						puts "WAN DNS:#{dns_addr}"
						assert_match @ip_regxp, wan_addr, '3G获取ip地址失败！'
						assert_match /#{@tc_wan_type}/, wan_type, '接入类型错误！'
						assert_match @ip_regxp, gateway_addr, '3G获取网关ip地址失败！'
						assert_match @ip_regxp, mask, '3G获取ip地址掩码失败！'
						assert_match @ip_regxp, dns_addr, '3G获取dns ip地址失败！'

						sim_status = @status_page.sim_status_element.element.image(src: @ts_tag_img_normal)
						assert(sim_status.exists?, "SIM卡状态不正常")
						signal_status = @status_page.signal_strength_element.element.image(src: @ts_tag_signal_normal)
						assert(signal_status.exists?, "SIM卡信号不稳定")
						signal = signal_status.alt
						puts "信号强度为：#{signal}".to_gbk
						reg_status = @status_page.reg_status_element.element.image(src: @ts_tag_img_normal)
						assert(reg_status.exists?, "SIM卡注册不正常")
						net_status = @status_page.net_stauts_element.element.image(src: @ts_tag_img_normal)
						assert(net_status.exists?, "SIM卡网络不正常")
						net_type = @status_page.get_net_type
						puts "接入类型为：#{net_type}".to_gbk
						isp_type = @status_page.get_isp_name
						puts "运营商类型为：#{isp_type}".to_gbk
				}

				operate("8 重启后验证业务") {
						rs = ping(@ts_web)
						assert(rs, '重启后无法连接网络')
				}

		end

		def clearup

				operate("1 恢复为默认的接入方式，DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => "set_wifi").exists?
								login_no_default_ip(@browser) #重新登录
						end

						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
