#artDialog X问题
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.40", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1 打开options设置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
				}

				operate("2 选择PPTP连接方式") {

				}

				operate("3 设置PPTP参数") {
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
				}

				operate("4 查看WAN状态") {
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						wan_addr     = @sys_page.get_wan_ip
						wan_type     = @sys_page.get_wan_type
						puts "PPTP获取的IP地址为：#{wan_addr}".to_gbk
						puts "查询到接入类型为：#{wan_type}".to_gbk
						mask         = @sys_page.get_wan_mask
						dns_addr     = @sys_page.get_wan_dns
						puts "PPTP获取的DNS地址为：#{dns_addr}".to_gbk

						assert_match @ts_tag_ip_regxp, wan_addr, 'PPTP获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！'
						assert_match @ts_tag_ip_regxp, mask, 'PPTP获取ip地址掩码失败！'
						assert_match @ts_tag_ip_regxp, dns_addr, 'PPTP获取dns ip地址失败！'

				}

				operate("5 验证业务") {
						rs =ping(@ts_web)
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
