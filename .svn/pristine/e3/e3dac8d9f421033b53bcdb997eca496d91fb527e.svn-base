#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.73", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_login_timeout = 5*60+30
				@tc_refresh_time  = 10
		end

		def process

				operate("1、登陆DUT，进入密码修改页面；") {
					rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
						assert(rs_login, "路由器登录失败！")
				}

				operate("2、超时为15分钟，检查不操作时间超过15分钟，是否需要重新登录认证；") {
						#超时时间为5分钟05秒
						@account_page = RouterPageObject::AccountPage.new(@browser)
						logout        = false
						33.times do |i|
								logout= @account_page.login_with_exists(@browser.url)
								puts "sleep #{@tc_refresh_time*(i+1)} seconds for router timeout ..."
								sleep @tc_refresh_time
								break if logout
						end
						assert(logout, "等待#{@tc_login_timeout}seconds后路由器能未超时")
				}

		end

		def clearup

		end

}
