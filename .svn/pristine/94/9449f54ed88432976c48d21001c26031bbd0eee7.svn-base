#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_15.1.7", "level" => "P2", "auto" => "n"}

		def prepare
				@dut_ip                 = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
				@tc_wait_time           = 3
				@tc_server_dst_port_tcp = 16801
				@tc_server_dst_port_udp = 15801
				@tc_client_port         = 5000
		end

		def process

				operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_security_page_step(@browser.url) #进入安全页面
						@options_page.open_switch("on", "on", "off", "off") #打开防火墙，ip过滤总开关
				}

				operate("2、添加一条规则，设置源IP为192.168.100.100，端口为5000，协议为TCP/UDP，保存配置，在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建UDP的数据包，端口为5000，源IP地址192.168.100.100，PC2上是否能抓到PC1上发出的数据包；") {
						@options_page.ipfilter_click #打开IP过滤页面
						@options_page.ip_add_item_element.click #添加新条目
						@options_page.ip_filter_src_ip_input(@dut_ip)
						@options_page.ip_filter_dst_port_input(@tc_server_dst_port_udp)
						@options_page.ip_save
						sleep @tc_wait_time

						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_client_port, @ts_tcp_server, @tc_server_dst_port_udp)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false,"发送请求时出现异常")
						end
						p "请求返回：#{rs.udp_message}".to_gbk
						assert_empty(rs.udp_message, "UDP协议过滤失败！")
				}

				operate("3、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，端口为5000，源IP地址为：192.168.100.100，PC2上是否能抓到PC1上发出的数据包。") {
						begin
								rs = HtmlTag::TestTcpClient.new(@ts_tcp_server, @tc_server_dst_port_udp)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false,"发送请求时出现异常")
						end
						p "请求返回：#{rs.tcp_message}".to_gbk
						assert_match("failed", rs.tcp_message, "TCP协议过滤失败")
				}

				operate("4、编辑步骤2、3，数据包生成器（如科来数据包生成器、IPTEST）构建UDP的数据包，把端口更改为6000，查看测试结果；") {
						@options_page.ip_filter_table_element.element.trs[1][7].link(class_name: @ts_tag_edit).image.click #编辑第一条规则
						@options_page.ip_filter_dst_port1_input(@tc_server_dst_port_tcp) #修改目的端口, 编辑状态text_field不使用原来的id
						@options_page.ip_save1 #编辑状态保存按钮不使用原来的id
						sleep @tc_wait_time

						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_client_port, @ts_tcp_server, @tc_server_dst_port_udp)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false,"发送请求时出现异常")
						end
						p "请求返回：#{rs.udp_message}".to_gbk
						assert_match("succeed", rs.udp_message, "更改端口后，UDP协议过滤失败！")
				}

				operate("5、编辑步骤2、3，数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，把源IP设置为192.168.100.200，查看测试结果。") {
						begin
								rs = HtmlTag::TestTcpClient.new(@ts_tcp_server, @tc_server_dst_port_udp)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false,"发送请求时出现异常")
						end
						p "请求返回：#{rs.tcp_message}".to_gbk
						refute_match("failed", rs.tcp_message, "更改端口后，TCP协议过滤失败")
				}


		end

		def clearup
				operate("1、关闭防火墙总开关和IP过滤开关") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						options_page = RouterPageObject::OptionsPage.new(@browser)
						rs = options_page.login_with_exists(@browser.url)
						if rs
								options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)
						end
						options_page.ipfilter_close_sw_del_all_step(@browser.url)
				}

		end

}
