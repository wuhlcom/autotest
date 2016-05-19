#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.12", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time    = 3
				@tc_clone_time   = 40
				@tc_reboot_time  = 120
				@tc_relogin_time = 60
		end

		def process

				operate("1����¼DUT������WAN����ΪDHCPC��ʽ��") {
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
				}

				operate("2��ѡ��ʹ�ü����MAC��ַ����¡�����棻") {
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						#��������
						network_set = @option_iframe.link(id: @ts_tag_op_network)
						network_set.wait_until_present(@tc_wait_time)
						network_set.click
						#MAC��¡
						@option_iframe.link(id: @ts_tag_clone_mac).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_clone_mac).click
						clone_sw = @option_iframe.button(id: @ts_tag_clone_sw)
						clone_sw.wait_until_present(@tc_wait_time)
						#�򿪿�¡����
						if clone_sw.class_name == "off"
								clone_sw.click
						end
						#�����¡MAC
						mac_clone = @option_iframe.button(id: @ts_tag_fillmac)
						mac_clone.click
						#�ύ��¡
						@option_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_clone_time
				}

				operate("3����λDUT��Ĭ������״̬��") {
						@option_iframe.link(id: @ts_tag_op_system).click #ϵͳ����
						recover_sys = @option_iframe.link(id: @ts_tag_recover)
						recover_sys.wait_until_present(@tc_wait_time)
						recover_sys.click
						#����ָ���������
						recover_btn = @option_iframe.button(id: @ts_tag_reset_factory)
						recover_btn.wait_until_present(@tc_wait_time)
						recover_btn.click
						#ȷ�ϻָ�����
						@option_iframe.button(class_name: @ts_tag_reboot_confirm).click
						sleep @tc_reboot_time
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "��λ��·������δ��ת����¼ҳ��!"
						login_no_default_ip(@browser) #���µ�¼
				}

				operate("4���鿴DUT��DHCP�����Ƿ񱻸�λ��Ĭ��״̬��") {
						@browser.span(id: @tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @tag_status).click
						@state_iframe = @browser.iframe(src: @tag_status_iframe_src)
						assert(@state_iframe.exists?, "��״̬����ʧ�ܣ�")
						sleep @tc_wait_time
						wan_type = @state_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
						assert_equal(@ts_wan_mode_dhcp, wan_type,"DHCP����δ�ָ�Ĭ�ϣ�")
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						#����������
						network_set = @option_iframe.link(id: @ts_tag_op_network)
						network_set.click
						#�鿴MAC��¡����״̬
						@option_iframe.link(id: @ts_tag_clone_mac).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_clone_mac).click
						clone_sw = @option_iframe.button(id: @ts_tag_clone_sw)
						clone_sw.wait_until_present(@tc_wait_time)
						assert(clone_sw.class_name == "off", "mac��¡δ�ָ�Ĭ�����ã�")
				}


		end

		def clearup
				operate("�ָ�Ĭ������") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						@option_iframe.link(id: @ts_tag_clone_mac).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_clone_mac).click
						clone_sw = @option_iframe.button(id: @ts_tag_clone_sw)
						clone_sw.wait_until_present(@tc_wait_time)
						if clone_sw.class_name == "on"
								clone_sw.click
								@option_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_clone_time
						end
				}
		end

}
