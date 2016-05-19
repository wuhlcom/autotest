#
# description:
# author:wuhongliang
# Զ�̿������ָ���������
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.8", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj   = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_wait_time    = 5
				@tc_mac          = "00:11:00:00:00:FF"
				@tc_desc         = "remotetest"
				@tc_switch_on    = "on"
				@tc_switch_off   = "off"
				@tc_wifi_off     = "OFF"
				@tc_wifi_on      = "ON"
		end

		def process

				operate("1��PC1��¼DUTҳ���޸ĵ�ǰ����(WAN ��������ΪPPPOE)��") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						# ����ǰ�Ƚ�·�����ָ���������
						@options_page.recover_factory(@browser.url)
						# ���µ�¼
						@options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)

						#����������WEB
						@options_page.open_web_access_btn(@browser.url)
						@tc_web_acc_port = @options_page.web_access_port
						@options_page.save_web_access

						#����MAC����
						@options_page.security_settings
						sleep @tc_wait_time
						@options_page.open_switch(@tc_switch_on, @tc_switch_off, @tc_switch_on, @tc_switch_off)
						@options_page.mac_filter #��mac����ҳ��
						sleep @tc_wait_time
						@options_page.mac_filter_add #��ӹ��˹���
						@options_page.mac_filter_input(@tc_mac, @tc_desc)
						@options_page.mac_filter_save
						rs = @browser.iframe(src: @ts_tag_advance_src).td(:text, @tc_mac).exists?
						assert(rs, "MAC�������ʧ��!")

						#�ر����߿���
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.close_2g_sw(@browser.url)
						@wifi_page.save_wifi_config(60)

						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪPPPOE".to_gbk
						#�޸ķ�������Լ��WANҪ���»�ȡһ��IP��ַ������ֱ������DHCPģʽ������
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type  = @systatus_page.get_wan_type
						@wan_addr = @systatus_page.get_wan_ip
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{@wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, @wan_addr, 'PPPOE��ȡIP��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
						#�鿴���߿���״̬
						rs_wifisw = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_off, rs_wifisw, "WIFI����δ�ر�")
				}

				operate("2��PC2Զ�̵�¼DUTҳ�棬�ָ�����Ĭ�����ã�") {
						@tc_remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{@tc_remote_url}"
						rs=@tc_server_obj.restore_router(@tc_remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "�������ʿ���·�����ָ���������ʧ��")
						@browser.refresh
						sleep 1
						@browser.refresh
						sleep @tc_wait_time
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'
						rs_wifisw = @systatus_page.get_wifi_switch
						puts "��ѯ��WIFI����״̬:#{rs_wifisw}".to_gbk
						assert_equal(@tc_wifi_on, rs_wifisw, "WIFI����δ�ر�")

						puts "��ѯ������ǽ����״̬".to_gbk
						@options_page.open_security_page_step(@browser.url)
						fw_sw = @options_page.firewall_switch_element.class_name
						mac_sw= @options_page.mac_filter_switch_element.class_name
						assert_equal(@tc_switch_off, fw_sw, "�������ӻָ�����ֵ�����ǽ�ܿ���δ�ر�")
						assert_equal(@tc_switch_off, mac_sw, "�������ӻָ�����ֵ��MAC���˿���δ�ر�")
				}

		end

		def clearup

				operate("1 �ָ�Ĭ��DHCP����") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2.�ָ�wifi����״̬") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
						unless @wifi_page.wifi_sw_element.class_name==@tc_switch_on
								@wifi_page.turn_on_2g_sw
								@wifi_page.save_wifi_config
						end
				}

				operate("3 �رշ���ǽ���ز�ɾ������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.close_web_access(@browser.url)
				}

				operate("4 �ر��������ʿ���") {
						@options_page.close_web_access(@browser.url)
				}
		end

}
