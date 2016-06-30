#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.15", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1��DUT������ɣ���龲̬��������ҳ�������ť���ڵ����ذ�ť�����ת�����ҳ�档") {

				}

				operate("2������WAN����Ϊ��̬���뷽ʽ��") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
				}

				operate("3������IP��ַΪ10.0.0.10������Ϊ255.255.255.0������Ϊ10.0.0.1��DNSΪ10.0.0.1��������棻") {
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
						assert_equal(@ts_staticNetmask, wan_mask, '��̬IP����ʧ�ܣ�')
						assert_equal(@ts_staticGateway, wan_gw, '��̬IP����ʧ�ܣ�')
						assert_equal(@ts_staticPriDns, wan_dns, '��̬IP����ʧ�ܣ�')
				}

		end

		def clearup
				operate("1 �ָ�Ĭ�Ϸ�ʽ:DHCP") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
