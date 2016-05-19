#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.7", "level" => "P1", "auto" => "n"}

		def prepare

				DRb.start_service
				@wifi = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time        = 3
				@tc_wifi_time       = 30
				@tc_net_reset        = 15
				@tc_lan_ip1 = "172.168.100.1"

		end


		def process

				operate("1 ����������") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
				}

				operate("2 ����·����wifi") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url)
						@tc_ssid = rs_wifi[:ssid]
						@tc_pwd = rs_wifi[:pwd]

						flag  = "1"
						rs    = @wifi.connect(@tc_ssid, flag, @tc_pwd)
						assert rs, 'wifi����ʧ��'
				}

				operate("3 �鿴�ͻ�����Ϣ") {
						sleep @tc_net_reset
						ip_info     = ipconfig("all")
						dns_servers = ip_info[@ts_nicname][:dns_server]
						rs1         = dns_servers.any? { |dns_server| dns_server=~/#{@ts_default_ip}/ }
						assert rs1, "DNS��ַ����ȷ"

						wifi_info     = @wifi.ipconfig("all")
						wifi_ip       = wifi_info[@ts_wlan_nicname][:ip][0]
						sub_default_ip=@ts_default_ip.sub(/\.\d+$/, "")
						assert_match(/#{sub_default_ip}/, wifi_ip, "wlan�ͻ��˵�ַ����ȷ")
						wifi_gw = wifi_info[@ts_wlan_nicname][:gateway][0]
						assert_equal @ts_default_ip, wifi_gw, "wlan�ͻ������ص�ַ����ȷ"
						wifi_dns_servers = wifi_info[@ts_wlan_nicname][:dns_server]
						rs2              = wifi_dns_servers.any? { |wifi_dns_server| wifi_dns_server=~/#{@ts_default_ip}/ }
						assert(rs2, "wifi�ͻ���DNS��ַ����ȷ")
				}

				operate("4 �޸�lan ipΪB���ַ") {
						@lan_page.lan_ip_config(@tc_lan_ip1, @browser.url)

						@login_page = RouterPageObject::LoginPage.new(@browser)
						login_ui    = @login_page.login_with_exists(@browser.url)
						assert(login_ui, "������δ��ת����¼ҳ�棡")
						#���µ�¼·����
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
				}

				operate("5 �޸�ΪB���ַ��pc���»�ȡip��ַ") {
						flag  = "1"
						rs    = @wifi.connect(@tc_ssid, flag, @tc_pwd)
						assert rs, 'wifi����ʧ��'

						sleep @tc_net_reset
						ip_info     = ipconfig("all")
						dns_servers = ip_info[@ts_nicname][:dns_server]
						rs1         = dns_servers.any? { |dns_server| dns_server=~/#{@tc_lan_ip1}/ }
						assert rs1, "DNS��ַ����ȷ"
						wifi_info     = @wifi.ipconfig("all")
						wifi_ip       = wifi_info[@ts_wlan_nicname][:ip][0]
						sub_default_ip=@tc_lan_ip1.sub(/\.\d+$/, "")
						assert_match(/#{sub_default_ip}/, wifi_ip, "wlan�ͻ��˵�ַ����ȷ")

						wifi_gw = wifi_info[@ts_wlan_nicname][:gateway][0]
						assert_equal @tc_lan_ip1, wifi_gw, "wlan�ͻ������ص�ַ����ȷ"
						wifi_dns_servers = wifi_info[@ts_wlan_nicname][:dns_server]
						rs2              = wifi_dns_servers.any? { |wifi_dns_server| wifi_dns_server=~/#{@tc_lan_ip1}/ }
						assert rs2, "wifi�ͻ���DNS��ַ����ȷ"
				}

				operate("6 �ָ�LanĬ������") {
						@lan_page.lan_ip_config(@ts_default_ip, @browser.url)
						@login_page = RouterPageObject::LoginPage.new(@browser)
						login_ui    = @login_page.login_with_exists(@browser.url)
						assert(login_ui, "������δ��ת����¼ҳ�棡")
						#���µ�¼·����
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
				}

		end

		def clearup

				operate("1 �ָ�Ĭ������") {
						@wifi.netsh_disc_all #�Ͽ�wifi����
						rs1 = ping(@ts_default_ip)
						if rs1 == true
								puts "·��������Ĭ������".to_gbk
						else
								options_page = RouterPageObject::OptionsPage.new(@browser)
								options_page.recover_factory(@browser.url)

								##�������ʽ�ظ��������ã���ֹ·������¼ʧ�������޷��ָ�Ĭ������
								# lan_ip = ipconfig[@ts_nicname][:gateway][0]
								# telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
								# exp_ralink_init
						end
				}

		end

}
