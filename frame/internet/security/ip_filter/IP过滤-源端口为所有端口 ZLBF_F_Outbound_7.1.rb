#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_15.1.14", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time    = 3
				@tc_src_port     = 1
				@tc_src_port_end = 65535
				@tc_tcp_port     = 15801
				@dut_ip          = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
		end

		def process

				operate("1、DUT的接入类型选择为DHCP，保存配置。再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_security_setting(@browser.url) #打开安全界面
						@options_page.firewall_click
						@options_page.open_switch("on", "on", "off", "off")
				}

				operate("2、添加一条过滤规则，其它设置为默认，源端口设置为1-65535，协议为TCP/UDP，保存配置。") {
						@options_page.ipfilter_click
						@options_page.ip_add_item_element.click
						@options_page.ip_filter_src_ip_input(@dut_ip)
						@options_page.ip_filter_src_port_input(@tc_src_port, @tc_src_port_end)
						@options_page.ip_filter_save
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("3、在PC1上用数据包生成器（如：科来数据包生成器，IPTEST）构建，目的端口为1的TCP，UDP的数据包，数据包的IP地址相关信息任意设置，由LAN到WAN发送数据包，PC2上是否能抓到PC1上发出的数据包；") {
						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_src_port, @ts_tcp_server, @tc_tcp_port)
						rescue => ex
								p "发送请求时出现异常".to_gbk
								p ex.message.to_s
								assert(false, "发送请求时出现异常")
						end
						assert_equal("", rs.udp_message, "端口过滤失败！")
				}

				operate("4、编辑步骤2，数据包生成器更改源端口更改为65535，80，21，1024，60000等数据包，查看测试结果；") {
						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_src_port_end, @ts_tcp_server, @tc_tcp_port)
						rescue => ex
								p "发送请求时出现异常".to_gbk
								p ex.message.to_s
								assert(false, "发送请求时出现异常")
						end
						assert_equal("", rs.udp_message, "端口过滤失败！")

						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, 1024, @ts_tcp_server, @tc_tcp_port)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false, "发送请求时出现异常")
						end
						assert_equal("", rs.udp_message, "端口过滤失败！")
				}

				operate("5、重启DUT，执行步骤3，查看测试结果。") {
						@main_page = RouterPageObject::MainPage.new(@browser)
						@main_page.reboot
						@login_page = RouterPageObject::LoginPage.new(@browser)
						login_ui    = @login_page.login_with_exists(@browser.url)
						assert(login_ui, "重启后未跳转到登录界面~")
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_src_port, @ts_tcp_server, @tc_tcp_port)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false, "发送请求时出现异常")
						end
						assert_equal("", rs.udp_message, "端口过滤失败！")
				}


		end

		def clearup
				operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
						options_page = RouterPageObject::OptionsPage.new(@browser)
						options_page.ipfilter_close_sw_del_all_step(@browser.url)
				}
		end

}
