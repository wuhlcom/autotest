#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wifi_flag    = "1"
				@wifi            = DRbObject.new_with_uri(@ts_drb_server)
				@tc_conn_time    = 10
				@tc_tag_lan      = "set_wifi"
				@tc_pw_errinfo   = "����ֻ��������,��ĸ�������ַ�(~!@\#$*()_{}<>?.[]-=`^+:),����Ϊ8-63���ַ�"
				@tc_num_letter   = "123"*10+"Adf"*10+"12k"
				@tc_pw_64        = "1"*64
				@tc_pw_7         = "a"*7
				@tc_pw_space1    = " 25678df"
				@tc_pw_space2    = "25678df "
				@tc_pw_space3    = "25678 df"
				@tc_pw_specail   = "25678%df"
				@tc_wlan_pw_arr1 = ["ABCDEFGH", "AyzkEDXf", "51d2A3bck", @tc_num_letter]
				@tc_wlan_pw_arr2 = [@tc_pw_7, @tc_pw_space1, @tc_pw_space2, @tc_pw_space3, @tc_pw_specail, @tc_pw_64]

		end

		def process

				operate("1 ��������������") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
				}

				operate("2 ����·����WIFI") {
						@wifi_page     = RouterPageObject::WIFIPage.new(@browser)
						rs_wifi        = @wifi_page.modify_ssid_mode_pwd(@browser.url)
						@tc_ssid1_name = rs_wifi[:ssid]
						rs             = @wifi.connect(@tc_ssid1_name, @tc_wifi_flag, @ts_default_wlan_pw)
						assert rs, "WIFI����ʧ��"
				}

				operate("3 �޸�WIFI�������������") {
						@tc_wlan_pw_arr1.each do |pw|
								puts("�޸�����Ϊ��#{pw}".to_gbk)
								@wifi_page.change_ssid1_pw(pw, @browser.url)
								#ֻ�޸����벻�����ҳ����ת wuhongliang 2015-8-19
								puts("����wifi".to_gbk)
								rs1 = @wifi.connect(@tc_ssid1_name, @tc_wifi_flag, pw)
								assert rs1, "WIFI����ʧ��"
								puts("ping IP��ַ��#{@ts_default_ip}".to_gbk)
								rs2 = @wifi.ping(@ts_default_ip)
								assert rs2, "WIFI����ʧ��δ��ȡIP��ַ"
								@wifi.netsh_disc_all #�Ͽ�wifi����
								sleep @tc_conn_time
						end
				}

				operate("4 �Ƿ��û����������޷�����") {
						@tc_wlan_pw_arr2.each do |pw|
								unless @wifi_page.ssid1?
										@wifi_page.select_2g_basic(@browser.url)
								end
								puts("�޸�����Ϊ��#{pw}".to_gbk)
								@wifi_page.modify_ssid1_pw(pw)
								@wifi_page.save_wifi

								errinfo = @wifi_page.wifi_error
								puts("ERROR:#{errinfo}".to_gbk)
								assert_equal(@tc_pw_errinfo, errinfo, "������Ҳ�ܱ���")
						end
				}
		end

		def clearup
				operate("1 �ָ�Ĭ������") {
						@wifi.netsh_disc_all #�Ͽ�wifi����
						wifi_page = RouterPageObject::WIFIPage.new(@browser)
						if wifi_page.login_with_exists(@browser.url)
								rs_login = login_no_default_ip(@browser) #���µ�¼
								p rs_login[:flag]
								p rs_login[:message]
						end
						wifi_page.modify_default_ssid(@browser.url)
				}
		end

}
