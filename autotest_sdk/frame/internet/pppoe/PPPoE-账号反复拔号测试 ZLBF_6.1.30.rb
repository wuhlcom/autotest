#
# description:
# ������ֻ���Է����������(���)��ÿ��������PPPOEҵ������
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.30", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_reboot_time  = 120
				@tc_relogin_time = 60
				@tc_net_time     = 60
				@tc_wait_time    = 2
		end

		def process

				operate("1������DUT��WAN���ŷ�ʽΪPPPoE,��DNSΪ�Զ���ȡ��ʽ����֤������Ϊ�Զ�������д��ȷ�Ĳ����û��������룬�ύ��") {
						#����ΪPPPOE����
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
						puts "set pppoe mode,waiting for net reset..."
						sleep @tc_net_time
				}

				operate("2���鿴DUT�Ƿ񲦺ųɹ���") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match @ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'

						rs = ping(@ts_web)
						assert(rs, "PPPOE��ʽ·�����޷���������")
				}

				operate("4���������DUT 5�Σ��鿴DUT�����Ƿ�ɹ���DUT�Ƿ�����쳣��") {
						5.times do |i|
								puts "��#{i+1}������·����".encode("GBK")
								if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
										@browser.execute_script(@ts_close_div)
								end

								@browser.refresh
								@browser.span(id: @ts_tag_reboot).click
								reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
								assert reboot_confirm.exists?, "δ��ʾ����·����Ҫȷ��!"
								reboot_confirm.click

								puts "sleep #{@tc_reboot_time} for system reboot...."
								sleep(@tc_reboot_time) #����������Ͽ����������������ʹ��sleep���ȴ�����������Watir::Wait���ȴ�
								rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
								assert rs, "����·����ʧ��δ��ת����¼ҳ��!"
								#���µ�¼·����
								rs = login_no_default_ip(@browser)
								assert(rs, "���µ�¼·����ʧ��!")

								#��β�ѯ״̬ҳ��,��ֹ״̬ҳ����ʾʧ��
								3.times do
										@browser.refresh
										@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
										@browser.span(:id => @ts_tag_status).click
										sleep @tc_wait_time
										@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
										break if @status_iframe.b(:id => @ts_tag_wan_ip).exists?
										sleep @tc_status_time
								end

								wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
								puts "�������������Ϊ#{wan_type}".encode("GBK")
								assert_match @ip_regxp, wan_addr, '������PPPOE��ȡip��ַʧ�ܣ�'
								assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '������������ʹ���'

								rs = ping(@ts_web)
								assert(rs, "������PPPOE��ʽ·�����޷���������")
						end
				}


		end

		def clearup

				operate("1 �ָ�Ĭ��DHCP����") {
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
