#
# description:
# ������̺������
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.14", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi          = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wifi_ssid1 = "Wireless0"
				@tc_wifi_ssid2 = "Wireless1"
				@tc_wifi_ssid3 = "Wireless2"
				@tc_wifi_ssid4 = "Wireless3"
				@tc_wifi_on    = "ON"
				@tc_wifi_off   = "OFF"
				@tc_wifi_pw1   = "01234567"
				@tc_wifi_pw2   = "qwertyuioplkjhgfdsazxcvbnm896543210krtghjuiopasdfghjklmnbvcx123"
		end

		def process

				operate("1����Կ����#{@tc_wifi_pw1}��#{@tc_wifi_pw1.size}���ַ����Ƿ�������óɹ��� STA�Ƿ����ӳɹ���") {
						@wifi_page   = RouterPageObject::WIFIPage.new(@browser)
						@tc_mac_last = @wifi_page.get_mac_last
						@wifi_page.select_2g_basic(@browser.url)
						###############################ssid1#######################
						ssid1_name = @wifi_page.ssid1
						puts "��ǰSSID1��Ϊ#{ssid1_name}".to_gbk
						new_ssid1 = "wirless1_#{@tc_mac_last}"
						puts "��SSID1��Ϊ#{new_ssid1}".to_gbk
						@wifi_page.modify_ssid1(new_ssid1)
						puts "�޸�SSID1����Ϊ#{@tc_wifi_pw1}".to_gbk
						@wifi_page.modify_ssid1_pw(@tc_wifi_pw1)
						@wifi_page.save_wifi_config

						rs1_ssid1 = @wifi.connect(new_ssid1, @ts_wifi_flag, @tc_wifi_pw1)
						assert rs1_ssid1, 'WIFI����ʧ��'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI�ͻ����޷�pingͨ·����'

						puts "�޸�SSID1����Ϊ#{@tc_wifi_pw2}".to_gbk
						@wifi_page.modify_ssid1_pw(@tc_wifi_pw2)
						@wifi_page.save_wifi_config

						rs3_ssid1 = @wifi.connect(new_ssid1, @ts_wifi_flag, @tc_wifi_pw2)
						assert rs3_ssid1, 'WIFI����ʧ��'
						rs4_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs4_ssid1, 'WIFI�ͻ����޷�pingͨ·����'
						##############################SSID2#################################################
						ssid2_name = @wifi_page.ssid2
						puts "��ǰSSID2��Ϊ#{ssid2_name}".to_gbk
						new_ssid2 = "wirless2_#{@tc_mac_last}"
						puts "��SSID2��Ϊ#{new_ssid2}".to_gbk
						@wifi_page.modify_ssid2(new_ssid2)
						puts "�޸�SSID2����Ϊ#{@tc_wifi_pw1}".to_gbk
						@wifi_page.modify_ssid2_pw(@tc_wifi_pw1)
						if @wifi_page.ssid2_sw == @tc_wifi_off
								@wifi_page.ssid2_sw = @tc_wifi_on
						end
						##############################SSID3#################################################
						ssid3_name = @wifi_page.ssid3
						puts "��ǰSSID3��Ϊ#{ssid3_name}".to_gbk
						new_ssid3 = "wirless3_#{@tc_mac_last}"
						puts "��SSID3��Ϊ#{new_ssid3}".to_gbk
						@wifi_page.modify_ssid3(new_ssid3)
						if @wifi_page.ssid3_sw == @tc_wifi_off
								@wifi_page.ssid3_sw = @tc_wifi_on
						end
						puts "�޸�SSID3����Ϊ#{@tc_wifi_pw2}".to_gbk
						@wifi_page.modify_ssid3_pw(@tc_wifi_pw2)
						##############################SSID4#################################################
						ssid4_name = @wifi_page.ssid4
						puts "��ǰSSID4��Ϊ#{ssid4_name}".to_gbk
						new_ssid4 = "wirless4_#{@tc_mac_last}"
						puts "��SSID4��Ϊ#{new_ssid4}".to_gbk
						@wifi_page.modify_ssid4(new_ssid4)
						puts "�޸�SSID4����Ϊ#{@tc_wifi_pw1}".to_gbk
						@wifi_page.modify_ssid4_pw(@tc_wifi_pw1)
						if @wifi_page.ssid4_sw == @tc_wifi_off
								@wifi_page.ssid4_sw = @tc_wifi_on
						end

						@wifi_page.save_wifi_config
						##############################connect SSID2#################################################
						puts "conneting  ssid :#{new_ssid2}"
						rs1_ssid2 = @wifi.connect(new_ssid2, @ts_wifi_flag, @tc_wifi_pw1)
						assert rs1_ssid2, 'WIFI����ʧ��'
						rs2_ssid2 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid2, 'WIFI�ͻ����޷�pingͨ·����'
						##############################connect SSID3#################################################
						puts "conneting  ssid :#{new_ssid3}"
						rs3_ssid3 = @wifi.connect(new_ssid3, @ts_wifi_flag, @tc_wifi_pw2)
						assert rs3_ssid3, 'WIFI����ʧ��'
						rs4_ssid3 = @wifi.ping(@ts_default_ip)
						assert rs4_ssid3, 'WIFI�ͻ����޷�pingͨ·����'
						##############################connect SSID4#################################################
						puts "conneting  ssid :#{new_ssid4}"
						rs1_ssid4 = @wifi.connect(new_ssid4, @ts_wifi_flag, @tc_wifi_pw1)
						assert rs1_ssid4, 'WIFI����ʧ��'
						rs2_ssid4 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid4, 'WIFI�ͻ����޷�pingͨ·����'
				}

				# operate("2����Կ����#{@tc_wifi_pw2},#{@tc_wifi_pw2.size}��16���ƣ��Ƿ�������óɹ���STA�Ƿ����ӳɹ���") {
				# 		#��һ���Ѿ�ʵ��
				# }

		end

		def clearup
				operate("1 �ָ�Ĭ��ssid������") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#�޸ĵ�һ��SSID����
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						if @wifi_page.ssid1_sw == @tc_wifi_off
								@wifi_page.ssid1_sw = @tc_wifi_on
						end
						@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)

						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						if @wifi_page.ssid2_sw == @tc_wifi_on
								@wifi_page.ssid2_sw = @tc_wifi_off
						end
						@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)

						@wifi_page.modify_ssid3(@ts_wifi_ssid3)
						if @wifi_page.ssid3_sw == @tc_wifi_on
								@wifi_page.ssid3_sw = @tc_wifi_off
						end
						@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)

						@wifi_page.modify_ssid4(@ts_wifi_ssid4)
						if @wifi_page.ssid4_sw == @tc_wifi_on
								@wifi_page.ssid4_sw = @tc_wifi_off
						end
						@wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
						@wifi_page.save_wifi_config
				}
		end

}
