#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.2", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#��̬���ɷ���˿�
				@tc_dmz_tcpsrv_port = rand_port(50000, 65534)
				@tc_dmz_udpsrv_port = rand_port(40000, 49999)
				@tc_wait_time       = 3
				#dmz�رպ��Ѿ����͹�udp���ݵĶ˿���Ҫ�ȴ������Ӳ���Ч
				#�������˿�������Ч
				@tc_udp_data_time   = 180
		end

		def process

				operate("1����AP������һ��PPTP���ò��ţ��Զ���ȡIP��ַ�����أ�����DMZ���ܣ�����DMZĿ��IPΪ�¹�PC2��IP��ַ��") {
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@login_page = RouterPageObject::LoginPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						lan_ip = @sys_page.get_lan_ip
						#���·��������Ĭ��lanip�Ȼָ�ΪĬ��ip
						unless lan_ip =~/#{@ts_default_ip}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@options_page.recover_factory(@browser.url) #�ָ���������
								rs = @login_page.login_with_exists(@browser.url)
								assert rs, "�ָ��������ú�δ��ת��·������¼ҳ��!"
								rs_login = login_no_default_ip(@browser) #���µ�¼
								assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
						end
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@options_page.set_pptp(@ts_pptp_server_ip,@ts_pptp_usr,@ts_pptp_pw,@browser.url) #����pptp����
				}

				operate("2����PC2�Ͻ���FTP��������tftp��������") {
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@pc_ip_addr = ip_info[:ip][0]
						puts "DMZ Server IP #{@pc_ip_addr}"
						@options_page.set_dmz(@pc_ip_addr, @browser.url)
				}

				operate("3����PC1�Ͽ���TFTP�� FTP�ͻ��˷���AP��WAN��IP��ַ,��������Ӧ��ҵ�����ػ����ϴ����ֱ���PC2�����ϣ�Server��ץ���۲죻") {
						#�鿴Wan ip��ַ
						@sys_page.open_systatus_page(@browser.url)
						@tc_ppptp_addr = @sys_page.get_wan_ip
						puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{@tc_ppptp_addr}".to_gbk

						#lan����wan
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=================�ͻ��˻�ȡ��Http Server Message=================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "����dmz�󣬿ͻ���1���ӵ�WAN��http����ʧ��")

						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  =ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_ppptp_addr=~/#{new_net}/
						}

						#���·�ɲ����ڲ����·��
						unless temp
								dst  = @tc_ppptp_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip
								@tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#����tcp_server
						@tc_tcp_srvthr = tcp_multi_server(@pc_ip_addr, @tc_dmz_tcpsrv_port)
						#����udp server
						@tc_udp_srvthr = udp_server(@pc_ip_addr, @tc_dmz_udpsrv_port)
				}

				operate("4����PC2�Ϸ���PC1��WEB�����Ƿ�ɹ���") {
						#wan����lan dmz
						rs      = @tc_wan_drb.tcp_client(@tc_ppptp_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						puts tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "����dmz��tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_ppptp_addr, @tc_dmz_udpsrv_port, "PPTP")
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						puts udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "����dmz��UDP����ʧ��")
				}

				operate("5������DMZ���ظ�����3��4��") {
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_dmz_page
						dmz_switch_status = @options_page.dmz_switch_status #�õ�dmz����״̬
						if dmz_switch_status == "on"
								@options_page.click_dmz_switch
								@options_page.save_dmz
								sleep @tc_wait_time
						end

						rs      = @tc_wan_drb.tcp_client(@tc_ppptp_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================After closed DMZ,Message from TCP server==============="
						puts "no message: #{tcp_msg}"
						refute_match(/#{@ts_conn_state}/, tcp_msg, "�ر�dmz��tcp��������")

						#udp�ͻ��˿�Ҳ��̬����rand_port
						sleep @tc_udp_data_time
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_ppptp_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================After closed DMZ,Message from UDP server==============="
						puts "no message: #{udp_msg}"
						refute_match(/#{@ts_conn_state}/, udp_msg, "�ر�dmz��UDP��������")
				}

				operate("6��������������DMZ 3�����ϣ�AP�����Ƿ�������") {
						2.times.each do |i|
								puts "Repeat open and close DMZ #{i} time"
								#��dmz����
								dmz_switch_status = @options_page.dmz_switch_status #�õ�dmz����״̬
								if dmz_switch_status == "off"
										@options_page.click_dmz_switch
										@options_page.dmz_input(@pc_ip_addr)
										@options_page.save_dmz
										sleep @tc_wait_time
								end
								#�ر�DMZ
								if dmz_switch_status == "on"
										@options_page.click_dmz_switch
										@options_page.save_dmz
										sleep @tc_wait_time
								end
						end
						rs=ping(@ts_web)
						assert(rs, "·�����޷���������")
				}


		end

		def clearup

				operate("1 �ر�DMZ�������ϵķ���") {
						@tc_tcp_srvthr.kill if !@tc_tcp_srvthr.nil? && @tc_tcp_srvthr.alive?
						@tc_udp_srvthr.kill if !@tc_udp_srvthr.nil? && @tc_udp_srvthr.alive?
				}

				operate("2 ȡ��DMZ") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_dmz_page
						dmz_switch_status = @options_page.dmz_switch_status #�õ�dmz����״̬
						if dmz_switch_status == "on"
								@options_page.click_dmz_switch
								@options_page.save_dmz
						end
				}

				operate("3 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
