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
						@wan_page   = RouterPageObject::WanPage.new(@browser)
						@sys_page   = RouterPageObject::SystatusPage.new(@browser)
				}
				operate("2 设置外网连接方式") {

				}
				operate("3 设置外网PPPOE接入") {
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
				}

				operate("4 查看WAN状态") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@sys_page.open_systatus_page(@browser.url)
						wan_addr     = @sys_page.get_wan_ip
						wan_type     = @sys_page.get_wan_type
						mask         = @sys_page.get_wan_mask
						gateway_addr = @sys_page.get_wan_gw
						dns_addr     = @sys_page.get_wan_dns
						puts "WAN状态显示获取的IP地址为：#{wan_addr}".to_gbk
						puts "WAN状态显示接入类型为：#{wan_type}".to_gbk

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