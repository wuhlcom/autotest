#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_6.1.13", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time     = 2
				@tc_net_time      = 50
				@tc_net_conn_time = 15
				@tc_tag_iframe_close  = "aui_close"
				@tc_tag_net_reset_tip = "aui_state_noTitle aui_state_focus aui_state_lock"
		end

		def process

				operate("1 ��������������") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						assert_match /#{@ts_tag_netset_src}/i, @wan_iframe.src, '����������ʧ�ܣ�'
				}

				operate("2 �����������ӷ�ʽ") {
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
				}

				operate("3 ����������̬����") {
						static_radio       = @wan_iframe.radio(id: @ts_tag_wired_static)
						static_radio_state = static_radio.checked?
						unless static_radio_state
								static_radio.click
								sleep @tc_wait_time
						end

						puts "���þ�̬IP��ַΪ��#{@ts_staticIp}".to_gbk
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_net_conn_time, "�ȴ�����������ʾ����".to_gbk) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
						}
						Watir::Wait.while(@tc_net_time, "����������������".to_gbk) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present?
						}
						sleep @tc_net_conn_time #�ȴ��������ӳɹ�
				}

				operate("4 �鿴WAN״̬") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep(@tc_wait_time+8) #״̬ҳ����ʱˢ�½�����������8s�ӳ�
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						Watir::Wait.until(@tc_wait_time, "��WAN״̬ʧ��".to_gbk) {
								@status_iframe.present?
						}

						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_static})/
						puts "WAN״̬��ʾ��������Ϊ��#{Regexp.last_match(1)}".to_gbk

						mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						mask =~@ts_tag_ip_regxp
						puts "WAN״̬��ʾ�������ַΪ��#{Regexp.last_match(1)}".to_gbk

						gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						gateway_addr =~@ts_tag_ip_regxp
						puts "WAN״̬��ʾ������IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

						dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
						dns_addr =~@ts_tag_ip_regxp
						puts "WAN״̬��ʾ��DNS IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

						assert_match /#{@ts_staticIp}/, wan_addr, '��̬ip����ʧ�ܣ�'
						assert_match /#{@ts_wan_mode_static}/, wan_type, '�������ʹ���'
						assert_match /#{@ts_staticNetmask}/, mask, '��̬ip��������ʧ�ܣ�'
						assert_match /#{@ts_staticGateway}/, gateway_addr, '��̬��������ip��ַʧ�ܣ�'
						assert_match /#{@ts_staticPriDns}/, dns_addr, '��̬����dns ip��ַʧ�ܣ�'

				}
				operate("5 ��֤ҵ��") {
						rs = ping(@ts_web)
						assert(rs, '�޷���������')
				}
		end

		def clearup

				operate("�ָ�Ĭ��DHCP����") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						rs          = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name

						flag = false
						#����wan���ӷ�ʽΪ��������
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
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