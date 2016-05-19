#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.72", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_pw_length_err = "用户名和密码的长度是4-16个字符"
				@tc_pw_null_err   = "用户名和密码不能为空"
				@tc_usr_err       = "用户名只能是数字字母下划线"
				@tc_wait_time     = 5
				@tc_usr_null      = ""    #空用户名
				@tc_usr_new1      = "123" #过短的用户名
				@tc_usr_new2      = "ABCDEFGHIJKLMNHJK" #过长的用户名
				@tc_usr_new3      = "知路路由器" #中文用户名
		end

		def process

				operate("1、登陆DUT，进入密码修改页面；") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "路由器登录失败！")
						@browser.link(id: @ts_tag_modify_pw).click
						@account_iframe = @browser.iframe(src: @ts_tag_account_manage)
						assert(@account_iframe.exists?, "打开用户名密码修改页面失败！")

						puts("修改用户名为空".encode("GBK"))
						puts("密码为：#{@ts_default_pw}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@tc_usr_null)
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_null_err, error_info, "错误提示内容不正确")
				}

				operate("2、再次更改密码，输入当前密码，在新密码输入框及确认密码输入框中输入中文“汉字”，是否可以保存，且修改成功。") {
						puts("修改用户名为#{@tc_usr_new1.size}字符".encode("GBK"))
						puts("修改用户名为：#{@tc_usr_new1}".encode("GBK"))
						puts("修改密码为：#{@ts_default_pw}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@tc_usr_new1)
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_length_err, error_info, "错误提示内容不正确")

						puts("修改用户名为#{@tc_usr_new2.size}字符".encode("GBK"))
						puts("修改用户名为：#{@tc_usr_new2}".encode("GBK"))
						puts("修改密码为：#{@ts_default_pw}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@tc_usr_new2)
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_length_err, error_info, "错误提示内容不正确")


						puts("修改用户名为：#{@tc_usr_new3}".encode("GBK"))
						puts("修改密码为：#{@tc_usr_new3}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@tc_usr_new3)
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_usr_err, error_info, "错误提示内容不正确")

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

				}
		end

}
