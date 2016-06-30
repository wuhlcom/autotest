#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.31", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time      = 2
				@tc_vps_id         = 1
				@tc_test_ssid      = "wifitest"
				@tc_pub_tcp_port   = 5001
				@tc_vir_tcpsrv_port= 5002
		end

		def process

				operate("1����¼DUT����ҳ�棻") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.recover_factory(@browser.url)
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "�ָ�����ֵ��δ��ת����¼����")
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
				}

				operate("2������WAN����ΪPPTP��ʽ���޸�LAN��IP��ַ���޸ĵ�ַ�ط�Χ���޸�����SSID���޸����߰�ȫ���޸����߸߼���������Ӷ˿�ת�����򡢶˿ڴ����������URL���˹���IP��˿ڹ��˹��򡢿���UPNP���ܡ�����DMZ���ܡ�����DDNS���ܡ��޸ĵ�¼�����ҳ�����п����õ�ѡ�") {
						#�ָ�����ֵ���Ȳ�ѯĬ�����ã�
						#����������
						#�޸�SSID���޸Ľ��뷽ʽΪPPTP
						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_systatus_page(@browser.url)
						@tc_wan_type = @wifi_detail.get_wan_type
						puts "Ĭ�Ͻ��뷽ʽΪ#{@tc_wan_type}".to_gbk
						@wifi_detail.open_wifidetail_page(@browser.url)
						@tc_ssid1 = @wifi_detail.ssid1_name
						puts "Ĭ�Ͻ���SSID1Ϊ#{@tc_ssid1}".to_gbk

						@options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url) #pptp����
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.modify_ssid_mode_pwd(@browser.url, @tc_test_ssid) #�޸�SSID

						#��ѯ
						@wifi_detail.open_systatus_page(@browser.url)
						tc_wan_type = @wifi_detail.get_wan_type
						puts "���뷽ʽΪ#{tc_wan_type}".to_gbk

						@wifi_detail.open_wifidetail_page(@browser.url)
						tc_ssid1 = @wifi_detail.ssid1_name
						puts "SSID1Ϊ#{tc_ssid1}".to_gbk

						assert_equal(@ts_wan_mode_pptp, tc_wan_type, "���뷽ʽ��ΪPPTP")
						refute_equal(@tc_ssid1, tc_ssid1, "SSID�޸�ʧ��!")

						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "Virtual Server IP #{@tc_pc_ip}"
						@options_page.add_vps_step(@browser.url, @tc_pc_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port, @tc_vps_id)
						@options_page.open_vps_page
						rs = @options_page.vps_td1?
						assert(rs, "�������������ʧ��!")
				}

				operate("3����ҳ����и�λ���鿴���õĲ����Ƿ�ȫ����λ�ɳ���Ĭ��״̬��") {
						@options_page.recover_factory(@browser.url)
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "�ָ�����ֵ��δ��ת����¼����")
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						@wifi_detail.open_systatus_page(@browser.url)
						tc_wan_type = @wifi_detail.get_wan_type
						puts "�ָ��������ú���뷽ʽΪ#{@tc_wan_type}".to_gbk
						@wifi_detail.open_wifidetail_page(@browser.url)
						tc_ssid1 = @wifi_detail.ssid1_name
						puts "�ָ��������ú�SSID1Ϊ#{@tc_ssid1}".to_gbk
						assert_equal(@tc_wan_type, tc_wan_type, "�ָ���������뷽ʽδ�ָ�ΪĬ�Ϸ�ʽ")
						assert_equal(@tc_ssid1, tc_ssid1, "�ָ�������SSIDδ�ָ�ΪĬ������!")

						@options_page.open_vps(@browser.url)
						rs = @options_page.vps_td1?
						refute(rs, "�ָ�������������������ûָ�ʧ��!")
				}

		end

		def clearup

				operate("1 ɾ���������������") {
						rs = @options_page.login_with_exists(@browser.url)
						if rs
								rs_login = login_no_default_ip(@browser) #���µ�¼
								p rs_login[:flag]
								p rs_login[:message]
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_vps(@browser.url)
						if @options_page.vps_td1?
								@options_page.delete_all_vps
								@options_page.close_vps_btn
								@options_page.save_vps
						end
				}

				operate("2 �ָ�Ĭ��SSID�ͽ��뷽ʽ") {
						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						ssid1 = @wifi_detail.ssid1_name
						puts "����SSID1Ϊ#{ssid1}".to_gbk
						#�ָ�Ĭ��ssid
						unless ssid1==@tc_ssid1
								@wifi_page = RouterPageObject::WIFIPage.new(@browser)
								@wifi_page.modify_default_ssid(@browser.url)
						end
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end
}
