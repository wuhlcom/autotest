#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.22", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time     = 3
				@tc_clearup_time  = 30
				@tc_net_time      = 50
				@tc_diagnose_time = 120

				@tc_tag_select_state = "selected"
				@tc_net_dhcp         = "DHCP"
				@tc_net_pppoe        = "PPPOE"
				@tc_net_static       = "STATIC"
				@tc_tag_pppoe_usrid  = 'pppoeUser'
				@tc_tag_pppoe_pwid   = 'input_password1'

				@tc_tag_wired_static  = "wire-static"
				@tc_tag_staticIp      = "staticIp"
				@tc_tag_staticNetmask = "staticNetmask"
				@tc_tag_staticGateway = "staticGateway"
				@tc_tag_staticPriDns  = "staticPriDns"
		end

		def process

				operate("1��������3G������������������ΪWAN�ڣ�����ΪDHCP�����и߼����") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '����������ʧ�ܣ�')

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@tc_tag_select_state}/
								@wan_iframe.span(:id => @tc_tag_wan_mode_span).click
						end

						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						unless dhcp_radio_state
								dhcp_radio.click
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						#open diagnose
						@browser.link(id: @ts_tag_diagnose).click()
						sleep @tc_wait_time
						#��ȡ@browser�����¸������ڶ���ľ������
						@tc_handles = @browser.driver.window_handles
						assert(@tc_handles.size==2, "δ����ϴ���")
						#ͨ��������л���ͬ��windows����
						@browser.driver.switch_to.window(@tc_handles[1])
						# �򿪸߼����
						@browser.link(id: @ts_tag_ad_diagnose).click
						@browser.text_field(id: @ts_tag_url).wait_until_present(@tc_wait_time)
						@browser.text_field(id: @ts_tag_url).set(@ts_diag_web)
						@browser.button(id: @ts_tag_diag_btn).click
						Watir::Wait::until(@tc_wait_time, "���ڽ��и߼����") {
								@browser.div(text: @ts_tag_diag_ad_detecting).present?
						}
						Watir::Wait::until(@tc_diagnose_time, "�߼�������") {
								@browser.p(text: /#{@ts_tag_diag_nettype}/).present?
						}

						tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
						puts "�����������ͣ�#{tc_net_type}".to_gbk
						assert_equal(@tc_net_dhcp, tc_net_type, "�����������ʹ���")
						tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
						puts "WAN������״̬��#{tc_net_status}".to_gbk
						assert_equal(@ts_net_link, tc_net_status, "��������״̬�쳣")
						tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
						puts "������#{@ts_diag_web}������Ϊ��#{tc_net_domain_ip}".to_gbk
						assert_match(@ts_ip_reg, tc_net_domain_ip, "��������ʧ��")
						tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
						puts "��Ϲ��̶�����Ϊ��#{tc_loss_rate}".to_gbk
						assert_equal(@ts_loss_rate, tc_loss_rate, "��Ϲ��̶�������")
						tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
						puts "DNS����״̬��#{tc_dns_status}".to_gbk
						assert_equal(@ts_dns_status, tc_dns_status, "DNS����ʧ��")
						tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
						puts "HTTP��Ӧ�룺#{tc_http_code}".to_gbk
						assert_equal(@ts_http_status, tc_http_code, "HTTP��Ӧ����")
				}

				operate("2���޸�����ΪPPPOE�����и߼����") {
						@browser.driver.switch_to.window(@tc_handles[0])
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '����������ʧ�ܣ�')

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@tc_tag_select_state}/
								@wan_iframe.span(:id => @tc_tag_wan_mode_span).click
						end

						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end

						puts "������ȷ��PPPOE�ʻ���:#{@ts_pppoe_usr}��PPPOE����:#{@ts_pppoe_pw}��".to_gbk
						@wan_iframe.text_field(id: @tc_tag_pppoe_usrid).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @tc_tag_pppoe_pwid).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
						#ͨ��������л���ͬ��windows����
						@browser.driver.switch_to.window(@tc_handles[1])
						@browser.refresh
						sleep @tc_wait_time
						@browser.text_field(id: @ts_tag_url).wait_until_present(@tc_wait_time)
						@browser.text_field(id: @ts_tag_url).set(@ts_diag_web2)
						@browser.button(id: @ts_tag_diag_btn).click
						Watir::Wait::until(@tc_wait_time, "���ڽ��и߼����") {
								@browser.div(text: @ts_tag_diag_ad_detecting).present?
						}
						Watir::Wait::until(@tc_diagnose_time, "�߼�������") {
								@browser.p(text: /#{@ts_tag_diag_nettype}/).present?
						}

						tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
						puts "�����������ͣ�#{tc_net_type}".to_gbk
						assert_equal(@tc_net_pppoe, tc_net_type, "�����������ʹ���")
						tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
						puts "WAN������״̬��#{tc_net_status}".to_gbk
						assert_equal(@ts_net_link, tc_net_status, "��������״̬�쳣")
						tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
						puts "������#{@ts_diag_web2}������Ϊ��#{tc_net_domain_ip}".to_gbk
						assert_match(@ts_ip_reg, tc_net_domain_ip, "��������ʧ��")
						tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
						puts "��Ϲ��̶�����Ϊ��#{tc_loss_rate}".to_gbk
						assert_equal(@ts_loss_rate, tc_loss_rate, "��Ϲ��̶�������")
						tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
						puts "DNS����״̬��#{tc_dns_status}".to_gbk
						assert_equal(@ts_dns_status, tc_dns_status, "DNS����ʧ��")
						tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
						puts "HTTP��Ӧ�룺#{tc_http_code}".to_gbk
						assert_equal(@ts_http_status,tc_http_code,  "HTTP��Ӧ����")
				}

				operate("3���޸�Ϊ��̬��ַ�����и߼����") {
						@browser.driver.switch_to.window(@tc_handles[0])
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '����������ʧ�ܣ�')

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@tc_tag_select_state}/
								@wan_iframe.span(:id => @tc_tag_wan_mode_span).click
						end

						static_label = @wan_iframe.label(:id => @tc_tag_wired_static)
						rs1          = static_label.class_name
						unless rs1 =~/#{@tc_tag_select_state}/
								static_label.click
								sleep @tc_wait_time
						end

						puts "���õľ�̬IP��ַΪ��#{@ts_staticIp}".to_gbk
						@wan_iframe.text_field(:id, @tc_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @tc_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @tc_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @tc_tag_staticPriDns).set(@ts_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time #�ȴ��������ӳɹ�
						#ͨ��������л���ͬ��windows����
						@browser.driver.switch_to.window(@tc_handles[1])
						@browser.refresh
						sleep @tc_wait_time
						@browser.text_field(id: @ts_tag_url).wait_until_present(@tc_wait_time)
						@browser.text_field(id: @ts_tag_url).set(@ts_diag_web)
						@browser.button(id: @ts_tag_diag_btn).click
						Watir::Wait::until(@tc_wait_time, "���ڽ��и߼����") {
								@browser.div(text: @ts_tag_diag_ad_detecting).present?
						}
						Watir::Wait::until(@tc_diagnose_time, "�߼�������") {
								@browser.p(text: /#{@ts_tag_diag_nettype}/).present?
						}
						tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
						puts "�����������ͣ�#{tc_net_type}".to_gbk
						assert_equal(@tc_net_static, tc_net_type, "�����������ʹ���")
						tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
						puts "��������״̬��#{tc_net_status}".to_gbk
						assert_equal(@ts_net_link, tc_net_status, "��������״̬�쳣")
						tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
						puts "������#{@ts_diag_web}������Ϊ��#{tc_net_domain_ip}".to_gbk
						assert_match(@ts_ip_reg, tc_net_domain_ip, "��������ʧ��")
						tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
						puts "��Ϲ��̶�����Ϊ��#{tc_loss_rate}".to_gbk
						assert_equal(@ts_loss_rate, tc_loss_rate, "��Ϲ��̶�������")
						tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
						puts "DNS����״̬��#{tc_dns_status}".to_gbk
						assert_equal(@ts_dns_status, tc_dns_status, "DNS����ʧ��")
						tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
						puts "HTTP��Ӧ�룺#{tc_http_code}".to_gbk
						assert_equal(@ts_http_status,tc_http_code,  "HTTP��Ӧ����")
				}


		end

		def clearup
				operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						unless @tc_handles.nil?
								@browser.driver.switch_to.window(@tc_handles[0])
						end

						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#����wan���ӷ�ʽΪ��������
						rs1         =@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        =false
						unless rs1 =~/#{@tc_tag_select_state}/
								@wan_iframe.span(:id => @tc_tag_wan_mode_span).click
								flag=true
						end

						#��ѯ�Ƿ�ΪΪdhcpģʽ
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#����WIRE WANΪdhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag=true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_clearup_time
						end
				}
		end

}
