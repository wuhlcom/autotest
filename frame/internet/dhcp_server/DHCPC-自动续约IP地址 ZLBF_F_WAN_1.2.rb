#
# description:
# # ��ע����Լʱ��Ϊ��Լʱ���һ�롣
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.3", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_dumpcap_server         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_lease_time             = "120" #ץ��ʱ��
				@tc_dhcp_server_ip         = "10.10.10.1"
				@tc_dhcp_lease_set         = "ip dhcp-server set lease-time=00:01:00 numbers=DHCP-server" #�޸���ԼΪ1����
				@tc_dhcp_lease_default_set = "ip dhcp-server set lease-time=1d numbers=DHCP-server" #Ĭ��Ϊһ��
				@tc_dhcp_pri               = "ip dhcp-server pri"
		end

		def process

				operate("1���޸ķ�������Լʱ�䣻") {
						@tc_dumpcap_server.init_routeros_obj(@ts_server_ip)
						@tc_dumpcap_server.routeros_send_cmd(@tc_dhcp_lease_set) #������ԼΪ1����
						rs = @tc_dumpcap_server.dhcp_srv_pri(@tc_dhcp_pri)
						p "�޸ķ�����DHCP-server����Լʱ��Ϊ:#{rs["lease-time"]}".to_gbk
				}

				operate("2��DUT��������Ӧ��DHCPC ��ʽ�������ã��鿴DUT�Ƿ���Ի�ȡ��DHCP Server���õ���ص�ַ��Ϣ�ȣ�") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪDHCP".to_gbk
						#�޸ķ�������Լ��WANҪ���»�ȡһ��IP��ַ������ֱ������DHCPģʽ������
						@wan_page.set_dhcp_mode(@browser.url)
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						@wan_mac = sys_page.get_wan_mac
						wan_type = sys_page.get_wan_type
						wan_addr = sys_page.get_wan_ip
						mask     = sys_page.get_wan_mask
						gateway  = sys_page.get_wan_gw
						dns      = sys_page.get_wan_dns
						puts "��ѯ��WAN MACΪ#{@wan_mac}".to_gbk
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

				operate("3����LAN PC��ִ��ping dhcp server IP -t��") {
						@thread = Thread.new do
								rs = ping_lost_pack(@tc_dhcp_server_ip, 150)
								# assert(rs, "PC��ping dhcp server IP ��ͨ")
								assert(rs<1, "pc��ping�������ж�������")
								p "pingִ�н������޶�������".to_gbk
						end

				}

				operate("4���ȴ�3���Ӻ󣬲鿴DUT�Ƿ�request���ģ�������ԼIP��ַ����Լ����Ƿ�������PC PING�Ƿ��ж�������") {
						p "�鿴DUT�Ƿ�request����".to_gbk
						@tc_cap_fields = "-e frame.time_relative" #�鿴���ͱ���ʱ���õ�ʱ��
						@tc_cap_filter = "bootp.type==1&&eth.src==#{@wan_mac}" #Լ������Ϊ: request���Ĳ��ҽ���mac��ַԼ��
						args           = {nic: @ts_server_lannic, filter: @tc_cap_filter, duration: @tc_lease_time, fields: @tc_cap_fields}
						ts             = @tc_dumpcap_server.tshark_display_filter_fields(args).last(2)
						puts ts
						assert(!ts.empty?, "δץȡ������")
						request_time2 = ts[1].slice(/->(.+)/, 1).to_i
						request_time1 = ts[0].slice(/->(.+)/, 1).to_i
						puts "����request����ʱ���ֱ��ǣ�#{request_time1}s,�� #{request_time2}s".to_gbk
						flag  = false
						value =request_time2-request_time1
						puts "DHCP����������Ϊ60sʱ��·����WAN����request�ļ��Ϊ#{value}".to_gbk
						if (value>= 30 && value <= 33) #��Ϊ·������Լǰ����ARP����,dhcp��Լ���Ļ��ӳ�2-3s���ͣ�
								flag = true
						end
						assert(flag, "dut����Լʱ���һ��ʱ����δ��request���ģ�")
						@thread.join if @thread.alive? #����̻߳�δ�������͵ȴ�������ڽ���clearup�����
				}

				operate("5�����ķ���������Լʱ�䣬���²�������1~3��") {
						# ��ע����Լʱ��Ϊ��Լʱ���һ�롣
				}

		end

		def clearup
				operate("1 �ָ�DHCP������Ĭ����Լ") {
						@thread.join if !@thread.nil? && @thread.alive?
						@tc_dumpcap_server.init_routeros_obj(@ts_server_ip)
						@tc_dumpcap_server.routeros_send_cmd(@tc_dhcp_lease_default_set) #������ԼΪ24Сʱ
						rs = @tc_dumpcap_server.dhcp_srv_pri(@tc_dhcp_pri)
						p "�޸ķ�����DHCP-server����Լʱ��Ϊ:#{rs["lease-time"]}".to_gbk
				}
		end

}
