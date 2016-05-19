#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.7", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time = 5
				@tc_srv_time  = 5
				@tc_net_time  = 50
				@tc_pub_port1 = 10001
				@tc_pub_port2 = 10002
				@tc_pub_port3 = 10003
				@tc_pub_port4 = 10004
				@tc_pub_port5 = 10005
				@tc_srv_port1 = 10001
				@tc_srv_port2 = 10002
				@tc_srv_port3 = 10003
				@tc_srv_port4 = 10004
				@tc_srv_port5 = 10005
		end

		def process

				operate("1、AP的接入类型选择为静态IP，保存配置；") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开外网设置失败")

						#设置有线模式
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						#设置静态IP
						static_radio = @wan_iframe.radio(:id => @ts_tag_wired_static)
						static_radio.click
						sleep @tc_wait_time

						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time

						#关闭上一个页面
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、添加一条虚拟服务器的规则,协议选择TCP/UDP,起始端口设置为10000，终止端口设置为10000，服务IP地址设置为PC2地址，保存；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#查询PC IP地址
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"

						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开虚拟服务器开关
						@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_off).exists?
						#添加一条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip1).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip1).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_port1)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_srv_port1)
				}

				operate("3、重复步骤2，反复添加数条不同规则，添加规则至少5条以上，保存；") {
						#添加第二条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip2).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip2).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port2).set(@tc_pub_port2)
						@advance_iframe.text_field(name: @ts_tag_virpri_port2).set(@tc_srv_port2)

						#添加第三条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip3).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip3).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port3).set(@tc_pub_port3)
						@advance_iframe.text_field(name: @ts_tag_virpri_port3).set(@tc_srv_port3)

						#添加第四条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip4).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip4).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port4).set(@tc_pub_port4)
						@advance_iframe.text_field(name: @ts_tag_virpri_port4).set(@tc_srv_port4)

						#添加第五条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip5).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip5).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port5).set(@tc_pub_port5)
						@advance_iframe.text_field(name: @ts_tag_virpri_port5).set(@tc_srv_port5)
						#保存虚拟服务器设置
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_srv_time
						#刷新浏览器
						@browser.refresh
						sleep @tc_srv_time
						#打开高级设置,查看配置是否存在
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						#虚拟服务器开关
						rs = @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
						assert(rs, "虚拟服务器开关被关闭")

						virsrv_ip1      = @advance_iframe.text_field(name: @ts_tag_virip1).value
						virsrv_pub_port1= @advance_iframe.text_field(name: @ts_tag_virpub_port1).value
						vrisrv_port1    = @advance_iframe.text_field(name: @ts_tag_virpri_port1).value
						assert_equal(@tc_pc_ip, virsrv_ip1, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port1.to_s, virsrv_pub_port1, "查询不到路由器对外端口#{@tc_pub_port1}")
						assert_equal(@tc_srv_port1.to_s, vrisrv_port1, "查询不到虚拟服务器端口#{@tc_srv_port1}")

						virsrv_ip2      = @advance_iframe.text_field(name: @ts_tag_virip2).value
						virsrv_pub_port2= @advance_iframe.text_field(name: @ts_tag_virpub_port2).value
						vrisrv_port2    = @advance_iframe.text_field(name: @ts_tag_virpri_port2).value
						assert_equal(@tc_pc_ip, virsrv_ip2, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port2.to_s, virsrv_pub_port2, "查询不到路由器对外端口#{@tc_pub_port2}")
						assert_equal(@tc_srv_port2.to_s, vrisrv_port2, "查询不到虚拟服务器端口#{@tc_srv_port2}")

						virsrv_ip3      = @advance_iframe.text_field(name: @ts_tag_virip3).value
						virsrv_pub_port3= @advance_iframe.text_field(name: @ts_tag_virpub_port3).value
						vrisrv_port3    = @advance_iframe.text_field(name: @ts_tag_virpri_port3).value
						assert_equal(@tc_pc_ip, virsrv_ip3, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port3.to_s, virsrv_pub_port3, "查询不到路由器对外端口#{@tc_pub_port3}")
						assert_equal(@tc_srv_port3.to_s, vrisrv_port3, "查询不到虚拟服务器端口#{@tc_srv_port3}")

						virsrv_ip4      = @advance_iframe.text_field(name: @ts_tag_virip4).value
						virsrv_pub_port4= @advance_iframe.text_field(name: @ts_tag_virpub_port4).value
						vrisrv_port4    = @advance_iframe.text_field(name: @ts_tag_virpri_port4).value
						assert_equal(@tc_pc_ip, virsrv_ip4, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port4.to_s, virsrv_pub_port4, "查询不到路由器对外端口#{@tc_pub_port4}")
						assert_equal(@tc_srv_port4.to_s, vrisrv_port4, "查询不到虚拟服务器端口#{@tc_srv_port4}")

						virsrv_ip5      = @advance_iframe.text_field(name: @ts_tag_virip5).value
						virsrv_pub_port5= @advance_iframe.text_field(name: @ts_tag_virpub_port5).value
						vrisrv_port5    = @advance_iframe.text_field(name: @ts_tag_virpri_port5).value
						assert_equal(@tc_pc_ip, virsrv_ip5, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port5.to_s, virsrv_pub_port5, "查询不到路由器对外端口#{@tc_pub_port5}")
						assert_equal(@tc_srv_port5.to_s, vrisrv_port5, "查询不到虚拟服务器端口#{@tc_srv_port5}")
				}

				operate("4、非顺序删除设置的所有规则，是否能对规则删除成功，使用iptables-t nat-L-nv查看规则是否实际全部删除；") {
						#删除按不连续的顺序删除，按5,2,1,3,4来删除
						#查询路由器port_forward规则，即为路由器虚拟服务器规则
						puts "telnet router"
						init_router_obj(@ts_default_ip, @ts_default_usr, @ts_default_pw)
						puts "query port_forward chain"
						rs = router_nat_port_forward
						assert(rs[:rules].size==10, "规则条数不正确")
						all_srv_configs = rs[:srv_configs]
						puts "telnet router query rules:"
						pp all_srv_configs
						puts "预期配置的规则如下:".encode("GBK")
						p rule1_tcp = "tcp dpt:#{@tc_pub_port1} to:#{@tc_pc_ip}:#{@tc_srv_port1}"
						p rule1_udp = "udp dpt:#{@tc_pub_port1} to:#{@tc_pc_ip}:#{@tc_srv_port1}"
						p rule2_tcp = "tcp dpt:#{@tc_pub_port2} to:#{@tc_pc_ip}:#{@tc_srv_port2}"
						p rule2_udp = "udp dpt:#{@tc_pub_port2} to:#{@tc_pc_ip}:#{@tc_srv_port2}"
						p rule3_tcp = "tcp dpt:#{@tc_pub_port3} to:#{@tc_pc_ip}:#{@tc_srv_port3}"
						p rule3_udp = "udp dpt:#{@tc_pub_port3} to:#{@tc_pc_ip}:#{@tc_srv_port3}"
						p rule4_tcp = "tcp dpt:#{@tc_pub_port4} to:#{@tc_pc_ip}:#{@tc_srv_port4}"
						p rule4_udp = "udp dpt:#{@tc_pub_port4} to:#{@tc_pc_ip}:#{@tc_srv_port4}"
						p rule5_tcp = "tcp dpt:#{@tc_pub_port5} to:#{@tc_pc_ip}:#{@tc_srv_port5}"
						p rule5_udp = "udp dpt:#{@tc_pub_port5} to:#{@tc_pc_ip}:#{@tc_srv_port5}"
						rs_rule1_tcp = all_srv_configs.any? { |item| item=~/#{rule1_tcp}/ }
						rs_rule1_udp = all_srv_configs.any? { |item| item=~/#{rule1_udp}/ }
						assert(rs_rule1_tcp&&rs_rule1_udp, "规则1两条配置异常")

						rs_rule2_tcp = all_srv_configs.any? { |item| item=~/#{rule2_tcp}/ }
						rs_rule2_udp = all_srv_configs.any? { |item| item=~/#{rule2_udp}/ }
						assert(rs_rule2_tcp&&rs_rule2_udp, "规则2两条配置异常")

						rs_rule3_tcp = all_srv_configs.any? { |item| item=~/#{rule3_tcp}/ }
						rs_rule3_udp = all_srv_configs.any? { |item| item=~/#{rule3_udp}/ }
						assert(rs_rule3_tcp&&rs_rule3_udp, "规则3两条配置异常")

						rs_rule4_tcp = all_srv_configs.any? { |item| item=~/#{rule4_tcp}/ }
						rs_rule4_udp = all_srv_configs.any? { |item| item=~/#{rule4_udp}/ }
						assert(rs_rule4_tcp&&rs_rule4_udp, "规则4两条配置异常")

						rs_rule5_tcp = all_srv_configs.any? { |item| item=~/#{rule5_tcp}/ }
						rs_rule5_udp = all_srv_configs.any? { |item| item=~/#{rule5_udp}/ }
						assert(rs_rule5_tcp&&rs_rule5_udp, "规则5两条配置异常")

						#删除规则5
						@tc_rule5 = "5"
						@advance_iframe.td(text: @tc_rule5).parent.tds[6].link.click
						#保存
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_srv_time

						puts "query port_forward chain second"
						rs              = router_nat_port_forward
						all_srv_configs = rs[:srv_configs]
						pp all_srv_configs
						rs_rule1_tcp    = all_srv_configs.any? { |item| item=~/#{rule1_tcp}/ }
						rs_rule1_udp    = all_srv_configs.any? { |item| item=~/#{rule1_udp}/ }
						assert(rs_rule1_tcp&&rs_rule1_udp, "规则1两条配置异常")

						rs_rule2_tcp = all_srv_configs.any? { |item| item=~/#{rule2_tcp}/ }
						rs_rule2_udp = all_srv_configs.any? { |item| item=~/#{rule2_udp}/ }
						assert(rs_rule2_tcp&&rs_rule2_udp, "规则2两条配置异常")

						rs_rule3_tcp = all_srv_configs.any? { |item| item=~/#{rule3_tcp}/ }
						rs_rule3_udp = all_srv_configs.any? { |item| item=~/#{rule3_udp}/ }
						assert(rs_rule3_tcp&&rs_rule3_udp, "规则3两条配置异常")

						rs_rule4_tcp = all_srv_configs.any? { |item| item=~/#{rule4_tcp}/ }
						rs_rule4_udp = all_srv_configs.any? { |item| item=~/#{rule4_udp}/ }
						assert(rs_rule4_tcp&&rs_rule4_udp, "规则4两条配置异常")

						rs_rule5_tcp = all_srv_configs.any? { |item| item=~/#{rule5_tcp}/ }
						rs_rule5_udp = all_srv_configs.any? { |item| item=~/#{rule5_udp}/ }
						refute(rs_rule5_tcp&&rs_rule5_udp, "规则5删除失败")

						#删除规则2，1，3，4
						@tc_rule2 = "2"
						@tc_rule1 = "1"
						@tc_rule3 = "3"
						@tc_rule4 = "4"
						@advance_iframe.td(text: @tc_rule2).parent.tds[6].link.click
						@advance_iframe.td(text: @tc_rule1).parent.tds[6].link.click
						@advance_iframe.td(text: @tc_rule3).parent.tds[6].link.click
						@advance_iframe.td(text: @tc_rule4).parent.tds[6].link.click
						#保存
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_srv_time

						puts "query port_forward chain third"
						rs              = router_nat_port_forward
						all_srv_configs = rs[:srv_configs]
						# rule_clear = rs[:has_rule]
						# refute(rule_clear,"规则没有全部删除")
						rs_rule1_tcp    = all_srv_configs.any? { |item| item=~/#{rule1_tcp}/ }
						rs_rule1_udp    = all_srv_configs.any? { |item| item=~/#{rule1_udp}/ }
						refute(rs_rule1_tcp&&rs_rule1_udp, "规则2删除失败")

						rs_rule2_tcp = all_srv_configs.any? { |item| item=~/#{rule2_tcp}/ }
						rs_rule2_udp = all_srv_configs.any? { |item| item=~/#{rule2_udp}/ }
						refute(rs_rule2_tcp&&rs_rule2_udp, "规则1删除失败")

						rs_rule3_tcp = all_srv_configs.any? { |item| item=~/#{rule3_tcp}/ }
						rs_rule3_udp = all_srv_configs.any? { |item| item=~/#{rule3_udp}/ }
						refute(rs_rule3_tcp&&rs_rule3_udp, "规则3删除失败")

						rs_rule4_tcp = all_srv_configs.any? { |item| item=~/#{rule4_tcp}/ }
						rs_rule4_udp = all_srv_configs.any? { |item| item=~/#{rule4_udp}/ }
						refute(rs_rule4_tcp&&rs_rule4_udp, "规则4删除失败")
						#断开telnet 连接
						logout_router unless @router.nil?
				}


		end

		def clearup

				operate("1 恢复为默认的接入方式，DHCP接入") {
						#断开telnet 连接
						# logout_router unless @router.nil?
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式为网线连接
						#设置为有线wan
						rs1         =@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        =false
						unless rs1=~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag=true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag=true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}

				operate("2 删除虚拟服务器配置") {
						if !@advance_iframe.nil? && !@advance_iframe.exists?
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						flag=false
						if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
								#关闭虚拟服务器开关
								@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
								flag=true
						end
						if @advance_iframe.text_field(name: @ts_tag_virip1).exists?
								#删除端口映射
								@advance_iframe.button(id: @ts_tag_delvir).click
								flag=true
						end
						if flag
								#保存
								@advance_iframe.button(id: @ts_tag_save_btn).click
								sleep @tc_wait_time
						end
				}
		end

}
