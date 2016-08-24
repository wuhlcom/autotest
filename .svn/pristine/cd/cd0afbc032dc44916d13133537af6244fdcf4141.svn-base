#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.39", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_cfg_name  = "config.tgz"
				@tc_wait_time = 15
		end

		def process
				operate("1 将路由器恢复出厂设置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.recover_factory(@browser.url)
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "恢复出厂值后未跳转到登录界面")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
				}

				operate("2、恢复出厂设置后查看默认配置") {
						#恢复出厂值后，先查询默认配置
						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_systatus_page(@browser.url)
						@tc_wan_type = @wifi_detail.get_wan_type
						puts "默认接入方式为#{@tc_wan_type}".to_gbk
						assert_equal(@ts_wan_mode_dhcp, @tc_wan_type, "默认接入接入类型不是#{@ts_wan_mode_dhcp}！")
				}

				operate("3、配置PPPOE接入方式") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
						sleep @tc_wait_time
						@wifi_detail.open_systatus_page(@browser.url)
						wan_type = @wifi_detail.get_wan_type
						puts "WAN状态显示接入类型为：#{wan_type}".to_gbk
						assert_equal(@ts_wan_mode_pppoe, wan_type, "设置为PPPOE模式后,接入类型不是#{@ts_wan_mode_pppoe}！")

						rs = ping(@ts_web)
						assert(rs, "PPPOE拨号上网正常")
				}

				operate("4、导出配置文件") {
						#取出下载目录下的所有文件绝对路径存入数组
						old_backup_files = Dir.glob(@ts_download_directory+"/*")
						#删除目录下所有配置文件
						old_backup_files.each do |file|
								FileUtils.rm_rf(file) if file=~/#{@tc_cfg_name}$/
						end
						old_config = Dir.glob(@ts_download_directory+"/*").any? { |file| file=~/#{@tc_cfg_name}$/ }
						refute(old_config, "旧的配置文件未删除")

						@options_page.export_file_step(@browser, @browser.url)

						#查看文件是否下载成功
						@tc_config_file = ""
						config_flag     = false
						Dir.glob(@ts_download_directory+"/*").each { |file|
								if file=~/#{@tc_cfg_name}$/
										@tc_config_file=file
										config_flag    =true
										break
								end
						}
						assert(config_flag, "PPPOE配置文件下载失败！")
				}

				operate("5、点击恢复出厂设置") {
						@options_page.recover_factory(@browser.url)
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "恢复出厂值后未跳转到登录界面")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
				}

				operate("6、恢复完成以后，查看路由器配置是否被恢复") {
						@wifi_detail.open_systatus_page(@browser.url)
						wan_type = @wifi_detail.get_wan_type
						puts "WAN状态显示接入类型为：#{wan_type}".to_gbk
						assert_equal(@ts_wan_mode_dhcp, wan_type, "设置为PPPOE模式后,接入类型不是#{@ts_wan_mode_dhcp}！")
				}

				operate("7、导入配置文件，查看导入是否成功") {
						@options_page.import_file_step(@browser.url, @tc_config_file)
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "导入配置未跳转到登录界面")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@wifi_detail.open_systatus_page(@browser.url)
						wan_type = @wifi_detail.get_wan_type
						puts "导入配置文件后WAN接入类型为：#{wan_type}".to_gbk
						assert_equal(@ts_wan_mode_pppoe, wan_type, "导入配置文件后,接入类型不是#{@ts_wan_mode_pppoe}！")

						#导入配置后，路由器PPPOE拨号业务验证
						rs_ping = ping(@ts_web)
						assert(rs_ping, "导入配置后PPPOE拨号上网正常")
				}

		end

		def clearup

				operate("1 恢复默认设置") {
						@browser.refresh
						wan_page = RouterPageObject::WanPage.new(@browser)
						rs       = wan_page.login_with_exists(@browser.url)
						if rs
								rs_login = login_no_default_ip(@browser) #重新登录
								p rs_login[:flag]
								p rs_login[:message]
						end
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
