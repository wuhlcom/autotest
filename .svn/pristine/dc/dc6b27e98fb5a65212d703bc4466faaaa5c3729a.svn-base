#
# description:
#  密码长度和密码中特殊字符
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.68", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_pw_length_err  = "用户名和密码的长度是4-16个字符"
				@tc_pw_null_err    = "用户名和密码不能为空"
				@tc_pw_notsame_err = "两次密码不一致"
				@tc_pw_content_err = "密码只能是数字和字母"
				@tc_wait_time      = 5
				@tc_new_pw1        = "01234567890123456"
				# @tc_new_pw2        = "0123456789012345"
				@tc_new_pw3        = "123"
				@tc_pw_special1    = "`-=[];'\\,./ !@#"
				@tc_pw_special2    = "$%^&*()_+{}:\"|<>"
				@tc_pw_special3    = "whl?"
				@tc_pw_null        = ""
				@tc_pw_confirm     = "confirmpw"
		end

		def process

				operate("1、登陆DUT，进入密码修改页面；") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "路由器登录失败！")
						@browser.link(id: @ts_tag_modify_pw).click
						@account_iframe = @browser.iframe(src: @ts_tag_account_manage)
						assert(@account_iframe.exists?, "打开用户名密码修改页面失败！")

						puts("修改密码为空".encode("GBK"))
						puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_pw_null)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_null_err, error_info, "错误提示内容不正确")

						puts("修改确认密码为空".encode("GBK"))
						puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_null)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_notsame_err, error_info, "错误提示内容不正确")

						puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						puts("修改密码为:#{@ts_default_pw}".encode("GBK"))
						puts("修改确认密码为:#{@tc_pw_confirm}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_confirm)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_notsame_err, error_info, "错误提示内容不正确")

						puts("修改密码为#{@tc_new_pw1.size}字符".encode("GBK"))
						puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						puts("修改密码为：#{@tc_new_pw1}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_new_pw1)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_new_pw1)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_length_err, error_info, "错误提示内容不正确")
						#最长边界
						# puts("修改密码为#{@tc_new_pw2.size}字符".encode("GBK"))
						# puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						# puts("修改密码为：#{@tc_new_pw2}".encode("GBK"))
						# @account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						# @account_iframe.text_field(id: @ts_tag_adpass).set(@tc_new_pw2)
						# @account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_new_pw2)
						# @account_iframe.button(id: @ts_tag_sbm).click
						# rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						# sleep @tc_wait_time
						# assert(rs, "修改密码为#{@tc_new_pw2.size}字符失败")

						puts("修改密码为#{@tc_new_pw3.size}字符".encode("GBK"))
						puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						puts("修改密码为：#{@tc_new_pw3}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_new_pw3)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_new_pw3)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_length_err, error_info, "错误提示内容不正确")

						puts("修改密码为#{@ts_default_pw.size}字符".encode("GBK"))
						puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						puts("修改密码为：#{@ts_default_pw}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "修改密码为#{@ts_default_pw.size}字符失败")
				}

				operate("2、输入当前密码，在新密码输入框及确认密码输入框中输入由~!@#$%^&*()_+{}|:\"<>?等 键盘上33个特殊字符组合密码字符串 ， 是否可以保存 ， 且修改成功 ； ") {
						puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						puts("修改密码为：#{@tc_pw_special1}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_pw_special1)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_special1)
						@account_iframe.button(id: @ts_tag_sbm).click
						#如果允许特殊字符
						# rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						# sleep @tc_wait_time
						# assert(rs, "修改密码为#{@tc_pw_special1}失败")
						#如果不允许
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_content_err, error_info, "错误提示内容不正确")

						puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						puts("修改密码为：#{@tc_pw_special2}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_pw_special1)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_special1)
						@account_iframe.button(id: @ts_tag_sbm).click
						# rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						# sleep @tc_wait_time
						# assert(rs, "修改密码为#{@tc_pw_special2}失败")
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_content_err, error_info, "错误提示内容不正确")

						puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
						puts("修改密码为：#{@tc_pw_special3}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_pw_special1)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_special1)
						@account_iframe.button(id: @ts_tag_sbm).click
						# rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						# sleep @tc_wait_time
						# assert(rs, "修改密码为#{@tc_pw_special3}失败")
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "弹出错误提示")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("错误提示内容:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_content_err, error_info, "错误提示内容不正确")
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
