#
#description:
#author:wuhongliang
#date:2016-06-03 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_Attack_1.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_delay = 2 #100pps
				@tc_count = 1000
		end

		def process

				operate("1 设置外网DHCP接入") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为DHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
				}
				operate("2 查看WAN状态") {
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						wan_type    = @sys_page.get_wan_type
						wan_addr    = @sys_page.get_wan_ip
						@tc_lan_mac = @sys_page.get_lan_mac
						@tc_lan_ip  = @sys_page.get_lan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
				}

				operate("3 验证业务是否正常") {
						rs1 = ping(@ts_default_ip)
						assert(rs1, '路由器无法登录')
						rs2 = ping(@ts_web)
						assert(rs2, '无法连接网络')
				}

				operate("4 发送报文前查看进程是否存在") {
						puts "查看udhcpc、udhcpd、lighttpd、dnsmasq、ntpd进程".to_gbk
						init_router_obj(@tc_lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						rs = router_attack_ps
						assert(rs, "发送FIN Flood报文前路由器进程异常")
				}

				operate("5 发送FIN Flood报文") {
						nicinfo = ipconfig(@ts_ipconf_all)
						@pc_mac = nicinfo[@ts_nicname][:mac]
						@pc_ip  = nicinfo[@ts_nicname][:ip][0]
						pktobj  = HtmlTag::Packets.new(@pc_mac, @pc_ip, @tc_lan_mac, @tc_lan_ip, @ts_nicname)
						rs      = pktobj.send_tcp("F", "%%%%%", "13523", @tc_count, @tc_delay)
						assert(rs.kind_of?(Hash), "报文发送失败")
				}

				operate("6 发送FIN Flood报文后查看进程") {
						puts "发送FIN Flood报文后查看udhcpc、udhcpd、lighttpd、dnsmasq、ntpd进程".to_gbk
						rs = router_attack_ps
						assert(rs, "发送FIN Flood报文后路由器进程异常")
				}

				operate("7 发送FIN Flood报文后验证业务") {
						rs1 = ping(@ts_default_ip)
						assert(rs1, '发送FIN Flood报文后路由器无法登录')
						rs2 = ping(@ts_web)
						assert(rs2, '发送FIN Flood报文后无法连接外网')
						puts "发送FIN Flood报文后查看路由器WEB是否可以登录".to_gbk
						@wan_page.refresh
						rs3 = @wan_page.wan?
						assert(rs3, '发送FIN Flood报文后无法打开WEB界面')
				}

		end

		def clearup


		end

}
