#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.10", "level" => "P3", "auto" => "n"}

		def prepare

				@tc_set_time = 1 #�����·����
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
				@tc_error_info = "��������"
		end

		def process

				operate("1����AP������һ��PPPoE���ò��ţ��Զ���ȡIP��ַ�����أ�����������������ܣ�") {
#����Ե��޹����ﲻ������
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

				operate("3��������Ӳ�ͬ�Ĺ���ֱ��������Ϊֹ��") {
						#��ӵڶ������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port2, @tc_srv_port2, 2)
						#��ӵ��������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port3, @tc_srv_port3, 3)
						sleep @tc_set_time #���������·�������Է�����ʧ��
						#��ӵ��������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port4, @tc_srv_port4, 4)
						#��ӵ��������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port5, @tc_srv_port5, 5)
						#��ӵ��������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_port6, @tc_srv_port6, 6)
						#��ӵ�7�����˿�ӳ��
						@options_page.add_vps
						# error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						error_tip = @options_page.vps_aui_content_element
						assert(error_tip.exists?, "δ����������ʾ")
						puts "ERROR TIP :#{error_tip.text}".encode("GBK")
						assert_equal(@tc_error_info, error_tip.text, "����������ʾ")

						#�����Ѿ���ӵĹ���
						puts "�����Ѿ���ӹ���".encode("GBK")
						@options_page.save_vps
						sleep @tc_srv_time

						#ɾ������������˳��ɾ������5,2,1,3,4��ɾ��
						#��ѯ·����port_forward���򣬼�Ϊ·�����������������
						puts "telnet router"
						init_router_obj(@ts_default_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						puts "query port_forward chain"
						rs = router_nat_port_forward(@ts_vps_chain_name) #ͳһƽ̨�汾�����������б䶯 2016/03/01
						assert(rs[:rules].size==12, "������������ȷ")
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
						p rule6_tcp = "tcp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
						p rule6_udp = "udp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
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

						rs_rule6_tcp = all_srv_configs.any? { |item| item=~/#{rule6_tcp}/ }
						rs_rule6_udp = all_srv_configs.any? { |item| item=~/#{rule6_udp}/ }
						assert(rs_rule6_tcp&&rs_rule6_udp, "����6���������쳣")
				}

				operate("4������AP�鿴������û�ж�ʧ��") {
						@options_page.refresh
						sleep 2
						@options_page.reboot
						rs = @options_page.login_with_exists(@browser.url)
						assert rs, "����·����ʧ��δ��ת����¼ҳ��!"
						#���µ�¼·����
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						#ɾ������������˳��ɾ������5,2,1,3,4��ɾ��
						#��ѯ·����port_forward���򣬼�Ϊ·�����������������
						puts "after reboot telnet router"
						init_router_obj(@ts_default_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						puts "after reboot query port_forward chain"
						rs = router_nat_port_forward(@ts_vps_chain_name) #ͳһƽ̨�汾�����������б䶯 2016/03/01
						assert(rs[:rules].size==12, "������������ȷ")
						all_srv_configs = rs[:srv_configs]
						puts "after reboot telnet router query rules:"
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
						p rule6_tcp = "tcp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
						p rule6_udp = "udp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
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

						rs_rule6_tcp = all_srv_configs.any? { |item| item=~/#{rule6_tcp}/ }
						rs_rule6_udp = all_srv_configs.any? { |item| item=~/#{rule6_udp}/ }
						assert(rs_rule6_tcp&&rs_rule6_udp, "����6���������쳣")
						#�Ͽ�telnet ����
						logout_router unless @router.nil?
				}


		end

		def clearup
				operate("1 ɾ���������������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}
		end

}
