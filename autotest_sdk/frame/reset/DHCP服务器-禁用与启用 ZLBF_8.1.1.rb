#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                 = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time         = 5
				@tc_net_time          = 50
				@tc_tag_lan           = "set_wifi"
				@tc_tag_lan_iframe_src= "lanset.asp"
				@tc_tag_ssid          = "ssid"
				@tc_tag_select_list   = "security_mode"
				@tc_sec_mode_wpa      = 'WPA-PSK/WPA2-PSK'
				@tc_wpa_value         = "WPAPSKWPA2PSK"
				@tc_tag_input_pw      = "input_password1"

				@tc_tag_net_reset_tip= "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_button       = "button"

				@tc_static_ip          = @ts_default_ip.sub(/\.\d+$/, '.123')
				@tc_static_args        = {nicname: @ts_nicname, source: "static", ip: "#{@tc_static_ip}", mask: "255.255.255.0"}
				@tc_dhcp_args          = {nicname: @ts_nicname, source: "dhcp"}
				@tc_show_dut_args      = {type: "addresses", nicname: @ts_nicname}
				@tc_show_wireless_args = {type: "addresses", nicname: @ts_wlan_nicname}
		end

		def process
				operate("1 ����������") {
						@browser.span(:id => @tc_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@tc_tag_lan_iframe_src}/i, @lan_iframe.src, '����������ʧ�ܣ�'
				}

				operate("2 ����·����wifi") {
						select = @lan_iframe.select_list(id: @tc_tag_select_list)
						unless select.selected?(@tc_sec_mode_wpa)
								puts "�ָ�Ĭ�ϵļ����뷽ʽ��#{@tc_sec_mode_wpa}".to_gbk
								select.select(@tc_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @tc_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#��������Ч
								puts "Waiting for wifi config changed..."
								sleep @tc_wait_net_reset
						end
						@passwd_input = @lan_iframe.text_field(id: @tc_tag_input_pw)
						@current_pw   = @passwd_input.value
						puts "wifi passwd:#{@current_pw}"

						ssid_name = @lan_iframe.text_field(:id, @tc_tag_ssid).value
						flag      ="1"
						rs1       = @wifi.connect(ssid_name, flag, @current_pw)
						assert rs1, 'wifi����ʧ��'
						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif�ͻ����޷�pingͨ·����'
				}

				operate("3 ����DHCP����") {
						#dhcp���عر�
						dhcp_button=@lan_iframe.button(:type, @tc_tag_button)
						if dhcp_button.class_name=="on"
								@lan_iframe.button(:type, @tc_tag_button).click
								#�ύ
								@lan_iframe.button(:id, @ts_tag_sbm).click
								Watir::Wait.until(@tc_wait_time, "�ȴ�����LAN��ʾ����ʧ��") {
										lan_reseting = @lan_iframe.div(class_name: @ts_tag_rebooting, text: @ts_tag_lan_reset_text)
										lan_reseting.present?
								}
								sleep @tc_net_time
								#�ȴ�ҳ����ת C021�汾������ת����¼����
								# rs = @browser.text_field(:name, @usr_text_id).wait_until_present(@tc_net_time)
								# assert rs, '��ת����¼ҳ��ʧ�ܣ�'
						end
				}

				operate("4 �ر�DHCP���ܺ����»�ȡip��ַ") {
						rs_ip_release=ip_release(@ts_nicname)
						assert rs_ip_release, '�ͷ�ip��ַʧ�ܣ�'
						rs_ip_renew= ip_renew(@ts_nicname)
						assert_equal(false, rs_ip_renew, '����ip��ַ����Ӧʧ��,��ȴ�ɹ��ˣ�')

						ip_info = netsh_if_ip_show(@tc_show_dut_args)
						flag    = ip_info[:ip].empty? || ip_info[:ip][0]=~/^169/
						p "#{@ts_nicname} ip: #{ip_info[:ip].join(",")}"
						assert flag, 'Ӧ��ȡip��ַʧ�ܣ���ȴ��ȡip��ַ�ɹ���'

						rs_wip_release =@wifi.ip_release(@ts_wlan_nicname)
						assert rs_wip_release, 'wifi�ͷ�ip��ַʧ�ܣ�'

						rs_wip_renew=@wifi.ip_renew(@ts_wlan_nicname)
						assert_equal(false, rs_wip_renew, 'wifi����ip��ַ����Ӧʧ��,��ȴ�ɹ��ˣ�')

						wip_info = @wifi.netsh_if_ip_show(@tc_show_wireless_args)
						wflag    = wip_info[:ip].empty? || wip_info[:ip][0]=~/^169/
						p "#{@ts_wlan_nicname} ip: #{wip_info[:ip].join(",")}"
						assert wflag, 'wifiӦ��ȡip��ַʧ�ܣ���ȴ��ȡip��ַ�ɹ���'
				}

				operate("5 ���´�DHCP����") {
						#Ҫ��dhcp������Ҫ����һ����̬ip��·��������
						rs = netsh_if_ip_setip(@tc_static_args)
						assert rs, "���þ�̬ipʧ��"
						ping_test = ping(@ts_default_ip, @ts_nicname)
						assert_equal(true, ping_test, "���þ�̬ip���޷�pingͨ·������")

						rs_login = login(@browser, @ts_default_ip)
						@browser.span(:id => @tc_tag_lan).click if rs_login
						@lan_iframe = @browser.iframe
						assert_match /#{@tc_tag_lan_iframe_src}/i, @lan_iframe.src, '����������ʧ�ܣ�'

						dhcp_button=@lan_iframe.button(:type, @tc_tag_button)
						if dhcp_button.class_name=="off"
								@lan_iframe.button(:type, @tc_tag_button).click
								#�ύ
								@lan_iframe.button(:id, @ts_tag_sbm).click
								Watir::Wait.until(@tc_wait_time, "�ȴ�����LAN��ʾ����ʧ��") {
										lan_reseting = @lan_iframe.div(class_name: @ts_tag_rebooting, text: @ts_tag_lan_reset_text)
										lan_reseting.present?
								}
								sleep @tc_net_time
						end
				}

				operate("6 ���´�DHCP���ܺ����»�ȡip��ַ") {
						set_dhcp = netsh_if_ip_setip(@tc_dhcp_args)
						assert set_dhcp, '�ָ�dhcp���ܺ󣬻�ԭ����Ϊdhcpģʽ��'

						sleep 3
						rs_ip_release=ip_release(@ts_nicname)
						assert rs_ip_release, '�ͷ�ip��ַʧ�ܣ�'

						rs_ip_renew= ip_renew(@ts_nicname)
						assert rs_ip_renew, '����ip��ַ����ʧ��'

						ip_info = netsh_if_ip_show(@tc_show_dut_args)
						p "#{@ts_nicname} ip: #{ip_info[:ip].join(",")}"

						rs1 =ping(@ts_default_ip)
						assert rs1, '�ͻ����޷�pingͨ·����'

						rs_wip_release =@wifi.ip_release(@ts_wlan_nicname)
						assert rs_wip_release, 'wifi�ͷ�ip��ַʧ�ܣ�'

						rs_wip_renew=@wifi.ip_renew(@ts_wlan_nicname)
						assert rs_wip_renew, 'wifi����ip��ַ����ʧ�ܣ�'

						wip_info = @wifi.netsh_if_ip_show(@tc_show_wireless_args)
						p "#{@ts_wlan_nicname} ip: #{wip_info[:ip].join(",")}"


						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif�ͻ����޷�pingͨ·����'
				}

		end

		def clearup

				operate("��ԭ·����DHCPĬ�Ͽ�������") {
						@wifi.netsh_disc_all #�Ͽ�wifi����
						ping_test = ping(@ts_default_ip)
						unless ping_test
								netsh_if_ip_setip(@tc_static_args)
								sleep 5
						end

						rs_login=login(@browser, @ts_default_ip)
						@browser.span(:id => @tc_tag_lan).click if rs_login
						@lan_iframe = @browser.iframe

						dhcp_button=@lan_iframe.button(:type, @tc_tag_button)
						if dhcp_button.class_name=="off"
								@lan_iframe.button(:type, @tc_tag_button).click
								#�ύ
								@lan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}

				operate("�ָ�����Ĭ������") {
						rs_state=netsh_if_ip_show(@tc_show_dut_args)
						netsh_if_ip_setip(@tc_dhcp_args) if rs_state[:dhcp_state]=="no"
						sleep @tc_wait_time
				}
		end

}
