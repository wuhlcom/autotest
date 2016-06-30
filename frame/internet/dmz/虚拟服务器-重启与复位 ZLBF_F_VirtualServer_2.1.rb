#
# description:
# ʹ�þ�̬IP���������Բ�ʹ��PPTP����������
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.5", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_vir_tcpsrv_port = 33000
				@tc_vir_udpsrv_port = 34000
				@tc_pub_tcp_port    = 23000
				@tc_pub_udp_port    = 24000
		end

		def process

				operate("1����AP�����þ�̬IP���룬����������������ܣ������һ������,Э��ѡ��TCP/UDP,��ʼ����ֹ�˿�����Ϊ5000������IP��ַ����ΪPC2��ַ�����棻") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)

						#�鿴Wan ip��ַ
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						@tc_static_ip = @sys_page.get_wan_ip
						wan_type      = @sys_page.get_wan_type
						assert_match /#{@ts_staticIp}/, @tc_static_ip, '��̬ip����ʧ�ܣ�'
						assert_match /#{@ts_wan_mode_static}/, wan_type, '�������ʹ���'
				}

				operate("2���ظ�����1�ֱ���Ӷ˿ں�Ϊ80��8080��137��139��1024��10000��65535����") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						#��ѯPC IP��ַ
						ip_info       = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip     = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
						puts "Virtual Server IP #{@tc_pc_ip}"
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, 1)

						#��ӵڶ������˿�ӳ��
						@options_page.add_vps
						@options_page.vps_input(@tc_pc_ip, @tc_pub_udp_port, @tc_vir_udpsrv_port, 2)
						@options_page.save_vps

						#����������
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						#����tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#����udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)

						#�������������
						rs      = @tc_wan_drb.tcp_client(@tc_static_ip, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_static_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "���������������UDP����ʧ��")
				}

				operate("3������DUT���鿴���õĹ����Ƿ������Ч��") {
						@options_page.refresh
						sleep 2
						@options_page.reboot
						rs = @options_page.login_with_exists(@browser.url)
						assert rs, "����·����ʧ��δ��ת����¼ҳ��!"
						#���µ�¼·����
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						#��ѯPC IP��ַ
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "after router reboot��pc ip addr is: #{@tc_pc_ip}"
						puts "after router reboot��Virtual Server IP is:#{@tc_pc_ip}"
						unless @tc_pc_ip2==@tc_pc_ip
								puts "after router reboot��������virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
								#����udp server
								udp_server(@tc_pc_ip2, @tc_vir_udpsrv_port)
						end

						#�������������
						rs      = @tc_wan_drb.tcp_client(@tc_static_ip, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "after router reboot�����������������tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_static_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "after router reboot�����������������UDP����ʧ��")

						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_vps_page
						rs = @options_page.vps_switch_status
						assert_equal("on", rs, "������������ر��ر�")

						virsrv_ip1      = @options_page.vps_ip1
						virsrv_pub_port1= @options_page.vps_common_port1
						vrisrv_port1    = @options_page.vps_private_port1
						assert_equal(@tc_pc_ip, virsrv_ip1, "��ѯ�������������IP")
						assert_equal(@tc_pub_tcp_port.to_s, virsrv_pub_port1, "��ѯ����·��������˿�#{@tc_pub_tcp_port}")
						assert_equal(@tc_vir_tcpsrv_port.to_s, vrisrv_port1, "��ѯ��������������˿�#{@tc_vir_tcpsrv_port}")

						virsrv_ip2      = @options_page.vps_ip2
						virsrv_pub_port2= @options_page.vps_common_port2
						vrisrv_port2    = @options_page.vps_private_port2
						assert_equal(@tc_pc_ip, virsrv_ip2, "��ѯ�������������IP")
						assert_equal(@tc_pub_udp_port.to_s, virsrv_pub_port2, "��ѯ����·��������˿�#{@tc_pub_udp_port}")
						assert_equal(@tc_vir_udpsrv_port.to_s, vrisrv_port2, "��ѯ��������������˿�#{@tc_vir_udpsrv_port}")
				}

				operate("4����λDUT���鿴�����Ƿ���ȫ��գ�") {
						@options_page.recover_factory(@browser.url) #�ָ���������
						@rs_recover = @options_page.login_with_exists(@browser.url)
						assert @rs_recover, "�ָ��������ú�δ��ת��·������¼ҳ��!"

						#���µ�¼·����
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_vps_page
						rs = @options_page.vps_switch_status
						assert_equal("off", rs, "�ָ��������ú��������������δ�ر�")

						rs2 = @options_page.vps_ip1_element
						refute(rs2.exists?, "�ָ��������ú��������������1δɾ��")

						rs3 = @options_page.vps_ip2_element
						refute(rs3.exists?, "�ָ��������ú��������������2δɾ��")
				}


		end

		def clearup
				operate("1 �ָ�Ĭ��DHCP����") {
						unless @rs_recover #����ѽ��лָ������������ﲻִ��
								wan_page = RouterPageObject::WanPage.new(@browser)
								if wan_page.login_with_exists(@browser.url)
									rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
								end
								wan_page.set_dhcp(@browser, @browser.url)
						end
				}
				operate("2 ɾ���������������") {
						unless @rs_recover #����ѽ��лָ������������ﲻִ��
								@options_page = RouterPageObject::OptionsPage.new(@browser)
								@options_page.delete_allvps_close_switch_step(@browser.url)
						end
				}
		end

}

