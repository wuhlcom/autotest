#
# description:
# bug:�����������������LAN���IP��ַ
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.2", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_pub_tcp_port    = 5869
				@tc_vir_tcpsrv_port = 80
				@tc_ip_error_tip    = "IP��ַ��ʽ����"
				@tc_ip_error_tip1   = "��ַ��ip����"
		end

		def process

				operate("1���ڡ�IP��ַ������ȫ0��ȫ1����0��ͷ��ַ��0��β��ַ���磺0.0.0.0��255.255.255.255��0.0.0.1��192.0.0.0�Ƿ��������룻") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps

						virtualsrv_ip_addr1 = "0.168.100.100"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr1}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr1, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "δ���������ַ������ʾ")
						assert_equal(@tc_ip_error_tip, error_tip, "��ʾ��Ϣ����")

						virtualsrv_ip_addr3 = "192.168.100.0"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr3}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr3, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "δ���������ַ������ʾ")
						assert_equal(@tc_ip_error_tip, error_tip, "��ʾ��Ϣ����")

				}

				operate("2���ڡ�IP��ַ������D���ַ��E���ַ���鲥��ַ���磺224.1.1.1��240.1.1.1��255.1.1.1���Ƿ��������룻") {
						virtualsrv_ip_addr5 = "224.168.100.10"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr5}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr5, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "δ���������ַ������ʾ")
						assert_equal(@tc_ip_error_tip1, error_tip, "��ʾ��Ϣ����")
				}

				operate("3���ڡ�IP��ַ���������255��С��0��С�������֣��磺256��-11���Ƿ��������룻") {
						virtualsrv_ip_addr7 = "100"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr7}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr7, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "δ���������ַ������ʾ")
						assert_equal(@tc_ip_error_tip, error_tip, "��ʾ��Ϣ����")

						virtualsrv_ip_addr4 = "192.168.-100.100"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr4}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr4, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "δ���������ַ������ʾ")
						assert_equal(@tc_ip_error_tip, error_tip, "��ʾ��Ϣ����")
				}

				operate("4���ڡ�IP��ַ������㲥��ַ���磺192.168.2.255,10.255.255.255���Ƿ��������룻") {
						virtualsrv_ip_addr4 = "192.168.100.255"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr4}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr4, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "δ���������ַ������ʾ")
						assert_equal(@tc_ip_error_tip, error_tip, "��ʾ��Ϣ����")
				}

				operate("5��������DUT WAN�ڵ�IP��ַ��ַ���Ƿ��������룻") {
#padding
				}

				operate("6������ػ���ַ���磺127.0.0.1���Ƿ��������룻") {
						virtualsrv_ip_addr4 = "127.0.0.1"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr4}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr4, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "δ���������ַ������ʾ")
						assert_equal(@tc_ip_error_tip, error_tip, "��ʾ��Ϣ����")
				}

				operate("7����IP��ַ����A~Z,a~z,~!@#$%^��33�������ַ������ģ��ո�Ϊ�յȣ��Ƿ��������룻") {
						virtualsrv_ip_addr = "����"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "δ���������ַ������ʾ")
						assert_equal(@tc_ip_error_tip, error_tip, "��ʾ��Ϣ����")
				}

				operate("8��������LAN��IPͬһ����ַ���磺192.168.100.1���Ƿ��������룻") {
						#����Ӧ�ò�����������LAN��ͬ�ĵ�ַ
						ip_info = ipconfig
						srv_ip  = ip_info[@ts_nicname][:gateway][0]
						p "�������������IP��ַΪ:#{srv_ip}".encode("GBK")
						@options_page.vps_input(srv_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "δ���������ַ������ʾ")
						assert_equal(@tc_ip_error_tip, error_tip, "��ʾ��Ϣ����")
				}


		end

		def clearup
				operate("1 ɾ���������������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}
		end

}
