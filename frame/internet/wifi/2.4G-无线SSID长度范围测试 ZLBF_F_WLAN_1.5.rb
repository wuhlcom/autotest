#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.8", "level" => "P2", "auto" => "n"}

		def prepare

				DRb.start_service
				@wifi          = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_ssid_name1 = "a" #���SSID
				@tc_ssid_name2 = "autotest_23a23f" #�м�ֵ
				@tc_ssid_name3 = "1234567890ASDFGHJKLMqwertyuiop12" #�SSID
				@tc_wifi_on    = "ON"
				@tc_wifi_off   = "OFF"
		end

		def process

				operate("1����������SSIDΪ1���ַ�������Ϊ��#{@tc_ssid_name1}�������߿ͻ�����֮�������鿴�Ƿ������ӳɹ���") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name1)
						puts "�޸�SSID1����Ϊ#{@tc_ssid_name1}".to_gbk
						ssid_mode = @wifi_page.ssid1_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "�޸�SSID1����Ϊ#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid1_sw == @tc_wifi_off
								@wifi_page.ssid1_sw = @tc_wifi_on
						end
						ssid1_pw = @wifi_page.ssid1_pw

						#ssid2
						@wifi_page.modify_ssid2(@tc_ssid_name2)
						puts "�޸�SSID2����Ϊ#{@tc_ssid_name2}".to_gbk
						ssid_mode = @wifi_page.ssid2_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "�޸�SSID2����Ϊ#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid2_sw == @tc_wifi_off
								@wifi_page.ssid2_sw = @tc_wifi_on
						end
						ssid2_pw = @wifi_page.ssid2_pw

						#ssid3
						@wifi_page.modify_ssid3(@tc_ssid_name3)
						puts "�޸�SSID3����Ϊ#{@tc_ssid_name3}".to_gbk
						ssid_mode = @wifi_page.ssid3_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "�޸�SSID3����Ϊ#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid3_sw == @tc_wifi_off
								@wifi_page.ssid3_sw = @tc_wifi_on
						end
						ssid3_pw = @wifi_page.ssid3_pw
						@wifi_page.save_wifi_config

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯSSID��ϸ��Ϣ".to_gbk
						ssid1 = @wifi_detail.ssid1_name
						ssid2 = @wifi_detail.ssid2_name
						ssid3 = @wifi_detail.ssid3_name
						assert_equal(@tc_ssid_name1, ssid1, "SSID1����ʧ��")
						assert_equal(@tc_ssid_name2, ssid2, "SSID2����ʧ��")
						assert_equal(@tc_ssid_name3, ssid3, "SSID3����ʧ��")

						p "���߿ͻ�������SSID1".to_gbk
						rs = @wifi.connect(@tc_ssid_name1, @ts_wifi_flag, ssid1_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi����ʧ��".to_gbk)
						pc_info = @wifi.ipconfig
						puts "IP��ַΪ#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk
						p "���߿ͻ��˷���#{@ts_default_ip}".to_gbk
						ping_rs = @wifi.ping(@ts_default_ip)
						assert(ping_rs, "���߿ͻ����޷���������#{@ts_default_ip}")

						@wifi.netsh_disc_all #�Ͽ�wifi����

						p "��������SSID2".to_gbk
						rs = @wifi.connect(@tc_ssid_name2, @ts_wifi_flag, ssid2_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi����ʧ��")
						pc_info = @wifi.ipconfig
						puts "IP��ַΪ#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk
						p "���߿ͻ��˷���#{@ts_default_ip}".to_gbk
						ping_rs = @wifi.ping(@ts_default_ip)
						assert(ping_rs, "���߿ͻ����޷���������#{@ts_default_ip}")

						p "��������SSID3".to_gbk
						rs = @wifi.connect(@tc_ssid_name3, @ts_wifi_flag, ssid3_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi����ʧ��")
						pc_info = @wifi.ipconfig
						puts "IP��ַΪ#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk
						p "���߿ͻ��˷���#{@ts_default_ip}".to_gbk
						ping_rs = @wifi.ping(@ts_default_ip)
						assert(ping_rs, "���߿ͻ����޷���������#{@ts_default_ip}")
				}

				operate("2����������SSIDΪ��#{@tc_ssid_name2}��#{@tc_ssid_name2.size}���ַ������߿ͻ�����֮�������鿴�Ƿ������ӳɹ���") {
						#��һ���Ѿ�ʵ��
				}


		end

		def clearup

				operate("1 �ָ�����Ĭ������") {
						#�Ͽ���������
						@wifi.netsh_disc_all
						#����������ʽҲ�ܱ���Ļ�������Ҫ�ȴ��䱣�����
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#�޸�SSID
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						if @wifi_page.ssid1_sw == @tc_wifi_off
								@wifi_page.ssid1_sw = @tc_wifi_on
						end

						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						if @wifi_page.ssid2_sw == @tc_wifi_on
								@wifi_page.ssid2_sw = @tc_wifi_off
						end

						@wifi_page.modify_ssid3(@ts_wifi_ssid3)
						if @wifi_page.ssid3_sw == @tc_wifi_on
								@wifi_page.ssid3_sw = @tc_wifi_off
						end

						@wifi_page.save_wifi_config
				}
		end

}
