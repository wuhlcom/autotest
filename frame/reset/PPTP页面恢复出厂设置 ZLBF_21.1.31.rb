#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.31", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time      = 2
				@tc_vps_id         = 1
				@tc_test_ssid      = "wifitest"
				@tc_pub_tcp_port   = 5001
				@tc_vir_tcpsrv_port= 5002
		end

		def process

				operate("1、登录DUT管理页面；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.recover_factory(@browser.url)
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "恢复出厂值后未跳转到登录界面")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
				}

				operate("2、配置WAN连接为PPTP方式，修改LAN口IP地址，修改地址池范围，修改无线SSID，修改无线安全，修改无线高级参数，添加端口转发规则、端口触发规则、添加URL过滤规则、IP与端口过滤规则、开启UPNP功能、开启DMZ功能、开启DDNS功能、修改登录密码等页面所有可配置的选项；") {
						#恢复出厂值后，先查询默认配置，
						#再增加配置
						#修改SSID，修改接入方式为PPTP
						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_systatus_page(@browser.url)
						@tc_wan_type = @wifi_detail.get_wan_type
						puts "默认接入方式为#{@tc_wan_type}".to_gbk
						@wifi_detail.open_wifidetail_page(@browser.url)
						@tc_ssid1 = @wifi_detail.ssid1_name
						puts "默认接入SSID1为#{@tc_ssid1}".to_gbk

						@options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url) #pptp接入
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.modify_ssid_mode_pwd(@browser.url, @tc_test_ssid) #修改SSID

						#查询
						@wifi_detail.open_systatus_page(@browser.url)
						tc_wan_type = @wifi_detail.get_wan_type
						puts "接入方式为#{tc_wan_type}".to_gbk

						@wifi_detail.open_wifidetail_page(@browser.url)
						tc_ssid1 = @wifi_detail.ssid1_name
						puts "SSID1为#{tc_ssid1}".to_gbk

						assert_equal(@ts_wan_mode_pptp, tc_wan_type, "接入方式不为PPTP")
						refute_equal(@tc_ssid1, tc_ssid1, "SSID修改失败!")

						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "Virtual Server IP #{@tc_pc_ip}"
						@options_page.add_vps_step(@browser.url, @tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, @tc_vps_id)
						@options_page.open_vps_page
						rs = @options_page.vps_td1?
						assert(rs, "虚拟服务器配置失败!")
				}

				operate("3、在页面进行复位，查看设置的参数是否全部复位成出厂默认状态；") {
						@options_page.recover_factory(@browser.url)
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "恢复出厂值后未跳转到登录界面")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@wifi_detail.open_systatus_page(@browser.url)
						tc_wan_type = @wifi_detail.get_wan_type
						puts "恢复出厂设置后接入方式为#{@tc_wan_type}".to_gbk
						@wifi_detail.open_wifidetail_page(@browser.url)
						tc_ssid1 = @wifi_detail.ssid1_name
						puts "恢复出厂设置后SSID1为#{@tc_ssid1}".to_gbk
						assert_equal(@tc_wan_type, tc_wan_type, "恢复出厂后接入方式未恢复为默认方式")
						assert_equal(@tc_ssid1, tc_ssid1, "恢复出厂后SSID未恢复为默认设置!")

						@options_page.open_vps(@browser.url)
						rs = @options_page.vps_td1?
						refute(rs, "恢复出厂后虚拟服务器配置恢复失败!")
				}

		end

		def clearup

				operate("1 删除虚拟服务器配置") {
						rs = @options_page.login_with_exists(@browser.url)
						if rs
								rs_login = login_no_default_ip(@browser) #重新登录
								p rs_login[:flag]
								p rs_login[:message]
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_vps(@browser.url)
						if @options_page.vps_td1?
								@options_page.delete_all_vps
								@options_page.close_vps_btn
								@options_page.save_vps
						end
				}

				operate("2 恢复默认SSID和接入方式") {
						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						ssid1 = @wifi_detail.ssid1_name
						puts "接入SSID1为#{ssid1}".to_gbk
						#恢复默认ssid
						unless ssid1==@tc_ssid1
								@wifi_page = RouterPageObject::WIFIPage.new(@browser)
								@wifi_page.modify_default_ssid(@browser.url)
						end
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end
}
