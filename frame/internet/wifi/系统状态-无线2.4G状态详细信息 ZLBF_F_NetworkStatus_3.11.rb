#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_5.1.37", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_ssid1     = "Wireless0"
				@tc_ssid2     = "Wireless1"
				@tc_ssid3     = "Wireless2"
				@tc_ssid4     = "Wireless3"
				@tc_ssid5     = "Wireless4"
				@tc_ssid6     = "Wireless5"
				@tc_ssid7     = "Wireless6"
				@tc_ssid8     = "Wireless7"
				@tc_pw        = "12345678"
				@tc_linkmax1  = "20"
				@tc_ssid1_cn  = "֪·�Զ�����1"
				@tc_ssid2_cn  = "֪·�Զ�����2"
				@tc_ssid3_cn  = "֪·�Զ�����3"
				@tc_ssid4_cn  = "֪·�Զ�����4"
				@tc_ssid5_cn  = "֪·�Զ�����5"
				@tc_ssid6_cn  = "֪·�Զ�����6"
				@tc_ssid7_cn  = "֪·�Զ�����7"
				@tc_ssid8_cn  = "֪·�Զ�����8"
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

				operate("1���鿴Ĭ������2.4G����״̬�Ƿ���ȷ��") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.recover_factory(@browser.url) #�ָ���������
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "�ָ��������ú�δ��ת����¼����")
						@options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url) #���µ�¼

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯSSID1Ĭ����ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid1_name
						ssid_pw = @wifi_detail.ssid1_pwmode
						linkmax = @wifi_detail.ssid1_linknum
						linked  = @wifi_detail.ssid1_linked
						ssid_rf = @wifi_detail.ssid1_rf
						ssid_sw = @wifi_detail.ssid1_sw
						# puts "��ѯ��SSID1��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID1���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID1���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID1��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID1��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID1���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid1, ssid, "��ѯ��Ĭ��SSID1��Ϊ#{@ts_wifi_ssid1}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID1���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID1�����������Ϊ#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID1����������Ϊ#{@tc_linkednum}")
						assert_equal(@tc_wifi_on, ssid_sw, "��ѯ��Ĭ��SSID1����״̬δ��")

						puts "��ѯSSID2Ĭ����ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid2_name
						ssid_pw = @wifi_detail.ssid2_pwmode
						linkmax = @wifi_detail.ssid2_linknum
						linked  = @wifi_detail.ssid2_linked
						ssid_rf = @wifi_detail.ssid2_rf
						ssid_sw = @wifi_detail.ssid2_sw
						puts "��ѯ��SSID2��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID2���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID2���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID2��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID2��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID2���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid2, ssid, "��ѯ��Ĭ��SSID2��Ϊ#{@ts_wifi_ssid2}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID2���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID2�����������Ϊ#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID2����������Ϊ#{@tc_linkednum}")
						assert_equal(@tc_wifi_off, ssid_sw, "��ѯ��Ĭ��SSID2����״̬δ��")

						puts "��ѯSSID3Ĭ����ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid3_name
						ssid_pw = @wifi_detail.ssid3_pwmode
						linkmax = @wifi_detail.ssid3_linknum
						linked  = @wifi_detail.ssid3_linked
						ssid_rf = @wifi_detail.ssid3_rf
						ssid_sw = @wifi_detail.ssid3_sw
						puts "��ѯ��SSID3��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID3���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID3���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID3��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID3��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID3���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid3, ssid, "��ѯ��Ĭ��SSID3��Ϊ#{@ts_wifi_ssid3}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID3���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID3�����������Ϊ#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID3����������Ϊ#{@tc_linkednum}")
						assert_equal(@tc_wifi_off, ssid_sw, "��ѯ��Ĭ��SSID3����״̬δ��")

						puts "��ѯSSID4Ĭ����ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid4_name
						ssid_pw = @wifi_detail.ssid4_pwmode
						linkmax = @wifi_detail.ssid4_linknum
						linked  = @wifi_detail.ssid4_linked
						ssid_rf = @wifi_detail.ssid4_rf
						ssid_sw = @wifi_detail.ssid4_sw
						puts "��ѯ��SSID4��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID4���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID4���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID4��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID4��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID4���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@ts_wifi_ssid4, ssid, "��ѯ��Ĭ��SSID4��Ϊ#{@ts_wifi_ssid4}")
						assert_equal(@ts_sec_mode_wpa, ssid_pw, "��ѯ��Ĭ��SSID4���ܷ�ʽ��Ϊ#{@ts_sec_mode_wpa}")
						assert_equal(@ts_linknum_max, linkmax, "��ѯ��Ĭ��SSID4�����������Ϊ#{@ts_linknum_max}")
						assert_equal(@tc_linkednum, linked, "��ѯ��Ĭ��SSID4����������Ϊ#{@tc_linkednum}")
						assert_equal(@tc_wifi_off, ssid_sw, "��ѯ��Ĭ��SSID4����״̬δ��")

						if @wifi_detail.ssid5_name?
								puts "��ѯSSID5Ĭ����ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid5_name
								ssid_pw = @wifi_detail.ssid5_pwmode
								linkmax = @wifi_detail.ssid5_linknum
								linked  = @wifi_detail.ssid5_linked
								ssid_rf = @wifi_detail.ssid5_rf
								ssid_sw = @wifi_detail.ssid5_sw
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
								assert_equal(@tc_wifi_off, ssid_sw, "��ѯ��Ĭ��SSID5����״̬δ��")
						end

						if @wifi_detail.ssid6_name?
								puts "��ѯSSID6Ĭ����ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid6_name
								ssid_pw = @wifi_detail.ssid6_pwmode
								linkmax = @wifi_detail.ssid6_linknum
								linked  = @wifi_detail.ssid6_linked
								ssid_rf = @wifi_detail.ssid6_rf
								ssid_sw = @wifi_detail.ssid6_sw
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
								assert_equal(@tc_wifi_off, ssid_sw, "��ѯ��Ĭ��SSID6����״̬δ��")
						end

						if @wifi_detail.ssid7_name?
								puts "��ѯSSID7Ĭ����ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid7_name
								ssid_pw = @wifi_detail.ssid7_pwmode
								linkmax = @wifi_detail.ssid7_linknum
								linked  = @wifi_detail.ssid7_linked
								ssid_rf = @wifi_detail.ssid7_rf
								ssid_sw = @wifi_detail.ssid7_sw
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
								assert_equal(@tc_wifi_off, ssid_sw, "��ѯ��Ĭ��SSID7����״̬δ��")
						end

						if @wifi_detail.ssid8_name?
								puts "��ѯSSID8Ĭ����ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid8_name
								ssid_pw = @wifi_detail.ssid8_pwmode
								linkmax = @wifi_detail.ssid8_linknum
								linked  = @wifi_detail.ssid8_linked
								ssid_rf = @wifi_detail.ssid8_rf
								ssid_sw = @wifi_detail.ssid8_sw
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
								assert_equal(@tc_wifi_off, ssid_sw, "��ѯ��Ĭ��SSID8����״̬δ��")
						end
				}

				operate("2����wifi����ҳ������2.4G��8��SSID�ֱ�Ϊopen1��Open8������ģʽWPA/WPA2��ϣ�����Ϊ88888888�����������20������ON��������棻") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#�޸�SSID1
						@wifi_page.modify_ssid1(@tc_ssid1)
						@wifi_page.modify_ssid1_pw(@tc_pw)
						@wifi_page.modify_ssid1_linknum(@tc_linkmax1)
						if @wifi_page.ssid1_sw==@tc_wifi_off
								@wifi_page.ssid1_sw=@tc_wifi_on
						end
						#�޸�SSID2
						@wifi_page.modify_ssid2(@tc_ssid2)
						@wifi_page.modify_ssid2_pw(@tc_pw)
						@wifi_page.modify_ssid2_linknum(@tc_linkmax1)
						if @wifi_page.ssid2_sw==@tc_wifi_off
								@wifi_page.ssid2_sw=@tc_wifi_on
						end
						#�޸�SSID3
						@wifi_page.modify_ssid3(@tc_ssid3)
						@wifi_page.modify_ssid3_pw(@tc_pw)
						@wifi_page.modify_ssid3_linknum(@tc_linkmax1)
						if @wifi_page.ssid3_sw==@tc_wifi_off
								@wifi_page.ssid3_sw=@tc_wifi_on
						end
						#�޸�SSID4
						@wifi_page.modify_ssid4(@tc_ssid4)
						@wifi_page.modify_ssid4_pw(@tc_pw)
						@wifi_page.modify_ssid4_linknum(@tc_linkmax1)
						if @wifi_page.ssid4_sw==@tc_wifi_off
								@wifi_page.ssid4_sw=@tc_wifi_on
						end

						#�޸�SSID5
						if @wifi_page.ssid5?
								@tc_flag1 = true
								@wifi_page.modify_ssid5(@tc_ssid5)
								@wifi_page.modify_ssid5_pw(@tc_pw)
								@wifi_page.modify_ssid5_linknum(@tc_linkmax1)
								if @wifi_page.ssid5_sw==@tc_wifi_off
										@wifi_page.ssid5_sw=@tc_wifi_on
								end
						end
						#�޸�SSID6
						if @wifi_page.ssid6?
								@tc_flag2 = true
								@wifi_page.modify_ssid6(@tc_ssid6)
								@wifi_page.modify_ssid6_pw(@tc_pw)
								@wifi_page.modify_ssid6_linknum(@tc_linkmax1)
								if @wifi_page.ssid6_sw==@tc_wifi_off
										@wifi_page.ssid6_sw=@tc_wifi_on
								end
						end
						#�޸�SSID7
						if @wifi_page.ssid7?
								@tc_flag3 = true
								@wifi_page.modify_ssid7(@tc_ssid7)
								@wifi_page.modify_ssid7_pw(@tc_pw)
								@wifi_page.modify_ssid7_linknum(@tc_linkmax1)
								if @wifi_page.ssid7_sw==@tc_wifi_off
										@wifi_page.ssid7_sw=@tc_wifi_on
								end
						end
						#�޸�SSID8
						if @wifi_page.ssid8?
								@tc_flag4 = true
								@wifi_page.modify_ssid8(@tc_ssid8)
								@wifi_page.modify_ssid8_pw(@tc_pw)
								@wifi_page.modify_ssid8_linknum(@tc_linkmax1)
								if @wifi_page.ssid8_sw==@tc_wifi_off
										@wifi_page.ssid8_sw=@tc_wifi_on
								end
						end
						#����
						@wifi_page.save_wifi_config

						# @wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯSSID1��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid1_name
						ssid_pw = @wifi_detail.ssid1_pwmode
						linkmax = @wifi_detail.ssid1_linknum
						linked  = @wifi_detail.ssid1_linked
						ssid_rf = @wifi_detail.ssid1_rf
						ssid_sw = @wifi_detail.ssid1_sw
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
						ssid    = @wifi_detail.ssid2_name
						ssid_pw = @wifi_detail.ssid2_pwmode
						linkmax = @wifi_detail.ssid2_linknum
						linked  = @wifi_detail.ssid2_linked
						ssid_rf = @wifi_detail.ssid2_rf
						ssid_sw = @wifi_detail.ssid2_sw
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
						ssid    = @wifi_detail.ssid3_name
						ssid_pw = @wifi_detail.ssid3_pwmode
						linkmax = @wifi_detail.ssid3_linknum
						linked  = @wifi_detail.ssid3_linked
						ssid_rf = @wifi_detail.ssid3_rf
						ssid_sw = @wifi_detail.ssid3_sw
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
						ssid    = @wifi_detail.ssid4_name
						ssid_pw = @wifi_detail.ssid4_pwmode
						linkmax = @wifi_detail.ssid4_linknum
						linked  = @wifi_detail.ssid4_linked
						ssid_rf = @wifi_detail.ssid4_rf
						ssid_sw = @wifi_detail.ssid4_sw
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
								ssid    = @wifi_detail.ssid5_name
								ssid_pw = @wifi_detail.ssid5_pwmode
								linkmax = @wifi_detail.ssid5_linknum
								linked  = @wifi_detail.ssid5_linked
								ssid_rf = @wifi_detail.ssid5_rf
								ssid_sw = @wifi_detail.ssid5_sw
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
								ssid    = @wifi_detail.ssid6_name
								ssid_pw = @wifi_detail.ssid6_pwmode
								linkmax = @wifi_detail.ssid6_linknum
								linked  = @wifi_detail.ssid6_linked
								ssid_rf = @wifi_detail.ssid6_rf
								ssid_sw = @wifi_detail.ssid6_sw
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
								ssid    = @wifi_detail.ssid7_name
								ssid_pw = @wifi_detail.ssid7_pwmode
								linkmax = @wifi_detail.ssid7_linknum
								linked  = @wifi_detail.ssid7_linked
								ssid_rf = @wifi_detail.ssid7_rf
								ssid_sw = @wifi_detail.ssid7_sw
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
								ssid    = @wifi_detail.ssid8_name
								ssid_pw = @wifi_detail.ssid8_pwmode
								linkmax = @wifi_detail.ssid8_linknum
								linked  = @wifi_detail.ssid8_linked
								ssid_rf = @wifi_detail.ssid8_rf
								ssid_sw = @wifi_detail.ssid8_sw
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

				operate("3����wifi����ҳ������2.4G��8��SSID�ֱ�Ϊ����1������8������ģʽΪNone�����������10������OFF��������棻") {
						@wifi_page.select_2g_basic(@browser.url)
						#�޸�ssid1Ϊopen
						@wifi_page.modify_ssid1(@tc_ssid1_cn)
						@wifi_page.set_ssid1_open
						@wifi_page.modify_ssid1_linknum(@tc_linkmax2)
						@wifi_page.ssid1_sw=@tc_wifi_off
						#�޸�ssid2Ϊopen
						@wifi_page.modify_ssid2(@tc_ssid2_cn)
						@wifi_page.set_ssid2_open
						@wifi_page.modify_ssid2_linknum(@tc_linkmax2)
						@wifi_page.ssid2_sw=@tc_wifi_off
						#�޸�ssid3Ϊopen
						@wifi_page.modify_ssid3(@tc_ssid3_cn)
						@wifi_page.set_ssid3_open
						@wifi_page.modify_ssid3_linknum(@tc_linkmax2)
						@wifi_page.ssid3_sw=@tc_wifi_off
						#�޸�ssid4Ϊopen
						@wifi_page.modify_ssid4(@tc_ssid4_cn)
						@wifi_page.set_ssid4_open
						@wifi_page.modify_ssid4_linknum(@tc_linkmax2)
						@wifi_page.ssid4_sw=@tc_wifi_off

						#�޸�ssid5Ϊopen
						if @tc_flag1
								@wifi_page.modify_ssid4(@tc_ssid5_cn)
								@wifi_page.set_ssid4_open
								@wifi_page.modify_ssid4_linknum(@tc_linkmax2)
								@wifi_page.ssid4_sw=@tc_wifi_off
						end
						#�޸�ssid6Ϊopen
						if @tc_flag2
								@wifi_page.modify_ssid6(@tc_ssid6_cn)
								@wifi_page.set_ssid6_open
								@wifi_page.modify_ssid6_linknum(@tc_linkmax2)
								@wifi_page.ssid6_sw=@tc_wifi_off
						end
						#�޸�ssid7Ϊopen
						if @tc_flag3
								@wifi_page.modify_ssid7(@tc_ssid7_cn)
								@wifi_page.set_ssid7_open
								@wifi_page.modify_ssid7_linknum(@tc_linkmax2)
								@wifi_page.ssid7_sw=@tc_wifi_off
						end
						#�޸�ssid8Ϊopen
						if @tc_flag4
								@wifi_page.modify_ssid8(@tc_ssid8_cn)
								@wifi_page.set_ssid8_open
								@wifi_page.modify_ssid8_linknum(@tc_linkmax2)
								@wifi_page.ssid8_sw=@tc_wifi_off
						end
						#����
						@wifi_page.save_wifi_config

						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "��ѯSSID1��ϸ��Ϣ".to_gbk
						ssid    = @wifi_detail.ssid1_name
						ssid_pw = @wifi_detail.ssid1_pwmode
						linkmax = @wifi_detail.ssid1_linknum
						linked  = @wifi_detail.ssid1_linked
						ssid_rf = @wifi_detail.ssid1_rf
						ssid_sw = @wifi_detail.ssid1_sw
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
						ssid    = @wifi_detail.ssid2_name
						ssid_pw = @wifi_detail.ssid2_pwmode
						linkmax = @wifi_detail.ssid2_linknum
						linked  = @wifi_detail.ssid2_linked
						ssid_rf = @wifi_detail.ssid2_rf
						ssid_sw = @wifi_detail.ssid2_sw
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
						ssid    = @wifi_detail.ssid3_name
						ssid_pw = @wifi_detail.ssid3_pwmode
						linkmax = @wifi_detail.ssid3_linknum
						linked  = @wifi_detail.ssid3_linked
						ssid_rf = @wifi_detail.ssid3_rf
						ssid_sw = @wifi_detail.ssid3_sw
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
						ssid    = @wifi_detail.ssid4_name
						ssid_pw = @wifi_detail.ssid4_pwmode
						linkmax = @wifi_detail.ssid4_linknum
						linked  = @wifi_detail.ssid4_linked
						ssid_rf = @wifi_detail.ssid4_rf
						ssid_sw = @wifi_detail.ssid4_sw
						puts "��ѯ��SSID4��Ϊ��#{ssid}".to_gbk
						puts "��ѯ��SSID4���ܷ�ʽΪ��#{ssid_pw}".to_gbk
						puts "��ѯ��SSID4���������Ϊ��#{linkmax}".to_gbk
						puts "��ѯ��SSID4��������Ϊ��#{linked}".to_gbk
						puts "��ѯ��SSID4��ƵΪ��#{ssid_rf}".to_gbk
						puts "��ѯ��SSID4���߿���״̬Ϊ��#{ssid_sw}".to_gbk
						assert_equal(@tc_ssid4_cn, ssid, "����SSID4Ϊ#{@tc_ssid4_cn}ʧ��")
						assert_equal(@ts_tag_wifi_open, ssid_pw, "����SSID4���ܷ�ʽΪ#{@ts_tag_wifi_open}ʧ��")
						assert_equal(@tc_linkmax2, linkmax, "����SSID4���������Ϊ#{@tc_linkmax2}ʧ��")
						assert_equal(@tc_linkednum, linked, "SSID4��������ͳ�ƴ���")
						assert_equal(@tc_wifi_off, ssid_sw, "SSID4����״̬����")

						if @tc_flag1
								puts "��ѯSSID5��ϸ��Ϣ".to_gbk
								ssid    = @wifi_detail.ssid5_name
								ssid_pw = @wifi_detail.ssid5_pwmode
								linkmax = @wifi_detail.ssid5_linknum
								linked  = @wifi_detail.ssid5_linked
								ssid_rf = @wifi_detail.ssid5_rf
								ssid_sw = @wifi_detail.ssid5_sw
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
								ssid    = @wifi_detail.ssid6_name
								ssid_pw = @wifi_detail.ssid6_pwmode
								linkmax = @wifi_detail.ssid6_linknum
								linked  = @wifi_detail.ssid6_linked
								ssid_rf = @wifi_detail.ssid6_rf
								ssid_sw = @wifi_detail.ssid6_sw
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
								ssid    = @wifi_detail.ssid7_name
								ssid_pw = @wifi_detail.ssid7_pwmode
								linkmax = @wifi_detail.ssid7_linknum
								linked  = @wifi_detail.ssid7_linked
								ssid_rf = @wifi_detail.ssid7_rf
								ssid_sw = @wifi_detail.ssid7_sw
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
								ssid    = @wifi_detail.ssid8_name
								ssid_pw = @wifi_detail.ssid8_pwmode
								linkmax = @wifi_detail.ssid8_linknum
								linked  = @wifi_detail.ssid8_linked
								ssid_rf = @wifi_detail.ssid8_rf
								ssid_sw = @wifi_detail.ssid8_sw
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
						if @tc_flag1
								@wifi_page.modify_ssid5(@ts_wifi_ssid5)
								@wifi_page.modify_ssid5_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
								if @wifi_page.ssid5_sw==@tc_wifi_on
										@wifi_page.ssid5_sw=@tc_wifi_off
								end
						end
						if @tc_flag2
								@wifi_page.modify_ssid6(@ts_wifi_ssid6)
								@wifi_page.modify_ssid6_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
								if @wifi_page.ssid6_sw==@tc_wifi_on
										@wifi_page.ssid6_sw=@tc_wifi_off
								end
						end
						if @tc_flag3
								@wifi_page.modify_ssid7(@ts_wifi_ssid4)
								@wifi_page.modify_ssid7_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
								if @wifi_page.ssid7_sw==@tc_wifi_on
										@wifi_page.ssid7_sw=@tc_wifi_off
								end
						end
						if @tc_flag4
								@wifi_page.modify_ssid8(@ts_wifi_ssid7)
								@wifi_page.modify_ssid8_pw(@ts_default_wlan_pw)
								@wifi_page.modify_ssid8_linknum(@ts_linknum_max)
								if @wifi_page.ssid8_sw==@tc_wifi_on
										@wifi_page.ssid8_sw=@tc_wifi_off
								end
						end
						#����
						@wifi_page.save_wifi_config
				}
		end

}
