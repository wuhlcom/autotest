#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.10", "level" => "P3", "auto" => "n"}

		def prepare

				@tc_set_time = 1 #配置下发间隔
				@tc_srv_time = 5

				@tc_pub_port1 = 11001
				@tc_pub_port2 = 11002
				@tc_pub_port3 = 11003
				@tc_pub_port4 = 11004
				@tc_pub_port5 = 11005
				@tc_pub_port6 = 11006

				@tc_srv_port1  = 12001
				@tc_srv_port2  = 12002
				@tc_srv_port3  = 12003
				@tc_srv_port4  = 12004
				@tc_srv_port5  = 12005
				@tc_srv_port6  = 12006
				@tc_error_info = "超出限制"
		end

		def process

				operate("1、在AP上配置一条PPPoE内置拨号，自动获取IP地址和网关，启用虚拟服务器功能；") {
#与测试点无关这里不做设置
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

				operate("3、继续添加不同的规则，直到满容量为止；") {
						#添加第二条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port2, @tc_srv_port2, 2)
						#添加第三条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port3, @tc_srv_port3, 3)
						sleep @tc_set_time #增加配置下发间隔，以防配置失败
						#添加第四条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port4, @tc_srv_port4, 4)
						#添加第五条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port5, @tc_srv_port5, 5)
						#添加第六条单端口映射
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port6, @tc_srv_port6, 6)
						#添加第7条单端口映射
						@options_page.add_vps
						# error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						error_tip = @options_page.vps_aui_content_element
						assert(error_tip.exists?, "未弹出错误提示")
						puts "ERROR TIP :#{error_tip.text}".encode("GBK")
						assert_equal(@tc_error_info, error_tip.text, "弹出错误提示")

						#保存已经添加的规则
						puts "保存已经添加规则".encode("GBK")
						@options_page.save_vps
						sleep @tc_srv_time

						#删除按不连续的顺序删除，按5,2,1,3,4来删除
						#查询路由器port_forward规则，即为路由器虚拟服务器规则
						puts "telnet router"
						init_router_obj(@ts_default_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						puts "query port_forward chain"
						rs = router_nat_port_forward(@ts_vps_chain_name) #统一平台版本中链表名称有变动 2016/03/01
						assert(rs[:rules].size==12, "规则条数不正确")
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
						p rule6_tcp = "tcp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
						p rule6_udp = "udp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
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

						rs_rule6_tcp = all_srv_configs.any? { |item| item=~/#{rule6_tcp}/ }
						rs_rule6_udp = all_srv_configs.any? { |item| item=~/#{rule6_udp}/ }
						assert(rs_rule6_tcp&&rs_rule6_udp, "规则6两条配置异常")
				}

				operate("4、重启AP查看规则有没有丢失。") {
						@options_page.refresh
						sleep 2
						@options_page.reboot
						rs = @options_page.login_with_exists(@browser.url)
						assert rs, "重启路由器失败未跳转到登录页面!"
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						#删除按不连续的顺序删除，按5,2,1,3,4来删除
						#查询路由器port_forward规则，即为路由器虚拟服务器规则
						puts "after reboot telnet router"
						init_router_obj(@ts_default_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						puts "after reboot query port_forward chain"
						rs = router_nat_port_forward(@ts_vps_chain_name) #统一平台版本中链表名称有变动 2016/03/01
						assert(rs[:rules].size==12, "规则条数不正确")
						all_srv_configs = rs[:srv_configs]
						puts "after reboot telnet router query rules:"
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
						p rule6_tcp = "tcp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
						p rule6_udp = "udp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
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

						rs_rule6_tcp = all_srv_configs.any? { |item| item=~/#{rule6_tcp}/ }
						rs_rule6_udp = all_srv_configs.any? { |item| item=~/#{rule6_udp}/ }
						assert(rs_rule6_tcp&&rs_rule6_udp, "规则6两条配置异常")
						#断开telnet 连接
						logout_router unless @router.nil?
				}


		end

		def clearup
				operate("1 删除虚拟服务器配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}
		end

}
