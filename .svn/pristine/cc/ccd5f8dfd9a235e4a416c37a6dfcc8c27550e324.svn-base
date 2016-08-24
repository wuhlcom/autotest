#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.4", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_lan_ip1 ="192.168.100.1"
				@tc_lan_pre1= @tc_lan_ip1.slice(/\d+\.\d+\.\d+/)
				@tc_lan_ip2 ="192.168.100.254"
				@tc_lan_pre2= @tc_lan_ip2.slice(/\d+\.\d+\.\d+/)
		end

		def process

				operate("1、登陆路由器进入内网设置") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
				}

				operate("2、分别更改DHCP服务地址为192.168.100.1,192.168.100.254") {
						puts "修改LAN DHCP服务IP为#{@tc_lan_ip1}".to_gbk
						@lan_page.lan_ip_config(@tc_lan_ip1, @browser.url)
						rs       = ipconfig(@ts_ipconf_all)
						pc_ip    = rs[@ts_nicname][:ip][0]
						pc_gw    = rs[@ts_nicname][:gateway][0]
						pc_dns   = rs[@ts_nicname][:dns_server]
						puts "PC获取到IP地址信息为:".to_gbk
						puts "PC IP地址为:#{pc_ip}".to_gbk
						puts "PC 网关为:#{pc_gw}".to_gbk
						puts "PC DNS为:#{pc_dns.join(",")}".to_gbk
						dns_flag = pc_dns.include?(@tc_lan_ip1)
						assert_match(/#{@tc_lan_pre1}/, pc_ip, "更改LAN DHCP服务IP后PC未获取到新网段IP")
						assert_equal(@tc_lan_ip1, pc_gw, "更改LAN DHCP服务IP后PC网关未更新")
						assert(dns_flag, "更改LAN DHCP服务IP后PC DNS未更新")
				}

				operate("3、分别保存，客户端是否自动获取IP地址为更改网段的IP地址、子网掩码、网关、DNS服务器信息") {
						puts "修改LAN DHCP服务IP为#{@tc_lan_ip2}".to_gbk
						@lan_page.lan_ip_config(@tc_lan_ip2, @browser.url)
						rs       = ipconfig(@ts_ipconf_all)
						pc_ip    = rs[@ts_nicname][:ip][0]
						pc_gw    = rs[@ts_nicname][:gateway][0]
						pc_dns   = rs[@ts_nicname][:dns_server]
						puts "PC获取到IP地址信息为:".to_gbk
						puts "PC IP地址为:#{pc_ip}".to_gbk
						puts "PC 网关为:#{pc_gw}".to_gbk
						puts "PC DNS为:#{pc_dns.join(",")}".to_gbk
						dns_flag = pc_dns.include?(@tc_lan_ip2)
						assert_match(/#{@tc_lan_pre2}/, pc_ip, "更改LAN DHCP服务IP后PC未获取到新网段IP")
						assert_equal(@tc_lan_ip2, pc_gw, "更改LAN DHCP服务IP后PC网关未更新")
						assert(dns_flag, "更改LAN DHCP服务IP后PC DNS未更新")
				}
		end

		def clearup
				operate("1 恢复默认DHCP服务IP") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						rs        = @lan_page.login_with_exists(@browser.url)
						if rs
								@lan_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url) #重新登录
						end
						@lan_page.open_lan_page(@browser.url)
						lan_ip = @lan_page.lan_ip
						unless lan_ip==@ts_default_ip
								@lan_page.lan_ip_config(@ts_default_ip, @browser.url)
						end
				}

		end

}
