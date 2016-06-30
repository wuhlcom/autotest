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

				operate("1��AP�Ľ�������ѡ��Ϊ��̬IP���������ã�") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
						#�ر���һ��ҳ��
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_ip   = @systatus_page.get_wan_ip
						assert_equal(@ts_wan_mode_static, wan_type, '�������ʹ���')
						assert_equal(@ts_staticIp, wan_ip, '��̬IP����ʧ�ܣ�')
				}

				operate("2�����һ������������Ĺ���,Э��ѡ��TCP/UDP,��ʼ�˿�����Ϊ10000����ֹ�˿�����Ϊ10000������IP��ַ����ΪPC2��ַ�����棻") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						#��ѯPC IP��ַ
						ip_info       = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip     = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port1, @tc_srv_port1, 1)
				}

				operate("3���ظ�����2���������������ͬ������ӹ�������5�����ϣ����棻") {
						#��ӵڶ������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port2, @tc_srv_port2, 2)

						#��ӵ��������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port3, @tc_srv_port3, 3)

						#��ӵ��������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port4, @tc_srv_port4, 4)

						#��ӵ��������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port5, @tc_srv_port5, 5)
						#�����������������
						@options_page.save_vps
						sleep @tc_srv_time
						#ˢ�������
						@browser.refresh
						sleep @tc_srv_time
						#�򿪸߼�����,�鿴�����Ƿ����
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_vps_page
						rs = @options_page.vps_switch_status
						assert_equal("on", rs, "������������ر��ر�")

						virsrv_ip1      = @options_page.vps_ip1
						virsrv_pub_port1= @options_page.vps_common_port1
						vrisrv_port1    = @options_page.vps_private_port1
						assert_equal(@tc_pc_ip, virsrv_ip1, "��ѯ�������������IP")
						assert_equal(@tc_pub_port1.to_s, virsrv_pub_port1, "��ѯ����·��������˿�#{@tc_pub_port1}")
						assert_equal(@tc_srv_port1.to_s, vrisrv_port1, "��ѯ��������������˿�#{@tc_srv_port1}")

						virsrv_ip2      = @options_page.vps_ip2
						virsrv_pub_port2= @options_page.vps_common_port2
						vrisrv_port2    = @options_page.vps_private_port2
						assert_equal(@tc_pc_ip, virsrv_ip2, "��ѯ�������������IP")
						assert_equal(@tc_pub_port2.to_s, virsrv_pub_port2, "��ѯ����·��������˿�#{@tc_pub_port2}")
						assert_equal(@tc_srv_port2.to_s, vrisrv_port2, "��ѯ��������������˿�#{@tc_srv_port2}")

						virsrv_ip3      = @options_page.vps_ip3
						virsrv_pub_port3= @options_page.vps_common_port3
						vrisrv_port3    = @options_page.vps_private_port3
						assert_equal(@tc_pc_ip, virsrv_ip3, "��ѯ�������������IP")
						assert_equal(@tc_pub_port3.to_s, virsrv_pub_port3, "��ѯ����·��������˿�#{@tc_pub_port3}")
						assert_equal(@tc_srv_port3.to_s, vrisrv_port3, "��ѯ��������������˿�#{@tc_srv_port3}")

						virsrv_ip4      = @options_page.vps_ip4_element.value
						virsrv_pub_port4= @options_page.vps_common_port4_element.value
						vrisrv_port4    = @options_page.vps_private_port4_element.value
						assert_equal(@tc_pc_ip, virsrv_ip4, "��ѯ�������������IP")
						assert_equal(@tc_pub_port4.to_s, virsrv_pub_port4, "��ѯ����·��������˿�#{@tc_pub_port4}")
						assert_equal(@tc_srv_port4.to_s, vrisrv_port4, "��ѯ��������������˿�#{@tc_srv_port4}")

						virsrv_ip5      = @options_page.vps_ip5
						virsrv_pub_port5= @options_page.vps_common_port5
						vrisrv_port5    = @options_page.vps_private_port5
						assert_equal(@tc_pc_ip, virsrv_ip5, "��ѯ�������������IP")
						assert_equal(@tc_pub_port5.to_s, virsrv_pub_port5, "��ѯ����·��������˿�#{@tc_pub_port5}")
						assert_equal(@tc_srv_port5.to_s, vrisrv_port5, "��ѯ��������������˿�#{@tc_srv_port5}")
				}

				operate("4����˳��ɾ�����õ����й����Ƿ��ܶԹ���ɾ���ɹ���ʹ��iptables-t nat-L-nv�鿴�����Ƿ�ʵ��ȫ��ɾ����") {
						# ɾ������������˳��ɾ�� �� ��5, 2, 1, 3, 4 ��ɾ��
						# ��ѯ·����port_forward���� �� ��Ϊ·�����������������
						puts "telnet router"
						init_router_obj(@ts_default_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						puts "query port_forward chain"
						rs = router_nat_port_forward(@ts_vps_chain_name) #ͳһƽ̨�汾�����������б䶯 2016/03/01
						assert(rs[:rules].size==10, "������������ȷ")
						all_srv_configs = rs[:srv_configs]
						puts "telnet router query rules:"
						pp all_srv_configs
						puts "Ԥ�����õĹ�������:".encode("GBK")
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
						assert(rs_rule1_tcp&&rs_rule1_udp, "����1���������쳣")

						rs_rule2_tcp = all_srv_configs.any? { |item| item=~/#{rule2_tcp}/ }
						rs_rule2_udp = all_srv_configs.any? { |item| item=~/#{rule2_udp}/ }
						assert(rs_rule2_tcp&&rs_rule2_udp, "����2���������쳣")

						rs_rule3_tcp = all_srv_configs.any? { |item| item=~/#{rule3_tcp}/ }
						rs_rule3_udp = all_srv_configs.any? { |item| item=~/#{rule3_udp}/ }
						assert(rs_rule3_tcp&&rs_rule3_udp, "����3���������쳣")

						rs_rule4_tcp = all_srv_configs.any? { |item| item=~/#{rule4_tcp}/ }
						rs_rule4_udp = all_srv_configs.any? { |item| item=~/#{rule4_udp}/ }
						assert(rs_rule4_tcp&&rs_rule4_udp, "����4���������쳣")

						rs_rule5_tcp = all_srv_configs.any? { |item| item=~/#{rule5_tcp}/ }
						rs_rule5_udp = all_srv_configs.any? { |item| item=~/#{rule5_udp}/ }
						assert(rs_rule5_tcp&&rs_rule5_udp, "����5���������쳣")

						#ɾ������5
						@tc_rule5 = "5"
						@options_page.delete_vps(@tc_rule5)
						#����
						@options_page.save_vps
						sleep @tc_srv_time

						puts "query port_forward chain second"
						rs              = router_nat_port_forward(@ts_vps_chain_name) #ͳһƽ̨�汾�����������б䶯 2016/03/01
						all_srv_configs = rs[:srv_configs]
						pp all_srv_configs
						rs_rule1_tcp = all_srv_configs.any? { |item| item=~/#{rule1_tcp}/ }
						rs_rule1_udp = all_srv_configs.any? { |item| item=~/#{rule1_udp}/ }
						assert(rs_rule1_tcp&&rs_rule1_udp, "����1���������쳣")

						rs_rule2_tcp = all_srv_configs.any? { |item| item=~/#{rule2_tcp}/ }
						rs_rule2_udp = all_srv_configs.any? { |item| item=~/#{rule2_udp}/ }
						assert(rs_rule2_tcp&&rs_rule2_udp, "����2���������쳣")

						rs_rule3_tcp = all_srv_configs.any? { |item| item=~/#{rule3_tcp}/ }
						rs_rule3_udp = all_srv_configs.any? { |item| item=~/#{rule3_udp}/ }
						assert(rs_rule3_tcp&&rs_rule3_udp, "����3���������쳣")

						rs_rule4_tcp = all_srv_configs.any? { |item| item=~/#{rule4_tcp}/ }
						rs_rule4_udp = all_srv_configs.any? { |item| item=~/#{rule4_udp}/ }
						assert(rs_rule4_tcp&&rs_rule4_udp, "����4���������쳣")

						rs_rule5_tcp = all_srv_configs.any? { |item| item=~/#{rule5_tcp}/ }
						rs_rule5_udp = all_srv_configs.any? { |item| item=~/#{rule5_udp}/ }
						refute(rs_rule5_tcp&&rs_rule5_udp, "����5ɾ��ʧ��")

						#ɾ������2��1��3��4��˳��
						option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						vps_table     = option_iframe.table(id: @ts_tag_vps_table)
						vps_trs       = vps_table.trs
						vps_trs[2][6].link.click
						vps_trs[1][6].link.click
						vps_trs[3][6].link.click
						vps_trs[4][6].link.click
						#����
						@options_page.save_vps
						sleep @tc_srv_time

						puts "query port_forward chain third"
						rs              = router_nat_port_forward(@ts_vps_chain_name) #ͳһƽ̨�汾�����������б䶯 2016/03/01
						all_srv_configs = rs[:srv_configs]
						# rule_clear = rs[:has_rule]
						# refute(rule_clear,"����û��ȫ��ɾ��")
						rs_rule1_tcp    = all_srv_configs.any? { |item| item=~/#{rule1_tcp}/ }
						rs_rule1_udp    = all_srv_configs.any? { |item| item=~/#{rule1_udp}/ }
						refute(rs_rule1_tcp&&rs_rule1_udp, "����2ɾ��ʧ��")

						rs_rule2_tcp = all_srv_configs.any? { |item| item=~/#{rule2_tcp}/ }
						rs_rule2_udp = all_srv_configs.any? { |item| item=~/#{rule2_udp}/ }
						refute(rs_rule2_tcp&&rs_rule2_udp, "����1ɾ��ʧ��")

						rs_rule3_tcp = all_srv_configs.any? { |item| item=~/#{rule3_tcp}/ }
						rs_rule3_udp = all_srv_configs.any? { |item| item=~/#{rule3_udp}/ }
						refute(rs_rule3_tcp&&rs_rule3_udp, "����3ɾ��ʧ��")

						rs_rule4_tcp = all_srv_configs.any? { |item| item=~/#{rule4_tcp}/ }
						rs_rule4_udp = all_srv_configs.any? { |item| item=~/#{rule4_udp}/ }
						refute(rs_rule4_tcp&&rs_rule4_udp, "����4ɾ��ʧ��")
						#�Ͽ�telnet ����
						logout_router unless @router.nil?
				}


		end

		def clearup

				operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						unless @browser.span(:id => @ts_tag_netset).exists?
							rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
						end

						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2 ɾ���������������") {
						@browser.refresh
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}
		end

}
