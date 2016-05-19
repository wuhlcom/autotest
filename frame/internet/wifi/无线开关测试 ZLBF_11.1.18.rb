#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.18", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi               = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_wait_time       = 2
				@tc_wifi_time       = 30
				@tc_wifi_on         = "on"
				@tc_wifi_status_off = "OFF"
				@tc_wifi_status_on  = "ON"
				@tc_ssid_name       = "autotest_1094"
		end

		def process

				operate("1������·������������ҳ�棻") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name)
						puts "�޸�SSID1����Ϊ#{@tc_ssid_name}".to_gbk
						ssid_mode = @wifi_page.ssid1_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "�޸�SSID1����Ϊ#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						end
						@tc_ssid1_pw = @wifi_page.ssid1_pw
						@wifi_page.save_wifi_config
				}

				operate("2���������߿���Ϊ�أ�") {
						@wifi_page.select_2g_advset
						@wifi_page.turn_off_2g_sw
						@wifi_page.save_wifi_config
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						systatus = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_status_off, systatus, "���߿��عر�ʧ�ܣ�")
						sleep @tc_wifi_time
				}

				operate("3��ʹ����������ɨ���SSID���Ƿ����ɨ��ɹ����ֶ��������Ӹ�SSID���Ƿ�������ӳɹ���") {
						rs = @wifi.scan_network_once(@tc_ssid_name)
						refute(rs[:flag], "���߿��عرպ�Ӧ���޷�ɨ��ɹ���")
						#�ֶ��������ò鿴�Ƿ����ӳɹ�
						ssid_hash ={:au_type => "WPA2PSK", :pass_type => "CCMP"}
						rs_conn = @wifi.add_new_connection(ssid_hash, @tc_ssid_name, @tc_ssid1_pw)
						refute(rs_conn, "���߿��عرպ�̬�����������Ӧ������ʧ��!")
				}

				operate("4���������߿���Ϊ����") {
						@wifi_page.open_2g_sw(@browser.url)
						@wifi_page.save_wifi_config
						@systatus_page.open_systatus_page(@browser.url)
						systatus = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_status_on, systatus, "���߿��ش�ʧ�ܣ�")
				}

				operate("5��ʹ����������ɨ���SSID���Ƿ����ɨ��ɹ����������ӳɹ���") {
						p "���߿ͻ�������SSID1".to_gbk
						rs = @wifi.connect(@tc_ssid_name, @ts_wifi_flag, @tc_ssid1_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi����ʧ��".to_gbk)
						pc_info = @wifi.ipconfig
						puts "IP��ַΪ#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk
						p "���߿ͻ��˷���#{@ts_default_ip}".to_gbk
						ping_rs = @wifi.ping(@ts_default_ip)
						assert(ping_rs, "���߿ͻ����޷�����#{@ts_default_ip}")
				}

		end

		def clearup

				operate("1 �ָ�����Ĭ������") {
						#�Ͽ���������
						@wifi.netsh_disc_all
						#�����߿���
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
						unless @wifi_page.wifi_sw_element.class_name==@tc_wifi_on
								@wifi_page.wifi_sw
								@wifi_page.save_wifi_config
						end
						#����������ʽҲ�ܱ���Ļ�������Ҫ�ȴ��䱣�����
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#�޸ĵ�һ��SSID����
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.save_wifi_config
				}

		end

}
