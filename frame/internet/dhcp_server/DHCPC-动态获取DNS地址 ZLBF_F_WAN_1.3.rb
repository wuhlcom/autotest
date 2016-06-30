#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.4", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1 ��������������") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
				}
				operate("2 ��������DHCP����") {
						puts "���ý��뷽ʽΪDHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
				}
				operate("4 �鿴WAN״̬") {
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						wan_type = sys_page.get_wan_type
						wan_addr = sys_page.get_wan_ip
						mask     = sys_page.get_wan_mask
						gateway  = sys_page.get_wan_gw
						dns      = sys_page.get_wan_dns
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{wan_addr}".to_gbk
						puts "��ѯ��WAN ����Ϊ#{mask}".to_gbk
						puts "��ѯ��WAN ����Ϊ#{gateway}".to_gbk
						puts "��ѯ��WAN DNSΪ#{dns}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'
						assert_match @ts_tag_ip_regxp, mask, 'dhcp��ȡip��ַ����ʧ�ܣ�'
						assert_match @ts_tag_ip_regxp, gateway, 'dhcp��ȡ����ip��ַʧ�ܣ�'
						assert_match @ts_tag_ip_regxp, dns, 'dhcp��ȡdns ip��ַʧ�ܣ�'
				}
				operate("6 ��֤ҵ��") {
						rs1 = ping(@ts_default_ip)
						assert(rs1, '·�����޷���¼')
						rs2 = ping(@ts_web)
						assert(rs2, '�޷���������')
				}

		end

		def clearup


		end

}
