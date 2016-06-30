#
# description:
# �ܴ�������Ӧ������WAN���뷽���������������LAN������
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {

		attr = {"id" => "ZLBF_27.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_ftp_time          = 15
				@tc_cap_gap           = 5
				#kpbs ��Сֵ
				@tc_bandwidth_min     = 1
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ���") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪDHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						wan_type = sys_page.get_wan_type
						wan_addr = sys_page.get_wan_ip
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'
				}

				operate("2�����ô���Ϊ��Сֵ#{@tc_bandwidth_min}kpbs,�鿴�����Ƿ�����") {
						#�򿪸߼�����
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_min) #�����ܴ���
						@options_page.save_traffic #����
						@options_page.traffic_ctl
						sleep 4
						bw_total = @options_page.total_bw
						assert_equal(@tc_bandwidth_min.to_s, bw_total, "������С����ɹ�")
				}

		end

		def clearup

				operate("1��ȡ���������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #����
				}
		end

}
