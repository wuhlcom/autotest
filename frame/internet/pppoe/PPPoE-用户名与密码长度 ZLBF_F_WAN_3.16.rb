#
# description:
#用户名长为1-32字节
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.36", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_net_time     = 60
				@tc_wait_time    = 2
				@tc_usr_err      = "帐号为1到32位数字、字母和特殊字符(~!@#*()_{}<>?.[]-=^:)"
				@tc_pw_err       = "密码为1到32位数字、字母和特殊字符(~!@#*()_{}<>?.[]-=^:)"
				@tc_usr_null     = "请输入帐号"
				@tc_pw_null      = "请输入密码"
				@tc_netreset_div = "成功"
		end

		def process

				operate("1、在BAS开启抓包；") {

				}

				operate("2、登陆DUT，进入PPPoE拨号页面；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
				}

				operate("3、在用户名与密码处分别输入1个字节字符，查看是否可以保存，拔号是否以设置用户名与密码拨号；") {
						@wan_page.open_wan_page(@browser.url)
						@wan_page.wire_element.click #选择网线连接
						@wan_page.pppoe_dial_element.click #选择pppoe
						tc_pppoe_usr = "1"
						tc_pppoe_pw  = "1"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save #保存
						sleep @tc_wait_time
						@tc_error_tip = @wan_page.pppoe_err_msg
						assert_empty(@tc_error_tip, "设置失败!")
						puts "set pppoe mode,Waiting for net reset..."
						sleep @tc_net_time
				}

				operate("4、不输入用户名，输入1个字节字符的密码，查看是否可以保存，拔号是否以设置用户名与密码拨号；") {
						@wan_page.open_wan_page(@browser.url)
						@wan_page.wire_element.click #选择网线连接
						@wan_page.pppoe_dial_element.click #选择pppoe
						tc_pppoe_usr = ""
						tc_pppoe_pw  = "a"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为空".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save #保存
						sleep @tc_wait_time
						error_tip = @wan_page.pppoe_err_msg_element
						p "错误提示内容:#{error_tip.text}".encode("GBK")
						assert(error_tip.exists?, "未出现提示")
						assert_equal(@tc_usr_null, error_tip.text, "提示内容不正确")
				}

				operate("5、输入1个字节字符的用户名，不输入密码，查看是否可以保存，拔号是否以设置用户名与密码拨号；") {
						tc_pppoe_usr = "space"
						tc_pppoe_pw  = ""
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为空".encode("GBK")
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save #保存
						sleep @tc_wait_time
						error_tip = @wan_page.pppoe_err_msg_element
						p "错误提示内容:#{error_tip.text}".encode("GBK")
						assert(error_tip.exists?, "未出现提示")
						assert_equal(@tc_pw_null, error_tip.text, "提示内容不正确")
				}

				operate("6、在用户名输入32字节，查看是否可以保存，拨号是否以设置用户名与密码拨号；") {
						#用户名为32字节
						tc_pppoe_usr = "zhilu_pppoe_test_account@long.cn"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save #保存
						sleep @tc_wait_time
						error_tip = @wan_page.pppoe_err_msg_element
						assert_empty(error_tip.text, "设置失败!")
						puts "set pppoe mode,Waiting for net reset..."
						sleep @tc_net_time

						#密码最长为32字节
						@wan_page.open_wan_page(@browser.url)
						@wan_page.wire_element.click #选择网线连接
						@wan_page.pppoe_dial_element.click #选择pppoe
						tc_pppoe_usr = "zhilu"
						tc_pppoe_pw  = "P"*32
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save #保存
						sleep @tc_wait_time
						error_tip = @wan_page.pppoe_err_msg_element
						assert_empty(error_tip.text, "设置失败!")
						puts "set pppoe mode,Waiting for net reset..."
						sleep @tc_net_time
				}

				operate("7、在用户名输入33字节，查看是否可以保存，拨号是否以设置用户名与密码拨号；") {
						@wan_page.open_wan_page(@browser.url)
						@wan_page.wire_element.click #选择网线连接
						@wan_page.pppoe_dial_element.click #选择pppoe
						#用户名最长为32字节，输入33字节
						tc_pppoe_usr = "zhilu_pppoe_test_account@long.cn1"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save #保存
						sleep @tc_wait_time
						error_tip = @wan_page.pppoe_err_msg_element
						p "错误提示内容:#{error_tip.text}".encode("GBK")
						assert(error_tip.exists?, "未出现提示")
						assert_equal(@tc_usr_err, error_tip.text, "提示内容不正确")

						#用户名最长为32字节
						tc_pppoe_usr = "zhilu"
						tc_pppoe_pw  = "P"*33
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #输入账号密码
						@wan_page.save #保存
						sleep @tc_wait_time
						error_tip = @wan_page.pppoe_err_msg_element
						p "错误提示内容:#{error_tip.text}".encode("GBK")
						assert(error_tip.exists?, "未出现提示")
						assert_equal(@tc_pw_err, error_tip.text, "提示内容不正确")
				}


		end

		def clearup
				operate("1 恢复默认DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
