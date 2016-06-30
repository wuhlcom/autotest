#
#description:
#author:wuhongliang
#date:2016-06-03 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_Attack_1.1.7", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_count= 100000
		end

		def process

				operate("1 ��������DHCP����") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪDHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
				}
				operate("2 �鿴WAN״̬") {
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						wan_type    = @sys_page.get_wan_type
						wan_addr    = @sys_page.get_wan_ip
						@tc_lan_mac = @sys_page.get_lan_mac
						@tc_lan_ip  = @sys_page.get_lan_ip
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'
				}

				operate("3 ��֤ҵ���Ƿ�����") {
						rs1 = ping(@ts_default_ip)
						assert(rs1, '·�����޷���¼')
						rs2 = ping(@ts_web)
						assert(rs2, '�޷���������')
				}

				operate("4 ���ͱ���ǰ�鿴�����Ƿ����") {
						puts "�鿴udhcpc��udhcpd��lighttpd��dnsmasq��ntpd����".to_gbk
						init_router_obj(@tc_lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						rs = router_attack_ps
						assert(rs, "����SYN Flood����ǰ·���������쳣")
				}

				operate("5 ����SYN Flood����") {
						nicinfo = ipconfig(@ts_ipconf_all)
						@pc_mac = nicinfo[@ts_nicname][:mac]
						@pc_ip  = nicinfo[@ts_nicname][:ip][0]
						pktobj  = HtmlTag::Packets.new(@pc_mac, @pc_ip, @tc_lan_mac, @tc_lan_ip, @ts_nicname)
						rs      = pktobj.send_tcp("S","%%%%%","13521",@tc_count)
						assert(rs.kind_of?(Hash), "���ķ���ʧ��")
				}

				operate("6 ����SYN Flood���ĺ�鿴����") {
						puts "����SYN Flood���ĺ�鿴udhcpc��udhcpd��lighttpd��dnsmasq��ntpd����".to_gbk
						rs = router_attack_ps
						assert(rs, "����SYN Flood���ĺ�·���������쳣")
				}

				operate("7 ����SYN Flood���ĺ���֤ҵ��") {
						rs1 = ping(@ts_default_ip)
						assert(rs1, '����SYN Flood���ĺ�·�����޷���¼')
						rs2 = ping(@ts_web)
						assert(rs2, '����SYN Flood���ĺ��޷���������')
						puts "����SYN Flood���ĺ�鿴·����WEB�Ƿ���Ե�¼".to_gbk
						@wan_page.refresh
						rs3 = @wan_page.wan?
						assert(rs3, '����SYN Flood���ĺ��޷���WEB����')
				}

		end

		def clearup


		end

}
