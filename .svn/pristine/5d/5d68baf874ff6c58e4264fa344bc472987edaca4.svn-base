#
# description:
#  `&\"\'\s 用户名和密码这五个特殊字符不支持
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.37", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_net_time     = 60
				@tc_wait_time    = 3
				@tc_usr_err      = "帐号为1到32位数字、字母和特殊字符(~!@#*()_{}<>?.[]-=^:)"
				@tc_pw_err       = "密码为1到32位数字、字母和特殊字符(~!@#*()_{}<>?.[]-=^:)"
				@tc_usr_null     = "请输入帐号"
				@tc_netreset_div = "成功"
				@tc_net_hint     = "设置成功！正在重启网络中，请稍等..."
		end

		def process

				operate("1、在BAS开启抓包；") {

				}

				operate("2、登陆DUT，进入PPPoE拨号页面；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
				}

				operate("3、在用户名处输入特殊字符~!@#$%^&*()_+{}|:<>?等 键盘上33个特殊字符, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "-=[];\\,./~!@#$%^*()_+{}:|<>?"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入密码为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save
						err_msg = @wan_page.pppoe_err_msg
						assert_equal(@tc_usr_err, err_msg, "提示信息不正确")
				}

				operate(" 4 、 在用户名处输入09, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "0123456789"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入密码为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "使用正常用户名密码拨号后，页面提示错误")
						sleep @tc_net_time
				}

				operate(" 5 、 在用户名处输入az, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "abcdefghijklmopqrstuvwxyz"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入密码为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "使用正常用户名密码拨号后，页面提示错误")
						sleep @tc_net_time
				}

				operate(" 6 、 在用户名处输入AZ, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "ABCDEFGHIJKLMOPQRSTUVWXYZ"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入密码为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "使用正常用户名密码拨号后，页面提示错误")
						sleep @tc_net_time
				}

				operate(" 7 、 在密码处依次重复步骤3 ~7 ， 查看测试结果 。 ") {
						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "-=[];\\,./~!@#$%^*()_+{}:|<>?"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入密码为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save
						err_msg = @wan_page.pppoe_err_msg
						assert_equal(@tc_pw_err, err_msg, "提示信息不正确")

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "0123456789"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入密码为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "使用正常用户名密码拨号后，页面提示错误")
						sleep @tc_net_time

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "abcdefghijklmopqrstuvwxyz"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入密码为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "使用正常用户名密码拨号后，页面提示错误")
						sleep @tc_net_time
				}


		end

		def clearup

				operate("恢复默认DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
