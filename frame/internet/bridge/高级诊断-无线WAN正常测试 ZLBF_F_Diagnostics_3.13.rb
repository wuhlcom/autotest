#
# description:
# Wanprotocal �������������ͣ���WISP
# Wanlink ��Wan����״̬��������
# IP ��������������IP��ַ����ʧ��
# GW ������Ĭ�����صĶ����ʣ���100%
# DNS ��������������ʧ��
# HTTP ������״̬�룩��404
# "Wanprotocal �������������ͣ���WISP"
# "Wanlink ��Wan����״̬��������"
# "IP ��������������IP��ַ����14.215.177.38"
# "GW ������Ĭ�����صĶ����ʣ���0%"
# "DNS ���������������ɹ�"
# "HTTP ������״̬�룩��200"
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.31", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wan_type    = "WISP"
				@tc_normal      = "����"
				@tc_dns         = "�ɹ�"
				@tc_loss        = "0%"
				@tc_http_code   = "200"
		end

		def process

				operate("0����ȡ���AP��ssid������") {
						@browser1         = Watir::Browser.new :ff, :profile => "default"
						@accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
						@accompany_router.login_accompany_router(@ts_tag_ap_url)
						#���AP 2.4G����
						@accompany_router.open_wireless_24g_page
						#��ȡssid������
						@ap_ssid = @accompany_router.ap_ssid
						@ap_pwd  = @accompany_router.ap_pwd
						p "���AP��ssidΪ��#{@ap_ssid}������Ϊ��#{@ap_pwd}".to_gbk
				}

				operate("1��������3G������������������ΪLAN�ڣ�����WIFI����Ϊ����WAN�����м̵�����������·�������档���и߼����") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_bridge_pattern(@browser.url, @ap_ssid, @ap_pwd)
						#�鿴WAN״̬
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_ip   = @systatus_page.get_wan_ip
						wan_gw   = @systatus_page.get_wan_gw
						puts "WAN���뷽ʽΪ:#{wan_type}".to_gbk
						assert_match(/#{@ts_tag_wifiwan}/, wan_type, "�������ʹ���")
						puts "WAN IP��ַ:#{wan_ip}".to_gbk
						assert_match(@ts_tag_ip_regxp, wan_ip, "����WAN��ȡIP��ַʧ��")
						puts "WAN ����Ϊ:#{wan_gw}".to_gbk
						assert_match(@ts_tag_ip_regxp, wan_gw, "����WAN��ȡ���ص�ַʧ��")
						rs = ping(@ts_web)
						assert(rs, "��������ʧ��!")

						#�򿪸߼����
						@diagnose_advpage = RouterPageObject::DiagnoseAdvPage.new(@browser)
						@diagnose_advpage.initialize_diagadv(@browser)
						#�����ַ
						@diagnose_advpage.url_addr = @ts_diag_web
						#������
						@diagnose_advpage.advdiag
						loss = @diagnose_advpage.gw_loss
						@diagnose_advpage.advdiag if loss =~ /gw\s*.+��%/i #��������ʳ���%ʱ���������һ��
						wan_protocol = @diagnose_advpage.wan_type
						puts "#{wan_protocol}".encode("GBK")
						assert_match(/#{@tc_wan_type}/, wan_protocol, "�������ʹ���")

						wanlink = @diagnose_advpage.net_status
						puts "#{wanlink}".encode("GBK")
						assert_match(/#{@tc_normal}/, wanlink, "WAN����״̬����")

						domain_ip = @diagnose_advpage.domain_ip
						puts "#{domain_ip}".encode("GBK")
						assert_match(@ts_tag_ip_regxp, domain_ip, "��������ʧ��")

						loss = @diagnose_advpage.gw_loss
						puts "#{loss}".encode("GBK")
						assert_match(/#{@tc_loss}/, loss, "�����ʴ���")

						dns = @diagnose_advpage.dns_parse
						puts "#{dns}".encode("GBK")
						assert_match(/#{@tc_dns}/, dns, "DNS����ʧ��")

						http_code = @diagnose_advpage.http_code
						puts "#{http_code}".encode("GBK")
						assert_match(/#{@tc_http_code}/, http_code, "״̬�����")
				}


		end

		def clearup

				operate("1���ָ�Ĭ�Ͻ��뷽ʽDHCP") {
						@browser1.close
						tc_handles = @browser.driver.window_handles
						@browser.driver.switch_to.window(tc_handles[0])
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}

		end

}
