#
# description:
# tcp�������׳�������ʧ�ܵ�����
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.9", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#��̬���ɷ���˿�
				@tc_vir_tcpsrv_port = 53581 #rand_port(50000, 65534)
				@tc_pub_tcp_port    = 30001
				@tc_vir_udpsrv_port = 40448 #rand_port(40000, 49999)
				@tc_pub_udp_port    = 20001
				@tc_wait_time       = 3
				@tc_udp_data_time   = 30
		end

		def process

				operate("1����AP������һ��PPPoE���ò��ţ��Զ���ȡIP��ַ�����أ�����������������ܣ�") {
						@sys_page     = RouterPageObject::SystatusPage.new(@browser)
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@wan_page     = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
						#�鿴Wan ip��ַ
						@sys_page.open_systatus_page(@browser.url)
						@tc_pppoe_addr = @sys_page.get_wan_ip
						puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{@tc_pppoe_addr}".to_gbk
				}

				operate("2����AP��������ӷ���FTP(TCP�˿�Ϊ20��21)��HTTP(TCP�˿�Ϊ80)��TELNET(TCP�˿�Ϊ23)��TFTP(UDP�˿�Ϊ69)��,������IP��ַ����ΪPC2��IP��ַ�ȹ���,���棻") {
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "Virtual Server IP #{@tc_pc_ip}"
						# ���һ���������������
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, 1)
						# ��ӵڶ������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_udp_port, @tc_vir_udpsrv_port, 2)
						@options_page.save_vps
				}

				operate("3��PC1����PC2�����FTP��HTTP��TELNET/TFTP��������") {
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_pppoe_addr=~/#{new_net}/
						}

						#���·�ɲ����ڲ����·��
						unless temp
								dst  = @tc_pppoe_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #����Ϊpptp�����ַ
								@tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#����tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#����udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)
						sleep @tc_wait_time

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						puts tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						puts udp_msg
						assert_match(/#{@ts_conn_state}/, udp_msg, "���������������UDP����ʧ��")
				}

				operate("4���ر�AP������������أ�PC1����PC2�����FTP��HTTP��TELNET/TFTP��������") {
						@options_page.close_vps_btn #�رտ���
						@options_page.save_vps
						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================After close portmapping Message from TCP server==============="
						puts tcp_msg
						refute_match(/#{@ts_conn_state}/, tcp_msg, "�ر������������tcp���ӳɹ�")
						#�Ѿ�������udp�����ڷ���رպ�һ��ʱ��������ͨ�ţ�����һ����ʱ�����޷�ͨ����
						puts "Waiting for UDP...."
						sleep @tc_udp_data_time
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================After close portmapping Message from UDP server==============="
						puts udp_msg
						refute_match(/#{@ts_conn_state}/, udp_msg, "�ر������������UDP���ӳɹ� ")
				}

				operate("5������AP��PC1����PC2�����FTP��HTTP��TELNET/TFTP��������") {
						@options_page.refresh
						sleep 2
						@options_page.reboot
						#���µ�¼·����
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "������δ��ת����¼����")
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						#�鿴Wan ip��ַ
						@sys_page.open_systatus_page(@browser.url)
						@tc_pppoe_addr = @sys_page.get_wan_ip
						puts "������WAN״̬��ʾ��ȡ��IP��ַΪ��#{@tc_pppoe_addr}".to_gbk

						#����·���������PC ��ȡIP��ԭ����ͬ��Ҫ��������tcp����
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip2}"
						unless (@tc_pc_ip2==@tc_pc_ip)
								puts "����·������ ������Virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
								#����udp server
								udp_server(@tc_pc_ip2, @tc_vir_udpsrv_port)
						end

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================After reboot, Message from TCP server==============="
						print tcp_msg
						refute_match(/#{@ts_conn_state}/, tcp_msg, "�ر������������tcp���ӳɹ�")
						#�ر�
						puts "Waiting for UDP...."
						sleep @tc_udp_data_time
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================After reboot,Message from UDP server==============="
						puts udp_msg
						refute_match(/#{@ts_conn_state}/, udp_msg, "�ر������������UDP���ӳɹ�")
				}

		end

		def clearup
				operate("1 ɾ���������������") {
						# sleep
						rs = @options_page.login_with_exists(@browser.url)
						if rs
								rs_login = login_no_default_ip(@browser) #���µ�¼
								p rs_login[:flag]
								p rs_login[:message]
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}

				operate("2 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
