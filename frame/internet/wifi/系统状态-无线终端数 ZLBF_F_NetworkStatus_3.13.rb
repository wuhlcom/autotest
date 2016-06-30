#
# description:
# ����ֻ��һ�����߿ͻ��ˣ���������������߿ͻ��˷ֱ�����ÿ��SSIdʱ�������ǲ�����ȷ����
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_5.1.39", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi         = DRbObject.new_with_uri(@ts_drb_server)
				@tc_linkednum = "1"
				@tc_linkednone= "0"
				@tc_flag5     = false
				@tc_flag6     = false
				@tc_flag7     = false
				@tc_flag8     = false
				@tc_wifi_on    = "ON"
				@tc_wifi_off   = "OFF"
		end

		def process

				# operate("1��SSID1����2���նˣ�SSID2����3���նˣ�") {
				operate("1���޸���������") {
						@wifi_page   = RouterPageObject::WIFIPage.new(@browser)
						@tc_mac_last = @wifi_page.get_mac_last
						@wifi_page.select_2g_basic(@browser.url)
						###############################ssid1#######################
						ssid1_name = @wifi_page.ssid1
						puts "��ǰSSID1��Ϊ#{ssid1_name}".to_gbk
						@new_ssid1 = "autotest1_#{@tc_mac_last}"
						puts "��SSID1��Ϊ#{@new_ssid1}".to_gbk
						@wifi_page.modify_ssid1(@new_ssid1)
						unless @wifi_page.ssid1_pw==@ts_default_wlan_pw
								puts "�޸�SSID1����Ϊ#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid1_sw==@tc_wifi_off
								@wifi_page.ssid1_sw=@tc_wifi_on
						end
						###############################ssid2#######################
						ssid2_name = @wifi_page.ssid2
						puts "��ǰSSID2��Ϊ#{ssid2_name}".to_gbk
						@new_ssid2 = "autotest2_#{@tc_mac_last}"
						puts "��SSID2��Ϊ#{@new_ssid2}".to_gbk
						@wifi_page.modify_ssid2(@new_ssid2)
						unless @wifi_page.ssid2_pw==@ts_default_wlan_pw
								puts "�޸�SSID2����Ϊ#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid2_sw==@tc_wifi_off
								@wifi_page.ssid2_sw=@tc_wifi_on
						end
						###############################ssid3#######################
						ssid3_name = @wifi_page.ssid3
						puts "��ǰSSID3��Ϊ#{ssid3_name}".to_gbk
						@new_ssid3 = "autotest3_#{@tc_mac_last}"
						puts "��SSID3��Ϊ#{@new_ssid3}".to_gbk
						@wifi_page.modify_ssid3(@new_ssid3)
						unless @wifi_page.ssid3_pw==@ts_default_wlan_pw
								puts "�޸�SSID3����Ϊ#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid3_sw==@tc_wifi_off
								@wifi_page.ssid3_sw=@tc_wifi_on
						end
						###############################ssid4#######################
						ssid4_name = @wifi_page.ssid4
						puts "��ǰSSID4��Ϊ#{ssid4_name}".to_gbk
						@new_ssid4 = "autotest4_#{@tc_mac_last}"
						puts "��SSID4��Ϊ#{@new_ssid4}".to_gbk
						@wifi_page.modify_ssid4(@new_ssid4)
						unless @wifi_page.ssid4_pw==@ts_default_wlan_pw
								puts "�޸�SSID4����Ϊ#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid4_sw==@tc_wifi_off
								@wifi_page.ssid4_sw=@tc_wifi_on
						end

						if @wifi_page.ssid5?
								@tc_flag5  = true
								ssid5_name = @wifi_page.ssid5
								puts "��ǰSSID5��Ϊ#{ssid5_name}".to_gbk
								@new_ssid5 = "autotest5_#{@tc_mac_last}"
								puts "��SSID5��Ϊ#{@new_ssid5}".to_gbk
								@wifi_page.modify_ssid5(@new_ssid5)
								unless @wifi_page.ssid5_pw==@ts_default_wlan_pw
										puts "�޸�SSID5����Ϊ#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid5_pw(@ts_default_wlan_pw)
								end
								if @wifi_page.ssid5_sw==@tc_wifi_off
										@wifi_page.ssid5_sw=@tc_wifi_on
								end
						end

						if @wifi_page.ssid6?
								@tc_flag6  = true
								ssid6_name = @wifi_page.ssid6
								puts "��ǰSSID6��Ϊ#{ssid6_name}".to_gbk
								@new_ssid6 = "autotest6_#{@tc_mac_last}"
								puts "��SSID6��Ϊ#{@new_ssid6}".to_gbk
								@wifi_page.modify_ssid6(@new_ssid6)
								unless @wifi_page.ssid6_pw==@ts_default_wlan_pw
										puts "�޸�SSID6����Ϊ#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid6_pw(@ts_default_wlan_pw)
								end
								if @wifi_page.ssid6_sw==@tc_wifi_off
										@wifi_page.ssid6_sw=@tc_wifi_on
								end
						end

						if @wifi_page.ssid7?
								@tc_flag7  = true
								ssid7_name = @wifi_page.ssid7
								puts "��ǰSSID7��Ϊ#{ssid7_name}".to_gbk
								@new_ssid7 = "autotest7_#{@tc_mac_last}"
								puts "��SSID7��Ϊ#{@new_ssid7}".to_gbk
								@wifi_page.modify_ssid7(@new_ssid7)
								unless @wifi_page.ssid7_pw==@ts_default_wlan_pw
										puts "�޸�SSID7����Ϊ#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid7_pw(@ts_default_wlan_pw)
								end
								if @wifi_page.ssid7_sw==@tc_wifi_off
										@wifi_page.ssid7_sw=@tc_wifi_on
								end
						end

						if @wifi_page.ssid8?
								@tc_flag8  = true
								ssid8_name = @wifi_page.ssid8
								puts "��ǰSSID8��Ϊ#{ssid8_name}".to_gbk
								@new_ssid8 = "autotest8_#{@tc_mac_last}"
								puts "��SSID8��Ϊ#{@new_ssid8}".to_gbk
								@wifi_page.modify_ssid8(@new_ssid8)
								unless @wifi_page.ssid8_pw==@ts_default_wlan_pw
										puts "�޸�SSID8����Ϊ#{@ts_default_wlan_pw}".to_gbk
										@wifi_page.modify_ssid8_pw(@ts_default_wlan_pw)
								end
								if @wifi_page.ssid8_sw==@tc_wifi_off
										@wifi_page.ssid8_sw=@tc_wifi_on
								end
						end
						@wifi_page.save_wifi_config
				}

				operate("2������SSID,�ֱ�鿴ϵͳ״̬-����״̬���飬�ն����Ƿ���ʾ��ȷ��") {
						puts "����#{@new_ssid1}".to_gbk
						rs1_ssid1 = @wifi.connect(@new_ssid1, @ts_wifi_flag, @ts_default_wlan_pw)
						assert rs1_ssid1, 'WIFI����ʧ��'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI�ͻ����޷�pingͨ·����'
						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯ������ϸ��Ϣ".to_gbk
						linked = @wifi_detail.ssid1_linked
						puts "��ѯ��SSID1��������Ϊ��#{linked}".to_gbk
						assert_equal(@tc_linkednum, linked, "SSID1��������ͳ�ƴ���")

						puts "����#{@new_ssid2}".to_gbk
						@wifi.netsh_disc_all
						rs1_ssid1 = @wifi.connect(@new_ssid2, @ts_wifi_flag, @ts_default_wlan_pw)
						assert rs1_ssid1, 'WIFI����ʧ��'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI�ͻ����޷�pingͨ·����'

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯ������ϸ��Ϣ".to_gbk
						linked1 = @wifi_detail.ssid1_linked
						linked  = @wifi_detail.ssid2_linked
						puts "��ѯ��SSID1��������Ϊ��#{linked1}".to_gbk
						puts "��ѯ��SSID2��������Ϊ��#{linked}".to_gbk
						assert_equal(@tc_linkednone, linked1, "SSID1��������ͳ�ƴ���")
						assert_equal(@tc_linkednum, linked, "SSID2��������ͳ�ƴ���")

						puts "����#{@new_ssid3}".to_gbk
						@wifi.netsh_disc_all
						rs1_ssid1 = @wifi.connect(@new_ssid3, @ts_wifi_flag, @ts_default_wlan_pw)
						assert rs1_ssid1, 'WIFI����ʧ��'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI�ͻ����޷�pingͨ·����'

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯ������ϸ��Ϣ".to_gbk
						linked1 = @wifi_detail.ssid1_linked
						linked2 = @wifi_detail.ssid2_linked
						linked  = @wifi_detail.ssid3_linked
						puts "��ѯ��SSID1��������Ϊ��#{linked1}".to_gbk
						puts "��ѯ��SSID2��������Ϊ��#{linked2}".to_gbk
						puts "��ѯ��SSID3��������Ϊ��#{linked}".to_gbk
						assert_equal(@tc_linkednone, linked1, "SSID1��������ͳ�ƴ���")
						assert_equal(@tc_linkednone, linked2, "SSID2��������ͳ�ƴ���")
						assert_equal(@tc_linkednum, linked, "SSID3��������ͳ�ƴ���")

						puts "����#{@new_ssid4}".to_gbk
						@wifi.netsh_disc_all
						rs1_ssid1 = @wifi.connect(@new_ssid4, @ts_wifi_flag, @ts_default_wlan_pw)
						assert rs1_ssid1, 'WIFI����ʧ��'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI�ͻ����޷�pingͨ·����'

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯ������ϸ��Ϣ".to_gbk
						linked1 = @wifi_detail.ssid1_linked
						linked2 = @wifi_detail.ssid2_linked
						linked3 = @wifi_detail.ssid3_linked
						linked  = @wifi_detail.ssid4_linked
						puts "��ѯ��SSID1��������Ϊ��#{linked1}".to_gbk
						puts "��ѯ��SSID2��������Ϊ��#{linked2}".to_gbk
						puts "��ѯ��SSID3��������Ϊ��#{linked3}".to_gbk
						puts "��ѯ��SSID4��������Ϊ��#{linked}".to_gbk
						assert_equal(@tc_linkednone, linked1, "SSID1��������ͳ�ƴ���")
						assert_equal(@tc_linkednone, linked2, "SSID2��������ͳ�ƴ���")
						assert_equal(@tc_linkednone, linked3, "SSID3��������ͳ�ƴ���")
						assert_equal(@tc_linkednum, linked, "SSID4��������ͳ�ƴ���")

						if @tc_flag5
								@wifi.netsh_disc_all
								rs1_ssid1 = @wifi.connect(@new_ssid5, @ts_wifi_flag, @ts_default_wlan_pw)
								assert rs1_ssid1, 'WIFI����ʧ��'
								rs2_ssid1 = @wifi.ping(@ts_default_ip)
								assert rs2_ssid1, 'WIFI�ͻ����޷�pingͨ·����'
								@wifi_detail.open_wifidetail_page(@browser.url)
								puts "��ѯ������ϸ��Ϣ".to_gbk
								linked4 = @wifi_detail.ssid4_linked
								linked  = @wifi_detail.ssid5_linked
								puts "��ѯ��SSID4��������Ϊ��#{linked4}".to_gbk
								puts "��ѯ��SSID5��������Ϊ��#{linked}".to_gbk
								assert_equal(@tc_linkednone, linked3, "SSID4��������ͳ�ƴ���")
								assert_equal(@tc_linkednum, linked, "SSID5��������ͳ�ƴ���")
						end

						if @tc_flag6
								@wifi.netsh_disc_all
								rs1_ssid1 = @wifi.connect(@new_ssid6, @ts_wifi_flag, @ts_default_wlan_pw)
								assert rs1_ssid1, 'WIFI����ʧ��'
								rs2_ssid1 = @wifi.ping(@ts_default_ip)
								assert rs2_ssid1, 'WIFI�ͻ����޷�pingͨ·����'
								@wifi_detail.open_wifidetail_page(@browser.url)
								puts "��ѯ������ϸ��Ϣ".to_gbk
								linked5 = @wifi_detail.ssid5_linked
								linked  = @wifi_detail.ssid6_linked
								puts "��ѯ��SSID5��������Ϊ��#{linked5}".to_gbk
								puts "��ѯ��SSID6��������Ϊ��#{linked}".to_gbk
								assert_equal(@tc_linkednone, linked5, "SSID5��������ͳ�ƴ���")
								assert_equal(@tc_linkednum, linked, "SSID6��������ͳ�ƴ���")
						end

						if @tc_flag7
								@wifi.netsh_disc_all
								rs1_ssid1 = @wifi.connect(@new_ssid7, @ts_wifi_flag, @ts_default_wlan_pw)
								assert rs1_ssid1, 'WIFI����ʧ��'
								rs2_ssid1 = @wifi.ping(@ts_default_ip)
								assert rs2_ssid1, 'WIFI�ͻ����޷�pingͨ·����'

								@wifi_detail.open_wifidetail_page(@browser.url)
								puts "��ѯ������ϸ��Ϣ".to_gbk
								linked6 = @wifi_detail.ssid6_linked
								linked  = @wifi_detail.ssid7_linked
								puts "��ѯ��SSID6��������Ϊ��#{linked6}".to_gbk
								puts "��ѯ��SSID7��������Ϊ��#{linked}".to_gbk
								assert_equal(@tc_linkednone, linked6, "SSID6��������ͳ�ƴ���")
								assert_equal(@tc_linkednum, linked, "SSID7��������ͳ�ƴ���")
						end

						if @tc_flag8
								@wifi.netsh_disc_all
								rs1_ssid1 = @wifi.connect(@new_ssid8, @ts_wifi_flag, @ts_default_wlan_pw)
								assert rs1_ssid1, 'WIFI����ʧ��'
								rs2_ssid1 = @wifi.ping(@ts_default_ip)
								assert rs2_ssid1, 'WIFI�ͻ����޷�pingͨ·����'

								@wifi_detail.open_wifidetail_page(@browser.url)
								puts "��ѯ������ϸ��Ϣ".to_gbk
								linked7 = @wifi_detail.ssid7_linked
								linked  = @wifi_detail.ssid8_linked
								puts "��ѯ��SSID6��������Ϊ��#{linked7}".to_gbk
								puts "��ѯ��SSID7��������Ϊ��#{linked}".to_gbk
								assert_equal(@tc_linkednone, linked7, "SSID7��������ͳ�ƴ���")
								assert_equal(@tc_linkednum, linked, "SSID8��������ͳ�ƴ���")
						end
				}

				# operate("4���ֱ�鿴ϵͳ״̬-����״̬���飬�ն����Ƿ���ʾ��ȷ��") {}

		end

		def clearup
				operate("1 �ָ�Ĭ������") {
						@wifi.netsh_disc_all
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#�޸�SSID1
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)
						if @wifi_page.ssid1_sw==@tc_wifi_off
								@wifi_page.ssid1_sw=@tc_wifi_on
						end
						#�޸�SSID2
						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						if @wifi_page.ssid2_sw==@tc_wifi_on
								@wifi_page.ssid2_sw=@tc_wifi_off
						end
						#�޸�SSID3
						@wifi_page.modify_ssid3(@ts_wifi_ssid3)
						@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						if @wifi_page.ssid3_sw==@tc_wifi_on
								@wifi_page.ssid3_sw=@tc_wifi_off
						end
						#�޸�SSID4
						@wifi_page.modify_ssid4(@ts_wifi_ssid4)
						@wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
						if @wifi_page.ssid4_sw==@tc_wifi_on
								@wifi_page.ssid4_sw=@tc_wifi_off
						end
						if @tc_flag5
								@wifi_page.modify_ssid5(@ts_wifi_ssid5)
								@wifi_page.modify_ssid5_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
								if @wifi_page.ssid5_sw==@tc_wifi_on
										@wifi_page.ssid5_sw=@tc_wifi_off
								end
						end
						if @tc_flag6
								@wifi_page.modify_ssid6(@ts_wifi_ssid6)
								@wifi_page.modify_ssid6_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
								if @wifi_page.ssid6_sw==@tc_wifi_on
										@wifi_page.ssid6_sw=@tc_wifi_off
								end
						end
						if @tc_flag7
								@wifi_page.modify_ssid7(@ts_wifi_ssid7)
								@wifi_page.modify_ssid7_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
								if @wifi_page.ssid7_sw==@tc_wifi_on
										@wifi_page.ssid7_sw=@tc_wifi_off
								end
						end
						if @tc_flag8
								@wifi_page.modify_ssid8(@ts_wifi_ssid8)
								@wifi_page.modify_ssid8_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid8_linknum(@ts_linknum_max)
								if @wifi_page.ssid7_sw==@tc_wifi_on
										@wifi_page.ssid7_sw=@tc_wifi_off
								end
						end
						#����
						@wifi_page.save_wifi_config
				}
		end

}
