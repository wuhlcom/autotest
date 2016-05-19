#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.54", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_wait_time = 5
				@tc_new_usr   = "adminnew"
				@tc_new_pw    = "adminnew"

		end

		def process

				operate("1、登录DUT管理页面，进入系统工具->密码修改页面；") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "路由器登录失败！")
						@browser.link(id: @ts_tag_modify_pw).click
						@account_iframe = @browser.iframe(src: @ts_tag_account_manage)
						assert(@account_iframe.exists?, "打开用户名密码修改页面失败！")
						puts("修改用户名为：#{@tc_new_usr}".encode("GBK"))
						puts("修改密码为：#{@tc_new_pw}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@tc_new_usr)
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_new_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_new_pw)
						@account_iframe.button(id: @ts_tag_sbm).click
						@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
				}

				operate("2、使用新的用户名和密码重新登陆web是否成功；") {
						if @browser.div(class_name: @ts_aui_state_full).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_logout).click
						@browser.text_field(name: @ts_tag_login_usr).wait_until_present(@tc_wait_time)
						@browser.text_field(name: @ts_tag_login_usr).set(@tc_new_usr)
						@browser.text_field(name: @ts_tag_login_pw).set(@tc_new_pw)
						@browser.button(id: @ts_tag_sbm).click
						rs = @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
						assert(rs, "新账户登录失败!")
				}


		end

		def clearup

				operate("恢复默认账户") {
						if @browser.div(class_name: @ts_aui_state_full).exists?
								@browser.execute_script(@ts_close_div)
						end

						if @browser.link(id: @ts_tag_modify_pw).exists?
								@browser.link(id: @ts_tag_modify_pw).click
								@account_iframe = @browser.iframe(src: @ts_tag_account_manage)
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
								@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
								@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
								@account_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
						end

						if @browser.text_field(name: @ts_tag_login_usr).exists?
								@browser.text_field(name: @ts_tag_login_usr).set(@tc_new_usr)
								@browser.text_field(name: @ts_tag_login_pw).set(@tc_new_pw)
								@browser.button(id: @ts_tag_sbm).click
								unless @browser.div(class_name: @ts_tag_login_error, text: @ts_tag_login_errinfo).exists?
										@browser.link(id: @ts_tag_modify_pw).click
										@account_iframe = @browser.iframe(src: @ts_tag_account_manage)
										@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
										@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
										@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
										@account_iframe.button(id: @ts_tag_sbm).click
										sleep @tc_wait_time
								end
						end
				}

		end

}
