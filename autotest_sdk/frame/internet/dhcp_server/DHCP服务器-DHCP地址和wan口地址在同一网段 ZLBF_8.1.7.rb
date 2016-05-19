#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.7", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_net_time   = "60"
				@tc_error_info = "IP ��������WAN�ں�LAN�ڲ�������ͬһ����"
		end

		def process

				operate("1����½·���������������ã�") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "��WAN״̬ʧ�ܣ�")
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_ip   = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_ip=~@ts_tag_ip_regxp
						@tc_wan_ip = Regexp.last_match(1)
						#���ж��Ƿ�Ϊdhcpģʽ�������������Ϊdhcpģʽ
						unless wan_type=~/#{@ts_wan_mode_dhcp}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end

								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert_match(@wan_iframe.exists?, '����������ʧ�ܣ�')

								rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
								unless rs1=~/#{@ts_tag_select_state}/
										@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								end

								#�������dhcp�����������Ϊdhcp����
								dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
								dhcp_radio_state = dhcp_radio.checked?
								unless dhcp_radio_state
										dhcp_radio.click
										@wan_iframe.button(:id, @ts_tag_sbm).click
										sleep @tc_net_time
								end
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end

								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, "��WAN״̬ʧ�ܣ�")
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
								wan_ip   = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
								wan_ip=~@ts_tag_ip_regxp
								@tc_wan_ip = Regexp.last_match(1)
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
						end
						assert_match(@ts_tag_ip_regxp, @tc_wan_ip, "WAN��δ��ȡ��IP��ַ")
				}

				operate("2��DHCP��ַ�����wan�ڵ�ַ��ͬһ�Σ�") {
						ip_arr = @tc_wan_ip.split(".")
						if ip_arr.last.to_i<254
								new_serverip=@tc_wan_ip.succ
						else
								new_serverip=@tc_wan_ip.sub(/\.\d+$/, ".20")
						end
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "�������ô�ʧ��!")

						tc_serverip_field = @lan_iframe.text_field(id: @ts_tag_lanip)
						current_serverip  = tc_serverip_field.value
						puts "��ǰDHCP��������ַΪ��#{current_serverip}".encode("GBK")
						puts "�޸�DHCP��������ַΪ��#{new_serverip}".encode("GBK")
						tc_serverip_field = @lan_iframe.text_field(id: @ts_tag_lanip).set(new_serverip)
						@lan_iframe.button(id: @ts_tag_sbm).click
				}

				operate("3���������") {
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_info, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")
				}


		end

		def clearup

		end

}
