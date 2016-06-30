#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi               = DRbObject.new_with_uri(@ts_drb_server) #���߿ͻ���
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2) #WAN��druby����
				#��̬���ɷ���˿�
				@tc_dmz_tcpsrv_port = rand_port(50000, 65534)
				@tc_dmz_udpsrv_port = rand_port(40000, 49999)

		end

		def process
				operate("1����AP������һ��PPPoE���ò��ţ��Զ���ȡIP��ַ�����أ�����DMZ���ܣ�����DMZĿ��IPΪ�¹�PC2��IP��ַ��") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url) #pppoe

						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						@tc_wan_addr = @sys_page.get_wan_ip
						wan_type     = @sys_page.get_wan_type
						puts "WAN IP:#{@tc_wan_addr}"
						puts "WAN TYPE:#{wan_type}"
						assert_match @ip_regxp, @tc_wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'

						rs = ping(@ts_web)
						assert(rs, "�޷���������")
				}

				operate("2����PC2�Ͻ���FTP��������tftp��������") {
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "DMZ Server IP #{@tc_pc_ip}"
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.set_dmz(@tc_pc_ip, @browser.url)
				}

				operate("3����PC1�Ͽ���TFTP�� FTP�ͻ��˷���AP��WAN��IP��ַ,��������Ӧ��ҵ�����ػ����ϴ����ֱ���PC2�����ϣ�Server��ץ���۲죻") {
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_wan_addr=~/#{new_net}/
						}

						#���WAN���������·�ɲ����ڲ����·��
						unless temp
								dst  = @tc_wan_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #����Ϊpptp�����ַ
								@tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#����tcp_server
						puts "����TCP����˿�Ϊ#{@tc_dmz_tcpsrv_port}".to_gbk
						@tc_tcp_thr = tcp_multi_server(@tc_pc_ip, @tc_dmz_tcpsrv_port)
						#����udp server
						puts "����UDP����˿�Ϊ#{@tc_dmz_udpsrv_port}".to_gbk
						@tc_udp_thr = udp_server(@tc_pc_ip, @tc_dmz_udpsrv_port)

						#��WAN�����DMZ����
						rs          = @tc_wan_drb.tcp_client(@tc_wan_addr, @tc_dmz_tcpsrv_port)
						tcp_msg     = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "����dmz��tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_wan_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "����dmz��UDP����ʧ��")
				}

				operate("4����LAN��PC3����TFTP�� FTP�ͻ��˷���AP��WAN��IP��ַ,��������Ӧ��ҵ�����ػ����ϴ����ֱ���PC2�����ϣ�Server��ץ���۲죻") {
						p "��ȡ·����SSID������".to_gbk
						@wifi_page  = RouterPageObject::WIFIPage.new(@browser)
						wifi_config = @wifi_page.modify_ssid_mode_pwd(@browser.url, "autotest")
						#������������
						puts "wifi ssid: #{wifi_config[:ssid]},passwd:#{wifi_config[:pwd]}"
						rs1 = @wifi.connect(wifi_config[:ssid], @ts_wifi_flag, wifi_config[:pwd])
						assert rs1, 'wifi����ʧ��'
						http_get = @wifi.http_client(@ts_wan_pppoe_httpip)
						puts "=================�ڶ����ͻ������ȡ��Message from HTTP server===============".encode("GBK")
						puts http_get
						assert_match(/#{@ts_conn_state}/, http_get, "����dmz�������ͻ������ӵ�WAN��http����ʧ��")
				}

				operate("5����PC2�Ϸ���PC1��WEB�����Ƿ�ɹ���") {
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=========================��һ���ͻ��˻�ȡ��Http Server Message========================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "����dmz�󣬿ͻ���1���ӵ�WAN��http����ʧ��")
				}

				operate("6�������󣬼��DMZ�����Ƿ���Ч��") {
						@wifi_page.close_wifi_page
						@wifi_page.reboot
						rs = @wifi_page.login_with_exists(@browser.url)
						assert rs, "��ת����¼ҳ��ʧ��!"
						#���µ�¼
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						@sys_page.open_systatus_page(@browser.url)
						@tc_wan_addr = @sys_page.get_wan_ip
						puts "������WAN״̬��ʾ��ȡ��IP��ַΪ��#{@tc_wan_addr}".to_gbk

						rs      = @tc_wan_drb.tcp_client(@tc_wan_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================�����Message from TCP server===============".encode("GBK")
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "����·������tcp����ʧ��")

						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_wan_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================������Message from UDP server===============".encode("GBK")
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "����·������UDP����ʧ��")

						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "================�������һ���ͻ��˻�ȡ��Http Server Message==============".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "����dmz�󣬿ͻ���1���ӵ�WAN��http����ʧ��")
				}

				operate("7����PC1 ping WAN�� IP.") {
						#����WAN�������ping·����WAN IP
						rs = @tc_wan_drb.ping(@tc_wan_addr)
						assert(rs, "��WAN��PING·�����ɹ�")
				}

		end

		def clearup

				operate("1 ֹͣtcp udp server") {
						@wifi.netsh_disc_all #�Ͽ�wifi����
						begin
								#ֹͣtcp udp server
								@tc_tcp_thr.kill if !@tc_tcp_thr.nil?&&@tc_tcp_thr.alive?
								@tc_udp_thr.kill if !@tc_tcp_thr.nil?&&@tc_udp_thr.alive?
						rescue => ex
								p ex.message.to_s
						end
				}

				operate("2 �ָ�ΪĬ��SSID") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						if @wifi_page.login_with_exists(@browser.url)
								rs_login = login_no_default_ip(@browser) #���µ�¼
								p rs_login[:flag]
								p rs_login[:message]
						end
						@wifi_page.modify_default_ssid(@browser.url)
						sleep 10
				}

				operate("3 ȡ��DMZ") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.dmz_page(@browser.url)
						dmz_switch_status = @options_page.dmz_switch_status #�õ�dmz����״̬
						if dmz_switch_status == "on"
								@options_page.click_dmz_switch
								@options_page.save_dmz
						end
				}

				operate("4 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

		end
}
