#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.72", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_pw_length_err = "用户名的长度必须在4到32个字符之间"
				@tc_null_err      = "用户名和密码不能为空"
				@tc_usr_err       = "用户名只能是数字字母下划线"
				@tc_usr_null      = "" #空用户名
				@tc_usr_new1      = "123" #过短的用户名
				@tc_usr_new2      = "ABCDEFGHIJKLMNHJKABCDEFGHIJKLMNHJK" #过长的用户名
				@tc_usr_new3      = "知路路由器" #中文用户名
		end

		def process

				operate("1、登陆DUT，进入密码修改页面；") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "路由器登录失败！")

						@account_page = RouterPageObject::AccountPage.new(@browser)
						@account_page.open_account_page(@browser.url)

						puts("修改用户名为空".encode("GBK"))
						puts("密码为：#{@ts_default_pw}".encode("GBK"))
						@account_page.input_usr(@tc_usr_null)
						@account_page.set_pw(@ts_default_pw) # 输入密码
						@account_page.save
						error_info =@account_page.error_msg
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_null_err, error_info, "错误提示内容不正确")
				}

				operate("2、再次更改密码，输入当前密码，在新密码输入框及确认密码输入框中输入中文“汉字”，是否可以保存，且修改成功。") {
						puts("修改用户名为#{@tc_usr_new1.size}字符".encode("GBK"))
						puts("修改用户名为：#{@tc_usr_new1}".encode("GBK"))
						puts("密码为：#{@ts_default_pw}".encode("GBK"))
						@account_page.input_usr(@tc_usr_new1)
						@account_page.set_pw(@ts_default_pw) # 输入密码
						@account_page.save
						error_info =@account_page.error_msg
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_length_err, error_info, "错误提示内容不正确")

						puts("修改用户名为#{@tc_usr_new2.size}字符".encode("GBK"))
						puts("修改用户名为：#{@tc_usr_new2}".encode("GBK"))
						puts("修改密码为：#{@ts_default_pw}".encode("GBK"))
						@account_page.input_usr(@tc_usr_new2)
						@account_page.set_pw(@ts_default_pw) # 输入密码
						@account_page.save
						error_info =@account_page.error_msg
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_length_err, error_info, "错误提示内容不正确")


						puts("修改用户名为：#{@tc_usr_new3}".encode("GBK"))
						puts("修改密码为：#{@tc_usr_new3}".encode("GBK"))
						@account_page.input_usr(@tc_usr_new3)
						@account_page.set_pw(@ts_default_pw) # 输入密码
						@account_page.save
						error_info =@account_page.error_msg
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_usr_err, error_info, "错误提示内容不正确")

				}


		end

		def clearup
				operate("1 恢复默认账户") {
						@account_page = RouterPageObject::AccountPage.new(@browser)
						rs = @account_page.login_with_exists(@browser.url)
						if rs #如果当前是登录界面，则先登录
								usrnames =[@tc_usr_new1, @tc_usr_new2, @tc_usr_new3]
								flag     =false
								usrnames.each do |usr|
										@account_page.login_with(usr, @ts_default_pw, @browser.url) #新帐户登录
										lan = @account_page.lan?
										if lan
												puts "修改为默认账户!".to_gbk
												@account_page.modify_account(@browser.url, @ts_default_usr, @ts_default_pw) #新账户登录成功则修改账户为默认
												flag=true
												break
										end
								end

								unless flag
										@account_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url) #新帐户登录失败，则尝试使用旧账户登录
										lan = @account_page.lan?
										if lan
												puts "当前账户已经是默认账户!".to_gbk
										else
												puts "账户异常!".to_gbk
										end
								end
						else #如果当前页面不是登录页面，则说已经登录,就直接恢复为默认账户
								puts "直接恢复为默认账户!".to_gbk
								@account_page.modify_account(@browser.url, @ts_default_usr, @ts_default_pw)
						end
				}
		end

}
