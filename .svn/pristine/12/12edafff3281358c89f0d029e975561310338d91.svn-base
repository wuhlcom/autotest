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
				@tc_usr_err      = "帐号不允许有特殊字符且长度在1到32位"
				@tc_pw_err       = "密码不允许有特殊字符且长度在1到32位"
				@tc_usr_null     = "请输入帐号"
				@tc_netreset_div = "成功"
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
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.set_pppoe(tc_pppoe_usr, tc_pppoe_pw, @browser.url)
						@browser.refresh
						sleep @tc_wait_time
				}

				operate(" 4 、 在用户名处输入09, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "0123456789"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.set_pppoe(tc_pppoe_usr, tc_pppoe_pw, @browser.url)
						@browser.refresh
						sleep @tc_wait_time
				}

				operate(" 5 、 在用户名处输入az, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "abcdefghijklmopqrstuvwxyz"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.set_pppoe(tc_pppoe_usr, tc_pppoe_pw, @browser.url)
						@browser.refresh
						sleep @tc_wait_time
				}

				operate(" 6 、 在用户名处输入AZ, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "ABCDEFGHIJKLMOPQRSTUVWXYZ"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.set_pppoe(tc_pppoe_usr, tc_pppoe_pw, @browser.url)
						@browser.refresh
						sleep @tc_wait_time
				}

				operate(" 7 、 在密码处依次重复步骤3 ~7 ， 查看测试结果 。 ") {
						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "-=[];\\,./~!@#$%^*()_+{}:|<>?"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.set_pppoe(tc_pppoe_usr, tc_pppoe_pw, @browser.url)
						@browser.refresh
						sleep @tc_wait_time

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "0123456789"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.set_pppoe(tc_pppoe_usr, tc_pppoe_pw, @browser.url)
						@browser.refresh
						sleep @tc_wait_time

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "abcdefghijklmopqrstuvwxyz"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.set_pppoe(tc_pppoe_usr, tc_pppoe_pw, @browser.url)
						@browser.refresh
						sleep @tc_wait_time
				}


		end

		def clearup

				operate("恢复默认DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
