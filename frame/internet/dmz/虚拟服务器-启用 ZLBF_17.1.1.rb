#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#��̬���ɷ���˿�
				@tc_vir_tcpsrv_port = rand_port(50000, 65534)
				@tc_pub_tcp_port    = 30000
				@tc_vir_udpsrv_port = rand_port(40000, 49999)
				@tc_pub_udp_port    = 20000

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
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_ip_addr = ip_info[:ip][0]
						puts "Virtual Server IP #{@tc_ip_addr}"
						#���һ���������������
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_ip_addr, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, 1)
						#��ӵڶ������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_ip_addr, @tc_pub_udp_port, @tc_vir_udpsrv_port, 2)
						@options_page.save_vps
				}

				operate("3����PC2�Ͽ���HTTP�� FTP��TELNET��TFTP�ȷ�����PC1�Ͽ���HTTP����") {
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  =ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						#��ѯ��������Ĭ��·���Ƿ����
						routes = @tc_wan_drb.cmd_route_print()
						puts "WAN SERVER Permannet Route Info"
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
						tcp_multi_server(@tc_ip_addr, @tc_vir_tcpsrv_port)
						#����udp server
						udp_server(@tc_ip_addr, @tc_vir_udpsrv_port)
				}

				operate("4��PC1ͨ��WAN�ڷ���PC2�ϵ�HTTP�� FTP��TELNET��TFTP�ȷ��񣬲���PC2�����ϣ�Server��ץ���۲죻") {
						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "���������������UDP����ʧ��")
				}

				operate("5����PC2�Ϸ���PC1��HTTP�����Ƿ�ɹ�������PC1��ץ���۲죻") {
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=========================�ͻ��˻�ȡ��Http Server Message========================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "��������������󣬿ͻ���1���ӵ�WAN��http����ʧ��")
				}


		end

		def clearup

				operate("1 ɾ���������������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}

				operate("2 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

		end

}
