#
# description:
#用户名长为1-32字节
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.36", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_net_time     = 60
				@tc_wait_time    = 2
				@tc_usr_err      = "帐号不允许有特殊字符且长度在1到32位"
				@tc_pw_err       = "密码不允许有特殊字符且长度在1到32位"
				@tc_usr_null     = "请输入帐号"
				@tc_pw_null      = "请输入密码"
				@tc_netreset_div = "成功"
		end

		def process

				operate("1、在BAS开启抓包；") {

				}

				operate("2、登陆DUT，进入PPPoE拨号页面；") {
						#设置为PPPOE拨号
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开外网设置失败")
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end
				}

				operate("3、在用户名与密码处分别输入1个字节字符，查看是否可以保存，拔号是否以设置用户名与密码拨号；") {
						tc_pppoe_usr = "1"
						tc_pppoe_pw  = "1"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip     = @wan_iframe.p(id: @ts_tag_wan_err)
						@tc_error_tip = error_tip.text
						assert_empty(@tc_error_tip, "设置失败!")
						puts "set pppoe mode,Waiting for net reset..."
						sleep @tc_net_time
				}

				operate("4、不输入用户名，输入1个字节字符的密码，查看是否可以保存，拔号是否以设置用户名与密码拨号；") {
						tc_pppoe_usr = ""
						tc_pppoe_pw  = "a"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为空".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_wan_err)
						p "错误提示内容:#{error_tip.text}".encode("GBK")
						assert(error_tip.exists?, "未出现提示")
						assert_equal(@tc_usr_null, error_tip.text, "提示内容不正确")
				}

				operate("5、输入1个字节字符的用户名，不输入密码，查看是否可以保存，拔号是否以设置用户名与密码拨号；") {
						tc_pppoe_usr = "space"
						tc_pppoe_pw  = ""
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为空".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @wan_iframe.p(id: @ts_tag_wan_err)
						p "错误提示内容:#{error_tip.text}".encode("GBK")
						assert(error_tip.exists?, "未出现提示")
						assert_equal(@tc_pw_null, error_tip.text, "提示内容不正确")
				}

				operate("6、在用户名输入32字节，查看是否可以保存，拨号是否以设置用户名与密码拨号；") {
						#用户名为32字节
						tc_pppoe_usr = "zhilu_pppoe_test_account@long.cn"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @wan_iframe.p(id: @ts_tag_wan_err)
						assert_empty(error_tip.text, "设置失败!")
						puts "set pppoe mode,Waiting for net reset..."
						sleep @tc_net_time

						#密码最长为32字节
						tc_pppoe_usr = "zhilu"
						tc_pppoe_pw  = "P"*32
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @wan_iframe.p(id: @ts_tag_wan_err)
						assert_empty(error_tip.text, "设置失败!")
						puts "set pppoe mode,Waiting for net reset..."
						sleep @tc_net_time
				}

				operate("7、在用户名输入33字节，查看是否可以保存，拨号是否以设置用户名与密码拨号；") {
						#用户名最长为32字节，输入33字节
						tc_pppoe_usr = "zhilu_pppoe_test_account@long.cn1"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_wan_err)
						p "错误提示内容:#{error_tip.text}".encode("GBK")
						assert(error_tip.exists?, "未出现提示")
						assert_equal(@tc_usr_err, error_tip.text, "提示内容不正确")

						#用户名最长为32字节
						tc_pppoe_usr = "zhilu"
						tc_pppoe_pw  = "P"*33
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_wan_err)
						p "错误提示内容:#{error_tip.text}".encode("GBK")
						assert(error_tip.exists?, "未出现提示")
						assert_equal(@tc_pw_err, error_tip.text, "提示内容不正确")
				}


		end

		def clearup
				operate("1 恢复默认DHCP接入") {
						@browser.refresh
						sleep @tc_wait_time
						if @browser.span(:id => @ts_tag_netset).exists?
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						flag = false
						#设置wan连接方式为网线连接
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/#{@tc_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag = true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						#设置WIRE WAN为DHCP模式
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_net_time
						end
				}
		end

}
