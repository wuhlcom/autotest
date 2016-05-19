#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.36", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_usr_arr      = ["errname", "admin"]
				@tc_pw_arr       = ["admin", "errpasswd"]
				@tc_null_account = ["", "", "admin"]
				@tc_null_pw      = ["", "admin", ""]
				@tc_usr_pw_err   = "用户名或密码错误"
				@tc_usr_pw_null  = "用户名和密码不能为空"
				@tc_login_time   = 2
		end

		def process
				operate("1 登录测试") {
						rs = ping_recover(@ts_default_ip)
						assert(rs, "无法PING通路由器")
						@browser.goto(@ts_default_ip)
						@main_page = RouterPageObject::MainPage.new(@browser)
						rs         = @main_page.login_with_exists(@browser.url)
						assert(rs, '打开登录页面失败！')
						@tc_usr_arr.each_with_index do |usr, i|
								puts "错误账户密码测试:第#{i+1}组帐户测试".to_gbk
								puts "----usrname:#{usr}"
								puts "----passwd:#{@tc_pw_arr[i]}"
								@main_page.login_with(usr, @tc_pw_arr[i], @browser.url)
								sleep @tc_login_time
								errinfo = @main_page.main_error
								puts "ERROR TIP:#{errinfo}".to_gbk
								assert_equal(@tc_usr_pw_err, errinfo, "输入错误帐户或密码登录成功了！")
						end

						@tc_null_account.each_with_index do |usr, i|
								puts "用户名或密码为空测试：第#{i+1}组帐户测试".to_gbk
								puts "----usrname:#{usr}"
								puts "----passwd:#{@tc_null_pw[i]}"
								@main_page.login_with(usr, @tc_null_pw[i], @browser.url)
								sleep @tc_login_time
								errinfo = @main_page.main_error
								puts "ERROR TIP:#{errinfo}".to_gbk
								assert_equal(@tc_usr_pw_null, errinfo, "输入错误帐户或密码为空登录成功了！")
						end
				}
		end

		def clearup

		end

}
