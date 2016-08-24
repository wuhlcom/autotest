#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
	attr = {"id" => "ZLBF_21.1.36", "level" => "P1", "auto" => "n"}
	
	def prepare
		# @tc_usr_arr     = ["errname", "admin", "", "", "admin"]
		# @tc_pw_arr      = ["admin", "errpasswd", "", "admin", ""]
		# @tc_usr_pw_err  = "用户名或密码错误"
		# @tc_usr_pw_null = "用户名和密码不能为空"
		# @tag_div_calss  = "error_text"
		# @wait_for_login = 5
	end
	
	def process
		operate("1 登录测试") {
			# @browser.goto(@ts_default_ip)
			# rs = @browser.text_field(:name, @ts_tag_login_usr).wait_until_present(@wait_for_login)
			# assert rs, '打开登录页面失败！'
			# @tc_usr_arr.each_with_index do |usr, i|
			# 	puts "第#{i+1}组帐户测试".to_gbk
			# 	puts "----usrname:#{usr}"
			# 	puts "----passwd:#{@tc_pw_arr[i]}"
			# 	result = ping_dhcp(@ts_default_ip, @ts_nicname)
			# 	if result==true
			# 		@browser.text_field(:name, @ts_tag_login_usr).set(usr)
			# 		@browser.text_field(:name, @ts_tag_login_pw).set(@tc_pw_arr[i])
			# 		@browser.button(:value, @ts_tag_login_button).click
			# 	else
			# 		result=false
			# 	end
			# 	assert(result, "无法连接路由器！")
			# 	sleep 3
			# 	errinfo = @browser.div(:class, @tag_div_calss).text
			# 	puts "Error info:"
			# 	puts errinfo.to_gbk
			# 	flag = (errinfo=~/#{@tc_usr_pw_err}|#{@tc_usr_pw_null}/)
			# 	assert(flag, "输入错误帐户或密码登录成功了！")
			# end
		}
	end
	
	def clearup
	
	end
	
}
