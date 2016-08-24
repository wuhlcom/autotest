#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.8", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_srv_time  = 5
				@tc_pub_port1 = 20001
				@tc_pub_port2 = 20002
				@tc_pub_port3 = 20003
				@tc_pub_port4 = 20004
				@tc_pub_port5 = 20005
				@tc_srv_port1 = 30001
				@tc_srv_port2 = 30002
				@tc_srv_port3 = 30003
				@tc_srv_port4 = 30004
				@tc_srv_port5 = 30005
		end

		def process

				operate("1、AP的接入类型选择为静态IP，保存配置；") {
						#与接入方式无关，这里不设置接入方式
				}

				operate("2、添加一条虚拟服务器的规则,协议选择TCP/UDP,起始端口设置为10000，终止端口设置为10000，服务IP地址设置为PC2地址，保存；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						#查询PC IP地址
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"
						@options_page.open_vps_step(@browser.url) #打开虚拟服务器页面
						@options_page.add_vps #添加一条虚拟服务器规则
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

						#提交
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

						virsrv_ip1      = @options_page.vps_ip1_element.value
						virsrv_pub_port1= @options_page.vps_common_port1_element.value
						vrisrv_port1    = @options_page.vps_private_port1_element.value
						assert_equal(@tc_pc_ip, virsrv_ip1, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port1.to_s, virsrv_pub_port1, "查询不到路由器对外端口#{@tc_pub_port1}")
						assert_equal(@tc_srv_port1.to_s, vrisrv_port1, "查询不到虚拟服务器端口#{@tc_srv_port1}")

						virsrv_ip2      = @options_page.vps_ip2_element.value
						virsrv_pub_port2= @options_page.vps_common_port2_element.value
						vrisrv_port2    = @options_page.vps_private_port2_element.value
						assert_equal(@tc_pc_ip, virsrv_ip2, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port2.to_s, virsrv_pub_port2, "查询不到路由器对外端口#{@tc_pub_port2}")
						assert_equal(@tc_srv_port2.to_s, vrisrv_port2, "查询不到虚拟服务器端口#{@tc_srv_port2}")

						virsrv_ip3      = @options_page.vps_ip3_element.value
						virsrv_pub_port3= @options_page.vps_common_port3_element.value
						vrisrv_port3    = @options_page.vps_private_port3_element.value
						assert_equal(@tc_pc_ip, virsrv_ip3, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port3.to_s, virsrv_pub_port3, "查询不到路由器对外端口#{@tc_pub_port3}")
						assert_equal(@tc_srv_port3.to_s, vrisrv_port3, "查询不到虚拟服务器端口#{@tc_srv_port3}")

						virsrv_ip4      = @options_page.vps_ip4_element.value
						virsrv_pub_port4= @options_page.vps_common_port4_element.value
						vrisrv_port4    = @options_page.vps_private_port4_element.value
						assert_equal(@tc_pc_ip, virsrv_ip4, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port4.to_s, virsrv_pub_port4, "查询不到路由器对外端口#{@tc_pub_port4}")
						assert_equal(@tc_srv_port4.to_s, vrisrv_port4, "查询不到虚拟服务器端口#{@tc_srv_port4}")

						virsrv_ip5      = @options_page.vps_ip5_element.value
						virsrv_pub_port5= @options_page.vps_common_port5_element.value
						vrisrv_port5    = @options_page.vps_private_port5_element.value
						assert_equal(@tc_pc_ip, virsrv_ip5, "查询不到虚拟服务器IP")
						assert_equal(@tc_pub_port5.to_s, virsrv_pub_port5, "查询不到路由器对外端口#{@tc_pub_port5}")
						assert_equal(@tc_srv_port5.to_s, vrisrv_port5, "查询不到虚拟服务器端口#{@tc_srv_port5}")

						#删除按不连续的顺序删除，按5,2,1,3,4来删除
						#查询路由器port_forward规则，即为路由器虚拟服务器规则
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
				}

				operate("4、点击全部删除按键进行删除，使用iptables-t nat-L-nv查看规则是否实际全部删除；") {
						#删除所有端口映射
						@options_page.delete_all_vps
						@options_page.save_vps
						sleep @tc_srv_time
						puts "query port_forward chain third"
						rs         = router_nat_port_forward
						rule_clear = rs[:has_rule]
						refute(rule_clear, "规则没有全部删除")
						#断开telnet 连接
						logout_router unless @router.nil?
				}


		end

		def clearup
				operate("1 删除虚拟服务器配置") {
						#断开telnet 连接
						# logout_router unless @router.nil?
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}
		end

}
