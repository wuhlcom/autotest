#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.4", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1 打开外网连接设置") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
				}
				operate("2 设置外网DHCP接入") {
						puts "设置接入方式为DHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
				}
				operate("4 查看WAN状态") {
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						wan_type = sys_page.get_wan_type
						wan_addr = sys_page.get_wan_ip
						mask     = sys_page.get_wan_mask
						gateway  = sys_page.get_wan_gw
						dns      = sys_page.get_wan_dns
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_addr}".to_gbk
						puts "查询到WAN 掩码为#{mask}".to_gbk
						puts "查询到WAN 网关为#{gateway}".to_gbk
						puts "查询到WAN DNS为#{dns}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
						assert_match @ts_tag_ip_regxp, mask, 'dhcp获取ip地址掩码失败！'
						assert_match @ts_tag_ip_regxp, gateway, 'dhcp获取网关ip地址失败！'
						assert_match @ts_tag_ip_regxp, dns, 'dhcp获取dns ip地址失败！'
				}
				operate("6 验证业务") {
						rs1 = ping(@ts_default_ip)
						assert(rs1, '路由器无法登录')
						rs2 = ping(@ts_web)
						assert(rs2, '无法连接网络')
				}

		end

		def clearup


		end

}
