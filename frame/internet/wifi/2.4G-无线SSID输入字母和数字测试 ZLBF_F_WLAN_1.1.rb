#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.4", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi          = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_ssid_name1 = "abczfh123"
				@tc_ssid_name2 = "abczfh1234"
				@tc_wifi_on    = "ON"
				@tc_wifi_off   = "OFF"
		end

		def process

				operate("1������SSID����test123���鿴�Ƿ����óɹ���STA�Ƿ����ӳɹ���") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)

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
						ssid1_pw = @wifi_page.ssid1_pw
						if @wifi_page.ssid1_sw == @tc_wifi_off
								@wifi_page.ssid1_sw = @tc_wifi_on
						end

						#ssid2
						@wifi_page.modify_ssid2(@tc_ssid_name2)
						puts "�޸�SSID2����Ϊ#{@tc_ssid_name2}".to_gbk
						ssid_mode = @wifi_page.ssid2_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "�޸�SSID2����Ϊ#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						end
						ssid2_pw = @wifi_page.ssid2_pw
						if @wifi_page.ssid2_sw == @tc_wifi_off
								@wifi_page.ssid2_sw = @tc_wifi_on
						end
						@wifi_page.save_wifi_config

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯSSID��ϸ��Ϣ".to_gbk
						ssid1 = @wifi_detail.ssid1_name
						ssid2 = @wifi_detail.ssid2_name
						assert_equal(@tc_ssid_name1, ssid1, "SSID1����ʧ��")
						assert_equal(@tc_ssid_name2, ssid2, "SSID2����ʧ��")

						p "���߿ͻ�������SSID1".to_gbk
						flag ="1"

						rs = @wifi.connect(@tc_ssid_name1, flag, ssid1_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi����ʧ��".to_gbk)
						pc_info = @wifi.ipconfig
						puts "IP��ַΪ#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk

						p "���߿ͻ��˷�������#{@ts_web}".to_gbk
						ping_rs = @wifi.ping(@ts_web)
						assert(ping_rs, "���߿ͻ����޷���������#{@ts_web}")

						@wifi.netsh_disc_all #�Ͽ�wifi����

						p "��������SSID2".to_gbk
						rs = @wifi.connect(@tc_ssid_name2, flag, ssid2_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi����ʧ��")

						pc_info = @wifi.ipconfig
						puts "IP��ַΪ#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk

						p "���߿ͻ��˷�������#{@ts_web}".to_gbk
						ping_rs = @wifi.ping(@ts_web)
						assert(ping_rs, "���߿ͻ����޷���������#{@ts_web}")
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
						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						if @wifi_page.ssid2_sw == @tc_wifi_on
								@wifi_page.ssid2_sw = @tc_wifi_off
						end
						@wifi_page.save_wifi_config
				}
		end

}
