#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.6", "level" => "P3", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_vir_tcpsrv_port = 10000
				@tc_vir_udpsrv_port = 20000
				@tc_pub_tcp_port    = 10000
				@tc_pub_udp_port    = 20000
				@tc_wait_time       = 3
				@tc_tcp             = "TCP"
				@tc_udp             = "UDP"
		end

		def process

				operate("1��AP�Ľ�������ѡ��ΪDHCP���������ã�") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp_mode(@browser.url)
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						@tc_dhcp_ip = @sys_page.get_wan_ip
						wan_type = @sys_page.get_wan_type
						puts "WAN DHCPC IP ADDR #{@tc_dhcp_ip}"
						assert_match(@ts_tag_ip_regxp, @tc_dhcp_ip, 'dhcp��ȡip��ַʧ�ܣ�')
						assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���')
				}

				operate("2�����һ���������������,Э��ѡ��TCP,��ʼ�˿�����Ϊ10000����ֹ�˿�����Ϊ10000������IP��ַ����ΪPC2��ַ�����棻") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						#��ѯPC IP��ַ
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"
						#�������������
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, 1, @tc_tcp)
						@options_page.save_vps
						sleep @tc_wait_time

						#�鿴���������õ�������Ϣ�Ƿ���ȷ
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						# ����tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#����udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)
				}

				operate("3����PC1�ϴ�IPTEST���ߣ�����ģʽѡ�񡰿ͻ���ģʽ������������ѡ��TCP����Զ�̶˿ں�����Ϊ10000��Զ��IP��ַ����Ϊ��AP WAN��IP��ַ�����������ʼ���ӡ����ֱ���PC1��PC2������ץ���۲죻") {
						#ʹ��ruby socket��ʵ��
						#TCP���ӷ������������
						rs1     = @tc_wan_drb.tcp_client(@tc_dhcp_ip, @tc_pub_tcp_port)
						tcp_msg = rs1.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "����TCP�����������tcp����ʧ��")
						#udp ���ӻ�ʧ�ܣ���Ϊֻ����TCPЭ��
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_dhcp_ip, @tc_pub_tcp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						refute_match(/#{@ts_conn_state}/, udp_msg, "����TCP�����������UDP���ӳɹ�")
				}

				operate("4��ѡ����2����ӵĹ��򣬸���Э��ΪUDP,��ʼ�˿�����Ϊ20000����ֹ�˿�����Ϊ20000������IP��ַ����ΪPC2��ַ���Ƿ��ܶ���ѡ��Ĺ�������޸ģ����棻") {
						#�޸Ĺ���
						@options_page.vps_input(@tc_pc_ip, @tc_pub_udp_port, @tc_vir_udpsrv_port, 1, @tc_udp)
						@options_page.save_vps
						sleep @tc_wait_time+5 #�޸ĺ�Ĺ���Ҫ��Ч��Ҫ��ȼ���
				}

				operate("5����PC1�ϴ�IPTEST���ߣ�����ģʽѡ�񡰿ͻ���ģʽ������������ѡ��UDP����Զ�̶˿ں�����Ϊ20000��Զ��IP��ַ����Ϊ��AP WAN��IP��ַ�����������ʼ���ӡ�,����Ҫ���͵����ݣ���������͡����ֱ���PC1��PC2������ץ���۲죻") {
						#ʹ��ruby socket��ʵ��
						# #TCP���ӷ��������������ʧ��,��Ϊֻ������UDPЭ��
						rs1     = @tc_wan_drb.tcp_client(@tc_dhcp_ip, @tc_pub_udp_port)
						tcp_msg = rs1.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						print "\n"
						refute_match(/#{@ts_conn_state}/, tcp_msg, "����UDP�����������TCP���ӳɹ�")
						#udp ���ӳɹ���
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_dhcp_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "����UDP�����������UDP����ʧ��")
				}
		end

		def clearup
				operate("1 ɾ���������������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}
		end

}
