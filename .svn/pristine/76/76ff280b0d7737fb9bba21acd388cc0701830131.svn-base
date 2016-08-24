#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.72", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1 登录设备") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "路由器登录失败！")
				}

				operate("2 注销测试") {
						@main_page = RouterPageObject::MainPage.new(@browser)
						@main_page.logout
						rs = @main_page.login_with_exists(@browser.url)
						assert(rs, '注销失败！')
				}

				operate("3 注销之后重新登录") {
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
				}

		end

		def clearup

		end

}
