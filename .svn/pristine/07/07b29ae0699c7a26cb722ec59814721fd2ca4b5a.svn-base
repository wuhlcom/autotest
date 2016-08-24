#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.9", "level" => "P3", "auto" => "n"}

		def prepare
				DRb.start_service
				@backup_wifi_one = "wifiauto_llp"
				@backup_wifi_two = "wifiauto_setting"
				@tc_server_obj   = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_file_path    = "D:/remote_download/config.tgz" #此路径不能随意修改要与远程PC地址一致
				@tc_reboot_time  = 110
		end

		def process

				operate("0、首先先恢复出厂设置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						# 测试前先将路由器恢复出厂设置
						@options_page.recover_factory(@browser.url)
						@login_page = RouterPageObject::LoginPage.new(@browser)
						login = @login_page.login_with_exists(@browser.url)
						assert(login, "恢复出厂设置后未跳转到登录界面！")
						# 重新登录
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
				}

				operate("1、PC1修改DUT的无线，拨号，防火墙，LAN侧IP等配置，视为配置1；") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid1(@backup_wifi_one)
						puts "修改SSID1名字为#{@backup_wifi_one}".to_gbk
						@wifi_page.save_wifi_config

						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为PPPOE".to_gbk
						#修改服务器租约后，WAN要重新获取一次IP地址，这里直接设置DHCP模式并保存
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type  = @systatus_page.get_wan_type
						@wan_addr = @systatus_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{@wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, @wan_addr, 'PPPOE获取IP地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.more_obj
						puts "查询SSID1详细信息".to_gbk
						ssid_name = @wifi_detail.ssid1_name
						assert_equal(@backup_wifi_one, ssid_name, "修改SSID失败！")
				}

				operate("2、PC2远程备份该配置文件，查看是否备分成功；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_web_access_btn(@browser.url)
						@tc_web_acc_port = @options_page.web_access_port
						@options_page.save_web_access
						remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{remote_url}"
						@tc_server_obj.remote_login_router(remote_url, @ts_default_usr, @ts_default_pw)
						@tc_server_obj.export_config_file
				}

				operate("3、PC1再次修改无线，拨号，防火墙，LAN侧IP等配置，视为配置2；") {
						@wifi_page.select_2g_basic(@browser.url)
						@wifi_page.modify_ssid1(@backup_wifi_two)
						puts "修改SSID1名字为#{@backup_wifi_two}".to_gbk
						@wifi_page.save_wifi_config
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询SSID1详细信息".to_gbk
						ssid_name = @wifi_detail.ssid1_name
						assert_equal(@backup_wifi_two, ssid_name, "修改SSID失败！")
				}

				operate("4、PC2远程导入配置1，查看是否导入成功，当前配置是否为配置1。") {
						@tc_server_obj.import_config_file(@tc_file_path)
						@tc_server_obj.close_brower
						sleep @tc_reboot_time
						@browser.refresh
						@browser.cookies.clear
						@browser.refresh
						login_default(@browser, @ts_default_ip)

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "导入配置后查询SSID1详细信息".to_gbk
						ssid_name = @wifi_detail = @wifi_detail.ssid1_name
						assert_equal(@backup_wifi_one, ssid_name, "远程配置恢复失败")
				}
		end

		def clearup

				operate("1 恢复默认DHCP接入") {
						@tc_server_obj.close_brower
						wan_page = RouterPageObject::WanPage.new(@browser)
						if wan_page.login_with_exists(@browser.url)
								login_default(@browser, @ts_default_ip)
						end
						wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2 恢复默认SSID") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.modify_default_ssid(@browser.url)
				}

				operate("3 关闭外网访问开关") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.close_web_access(@browser.url)
				}
		end

}
