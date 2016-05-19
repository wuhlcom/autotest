#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_6.1.13", "level" => "P1", "auto" => "n"}

		def prepare
		end

		def process

				operate("1 打开外网连接设置") {
				}

				operate("2 设置外网连接方式") {
				}

				operate("3 设置外网静态接入") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
				}

				operate("4 查看WAN状态") {
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_ip   = @systatus_page.get_wan_ip
						wan_mask = @systatus_page.get_wan_mask
						wan_gw   = @systatus_page.get_wan_gw
						wan_dns  = @systatus_page.get_wan_dns
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_ip}".to_gbk
						puts "查询到WAN子网掩码为#{wan_mask}".to_gbk
						puts "查询到WAN网关为#{wan_gw}".to_gbk
						puts "查询到WAN DNS为#{wan_dns}".to_gbk
						assert_equal(@ts_wan_mode_static, wan_type, '接入类型错误！')
						assert_equal(@ts_staticIp, wan_ip, '静态IP配置失败！')
						assert_equal(@ts_staticNetmask, wan_mask, '静态掩码配置失败！')
						assert_equal(@ts_staticGateway, wan_gw, '静态网关配置失败！')
						assert_equal(@ts_staticPriDns, wan_dns, '静态DNS配置失败！')
				}
				operate("5 验证业务") {
						rs = ping(@ts_web)
						assert(rs, '无法连接网络')
				}

		end

		def clearup
				operate("1 恢复默认方式:DHCP") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}
		end
}