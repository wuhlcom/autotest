#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.12", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_clone_off = "off"
				@tc_lan_time  = 20
		end

		def process

				operate("1、登录DUT，设置WAN接入为DHCPC方式；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为DHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2、选择“使用计算机MAC地址”克隆，保存；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.clone_mac(@browser.url)
						puts "克隆操作后，查看是否克隆成功".to_gbk
						@browser.refresh
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_mac = @systatus_page.get_wan_mac.upcase
						puts "查询到克隆后WAN MAC为#{wan_mac}".to_gbk
						puts "被克隆的网卡MAC地址为 #{@ts_pc_mac}".to_gbk
						assert_equal(@ts_pc_mac, wan_mac, "MAC地址克隆失败!")
				}

				operate("3、复位DUT到默认配置状态；") {
						#恢复出厂设置
						@options_page.recover_factory(@browser.url)
						@login_page = RouterPageObject::LoginPage.new(@browser)
						login_ui    = @login_page.login_with_exists(@browser.url)
						assert(login_ui, "恢复出厂值后未自动跳转到登录界面~")
						#重新登录
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
				}

				operate("4、查看DUT的DHCP配置是否被复位到默认状态；") {
						clone_sw= @options_page.get_clone_sw_status(@browser.url)
						assert_equal(@tc_clone_off, clone_sw, "恢复出厂设置后克隆开关状态不正确")
						@systatus_page.open_systatus_page(@browser.url)
						wan_mac = @systatus_page.get_wan_mac.upcase
						@systatus_page.open_systatus_page(@browser.url)
						puts "恢复出厂设置后WAN MAC为#{wan_mac}".to_gbk
						refute_equal(@ts_pc_mac, wan_mac, "恢复克隆设置失败!")
				}


		end

		def clearup
				operate("1 恢复默认配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						if @options_page.username?
								rs_login = login_no_default_ip(@browser) #重新登录
								p rs_login[:flag]
								p rs_login[:message]
						end
						@options_page.shutdown_clone(@browser.url)
				}
		end

}
