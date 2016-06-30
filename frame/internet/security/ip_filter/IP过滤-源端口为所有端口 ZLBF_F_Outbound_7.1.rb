#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_15.1.14", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time    = 3
				@tc_src_port     = 1
				@tc_src_port_end = 65535
				@tc_tcp_port     = 15801
				@dut_ip          = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
		end

		def process

				operate("1��DUT�Ľ�������ѡ��ΪDHCP���������á��ٽ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ����棻") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
						@options_page.firewall_click
						@options_page.open_switch("on", "on", "off", "off")
				}

				operate("2�����һ�����˹�����������ΪĬ�ϣ�Դ�˿�����Ϊ1-65535��Э��ΪTCP/UDP���������á�") {
						@options_page.ipfilter_click
						@options_page.ip_add_item_element.click
						@options_page.ip_filter_src_ip_input(@dut_ip)
						@options_page.ip_filter_src_port_input(@tc_src_port, @tc_src_port_end)
						@options_page.ip_filter_save
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("3����PC1�������ݰ����������磺�������ݰ���������IPTEST��������Ŀ�Ķ˿�Ϊ1��TCP��UDP�����ݰ������ݰ���IP��ַ�����Ϣ�������ã���LAN��WAN�������ݰ���PC2���Ƿ���ץ��PC1�Ϸ��������ݰ���") {
						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_src_port, @ts_tcp_server, @tc_tcp_port)
						rescue => ex
								p "��������ʱ�����쳣".to_gbk
								p ex.message.to_s
								assert(false, "��������ʱ�����쳣")
						end
						assert_equal("", rs.udp_message, "�˿ڹ���ʧ�ܣ�")
				}

				operate("4���༭����2�����ݰ�����������Դ�˿ڸ���Ϊ65535��80��21��1024��60000�����ݰ����鿴���Խ����") {
						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_src_port_end, @ts_tcp_server, @tc_tcp_port)
						rescue => ex
								p "��������ʱ�����쳣".to_gbk
								p ex.message.to_s
								assert(false, "��������ʱ�����쳣")
						end
						assert_equal("", rs.udp_message, "�˿ڹ���ʧ�ܣ�")

						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, 1024, @ts_tcp_server, @tc_tcp_port)
						rescue => ex
								p ex.message.to_s
								p "��������ʱ�����쳣".to_gbk
								assert(false, "��������ʱ�����쳣")
						end
						assert_equal("", rs.udp_message, "�˿ڹ���ʧ�ܣ�")
				}

				operate("5������DUT��ִ�в���3���鿴���Խ����") {
						@main_page = RouterPageObject::MainPage.new(@browser)
						@main_page.reboot
						@login_page = RouterPageObject::LoginPage.new(@browser)
						login_ui    = @login_page.login_with_exists(@browser.url)
						assert(login_ui, "������δ��ת����¼����~")
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_src_port, @ts_tcp_server, @tc_tcp_port)
						rescue => ex
								p ex.message.to_s
								p "��������ʱ�����쳣".to_gbk
								assert(false, "��������ʱ�����쳣")
						end
						assert_equal("", rs.udp_message, "�˿ڹ���ʧ�ܣ�")
				}


		end

		def clearup
				operate("1 �رշ���ǽ�ܿ��غ�IP���˿��ز�ɾ����������") {
						options_page = RouterPageObject::OptionsPage.new(@browser)
						options_page.ipfilter_close_sw_del_all_step(@browser.url)
				}
		end

}
