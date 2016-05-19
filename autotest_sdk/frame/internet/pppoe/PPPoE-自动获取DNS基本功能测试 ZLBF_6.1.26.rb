#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.26", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_domain     = "www.baidu.com"
				@tc_cap_time   = 20
				@tc_net_time   = 50
				@tc_wait_time  = 2
				@tc_cap_fields = "-e frame.number -e eth.dst -e eth.src -e ip.src -e ip.dst -e dns.qry.name"
		end

		def process

				operate("1��BAS��LAN PCͬʱ����ץ����") {

				}

				operate("2��DUT��������Ӧ��PPPoE ��ʽ�������ã�DNSѡ���Զ���ISP��ȡ�����棻") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "����������ʧ��")
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
				}

				operate("3���鿴DUT��ȡ��DNS��Ϣ�Ƿ���ȷ������״̬������ҳ����ʾ��DNS��Ϣ��ʾ�Ƿ�������") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
						dns_addr =~ @ts_tag_ip_regxp
						@tc_dns_addr = Regexp.last_match(1)
						assert_match @ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
						assert_match @ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�'
						assert_match @ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�'
						assert_match @ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�'
				}

				operate("4��LAN PC����DOS������:ipconfig/flushdns�����PC��DNS����,ִ��ping www.sohu.com��") {
						@tc_main_filter = "dns && ip.dst==#{@tc_dns_addr}"
						@tc_main_args   ={nic: @ts_server_lannic, filter: @tc_main_filter, duration: @tc_cap_time, fields: @tc_cap_fields}
						puts "Capture filter: #{@tc_main_filter}"
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_args)
								end
								#���DNS����
								ipconfig_flushdns
								rs = ping(@tc_domain)
								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture DNS Packets ERROR")
						end
						assert(rs, "�޷���������")
						#���capture_rs��Ϊ��˵��ץ���˱���
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "δץ��DNS����")
				}

				operate("5����BASץ��ȷ�ϣ�DUT�Ƿ��Ի�ȡ������DNS���������ͳ�DNS����") {
						#���Ĳ��Ѿ�ʵ��
				}

				operate("6��LAN PC��www.sohu.com�����Ƿ�ɹ���") {
						#���Ĳ��Ѿ�ʵ��
				}
		end

		def clearup

				operate("�ָ�Ĭ��DHCP����") {
						if @browser.span(:id => @ts_tag_netset).exists?
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						flag = false
						#����wan���ӷ�ʽΪ��������
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/#{@tc_tag_select_state}/
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
