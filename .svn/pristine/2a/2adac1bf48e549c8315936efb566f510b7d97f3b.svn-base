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
						@browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_netset).click #外网
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						flag        = false
						#设置wan连接方式为网线连接
						rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
						unless rs1 =~/ #{@ts_tag_select_state}/
								@wan_iframe.span(id: @ts_tag_wired_mode_span).click #网线连接
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
						end
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
						if fire_wall_btn.class_name == "off"
								fire_wall_btn.click
						end
						ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
						if ip_btn.class_name == "off"
								ip_btn.click
						end
						@option_iframe.button(id: @ts_tag_security_save).click #保存
				}

				operate("2、添加一条规则，设置源IP为192.168.100.100，端口为5000，协议为TCP/UDP，保存配置，在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建UDP的数据包，端口为5000，源IP地址192.168.100.100，PC2上是否能抓到PC1上发出的数据包；") {
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_ip_set).click #IP过滤
						@option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
						@option_iframe.span(id: @ts_tag_additem).click #添加新条目
						@option_iframe.text_field(id: @ts_ip_dst_port).set(@tc_server_dst_port_udp)
						@option_iframe.button(id: @ts_tag_save_filter).click #保存
						sleep @tc_wait_time
						ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
						dst_port   = @option_iframe.table(id: @ts_iptable).trs[1][4].text.slice(/(\d+)-/i, 1).to_i
						if (ip_clauses == 1 || dst_port != @tc_server_dst_port_udp)
								assert(false, "生成新条目失败")
						end
						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_client_port, @ts_tcp_server, 15801)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false,"发送请求时出现异常")
						end
						assert_empty(rs.udp_message, "UDP协议过滤失败！")
				}

				operate("3、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，端口为5000，源IP地址为：192.168.100.100，PC2上是否能抓到PC1上发出的数据包。") {
						begin
								rs = HtmlTag::TestTcpClient.new(@ts_tcp_server, 16801)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false,"发送请求时出现异常")
						end
						assert_match("succeed", rs.tcp_message, "TCP协议过滤失败")
				}

				operate("4、编辑步骤2、3，数据包生成器（如科来数据包生成器、IPTEST）构建UDP的数据包，把端口更改为6000，查看测试结果；") {
						@option_iframe.table(id: @ts_iptable).trs[1][7].link(class_name: @ts_tag_edit).click
						@option_iframe.text_field(id: @ts_ip_dst_port1).set(@tc_server_dst_port_tcp)
						@option_iframe.button(id: @ts_tag_save_filter1).click #保存
						sleep @tc_wait_time
						ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
						dst_port   = @option_iframe.table(id: @ts_iptable).trs[1][4].text.slice(/(\d+)-/i, 1).to_i
						if (ip_clauses == 1 || dst_port != @tc_server_dst_port_tcp)
								assert(false, "生成新条目失败")
						end

						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_client_port, @ts_tcp_server, 15801)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false,"发送请求时出现异常")
						end
						assert_match("succeed", rs.udp_message, "更改端口后，UDP协议过滤失败！")
				}

				operate("5、编辑步骤2、3，数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，把源IP设置为192.168.100.200，查看测试结果。") {
						begin
								rs = HtmlTag::TestTcpClient.new(@ts_tcp_server, 16801)
						rescue => ex
								p ex.message.to_s
								p "发送请求时出现异常".to_gbk
								assert(false,"发送请求时出现异常")
						end
						assert_match("failed", rs.tcp_message, "更改端口后，TCP协议过滤失败")
				}


		end

		def clearup
				operate("1、关闭防火墙总开关和IP过滤开关") {
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
						if fire_wall_btn.class_name == "on"
								fire_wall_btn.click
						end
						ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
						if ip_btn.class_name == "on"
								ip_btn.click
						end
						@option_iframe.button(id: @ts_tag_security_save).click #保存
				}

				operate("2、删除所有条目") {
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
						ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
						if ip_clauses > 1 #如果有条目就删除
								@option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
								@option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
						end
				}
		end

}
