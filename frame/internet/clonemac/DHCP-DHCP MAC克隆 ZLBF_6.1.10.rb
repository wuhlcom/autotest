#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.10", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_dumpcap    = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_wait_time = 2
				@tc_mac1       = "00:12:00:00:00:01"
				@tc_mac2       = "00:12:00:00:00:02"
				@tc_ping_num   = 300
				@tc_task       = "ping.exe"
				@tc_cap_filter = "ether src host #{@ts_pc_mac} and icmp"
				puts "Capture filter:#{@tc_cap_filter}"
				@tc_capfile = "#{@ts_cap_packetpath}/mac_clone_dhcp_pc.pcap"
		end

		def process

				operate("1.����MAC��¡ҳ�棬��DHCP Server����ץ����") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪDHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_addr = @systatus_page.get_wan_ip
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'
				}

				operate("2.ѡ��ʹ�ü����MAC��ַ���鿴��ַ�ı�������ʾMAC��ַ�Ƿ����¼������MAC��ַһ�£����棻") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.clone_mac(@browser.url)
						puts "��¡�����󣬲鿴�Ƿ��¡�ɹ�".to_gbk
						@browser.refresh

						@systatus_page.open_systatus_page(@browser.url)
						wan_mac = @systatus_page.get_wan_mac.upcase
						puts "��ѯ����¡��WAN MACΪ#{wan_mac}".to_gbk
						puts "����¡������MAC��ַΪ#{@ts_pc_mac}".to_gbk
						assert_equal(@ts_pc_mac, wan_mac, "MAC��ַ��¡ʧ��!")
				}

				operate("3.��LAN PC��ping ������IP��ַ��ץ���鿴ԴMAC�Ƿ���������MAC��ַһ�£�") {
						#ץ���鿴�Ƿ���Я����¡���mac
						#һ��pingһ��ץ��					
						begin
								thr = Thread.new { ping(@ts_web, @tc_ping_num) }
								sleep @tc_wait_time
								@tc_dumpcap.dumpcap_a(@tc_capfile, @ts_server_lannic, @ts_cap_timeout, @tc_cap_filter)
								packets = @tc_dumpcap.capinfos(@tc_capfile)
								puts "Capture packets num:#{packets}"
								assert(packets.to_i>0, "MAC��ַ��¡ʧ��,δץ����¡��İ�!")
						rescue => e
								puts e.message.to_s
						ensure
								thr.kill if thr.alive? #ǿ��ɱ��
								taskkill(@tc_task) if tasklist_exists?(@tc_task)
						end
				}

				operate("4.ѡ��ʹ��ָ��MAC��ַ�����������õ�MAC��ַ�����棻") {
						puts "����MAC��#{@tc_mac1} ���п�¡".to_gbk
						@options_page.set_clone_mac(@tc_mac1,@browser.url)
						#�鿴��¡��mac��ַ��Ϣ
						@browser.refresh
						@systatus_page.open_systatus_page(@browser.url)
						wan_mac = @systatus_page.get_wan_mac.upcase
						puts "��ѯ����¡��WAN MACΪ#{wan_mac}".to_gbk
						assert_equal(@tc_mac1, wan_mac, "����#{@tc_mac1}��¡��,��¡ʧ��!")
				}

				operate("5.��LAN PC��ping ������IP��ַ��ץ���鿴ԴMAC�����õ�MAC��ַһ�£�") {
						#ץ���鿴�Ƿ���Я����¡���mac
						#һ��pingһ��ץ��
						@tc_cap_filter = "ether src host #{@tc_mac1} and icmp"
						puts "Capture filter:#{@tc_cap_filter}"
						@tc_capfile = "#{@ts_cap_packetpath}/mac_clone_dhcp_input.pcap"
						begin
								thr = Thread.new { ping(@ts_web, @tc_ping_num) }
								sleep @tc_wait_time
								@tc_dumpcap.dumpcap_a(@tc_capfile, @ts_server_lannic, @ts_cap_timeout, @tc_cap_filter)
								packets = @tc_dumpcap.capinfos(@tc_capfile)
								puts "Capture packets num:#{packets}"
								assert(packets.to_i>0, "MAC��ַ��¡ʧ��,δץ����¡��İ�!")
						rescue => e
								puts e.message.to_s
						ensure
								thr.kill if thr.alive? #ǿ��ɱ��
								taskkill(@tc_task) if tasklist_exists?(@tc_task)
						end
				}

				operate("6��ѡ��ʹ��ȱʡ��ַ�������棻") {
						#�رտ�¡�ͻ�ʹ��·����Ĭ��MAC
						@options_page.shutdown_clone(@browser.url)
						#�鿴��¡��mac��ַ��Ϣ
						@browser.refresh
						@systatus_page.open_systatus_page(@browser.url)
						@tc_wan_mac = @systatus_page.get_wan_mac.upcase
						puts "�رտ�¡��,��ѯ����¡��WAN MACΪ#{@tc_wan_mac}".to_gbk
						refute_equal(@tc_mac1, @tc_wan_mac, "�رտ�¡��,��¡�ָ�ʧ��!")
				}

				operate("7.��LAN PC��ping ������IP��ַ��ץ���鿴ԴMAC�Ƿ���DUT Ĭ��WAN��MAC��ַһ�£�") {
						#ץ���鿴�Ƿ���Я����¡���mac
						#һ��pingһ��ץ��
						@tc_cap_filter = "ether src host #{@tc_wan_mac} and icmp"
						puts "Capture filter:#{@tc_cap_filter}"
						@tc_capfile = "#{@ts_cap_packetpath}/mac_clone_dhcp_default.pcap"
						begin
								thr = Thread.new { ping(@ts_web, @tc_ping_num) }
								sleep @tc_wait_time
								@tc_dumpcap.dumpcap_a(@tc_capfile, @ts_server_lannic, @ts_cap_timeout, @tc_cap_filter)
								packets = @tc_dumpcap.capinfos(@tc_capfile)
								puts "Capture packets num:#{packets}"
								assert(packets.to_i>0, "MAC��ַ��¡ʧ��,δץ����¡��İ�!")
						rescue => e
								puts e.message.to_s
						ensure
								thr.kill if thr.alive? #ǿ��ɱ��
								taskkill(@tc_task) if tasklist_exists?(@tc_task)
						end
				}

				# operate("8������MAC��ַ��¡��ʽ�л�5�����ϣ�DUT�Ƿ������쳣��") {
				#
				# }

		end

		def clearup

				operate("1 ȡ����¡") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.shutdown_clone(@browser.url)
				}

		end

}
