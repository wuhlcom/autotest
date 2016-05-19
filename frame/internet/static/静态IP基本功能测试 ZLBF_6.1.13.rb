#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_6.1.13", "level" => "P1", "auto" => "n"}

		def prepare
		end

		def process

				operate("1 ��������������") {
				}

				operate("2 �����������ӷ�ʽ") {
				}

				operate("3 ����������̬����") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
				}

				operate("4 �鿴WAN״̬") {
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_ip   = @systatus_page.get_wan_ip
						wan_mask = @systatus_page.get_wan_mask
						wan_gw   = @systatus_page.get_wan_gw
						wan_dns  = @systatus_page.get_wan_dns
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{wan_ip}".to_gbk
						puts "��ѯ��WAN��������Ϊ#{wan_mask}".to_gbk
						puts "��ѯ��WAN����Ϊ#{wan_gw}".to_gbk
						puts "��ѯ��WAN DNSΪ#{wan_dns}".to_gbk
						assert_equal(@ts_wan_mode_static, wan_type, '�������ʹ���')
						assert_equal(@ts_staticIp, wan_ip, '��̬IP����ʧ�ܣ�')
						assert_equal(@ts_staticNetmask, wan_mask, '��̬��������ʧ�ܣ�')
						assert_equal(@ts_staticGateway, wan_gw, '��̬��������ʧ�ܣ�')
						assert_equal(@ts_staticPriDns, wan_dns, '��̬DNS����ʧ�ܣ�')
				}
				operate("5 ��֤ҵ��") {
						rs = ping(@ts_web)
						assert(rs, '�޷���������')
				}

		end

		def clearup
				operate("1 �ָ�Ĭ�Ϸ�ʽ:DHCP") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}
		end
}