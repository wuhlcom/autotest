#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_15.1.10", "level" => "P2", "auto" => "n"}

		def prepare
				@dut_ip        = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
				@lose_efficacy = "失效"
				@tc_wait_time  = 3
		end

		def process

				operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)

						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_security_setting(@browser.url)
						@options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
				}

				operate("2、启用IP过滤功能，设置源IP为192.168.100.100，端口为1-65535，协议为TCP/UDP，设置状态为生效，保存配置，PC1能否访问外网") {
						@options_page.ipfilter_click
						@options_page.ip_add_item_element.click #新增条目
						@options_page.ip_filter_src_ip_input(@dut_ip)
						@options_page.ip_filter_save
						response = send_http_request(@ts_web)
						refute(response, "IP过滤失败，本机IP已过滤状态为生效时，但可以访问外网~")
				}

				operate("3、重启AP，PC1能否访问外网") {
						@options_page.refresh
						sleep @tc_wait_time
						@options_page.reboot
						login_ui = @options_page.login_with_exists(@browser.url)
						assert(login_ui, "重启后未跳转到登录界面~")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						response = send_http_request(@ts_web)
						refute(response, "重启后IP过滤失败，可以访问外网~")
				}

				operate("4、编辑步骤2添加的规则，把状态修改为失效，保存，PC1能否访问外网") {
						@options_page.open_security_setting(@browser.url)
						@options_page.ipfilter_click
						@options_page.ip_filter_table_element.element.trs[1][7].link(class_name: @ts_tag_edit).image.click #编辑第一条规则
						@options_page.ip_status_type1_element.select(/#{@lose_efficacy}/)
						@options_page.ip_save1
						sleep @tc_wait_time
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						puts "过滤规则状态修改为失效后，验证是否能访问外网~".to_gbk
						response = send_http_request(@ts_web)
						assert(response, "IP过滤失败，过滤规则状态修改为失效后，PC1无法访问外网~")
				}

				operate("5、重启AP,PC1能否访问外网") {
						@options_page.refresh
						sleep 2
						@options_page.reboot
						login_ui = @options_page.login_with_exists(@browser.url)
						assert(login_ui, "重启后未跳转到登录界面~")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						response = send_http_request(@ts_web)
						assert(response, "重启后IP过滤失败，不能访问外网~")
				}


		end

		def clearup
				operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
						options_page = RouterPageObject::OptionsPage.new(@browser)
						options_page.ipfilter_close_sw_del_all_step(@browser.url)
				}
		end

}
