#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_15.1.7", "level" => "P2", "auto" => "n"}

		def prepare
				@dut_ip                 = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
				@tc_wait_time           = 3
				@tc_server_dst_port_tcp = 16801
				@tc_server_dst_port_udp = 15801
				@tc_client_port         = 5000
		end

		def process

				operate("1��DUT�Ľ�������ѡ��ΪDHCP���������ã��ٽ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ����棻") {
						@browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_netset).click #����
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						flag        = false
						#����wan���ӷ�ʽΪ��������
						rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
						unless rs1 =~/ #{@ts_tag_select_state}/
								@wan_iframe.span(id: @ts_tag_wired_mode_span).click #��������
								flag = true
						end
						#��ѯ�Ƿ�ΪΪdhcpģʽ
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						#����WIRE WANΪDHCPģʽ
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end
						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
						end
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
						if fire_wall_btn.class_name == "off"
								fire_wall_btn.click
						end
						ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
						if ip_btn.class_name == "off"
								ip_btn.click
						end
						@option_iframe.button(id: @ts_tag_security_save).click #����
				}

				operate("2�����һ����������ԴIPΪ192.168.100.100���˿�Ϊ5000��Э��ΪTCP/UDP���������ã���PC1�������ݰ�����������������ݰ���������IPTEST������UDP�����ݰ����˿�Ϊ5000��ԴIP��ַ192.168.100.100��PC2���Ƿ���ץ��PC1�Ϸ��������ݰ���") {
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_ip_set).click #IP����
						@option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
						@option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
						@option_iframe.text_field(id: @ts_ip_dst_port).set(@tc_server_dst_port_udp)
						@option_iframe.button(id: @ts_tag_save_filter).click #����
						sleep @tc_wait_time
						ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
						dst_port   = @option_iframe.table(id: @ts_iptable).trs[1][4].text.slice(/(\d+)-/i, 1).to_i
						if (ip_clauses == 1 || dst_port != @tc_server_dst_port_udp)
								assert(false, "��������Ŀʧ��")
						end
						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_client_port, @ts_tcp_server, 15801)
						rescue => ex
								p ex.message.to_s
								p "��������ʱ�����쳣".to_gbk
								assert(false,"��������ʱ�����쳣")
						end
						assert_empty(rs.udp_message, "UDPЭ�����ʧ�ܣ�")
				}

				operate("3����PC1�������ݰ�����������������ݰ���������IPTEST������TCP�����ݰ����˿�Ϊ5000��ԴIP��ַΪ��192.168.100.100��PC2���Ƿ���ץ��PC1�Ϸ��������ݰ���") {
						begin
								rs = HtmlTag::TestTcpClient.new(@ts_tcp_server, 16801)
						rescue => ex
								p ex.message.to_s
								p "��������ʱ�����쳣".to_gbk
								assert(false,"��������ʱ�����쳣")
						end
						assert_match("succeed", rs.tcp_message, "TCPЭ�����ʧ��")
				}

				operate("4���༭����2��3�����ݰ�����������������ݰ���������IPTEST������UDP�����ݰ����Ѷ˿ڸ���Ϊ6000���鿴���Խ����") {
						@option_iframe.table(id: @ts_iptable).trs[1][7].link(class_name: @ts_tag_edit).click
						@option_iframe.text_field(id: @ts_ip_dst_port1).set(@tc_server_dst_port_tcp)
						@option_iframe.button(id: @ts_tag_save_filter1).click #����
						sleep @tc_wait_time
						ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
						dst_port   = @option_iframe.table(id: @ts_iptable).trs[1][4].text.slice(/(\d+)-/i, 1).to_i
						if (ip_clauses == 1 || dst_port != @tc_server_dst_port_tcp)
								assert(false, "��������Ŀʧ��")
						end

						begin
								rs = HtmlTag::TestUdpClient.new(@dut_ip, @tc_client_port, @ts_tcp_server, 15801)
						rescue => ex
								p ex.message.to_s
								p "��������ʱ�����쳣".to_gbk
								assert(false,"��������ʱ�����쳣")
						end
						assert_match("succeed", rs.udp_message, "���Ķ˿ں�UDPЭ�����ʧ�ܣ�")
				}

				operate("5���༭����2��3�����ݰ�����������������ݰ���������IPTEST������TCP�����ݰ�����ԴIP����Ϊ192.168.100.200���鿴���Խ����") {
						begin
								rs = HtmlTag::TestTcpClient.new(@ts_tcp_server, 16801)
						rescue => ex
								p ex.message.to_s
								p "��������ʱ�����쳣".to_gbk
								assert(false,"��������ʱ�����쳣")
						end
						assert_match("failed", rs.tcp_message, "���Ķ˿ں�TCPЭ�����ʧ��")
				}


		end

		def clearup
				operate("1���رշ���ǽ�ܿ��غ�IP���˿���") {
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
						if fire_wall_btn.class_name == "on"
								fire_wall_btn.click
						end
						ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
						if ip_btn.class_name == "on"
								ip_btn.click
						end
						@option_iframe.button(id: @ts_tag_security_save).click #����
				}

				operate("2��ɾ��������Ŀ") {
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_ip_set).click #����IP��������
						ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
						if ip_clauses > 1 #�������Ŀ��ɾ��
								@option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
								@option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #ɾ��������Ŀ
						end
				}
		end

}
