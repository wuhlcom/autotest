#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
	attr = {"id" => "ZLBF_21.1.72", "level" => "P1", "auto" => "n"}

	def prepare
		@tc_tag_logout = "logout"
		@tc_wait_time  = 5
	end

	def process

		operate("1 登录设备") {
			rs_login = login_recover(@browser, @ts_default_ip)
			assert(rs_login, "路由器登录失败！")
		}

		operate("2 注销测试") {
			#firefox
			#/html/body/div[2]/div/ul/li[5]/a
			#//*[@id="logout"]
			#chrome
			#"//*[@id='logout']"
			logout_btn = @browser.link(id: @tc_tag_logout)
			logout_btn.click
			rs2 = @browser.text_field(:name, @ts_tag_login_usr).wait_until_present(@tc_wait_time)
			assert(rs2, '注销失败！')
		}

		operate("3 注销之后重新登录") {
			#重新登录路由器
			rs = login_no_default_ip(@browser)
			assert(rs, "注销之后重新登录失败！")
		}

	end

	def clearup

	end

}
