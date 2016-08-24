#
# description:
#  `&\"\'\s 用户名和密码这五个特殊字符不支持
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.37", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_net_time     = 60
				@tc_wait_time    = 3
				@tc_usr_err      = "帐号不允许有特殊字符且长度在1到32位"
				@tc_pw_err       = "密码不允许有特殊字符且长度在1到32位"
				@tc_usr_null     = "请输入帐号"
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

				operate("3、在用户名处输入特殊字符~!@#$%^&*()_+{}|:<>?等 键盘上33个特殊字符, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "-=[];\\,./~!@#$%^*()_+{}:|<>?"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate(" 4 、 在用户名处输入09, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "0123456789"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate(" 5 、 在用户名处输入az, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "abcdefghijklmopqrstuvwxyz"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate(" 6 、 在用户名处输入AZ, 查看是否允许输入保存 ， 页面显示是否正常 ， 抓包确认拨号是否以设置用户名拨号 ； ") {
						tc_pppoe_usr = "ABCDEFGHIJKLMOPQRSTUVWXYZ"
						tc_pppoe_pw  = "PPPOETEST"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate(" 7 、 在密码处依次重复步骤3 ~7 ， 查看测试结果 。 ") {
						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "-=[];\\,./~!@#$%^*()_+{}:|<>?"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_usr)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "0123456789"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "abcdefghijklmopqrstuvwxyz"
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						puts "输入用户名为#{tc_pppoe_usr}".encode("GBK")
						puts "输入用户名为#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}


		end

		def clearup

				operate("恢复默认DHCP接入") {
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
						unless rs1.class_name =~/ #{@tc_tag_select_state}/
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
