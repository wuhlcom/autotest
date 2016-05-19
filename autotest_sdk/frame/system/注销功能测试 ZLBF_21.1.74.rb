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

		operate("1 ��¼�豸") {
			rs_login = login_recover(@browser, @ts_default_ip)
			assert(rs_login, "·������¼ʧ�ܣ�")
		}

		operate("2 ע������") {
			#firefox
			#/html/body/div[2]/div/ul/li[5]/a
			#//*[@id="logout"]
			#chrome
			#"//*[@id='logout']"
			logout_btn = @browser.link(id: @tc_tag_logout)
			logout_btn.click
			rs2 = @browser.text_field(:name, @ts_tag_login_usr).wait_until_present(@tc_wait_time)
			assert(rs2, 'ע��ʧ�ܣ�')
		}

		operate("3 ע��֮�����µ�¼") {
			#���µ�¼·����
			rs = login_no_default_ip(@browser)
			assert(rs, "ע��֮�����µ�¼ʧ�ܣ�")
		}

	end

	def clearup

	end

}
