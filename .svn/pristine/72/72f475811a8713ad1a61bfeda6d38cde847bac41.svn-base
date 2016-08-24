#
# description:
# author:liluping
# 删除规则等待时间过短
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_15.1.18", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time   = 5
				@dut_ip         = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
				@tc_additem_msg = "规则最多16条"
				@tc_srcip_null  = "源IP不能为空"
		end

		def process

				operate("1、DUT的接入类型选择为DHCP，保存配置；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2、进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，在IP过虑界面添加规则，直到不能添加为止，查看是否添加成功，添加数目与最大允许数目是否一致；") {
						rs            = @dut_ip.slice(/(\d+\.\d+\.\d+\.)\d+/i, 1)
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_security_setting(@browser.url)
						@options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
						@options_page.ipfilter_click
						@options_page.ip_add_item_element.click #新增条目
						puts "set ip filter client #{@dut_ip}"
						@options_page.ip_filter_src_ip_input(@dut_ip, @dut_ip)
						@options_page.ip_filter_save
						for n in 2..16
								rule_ip = rs + n.to_s
								@options_page.ip_add_item_element.click #新增条目
								puts "set ip filter client #{rule_ip}"
								@options_page.ip_filter_src_ip_input(rule_ip, rule_ip)
								@options_page.ip_filter_save
								if @options_page.ip_filter_err_msg==@tc_srcip_null #若设置源IP失败就再设置三次
										3.times.each do
												@options_page.ip_filter_src_ip_input(rule_ip, rule_ip)
												@options_page.ip_filter_save
												break if @options_page.ip_filter_err_msg.nil? || @options_page.ip_filter_err_msg==""
										end
								end
								sleep @tc_wait_time
						end
						# 添加到16条后再次点击新增条目，是否有限制提示
						@hint_msg = ""
						@options_page.ip_add_item_element.click #新增条
						sleep 3
						# @options_page.wait_until(10, "error tip not exists") do
						# 		flag = @options_page.ip_err_msg?
						# 		if flag
						# 				@hint_msg = @options_page.ip_err_msg
						# 		end
						# 		flag
						# end
						@hint_msg = @options_page.ip_err_msg
						puts "ERROR INFO:#{@hint_msg}".to_gbk
						assert_equal(@tc_additem_msg, @hint_msg, "提示信息不正确~")
						@options_page.ip_hint_close
				}

				operate("3、使用iptables-nvx-L命令查看所有规则添加与服务限制规则表显示规则数目、端口等是否正确；") {
						filter_item = @options_page.ip_filter_table_element.element.trs.size
						assert_equal(17, filter_item, "规则添加数目不一致！")
				}

				operate("4、使用数据包模拟器模拟匹配第一条，最后一条，及中间若干条规则数据包，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包。") {
						rs = send_http_request(@ts_web)
						refute(rs, "IP过滤失败，客户端ip：#{@dut_ip}被过滤，但仍能访问外网~")
				}

				operate("5、DUT重启后，所有添加规则是否都存在无丢失。") {
						rs = @options_page.login_with_exists(@browser.url)
						if rs
								@options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)
						end
						@options_page.refresh
						sleep @tc_wait_time
						@options_page.reboot
						login_ui = @options_page.login_with_exists(@browser.url)
						assert(login_ui, "重启后未跳转到登录界面~")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@options_page.open_security_setting(@browser.url)
						@options_page.ipfilter_click
						filter_item = @options_page.ip_filter_table_element.element.trs.size
						assert_equal(17, filter_item, "重启后，添加规则数目有变化~")
				}

				operate("6、非顺序删除添加的所有规则，查看删除是否成功，iptables-nvx-L命令查看是否删除成功。") {
						@options_page.ip_filter_table_element.element.trs[1][7].link(class_name: @ts_tag_del).image.click #删除第一条规则
						@options_page.ip_filter_table_element.element.trs[3][7].link(class_name: @ts_tag_del).image.click #删除第三条规则
						sleep @tc_wait_time
						filter_item = @options_page.ip_filter_table_element.element.trs.size
						assert_equal(15, filter_item, "删除两条规则后，总规则数不一致~")
				}

				operate("7、DUT重启后，添加规则是否还存在。") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@options_page.reboot(100)
						login_ui = @login_page.login_with_exists(@browser.url)
						assert(login_ui, "重启后未跳转到登录界面~")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						@options_page.open_security_setting(@browser.url)
						@options_page.ipfilter_click
						filter_item = @options_page.ip_filter_table_element.element.trs.size
						assert_equal(15, filter_item, "重启后，添加规则数有变化~")
				}


		end

		def clearup
				operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
						options_page = RouterPageObject::OptionsPage.new(@browser)
						options_page.ipfilter_close_sw_del_all_step(@browser.url)
				}
		end

}
