#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.55", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_new_usr    = "adminnew"
				@tc_new_pw     = "adminnew"
				@tc_usr_pw_err = "用户名或密码错误"
		end

		def process

				operate("1、登录DUT管理页面，进入系统工具->密码修改页面；") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "路由器登录失败！")

						@account_page = RouterPageObject::AccountPage.new(@browser)
						puts("修改用户名为：#{@tc_new_usr}".encode("GBK"))
						puts("修改密码为：#{@tc_new_pw}".encode("GBK"))
						@account_page.modify_account(@browser.url, @tc_new_usr, @tc_new_pw)
						rs = @account_page.login_with_exists(@browser.url)
						assert(rs, "修改账户失败")
				}

				operate("2、使用更改前的用户名和密码登录web是否成功；") {
						@account_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)
						errinfo = @account_page.main_error
						puts "ERROR TIP:#{errinfo}".to_gbk
						assert_equal(@tc_usr_pw_err, errinfo, "输入错误帐户或密码登录成功了！")
				}


		end

		def clearup

				operate("1 恢复默认账户") {
						@account_page = RouterPageObject::AccountPage.new(@browser)
						rs = @account_page.login_with_exists(@browser.url)
						if rs #如果当前是登录界面，则先登录
								@account_page.login_with(@tc_new_usr, @tc_new_pw, @browser.url) #新帐户登录
								lan = @account_page.lan?
								if lan
										puts "修改为默认账户!".to_gbk
										@account_page.modify_account(@browser.url, @ts_default_usr, @ts_default_pw) #新账户登录成功则修改账户为默认
								else
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
