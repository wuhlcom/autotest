#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.7", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_srv_time  = 5
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
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
						#关闭上一个页面
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_ip   = @systatus_page.get_wan_ip
						assert_equal(@ts_wan_mode_static, wan_type, '接入类型错误！')
						assert_equal(@ts_staticIp, wan_ip, '静态IP配置失败！')
				}

				operate("2、添加一条虚拟服务器的规则,协议选择TCP/UDP,起始端口设置为10000，终止端口设置为10000，服务IP地址设置为PC2地址，保存；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						#查询PC IP地址
						ip_info       = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip     = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port1, @tc_srv_port1, 1)
				}

				operate("3、重复步骤2，反复添加数条不同规则，添加规则至少5条以上，保存；") {
						#添加第二条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port2, @tc_srv_port2, 2)

						#添加第三条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port3, @tc_srv_port3, 3)

						#添加第四条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port4, @tc_srv_port4, 4)

						#添加第五条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port5, @tc_srv_port5, 5)
						#保存虚拟服务器设置
						@options_page.save_vps
						sleep @tc_srv_time
						#刷新浏览器
						@browser.refresh
						sleep @tc_srv_time
						#打开高级设置,查看配置是否存在
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_vps_page
						rs = @options_page.vps_switch_status
						assert_equal("on", rs, "虚拟服务器开关被关闭")

						virsrv_ip1      = @options_page.vps_ip1
						virsrv_pub_port1= @options_page.vps_common_port1
						vrisrv_port1    = @options_page.vps_private_port1
						assert_equal(@tc_pc_ip, virsrv_ip1, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port1.to_s, virsrv_pub_port1, "查询不到路由器对外端口#{@tc_pub_port1}")
						assert_equal(@tc_srv_port1.to_s, vrisrv_port1, "查询不到虚拟服务器端口#{@tc_srv_port1}")

						virsrv_ip2      = @options_page.vps_ip2
						virsrv_pub_port2= @options_page.vps_common_port2
						vrisrv_port2    = @options_page.vps_private_port2
						assert_equal(@tc_pc_ip, virsrv_ip2, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port2.to_s, virsrv_pub_port2, "查询不到路由器对外端口#{@tc_pub_port2}")
						assert_equal(@tc_srv_port2.to_s, vrisrv_port2, "查询不到虚拟服务器端口#{@tc_srv_port2}")

						virsrv_ip3      = @options_page.vps_ip3
						virsrv_pub_port3= @options_page.vps_common_port3
						vrisrv_port3    = @options_page.vps_private_port3
						assert_equal(@tc_pc_ip, virsrv_ip3, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port3.to_s, virsrv_pub_port3, "查询不到路由器对外端口#{@tc_pub_port3}")
						assert_equal(@tc_srv_port3.to_s, vrisrv_port3, "查询不到虚拟服务器端口#{@tc_srv_port3}")

						virsrv_ip4      = @options_page.vps_ip4_element.value
						virsrv_pub_port4= @options_page.vps_common_port4_element.value
						vrisrv_port4    = @options_page.vps_private_port4_element.value
						assert_equal(@tc_pc_ip, virsrv_ip4, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port4.to_s, virsrv_pub_port4, "查询不到路由器对外端口#{@tc_pub_port4}")
						assert_equal(@tc_srv_port4.to_s, vrisrv_port4, "查询不到虚拟服务器端口#{@tc_srv_port4}")

						virsrv_ip5      = @options_page.vps_ip5
						virsrv_pub_port5= @options_page.vps_common_port5
						vrisrv_port5    = @options_page.vps_private_port5
						assert_equal(@tc_pc_ip, virsrv_ip5, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port5.to_s, virsrv_pub_port5, "查询不到路由器对外端口#{@tc_pub_port5}")
						assert_equal(@tc_srv_port5.to_s, vrisrv_port5, "查询不到虚拟服务器端口#{@tc_srv_port5}")
				}

				operate("4、非顺序删除设置的所有规则，是否能对规则删除成功，使用iptables-t nat-L-nv查看规则是否实际全部删除；") {
						# 删除按不连续的顺序删除 ， 按5, 2, 1, 3, 4 来删除
						# 查询路由器port_forward规则 ， 即为路由器虚拟服务器规则
						puts "telnet router"
						init_router_obj(@ts_default_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						puts "query port_forward chain"
						rs = router_nat_port_forward(@ts_vps_chain_name) #统一平台版本中链表名称有变动 2016/03/01
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
						@options_page.delete_vps(@tc_rule5)
						#保存
						@options_page.save_vps
						sleep @tc_srv_time

						puts "query port_forward chain second"
						rs              = router_nat_port_forward(@ts_vps_chain_name) #统一平台版本中链表名称有变动 2016/03/01
						all_srv_configs = rs[:srv_configs]
						pp all_srv_configs
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
						refute(rs_rule5_tcp&&rs_rule5_udp, "规则5删除失败")

						#删除规则按2，1，3，4的顺序
						option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						vps_table     = option_iframe.table(id: @ts_tag_vps_table)
						vps_trs       = vps_table.trs
						vps_trs[2][6].link.click
						vps_trs[1][6].link.click
						vps_trs[3][6].link.click
						vps_trs[4][6].link.click
						#保存
						@options_page.save_vps
						sleep @tc_srv_time

						puts "query port_forward chain third"
						rs              = router_nat_port_forward(@ts_vps_chain_name) #统一平台版本中链表名称有变动 2016/03/01
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
						unless @browser.span(:id => @ts_tag_netset).exists?
							rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
						end

						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2 删除虚拟服务器配置") {
						@browser.refresh
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}
		end

}
