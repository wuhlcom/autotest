#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_5.1.38", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_ssid1     = "autotest0-5G"
				@tc_ssid2     = "autotest1-5G"
				@tc_ssid3     = "autotest2-5G"
				@tc_ssid4     = "autotest3-5G"
				@tc_ssid5     = "autotest4-5G"
				@tc_ssid6     = "autotest5-5G"
				@tc_ssid7     = "autotest6-5G"
				@tc_ssid8     = "autotest7-5G"
				@tc_pw        = "12345678"
				@tc_linkmax1  = "20"
				@tc_ssid1_cn  = "֪·�Զ�����1-5G"
				@tc_ssid2_cn  = "֪·�Զ�����2-5G"
				@tc_ssid3_cn  = "֪·�Զ�����3-5G"
				@tc_ssid4_cn  = "֪·�Զ�����4-5G"
				@tc_ssid5_cn  = "֪·�Զ�����5-5G"
				@tc_ssid6_cn  = "֪·�Զ�����6-5G"
				@tc_ssid7_cn  = "֪·�Զ�����7-5G"
				@tc_ssid8_cn  = "֪·�Զ�����8-5G"
				@tc_linkmax2  = "10"
				@tc_wifi_on   = "ON"
				@tc_wifi_off  = "OFF"
				@tc_rf_mode   = "2.4G"
				@tc_linkednum = "0"
				@tc_flag1     = false
				@tc_flag2     = false
				@tc_flag3     = false
				@tc_flag4     = false
		end

		def process

				operate("1���鿴Ĭ������5G����״̬�Ƿ���ȷ��") {
						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯSSID1Ĭ����ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid1_name_5g
						ssid_pw = @wifi_detail.ssid1_pwmode_5g
						linkmax = @wifi_detail.ssid1_linknum_5g
						linked  = @wifi_detail.ssid1_linked_5g
						ssid_rf = @wifi_detail.ssid1_rf_5g
						ssid_sw = @wifi_detail.ssid1_sw_5g
						puts "��ѯ��SSID1��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID1���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID1���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID1��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID1��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID1���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid1_5g, ssid, "��ѯ��Ĭ��SSID1��Ϊ#{@ts_wifi_ssid1_5g}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID1���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID1�����������Ϊ#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID1����������Ϊ#{@tc_linkednum}")
						assert_equal(@tc_wifi_on, ssid_sw, "��ѯ��Ĭ��SSID1����״̬δ��")

						puts "��ѯSSID2Ĭ����ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid2_name_5g
						ssid_pw = @wifi_detail.ssid2_pwmode_5g
						linkmax = @wifi_detail.ssid2_linknum_5g
						linked  = @wifi_detail.ssid2_linked_5g
						ssid_rf = @wifi_detail.ssid2_rf_5g
						ssid_sw = @wifi_detail.ssid2_sw_5g
						puts "��ѯ��SSID2��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID2���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID2���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID2��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID2��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID2���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid2_5g, ssid, "��ѯ��Ĭ��SSID2��Ϊ#{@ts_wifi_ssid2_5g}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID2���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID2�����������Ϊ#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID2����������Ϊ#{@tc_linkednum}")
						assert_equal(@tc_wifi_on, ssid_sw, "��ѯ��Ĭ��SSID2����״̬δ��")

						puts "��ѯSSID3Ĭ����ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid3_name_5g
						ssid_pw = @wifi_detail.ssid3_pwmode_5g
						linkmax = @wifi_detail.ssid3_linknum_5g
						linked  = @wifi_detail.ssid3_linked_5g
						ssid_rf = @wifi_detail.ssid3_rf_5g
						ssid_sw = @wifi_detail.ssid3_sw_5g
						puts "��ѯ��SSID3��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID3���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID3���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID3��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID3��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID3���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid3_5g, ssid, "��ѯ��Ĭ��SSID3��Ϊ#{@ts_wifi_ssid3_5g}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID3���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID3�����������Ϊ#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID3����������Ϊ#{@tc_linkednum}")
						assert_equal(@tc_wifi_on, ssid_sw, "��ѯ��Ĭ��SSID3����״̬δ��")

						puts "��ѯSSID4Ĭ����ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid4_name_5g
						ssid_pw = @wifi_detail.ssid4_pwmode_5g
						linkmax = @wifi_detail.ssid4_linknum_5g
						linked  = @wifi_detail.ssid4_linked_5g
						ssid_rf = @wifi_detail.ssid4_rf_5g
						ssid_sw = @wifi_detail.ssid4_sw_5g
						puts "��ѯ��SSID4��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID4���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID4���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID4��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID4��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID4���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid4_5g, ssid, "��ѯ��Ĭ��SSID4��Ϊ#{@ts_wifi_ssid4_5g}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID4���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID4�����������Ϊ#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID4����������Ϊ#{@tc_linkednum}")
						assert_equal(@tc_wifi_on, ssid_sw, "��ѯ��Ĭ��SSID4����״̬δ��")

						if @tc_flag1
								puts "��ѯSSID5Ĭ����ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid5_name_5g
								ssid_pw = @wifi_detail.ssid5_pwmode_5g
								linkmax = @wifi_detail.ssid5_linknum_5g
								linked  = @wifi_detail.ssid5_linked_5g
								ssid_rf = @wifi_detail.ssid5_rf_5g
								ssid_sw = @wifi_detail.ssid5_sw_5g
								puts "��ѯ��SSID5��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID5���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID5���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID5��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID5��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID5���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@ts_wifi_ssid5, ssid, "��ѯ��Ĭ��SSID5��Ϊ#{@ts_wifi_ssid5}")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID5���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
								assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID5�����������Ϊ#{@ts_linknum_max}")
								assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID5����������Ϊ#{@tc_linkednum}")
								assert_equal(@tc_wifi_on, ssid_sw, "��ѯ��Ĭ��SSID5����״̬δ��")
						end

						if @tc_flag2
								puts "��ѯSSID6Ĭ����ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid6_name_5g
								ssid_pw = @wifi_detail.ssid6_pwmode_5g
								linkmax = @wifi_detail.ssid6_linknum_5g
								linked  = @wifi_detail.ssid6_linked_5g
								ssid_rf = @wifi_detail.ssid6_rf_5g
								ssid_sw = @wifi_detail.ssid6_sw_5g
								puts "��ѯ��SSID6��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID6���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID6���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID6��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID6��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID6���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@ts_wifi_ssid6, ssid, "��ѯ��Ĭ��SSID6��Ϊ#{@ts_wifi_ssid6}")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID6���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
								assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID6�����������Ϊ#{@ts_linknum_max}")
								assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID6����������Ϊ#{@tc_linkednum}")
								assert_equal(@tc_wifi_on, ssid_sw, "��ѯ��Ĭ��SSID6����״̬δ��")
						end

						if @tc_flag3
								puts "��ѯSSID7Ĭ����ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid7_name_5g
								ssid_pw = @wifi_detail.ssid7_pwmode_5g
								linkmax = @wifi_detail.ssid7_linknum_5g
								linked  = @wifi_detail.ssid7_linked_5g
								ssid_rf = @wifi_detail.ssid7_rf_5g
								ssid_sw = @wifi_detail.ssid7_sw_5g
								puts "��ѯ��SSID7��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID7���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID7���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID7��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID7��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID7���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@ts_wifi_ssid7, ssid, "��ѯ��Ĭ��SSID7��Ϊ#{@ts_wifi_ssid7}")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID7���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
								assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID7�����������Ϊ#{@ts_linknum_max}")
								assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID7����������Ϊ#{@tc_linkednum}")
								assert_equal(@tc_wifi_on, ssid_sw, "��ѯ��Ĭ��SSID7����״̬δ��")
						end

						if @tc_flag4
								puts "��ѯSSID8Ĭ����ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid8_name_5g
								ssid_pw = @wifi_detail.ssid8_pwmode_5g
								linkmax = @wifi_detail.ssid8_linknum_5g
								linked  = @wifi_detail.ssid8_linked_5g
								ssid_rf = @wifi_detail.ssid8_rf_5g
								ssid_sw = @wifi_detail.ssid8_sw_5g
								puts "��ѯ��SSID8��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID8���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID8���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID8��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID8��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID8���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@ts_wifi_ssid8, ssid, "��ѯ��Ĭ��SSID8��Ϊ#{@ts_wifi_ssid8}")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID8���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
								assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID8�����������Ϊ#{@ts_linknum_max}")
								assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID8����������Ϊ#{@tc_linkednum}")
								assert_equal(@tc_wifi_on, ssid_sw, "��ѯ��Ĭ��SSID8����״̬δ��")
						end

				}

				operate("2����wifi����ҳ������5G��8��SSID�ֱ�Ϊopen1��Open8������ģʽWPA/WPA2��ϣ�����Ϊ88888888�����������20������ON��������棻") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_5g_basic(@browser.url)
						#�޸�SSID1
						@wifi_page.modify_ssid1_5g(@tc_ssid1)
						@wifi_page.modify_ssid1_pw_5g(@tc_pw)
						@wifi_page.modify_ssid1_linknum_5g(@tc_linkmax1)
						if @wifi_page.ssid1_sw_5g==@tc_wifi_off
								@wifi_page.ssid1_sw_5g=@tc_wifi_on
						end
						#�޸�SSID2
						@wifi_page.modify_ssid2_5g(@tc_ssid2)
						@wifi_page.modify_ssid2_pw_5g(@tc_pw)
						@wifi_page.modify_ssid2_linknum_5g(@tc_linkmax1)
						if @wifi_page.ssid2_sw_5g==@tc_wifi_off
								@wifi_page.ssid2_sw_5g=@tc_wifi_on
						end
						#�޸�SSID3
						@wifi_page.modify_ssid3_5g(@tc_ssid3)
						@wifi_page.modify_ssid3_pw_5g(@tc_pw)
						@wifi_page.modify_ssid3_linknum_5g(@tc_linkmax1)
						if @wifi_page.ssid3_sw_5g==@tc_wifi_off
								@wifi_page.ssid3_sw_5g=@tc_wifi_on
						end
						#�޸�SSID4
						@wifi_page.modify_ssid4_5g(@tc_ssid4)
						@wifi_page.modify_ssid4_pw_5g(@tc_pw)
						@wifi_page.modify_ssid4_linknum_5g(@tc_linkmax1)
						if @wifi_page.ssid4_sw_5g==@tc_wifi_off
								@wifi_page.ssid4_sw_5g=@tc_wifi_on
						end
						#�޸�SSID5
						if @wifi_page.ssid5?
								@tc_flag1 = true
								@wifi_page.modify_ssid5_5g(@tc_ssid5)
								@wifi_page.modify_ssid5_pw_5g(@tc_pw)
								@wifi_page.modify_ssid5_linknum_5g(@tc_linkmax1)
								if @wifi_page.ssid5_sw_5g==@tc_wifi_off
										@wifi_page.ssid5_sw_5g=@tc_wifi_on
								end
						end
						#�޸�SSID6
						if @wifi_page.ssid6?
								@tc_flag2 = true
								@wifi_page.modify_ssid6_5g(@tc_ssid6)
								@wifi_page.modify_ssid6_pw_5g(@tc_pw)
								@wifi_page.modify_ssid6_linknum_5g(@tc_linkmax1)
								if @wifi_page.ssid6_sw_5g==@tc_wifi_off
										@wifi_page.ssid6_sw_5g=@tc_wifi_on
								end
						end
						#�޸�SSID7
						if @wifi_page.ssid7?
								@tc_flag3 = true
								@wifi_page.modify_ssid7_5g(@tc_ssid7)
								@wifi_page.modify_ssid7_pw_5g(@tc_pw)
								@wifi_page.modify_ssid7_linknum_5g(@tc_linkmax1)
								if @wifi_page.ssid7_sw_5g==@tc_wifi_off
										@wifi_page.ssid7_sw_5g=@tc_wifi_on
								end
						end
						#�޸�SSID8
						if @wifi_page.ssid8?
								@tc_flag4 = true
								@wifi_page.modify_ssid8_5g(@tc_ssid8)
								@wifi_page.modify_ssid8_pw_5g(@tc_pw)
								@wifi_page.modify_ssid8_linknum_5g(@tc_linkmax1)
								if @wifi_page.ssid8_sw_5g==@tc_wifi_off
										@wifi_page.ssid8_sw_5g=@tc_wifi_on
								end
						end
						#����
						@wifi_page.save_wifi_config

						# @wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯSSID1��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid1_name_5g
						ssid_pw = @wifi_detail.ssid1_pwmode_5g
						linkmax = @wifi_detail.ssid1_linknum_5g
						linked  = @wifi_detail.ssid1_linked_5g
						ssid_rf = @wifi_detail.ssid1_rf_5g
						ssid_sw = @wifi_detail.ssid1_sw_5g
						puts "��ѯ��SSID1��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID1���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID1���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID1��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID1��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID1���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid1, ssid, "����SSID1Ϊ#{@tc_ssid1}ʧ��")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "����SSID1���ܷ�ʽΪ#{@ts_sec_mode_wpa}ʧ��")
						assert_equal(@tc_linkmax1, linkmax, "����SSID1���������Ϊ#{@tc_linkmax1}ʧ��")
						assert_equal(@tc_linkednum, linked, "SSID1��������ͳ�ƴ���")
						assert_equal(@tc_wifi_on, ssid_sw, "SSID1����״̬����")

						puts "��ѯSSID2��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid2_name_5g
						ssid_pw = @wifi_detail.ssid2_pwmode_5g
						linkmax = @wifi_detail.ssid2_linknum_5g
						linked  = @wifi_detail.ssid2_linked_5g
						ssid_rf = @wifi_detail.ssid2_rf_5g
						ssid_sw = @wifi_detail.ssid2_sw_5g
						puts "��ѯ��SSID2��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID2���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID2���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID2��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID2��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID2���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid2, ssid, "����SSID2Ϊ#{@tc_ssid2}ʧ��")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "����SSID2���ܷ�ʽΪ#{@ts_sec_mode_wpa}ʧ��")
						assert_equal(@tc_linkmax1, linkmax, "����SSID2���������Ϊ#{@tc_linkmax1}ʧ��")
						assert_equal(@tc_linkednum, linked, "SSID2��������ͳ�ƴ���")
						assert_equal(@tc_wifi_on, ssid_sw, "SSID2����״̬����")

						puts "��ѯSSID3��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid3_name_5g
						ssid_pw = @wifi_detail.ssid3_pwmode_5g
						linkmax = @wifi_detail.ssid3_linknum_5g
						linked  = @wifi_detail.ssid3_linked_5g
						ssid_rf = @wifi_detail.ssid3_rf_5g
						ssid_sw = @wifi_detail.ssid3_sw_5g
						puts "��ѯ��SSID3��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID3���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID3���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID3��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID3��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID3���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid3, ssid, "����SSID3Ϊ#{@tc_ssid3}ʧ��")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "����SSID3���ܷ�ʽΪ#{@ts_sec_mode_wpa}ʧ��")
						assert_equal(@tc_linkmax1, linkmax, "����SSID3���������Ϊ#{@tc_linkmax1}ʧ��")
						assert_equal(@tc_linkednum, linked, "SSID3��������ͳ�ƴ���")
						assert_equal(@tc_wifi_on, ssid_sw, "SSID3����״̬����")

						puts "��ѯSSID4��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid4_name_5g
						ssid_pw = @wifi_detail.ssid4_pwmode_5g
						linkmax = @wifi_detail.ssid4_linknum_5g
						linked  = @wifi_detail.ssid4_linked_5g
						ssid_rf = @wifi_detail.ssid4_rf_5g
						ssid_sw = @wifi_detail.ssid4_sw_5g
						puts "��ѯ��SSID4��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID4���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID4���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID4��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID4��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID4���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid4, ssid, "����SSID4Ϊ#{@tc_ssid4}ʧ��")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "����SSID4���ܷ�ʽΪ#{@ts_sec_mode_wpa}ʧ��")
						assert_equal(@tc_linkmax1, linkmax, "����SSID4���������Ϊ#{@tc_linkmax1}ʧ��")
						assert_equal(@tc_linkednum, linked, "SSID4��������ͳ�ƴ���")
						assert_equal(@tc_wifi_on, ssid_sw, "SSID4����״̬����")

						if @tc_flag1
								puts "��ѯSSID5��ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid5_name_5g
								ssid_pw = @wifi_detail.ssid5_pwmode_5g
								linkmax = @wifi_detail.ssid5_linknum_5g
								linked  = @wifi_detail.ssid5_linked_5g
								ssid_rf = @wifi_detail.ssid5_rf_5g
								ssid_sw = @wifi_detail.ssid5_sw_5g
								puts "��ѯ��SSID5��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID5���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID5���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID5��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID5��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID5���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid5, ssid, "����SSID5Ϊ#{@tc_ssid5}ʧ��")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "����SSID5���ܷ�ʽΪ#{@ts_sec_mode_wpa}ʧ��")
								assert_equal(@tc_linkmax1, linkmax, "����SSID5���������Ϊ#{@tc_linkmax1}ʧ��")
								assert_equal(@tc_linkednum, linked, "SSID5��������ͳ�ƴ���")
								assert_equal(@tc_wifi_on, ssid_sw, "SSID5����״̬����")
						end

						if @tc_flag2
								puts "��ѯSSID6��ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid6_name_5g
								ssid_pw = @wifi_detail.ssid6_pwmode_5g
								linkmax = @wifi_detail.ssid6_linknum_5g
								linked  = @wifi_detail.ssid6_linked_5g
								ssid_rf = @wifi_detail.ssid6_rf_5g
								ssid_sw = @wifi_detail.ssid6_sw_5g
								puts "��ѯ��SSID6��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID6���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID6���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID6��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID6��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID6���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid6, ssid, "����SSID6Ϊ#{@tc_ssid6}ʧ��")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "����SSID6���ܷ�ʽΪ#{@ts_sec_mode_wpa}ʧ��")
								assert_equal(@tc_linkmax1, linkmax, "����SSID6���������Ϊ#{@tc_linkmax1}ʧ��")
								assert_equal(@tc_linkednum, linked, "SSID6��������ͳ�ƴ���")
								assert_equal(@tc_wifi_on, ssid_sw, "SSID6����״̬����")
						end

						if @tc_flag3
								puts "��ѯSSID7��ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid7_name_5g
								ssid_pw = @wifi_detail.ssid7_pwmode_5g
								linkmax = @wifi_detail.ssid7_linknum_5g
								linked  = @wifi_detail.ssid7_linked_5g
								ssid_rf = @wifi_detail.ssid7_rf_5g
								ssid_sw = @wifi_detail.ssid7_sw_5g
								puts "��ѯ��SSID7��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID7���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID7���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID7��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID7��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID7���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid4, ssid, "����SSID7Ϊ#{@tc_ssid4}ʧ��")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "����SSID7���ܷ�ʽΪ#{@ts_sec_mode_wpa}ʧ��")
								assert_equal(@tc_linkmax1, linkmax, "����SSID7���������Ϊ#{@tc_linkmax1}ʧ��")
								assert_equal(@tc_linkednum, linked, "SSID7��������ͳ�ƴ���")
								assert_equal(@tc_wifi_on, ssid_sw, "SSID7����״̬����")
						end

						if @tc_flag4
								puts "��ѯSSID8��ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid8_name_5g
								ssid_pw = @wifi_detail.ssid8_pwmode_5g
								linkmax = @wifi_detail.ssid8_linknum_5g
								linked  = @wifi_detail.ssid8_linked_5g
								ssid_rf = @wifi_detail.ssid8_rf_5g
								ssid_sw = @wifi_detail.ssid8_sw_5g
								puts "��ѯ��SSID8��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID8���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID8���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID8��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID8��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID8���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid8, ssid, "����SSID4Ϊ#{@tc_ssid8}ʧ��")
								assert_equal(@ts_sec_mode_wpa, ssid_pw, "����SSID4���ܷ�ʽΪ#{@ts_sec_mode_wpa}ʧ��")
								assert_equal(@tc_linkmax1, linkmax, "����SSID4���������Ϊ#{@tc_linkmax1}ʧ��")
								assert_equal(@tc_linkednum, linked, "SSID4��������ͳ�ƴ���")
								assert_equal(@tc_wifi_on, ssid_sw, "SSID4����״̬����")
						end
				}

				operate("3����wifi����ҳ������5G��8��SSID�ֱ�Ϊ����1������8������ģʽΪNone�����������10������OFF��������棻") {
						@wifi_page.select_5g_basic(@browser.url)
						#�޸�ssid1Ϊopen
						@wifi_page.modify_ssid1_5g(@tc_ssid1_cn)
						@wifi_page.set_ssid1_open_5g
						@wifi_page.modify_ssid1_linknum_5g(@tc_linkmax2)
						@wifi_page.ssid1_sw_5g=@tc_wifi_off
						#�޸�ssid2Ϊopen
						@wifi_page.modify_ssid2_5g(@tc_ssid2_cn)
						@wifi_page.set_ssid2_open_5g
						@wifi_page.modify_ssid2_linknum_5g(@tc_linkmax2)
						@wifi_page.ssid2_sw=@tc_wifi_off
						#�޸�ssid3Ϊopen
						@wifi_page.modify_ssid3_5g(@tc_ssid3_cn)
						@wifi_page.set_ssid3_open_5g
						@wifi_page.modify_ssid3_linknum_5g(@tc_linkmax2)
						@wifi_page.ssid3_sw=@tc_wifi_off
						#�޸�ssid4Ϊopen
						@wifi_page.modify_ssid4_5g(@tc_ssid4_cn)
						@wifi_page.set_ssid4_open_5g
						@wifi_page.modify_ssid4_linknum_5g(@tc_linkmax2)
						@wifi_page.ssid4_sw_5g=@tc_wifi_off

						#�޸�ssid5Ϊopen
						if @tc_flag1
								@wifi_page.modify_ssid5_5g(@tc_ssid5_cn)
								@wifi_page.set_ssid5_open_5g
								@wifi_page.modify_ssid4_linknum_5g(@tc_linkmax2)
								@wifi_page.ssid5_sw_5g=@tc_wifi_off
						end
						#�޸�ssid6Ϊopen
						if @tc_flag2
								@wifi_page.modify_ssid6_5g(@tc_ssid6_cn)
								@wifi_page.set_ssid6_open_5g
								@wifi_page.modify_ssid6_linknum_5g(@tc_linkmax2)
								@wifi_page.ssid6_sw_5g=@tc_wifi_off
						end
						#�޸�ssid7Ϊopen
						if @tc_flag3
								@wifi_page.modify_ssid7_5g(@tc_ssid7_cn)
								@wifi_page.set_ssid7_open_5g
								@wifi_page.modify_ssid7_linknum_5g(@tc_linkmax2)
								@wifi_page.ssid7_sw_5g=@tc_wifi_off
						end
						#�޸�ssid8Ϊopen
						if @tc_flag4
								@wifi_page.modify_ssid8_5g(@tc_ssid8_cn)
								@wifi_page.set_ssid8_open_5g
								@wifi_page.modify_ssid8_linknum_5g(@tc_linkmax2)
								@wifi_page.ssid8_sw_5g=@tc_wifi_off
						end
						#����
						@wifi_page.save_wifi_config

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯSSID1��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid1_name_5g
						ssid_pw = @wifi_detail.ssid1_pwmode_5g
						linkmax = @wifi_detail.ssid1_linknum_5g
						linked  = @wifi_detail.ssid1_linked_5g
						ssid_rf = @wifi_detail.ssid1_rf_5g
						ssid_sw = @wifi_detail.ssid1_sw_5g
						puts "��ѯ��SSID1��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID1���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID1���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID1��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID1��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID1���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid1_cn, ssid, "����SSID1Ϊ#{@tc_ssid1_cn}ʧ��")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "����SSID1���ܷ�ʽΪ#{@ts_tag_wifi_open}ʧ��")
						assert_equal(@tc_linkmax2, linkmax, "����SSID1���������Ϊ#{@tc_linkmax2}ʧ��")
						assert_equal(@tc_linkednum, linked, "SSID1��������ͳ�ƴ���")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID1����״̬����")

						puts "��ѯSSID2��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid2_name_5g
						ssid_pw = @wifi_detail.ssid2_pwmode_5g
						linkmax = @wifi_detail.ssid2_linknum_5g
						linked  = @wifi_detail.ssid2_linked_5g
						ssid_rf = @wifi_detail.ssid2_rf_5g
						ssid_sw = @wifi_detail.ssid2_sw_5g
						puts "��ѯ��SSID2��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID2���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID2���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID2��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID2��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID2���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid2_cn, ssid, "����SSID2Ϊ#{@tc_ssid2_cn}ʧ��")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "����SSID2���ܷ�ʽΪ#{@ts_tag_wifi_open}ʧ��")
						assert_equal(@tc_linkmax2, linkmax, "����SSID2���������Ϊ#{@tc_linkmax2}ʧ��")
						assert_equal(@tc_linkednum, linked, "SSID2��������ͳ�ƴ���")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID2����״̬����")

						puts "��ѯSSID3��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid3_name_5g
						ssid_pw = @wifi_detail.ssid3_pwmode_5g
						linkmax = @wifi_detail.ssid3_linknum_5g
						linked  = @wifi_detail.ssid3_linked_5g
						ssid_rf = @wifi_detail.ssid3_rf_5g
						ssid_sw = @wifi_detail.ssid3_sw_5g
						puts "��ѯ��SSID3��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID3���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID3���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID3��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID3��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID3���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid3_cn, ssid, "����SSID3Ϊ#{@tc_ssid3_cn}ʧ��")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "����SSID3���ܷ�ʽΪ#{@ts_tag_wifi_open}ʧ��")
						assert_equal(@tc_linkmax2, linkmax, "����SSID3���������Ϊ#{@tc_linkmax2}ʧ��")
						assert_equal(@tc_linkednum, linked, "SSID3��������ͳ�ƴ���")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID3����״̬����")

						puts "��ѯSSID4��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid4_name_5g
						ssid_pw = @wifi_detail.ssid4_pwmode_5g
						linkmax = @wifi_detail.ssid4_linknum_5g
						linked  = @wifi_detail.ssid4_linked_5g
						ssid_rf = @wifi_detail.ssid4_rf_5g
						ssid_sw = @wifi_detail.ssid4_sw_5g
						puts "��ѯ��SSID4��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID4���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID4���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID4��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID4��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID4���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid5_cn, ssid, "����SSID4Ϊ#{@tc_ssid4_cn}ʧ��")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "����SSID4���ܷ�ʽΪ#{@ts_tag_wifi_open}ʧ��")
						assert_equal(@tc_linkmax2, linkmax, "����SSID4���������Ϊ#{@tc_linkmax2}ʧ��")
						assert_equal(@tc_linkednum, linked, "SSID4��������ͳ�ƴ���")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID4����״̬����")

						if @tc_flag1
								puts "��ѯSSID5��ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid5_name_5g
								ssid_pw = @wifi_detail.ssid5_pwmode_5g
								linkmax = @wifi_detail.ssid5_linknum_5g
								linked  = @wifi_detail.ssid5_linked_5g
								ssid_rf = @wifi_detail.ssid5_rf_5g
								ssid_sw = @wifi_detail.ssid5_sw_5g
								puts "��ѯ��SSID5��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID5���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID5���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID5��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID5��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID5���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid5_cn, ssid, "����SSID5Ϊ#{@tc_ssid5_cn}ʧ��")
								assert_equal(@ts_tag_wifi_open, ssid_pw, "����SSID5���ܷ�ʽΪ#{@ts_tag_wifi_open}ʧ��")
								assert_equal(@tc_linkmax2, linkmax, "����SSID5���������Ϊ#{@tc_linkmax2}ʧ��")
								assert_equal(@tc_linkednum, linked, "SSID5��������ͳ�ƴ���")
								assert_equal(@tc_wifi_off, ssid_sw, "SSID5����״̬����")
						end

						if @tc_flag2
								puts "��ѯSSID5��ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid6_name_5g
								ssid_pw = @wifi_detail.ssid6_pwmode_5g
								linkmax = @wifi_detail.ssid6_linknum_5g
								linked  = @wifi_detail.ssid6_linked_5g
								ssid_rf = @wifi_detail.ssid6_rf_5g
								ssid_sw = @wifi_detail.ssid6_sw_5g
								puts "��ѯ��SSID6��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID6���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID6���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID6��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID6��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID6���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid6_cn, ssid, "����SSID6Ϊ#{@tc_ssid6_cn}ʧ��")
								assert_equal(@ts_tag_wifi_open, ssid_pw, "����SSID6���ܷ�ʽΪ#{@ts_tag_wifi_open}ʧ��")
								assert_equal(@tc_linkmax2, linkmax, "����SSID6���������Ϊ#{@tc_linkmax2}ʧ��")
								assert_equal(@tc_linkednum, linked, "SSID6��������ͳ�ƴ���")
								assert_equal(@tc_wifi_off, ssid_sw, "SSID6����״̬����")
						end

						if @tc_flag3
								puts "��ѯSSID5��ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid7_name_5g
								ssid_pw = @wifi_detail.ssid7_pwmode_5g
								linkmax = @wifi_detail.ssid7_linknum_5g
								linked  = @wifi_detail.ssid7_linked_5g
								ssid_rf = @wifi_detail.ssid7_rf_5g
								ssid_sw = @wifi_detail.ssid7_sw_5g
								puts "��ѯ��SSID7��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID7���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID7���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID7��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID7��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID7���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid7_cn, ssid, "����SSID7Ϊ#{@tc_ssid7_cn}ʧ��")
								assert_equal(@ts_tag_wifi_open, ssid_pw, "����SSID7���ܷ�ʽΪ#{@ts_tag_wifi_open}ʧ��")
								assert_equal(@tc_linkmax2, linkmax, "����SSID7���������Ϊ#{@tc_linkmax2}ʧ��")
								assert_equal(@tc_linkednum, linked, "SSID7��������ͳ�ƴ���")
								assert_equal(@tc_wifi_off, ssid_sw, "SSID7����״̬����")
						end

						if @tc_flag4
								puts "��ѯSSID8��ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid8_name_5g
								ssid_pw = @wifi_detail.ssid8_pwmode_5g
								linkmax = @wifi_detail.ssid8_linknum_5g
								linked  = @wifi_detail.ssid8_linked_5g
								ssid_rf = @wifi_detail.ssid8_rf_5g
								ssid_sw = @wifi_detail.ssid8_sw_5g
								puts "��ѯ��SSID8��Ϊ��#{ssid}".to_gbk
								puts "��ѯ��SSID8���ܷ�ʽΪ��#{ssid_pw}".to_gbk
								puts "��ѯ��SSID8���������Ϊ��#{linkmax}".to_gbk
								puts "��ѯ��SSID8��������Ϊ��#{linked}".to_gbk
								puts "��ѯ��SSID8��ƵΪ��#{ssid_rf}".to_gbk
								puts "��ѯ��SSID8���߿���״̬Ϊ��#{ssid_sw}".to_gbk
								assert_equal(@tc_ssid8_cn, ssid, "����SSID8Ϊ#{@tc_ssid8_cn}ʧ��")
								assert_equal(@ts_tag_wifi_open, ssid_pw, "����SSID8���ܷ�ʽΪ#{@ts_tag_wifi_open}ʧ��")
								assert_equal(@tc_linkmax2, linkmax, "����SSID8���������Ϊ#{@tc_linkmax2}ʧ��")
								assert_equal(@tc_linkednum, linked, "SSID8��������ͳ�ƴ���")
								assert_equal(@tc_wifi_off, ssid_sw, "SSID8����״̬����")
						end
				}


		end

		def clearup
				operate("1 �ָ�Ĭ������") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_5g_basic(@browser.url)
						#�޸�SSID1
						@wifi_page.modify_ssid1_5g(@ts_wifi_ssid1_5g)
						@wifi_page.modify_ssid1_pw_5g(@ts_default_wlan_pw)
						@wifi_page.modify_ssid1_linknum_5g(@ts_linknum_max)
						if @wifi_page.ssid1_sw_5g==@tc_wifi_off
								@wifi_page.ssid1_sw_5g=@tc_wifi_on
						end
						#�޸�SSID2
						@wifi_page.modify_ssid2_5g(@ts_wifi_ssid2_5g)
						@wifi_page.modify_ssid2_pw_5g(@ts_default_wlan_pw)
						@wifi_page.modify_ssid2_linknum_5g(@ts_linknum_max)
						if @wifi_page.ssid2_sw_5g==@tc_wifi_off
								@wifi_page.ssid2_sw_5g=@tc_wifi_on
						end
						#�޸�SSID3
						@wifi_page.modify_ssid3_5g(@ts_wifi_ssid3_5g)
						@wifi_page.modify_ssid3_pw_5g(@ts_default_wlan_pw)
						@wifi_page.modify_ssid3_linknum_5g(@ts_linknum_max)
						if @wifi_page.ssid3_sw_5g==@tc_wifi_off
								@wifi_page.ssid3_sw_5g=@tc_wifi_on
						end
						#�޸�SSID4
						@wifi_page.modify_ssid4_5g(@ts_wifi_ssid4_5g)
						@wifi_page.modify_ssid4_pw_5g(@ts_default_wlan_pw)
						@wifi_page.modify_ssid4_linknum_5g(@ts_linknum_max)
						if @wifi_page.ssid4_sw_5g==@tc_wifi_off
								@wifi_page.ssid4_sw_5g=@tc_wifi_on
						end
						if @tc_flag1
								@wifi_page.modify_ssid5_5g(@ts_wifi_ssid4_5g)
								@wifi_page.modify_ssid5_pw_5g(@ts_default_wlan_pw)
								@wifi_page.modify_ssid5_linknum_5g(@ts_linknum_max)
								if @wifi_page.ssid5_sw_5g==@tc_wifi_off
										@wifi_page.ssid5_sw_5g=@tc_wifi_on
								end
						end
						if @tc_flag2
								@wifi_page.modify_ssid6_5g(@ts_wifi_ssid5_5g)
								@wifi_page.modify_ssid6_pw_5g(@ts_default_wlan_pw)
								@wifi_page.modify_ssid6_linknum_5g(@ts_linknum_max)
								if @wifi_page.ssid6_sw_5g==@tc_wifi_off
										@wifi_page.ssid6_sw_5g=@tc_wifi_on
								end
						end
						if @tc_flag3
								@wifi_page.modify_ssid7_5g(@ts_wifi_ssid6_5g)
								@wifi_page.modify_ssid7_pw_5g(@ts_default_wlan_pw)
								@wifi_page.modify_ssid7_linknum_5g(@ts_linknum_max)
								if @wifi_page.ssid7_sw_5g==@tc_wifi_off
										@wifi_page.ssid7_sw_5g=@tc_wifi_on
								end
						end
						if @tc_flag4
								@wifi_page.modify_ssid8_5g(@ts_wifi_ssid7_5g)
								@wifi_page.modify_ssid8_pw_5g(@ts_default_wlan_pw)
								@wifi_page.modify_ssid8_linknum_5g(@ts_linknum_max)
								if @wifi_page.ssid8_sw_5g==@tc_wifi_off
										@wifi_page.ssid8_sw_5g=@tc_wifi_on
								end
						end
						#����
						@wifi_page.save_wifi_config
				}
		end

}
