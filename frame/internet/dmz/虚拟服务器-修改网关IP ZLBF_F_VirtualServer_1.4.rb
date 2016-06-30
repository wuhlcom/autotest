#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.4", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#��̬���ɷ���˿�
				@tc_vir_tcpsrv_port = 41000
				@tc_pub_tcp_port    = 21000
				@tc_wait_time       = 3
				@tc_lan_sameseg_ip  = "192.168.100.2"
				@tc_lan_ip_new      = "192.168.123.1"

		end

		def process

				operate("1���ָ�DUTĬ�����ã����ý�������ΪPPTP��") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						#����PPTP����
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url) #����pptp����

						#��ѯPPTP����״̬
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						@tc_pptp_ip = @sys_page.get_wan_ip
						puts "PPTP��ȡ��IP��ַΪ��#{@tc_pptp_ip}".to_gbk

						wan_type = @sys_page.get_wan_type
						puts "��ѯ����������Ϊ��#{wan_type}".to_gbk

						assert_match @ts_tag_ip_regxp, @tc_pptp_ip, 'PPTP��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���'
				}

				operate("2�����һ��������������򣬱������ã���֤�����Ƿ���Ч��") {
						#��ѯPC IP��ַ
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"
						@options_page.add_vps_step(@browser.url, @tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port,1) #���һ���������������
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						#��ѯ��������Ĭ��·���Ƿ����
						routes = @tc_wan_drb.cmd_route_print()
						puts "WAN Server permanetn route info:"
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_pptp_ip=~/#{new_net}/
						}

						#���·�ɲ����ڲ����·��
						unless temp
								dst  = @tc_pptp_ip.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #����Ϊpptp�����ַ
								cmd_route_add(dst, mask, gw)
						end

						# ����tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						# #TCP���ӷ������������
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
				}

				operate("3���޸����ص�ַΪ��Ĭ�ϵ�ַͬ���ε�������ַ����֤����2����ӵĹ����Ƿ���Ч��") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.lan_ip_config(@tc_lan_sameseg_ip, @browser.url)

						#���µ�¼·����
						unless @browser.text_field(:name, @ts_tag_aduser).exist?
								@browser.cookies.clear
								@browser.goto(@tc_lan_sameseg_ip)
								rs = @browser.text_field(:name, @ts_tag_aduser).exist?
								assert(rs, '·�����޷���¼��')
						end
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						#����·���������PC ��ȡIP��ԭ����ͬ��Ҫ��������tcp����
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip2}"
						unless @tc_pc_ip2==@tc_pc_ip
								puts "�޸�LAN IP Ϊ#{@tc_lan_sameseg_ip}�� ������Virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
						end

						#TCP���ӷ������������
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
				}

				operate("4���޸����ص�ַΪ��Ĭ�ϵ�ַ��ͬ���εĵ�ַ�������з���IP��ַ�Ƿ����޸ĳ���Ӧ���ε�IP��ַ�����޸ĳɹ�����֤�����Ƿ���Ч��") {
						@lan_page.lan_ip_config(@tc_lan_ip_new, @browser.url)
						#���µ�¼·����
						unless @browser.text_field(:name, @ts_tag_aduser).exist?
								@browser.cookies.clear
								@browser.goto(@tc_lan_ip_new)
								rs = @browser.text_field(:name, @ts_tag_aduser).exist?
								assert(rs, '·�����޷���¼��')
						end
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
						#����·���������PC ��ȡIP��ԭ����ͬ��Ҫ��������tcp����
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip3 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip3}"
						unless (@tc_pc_ip3==@tc_pc_ip) && (@tc_pc_ip3==@tc_pc_ip2)
								puts "�޸�LAN IP Ϊ#{@tc_lan_ip_new}�� ������Virtual Server IP #{@tc_pc_ip3}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip3, @tc_vir_tcpsrv_port)
						end
						#TCP���ӷ������������
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
				}

				operate("5���ڲ���4���޸ĳɹ��Ļ����ϣ��ٽ����ص�ַ�޸ĳ�Ĭ�����ε�IP��ַ����֤�����Ƿ���Ч��") {
						@lan_page.lan_ip_config(@ts_default_ip, @browser.url)
						#���µ�¼·����
						rs = @browser.text_field(:name, @ts_tag_aduser).wait_until_present(@tc_wait_time)
						assert rs, '��ת����¼ҳ��ʧ�ܣ�'
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						#����·���������PC ��ȡIP��ԭ����ͬ��Ҫ��������tcp����
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip4 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip4}"
						unless (@tc_pc_ip4==@tc_pc_ip) && (@tc_pc_ip4==@tc_pc_ip2) && (@tc_pc_ip4==@tc_pc_ip3)
								puts "�޸�LAN IP Ϊ#{@ts_default_ip}�� ������Virtual Server IP #{@tc_pc_ip4}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip4, @tc_vir_tcpsrv_port)
						end

						#TCP���ӷ������������
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
				}

		end

		def clearup
				operate("1 �ָ�ΪĬ������") {
						# rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.recover_factory(@browser.url)
						# #�������ʽ�ظ��������ã���ֹ·������¼ʧ�������޷��ָ�Ĭ������
						# lan_ip = ipconfig[@ts_nicname][:gateway][0]
						# telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						# exp_ralink_init
				}
		end

}
