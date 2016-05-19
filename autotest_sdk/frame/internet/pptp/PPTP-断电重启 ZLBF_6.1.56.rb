#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.56", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_dumpcap_server      = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_pptp_dfault         = "pap,chap,mschap1,mschap2"
				@tc_wait_time           = 3
				@tc_pptp_setting_time   = 50
				@tc_net_time            = 50
				@tc_rebooting_wait_time = 120
		end

		def process

				operate("1����BAS����ץ����") {
						#����ppptp����ļ���ΪĬ������
						@tc_dumpcap_server.init_routeros_obj(@ts_pptp_server_ip)
						@tc_dumpcap_server.routeros_send_cmd(@ts_pptp_default_set)
						rs = @tc_dumpcap_server.pptp_srv_pri(@pptp_pri)
						p "�޸ķ�����PPTP��֤��ʽΪ:#{rs["authentication"]}".to_gbk
						assert_equal(@tc_pptp_dfault, rs["authentication"], "�޸���֤��ʽʧ��")
				}

				operate("2������DUT��WAN���ŷ�ʽΪPPTP��DUT��������Ӧ��PPTP��ʽ�������ã�DNSΪ�Զ���ȡ��ʽ����֤������Ϊ�Զ�������д��ȷ�Ĳ����û��������룬�鿴�����Ƿ�ɹ���") {
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						@option_iframe.link(id: @ts_tag_op_pptp).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_op_pptp).click #pptp����
						@option_iframe.text_field(id: @ts_tag_pptp_server).wait_until_present(@tc_wait_time)
						@option_iframe.text_field(id: @ts_tag_pptp_server).set(@ts_pptp_server_ip) #������IP
						@option_iframe.text_field(id: @ts_tag_pptp_usr).set(@ts_pptp_usr) #�û���
						@option_iframe.text_field(id: @ts_tag_pptp_pw).set(@ts_pptp_pw) #����
						@option_iframe.button(id: @ts_tag_sbm).click #����
						sleep @tc_pptp_setting_time
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

						assert_match(@ip_regxp, wan_addr, 'PPTP��ȡip��ַʧ�ܣ�')
						assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���')
						assert_match(@ip_regxp, mask, 'PPTP��ȡip��ַ����ʧ�ܣ�')
						assert_match(@ip_regxp, gateway_addr, 'PPTP��ȡ����ip��ַʧ�ܣ�')
						assert_match(@ip_regxp, dns_addr, 'PPTP��ȡdns ip��ַʧ�ܣ�')
				}

				operate("3����DUT����ҳ�棬�������DUT��������ɺ��Ƿ�һ�ο��ٲ��ųɹ�������ҵ���Ƿ�������ץ��ȷ�ϵ������ʱ��DUT�Ƿ��Ե�ǰ��call ID����Call-Clear-Request�Ͽ�����") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_reboot).click
						@browser.button(class_name: @ts_tag_reboot_confirm).click
						puts "·���������У����Ժ�...".to_gbk
						sleep @tc_rebooting_wait_time
						login_no_default_ip(@browser) #���µ�¼

						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

						assert_match(@ip_regxp, wan_addr, 'PPTP��ȡip��ַʧ�ܣ�')
						assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���')
						assert_match(@ip_regxp, mask, 'PPTP��ȡip��ַ����ʧ�ܣ�')
						assert_match(@ip_regxp, gateway_addr, 'PPTP��ȡ����ip��ַʧ�ܣ�')
						assert_match(@ip_regxp, dns_addr, 'PPTP��ȡdns ip��ַʧ�ܣ�')

						response = send_http_request(@ts_web)
						assert(response, "����ҵ��������")
				}

				# operate("4��ֱ�Ӷϵ�DUT������������ɺ��Ƿ�һ���Կ��ٲ��ųɹ�������ҵ���Ƿ���������������֮ǰDUT�Ƿ�����һ��call ID����Call-Clear-Request��ֹǰһ�����ӣ�") {
				#
				# }


		end

		def clearup
				operate("�Ͽ�����������") {
						@tc_dumpcap_server.logout_routeros
				}

				operate("�ָ�Ĭ��DHCP����") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end
						@browser.span(:id => @ts_tag_netset).click
						sleep @tc_wait_time
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						flag        = false
						#����wan���ӷ�ʽΪ��������
						@wan_iframe.link(:id => @ts_tag_wired_mode_link).wait_until_present(@tc_wait_time)
						rs1 = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/ #{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
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
								puts "Waiting for net reset..."
								sleep @tc_net_time
						end
				}
		end

}
