#
# description:
#
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.41", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_config_dir   = File.expand_path("../router_config", __FILE__)
				@tc_recover_err  = "上传文件格式错误！"
				@tc_recover_time = 110
				@err_msg         = ""
		end

		def process

				operate("1、WAN设置为PPPoE方式，输入正确的拨号用户名与密码，查看拨号是否成功，PC1，PC2上网业务是否正常；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@status_page = RouterPageObject::SystatusPage.new(@browser)
						@status_page.open_systatus_page(@browser.url)
						wan_addr = @status_page.get_wan_ip
						wan_type = @status_page.get_wan_type
						puts "WAN状态显示获取的IP地址为：#{wan_addr}".to_gbk
						puts "WAN状态显示接入类型为：#{wan_type}".to_gbk

						assert_match(@ts_tag_ip_regxp, wan_addr, '获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！')
				}

				operate("2、登录DUT管理页面，进入备份与恢复设置页面；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_options_page(@browser.url)
						@options_page.select_recover #进入配置恢复
				}

				operate("3、导入非法格式的配置文件，如：doc，xls，rar，AVI，txt，exe，wmv，cap等类型的文件，查看恢复是否成功，DUT是否会异常，PC1，PC2上网业务是否正常；") {
						#设置配置文件
						tc_config_path = @tc_config_dir+"/config_excel.xlsx"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@options_page.set_import_file(tc_config_path)
						sleep 1
						@options_page.import_btn
						@options_page.wait_until(5, "Error TIP not present") do
								flag = @options_page.recover_err?
								if flag
										@err_msg = @options_page.recover_err
										flag
								end
						end
						assert_equal(@tc_recover_err, @err_msg, "配置文件格式不正確也能导入成功")
						sleep 3

						#设置配置文件
						tc_config_path = @tc_config_dir+"/config_pic.png"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@options_page.set_import_file(tc_config_path)
						sleep 1
						@options_page.import_btn
						@options_page.wait_until(5, "Error TIP not present") do
								flag = @options_page.recover_err?
								if flag
										@err_msg = @options_page.recover_err
										flag
								end
						end
						assert_equal(@tc_recover_err, @err_msg, "配置文件格式不正確也能导入成功")
						sleep 3
				}

				operate("4、导入与配置文件名字相同其它类型的文件，如:1.jpg更改为config.xml，查看恢复是否成功，DUT是否会异常，PC1，PC2上网业务是否正常；") {
						#设置配置文件
						tc_config_path = @tc_config_dir+"/config_pic.dat"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@options_page.set_import_file(tc_config_path)
						sleep 1
						@options_page.import_btn
						@options_page.wait_until(5, "Error TIP not present") do
								flag = @options_page.recover_err?
								if flag
										@err_msg = @options_page.recover_err
										flag
								end
						end
						assert_equal(@tc_recover_err, @err_msg, "配置文件格式不正確也能导入成功")
						sleep 3
				}

				operate("5、编辑正确的配置文件，修改其中相关内容并保存，再导入此文件，选查看恢复是否成功，DUT是否会异常，PC1，PC2上网业务是否正常；") {
						#设置配置文件
						tc_config_path = @tc_config_dir+"/config_change.tgz"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@options_page.set_import_file(tc_config_path)
						sleep 1
						@options_page.import_btn
						@options_page.wait_until(5, "Error TIP not present") do
								flag = @options_page.recover_err?
								if flag
										@err_msg = @options_page.recover_err
										flag
								end
						end
						assert_equal(@tc_recover_err, @err_msg, "配置文件格式不正確也能导入成功")
						sleep 3
				}

				operate("6、从另外一个相同硬件相同软件上备份配置，再导入配置到此DUT上，DUT是否会异常，PC1，PC2上网业务是否正常。") {
						#设置配置文件
						tc_config_path = @tc_config_dir+"/config.tgz"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@options_page.set_import_file(tc_config_path)
						sleep 1
						@options_page.import_btn
						puts "Sleep #{@tc_recover_time} seconds for net reset..."
						sleep @tc_recover_time
						login_ui = @options_page.login_with_exists(@browser.url)
						assert(login_ui, "导入配置重启后未跳转到登录界面")
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
				}
		end

		def clearup
				operate("1 恢复默认配置") {
						#如果错误的配置文件导入成功，这里要等待路由器重启
						@browser.refresh
						wan_page = RouterPageObject::WanPage.new(@browser)
						unless @err_msg == @tc_recover_err
								p "等待路由重启..."
								sleep @tc_recover_time
								if wan_page.login_with_exists(@browser.url)
										rs_login = login_no_default_ip(@browser) #重新登录
										p rs_login[:flag]
										p rs_login[:message]
								end
						end
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
