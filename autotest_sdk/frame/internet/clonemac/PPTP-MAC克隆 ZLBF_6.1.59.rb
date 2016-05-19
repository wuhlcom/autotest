#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.59", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_dumpcap       = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_wait_time     = 2
				@tc_clone_time    = 10
				@tc_net_time      = 15
				@tc_net_wait_time = 60
				@tc_tag_pptp      = "PPTP-Settings"

				@tc_tag_pptp_usr = "username"
				@tc_tag_pptp_pw  = "psd"

				@tc_mac1     = "00:13:00:00:00:01"
				@tc_mac2     = "00:13:00:00:00:02"
				@tc_ping_num = 500
				@tc_task     = "ping.exe"
		end

		def process

				operate("1����BAS����ץ����") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ����������
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#ѡ��PPTP
						@advance_iframe.link(:id, @tc_tag_pptp).click
						sleep @tc_wait_time
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						#����PPTP
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip)
						@advance_iframe.text_field(:id, @tc_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_iframe.text_field(:id, @tc_tag_pptp_pw).set(@ts_pptp_pw)
						@advance_iframe.button(:id, @ts_tag_sbm).click
						Watir::Wait.until(@tc_wait_time, "PPTP���óɹ���ʾδ����") {
								@pptp_tip=@advance_iframe.div(class_name: @ts_tag_reset, text: /#{@ts_tag_pptp_set}/)
								@pptp_tip.present?
						}
						Watir::Wait.while(@tc_net_wait_time, "PPTP���óɹ���ʾ��ʧ") {
								@pptp_tip.present?
						}
						sleep @tc_net_wait_time #·����������ܻ������������������ӳ�

						#�رո߼�����
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#�ҵ�������DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#���ع���Ŀ¼ҳ���DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#���ر�����DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#���²鿴����״̬
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "���´�WAN״̬ʧ�ܣ�")

						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

						mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						mask =~@ts_tag_ip_regxp
						puts "WAN״̬��ʾ����Ϊ��#{Regexp.last_match(1)}".to_gbk

						dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
						dns_addr =~@ts_tag_ip_regxp
						puts "WAN״̬��ʾDNSΪ��#{Regexp.last_match(1)}".to_gbk

						wan_type = @status_iframe.b(:id => @tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_pptp})/
						puts "WAN״̬��ʾ��������Ϊ��#{Regexp.last_match(1)}".to_gbk

						assert_match @ts_tag_ip_regxp, wan_addr, '��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���'
						assert_match @ts_tag_ip_regxp, mask, '��ȡip��ַ����ʧ�ܣ�'
						assert_match @ts_tag_ip_regxp, dns_addr, '��ȡdns ip��ַʧ�ܣ�'
				}

				operate("2.ѡ��ʹ�ü����MAC��ַ���鿴��ַ�ı�������ʾMAC��ַ�Ƿ����¼������MAC��ַһ�£����棻") {
						puts "PC MAC address: #{@ts_pc_mac}"
						puts "Router Wan default MAC address: #{@ts_wan_mac}"
						refute_equal(@ts_pc_mac, @ts_wan_mac, "WAN MAC��PC MACһ�������Ѿ���¡��!")
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ����������
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#ѡ��mac��¡
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end

						#�򿪿�¡����
						clone_switch = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_off)
						#clone_switch.enabled?
						if clone_switch.exists?
								clone_switch.click
						end
						clone_switch_on = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						assert(clone_switch_on.exists?, "��¡����δ��!")
						#��¡��ַ
						@advance_iframe.button(id: @ts_tag_fillmac).click
						#��ȡ��¡��ַ
						clone_mac_addr = @advance_iframe.text_field(id: @ts_tag_pcmac).value
						puts "Clone MAC address: #{clone_mac_addr}"
						assert_equal(@ts_pc_mac.upcase, clone_mac_addr.upcase, "MAC��ַ��¡ʧ��!")
						#ȷ�Ͽ�¡
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_wait_time #�޸�mac��Ҫ�������磬�ȴ���������
						#�رո߼�����
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#�ҵ�������DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#�鿴��¡��mac��ַ��Ϣ
						@browser.refresh #ˢ��ҳ��
						system_ver = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						@ts_wan_mac_pattern1 =~system_ver
						@tc_wan_mac1 = Regexp.last_match(1)
						puts "Current WAN MAC :#{@tc_wan_mac1}"
						assert_equal(@ts_pc_mac, @tc_wan_mac1, "WAN MAC��PC MAC��һ��,��¡ʧ��!")
				}

				operate("3.��LAN PC��ping ������IP��ַ��ץ���鿴ԴMAC�Ƿ���������MAC��ַһ�£�") {
						#ץ���鿴�Ƿ���Я����¡���mac
						#һ��pingһ��ץ��
						tc_cap_filter = "ether src host #{@ts_pc_mac}"
						puts "Capture filter:#{tc_cap_filter}"
						capfile = "#{@ts_cap_packetpath}/mac_clone_pptp_pc.pcap"
						begin
								thr = Thread.new { ping(@ts_web, @tc_ping_num) }
								sleep @tc_wait_time
								@tc_dumpcap.dumpcap_a(capfile, @ts_server_lannic, @ts_cap_timeout, tc_cap_filter)
								packets = @tc_dumpcap.capinfos(capfile)
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
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ����������
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#ѡ��mac��¡
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end

						clone_switch_on = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						assert(clone_switch_on.exists?, "��¡����δ��!")
						#����mac��ַ
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(@tc_mac1)
						#ȷ�Ͽ�¡
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_wait_time #�޸�mac��Ҫ�������磬�ȴ���������
						#�رո߼�����
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#�ҵ�������DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#�鿴��¡��mac��ַ��Ϣ
						@browser.refresh
						system_ver = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						@ts_wan_mac_pattern1 =~system_ver
						@tc_wan_mac2 = Regexp.last_match(1)
						puts "Current WAN MAC :#{@tc_wan_mac2}"
						assert_equal(@tc_mac1, @tc_wan_mac2, "WAN MAC��clone MAC#{@tc_mac1}��һ��,��¡ʧ��!")
				}

				operate("5.��LAN PC��ping ������IP��ַ��ץ���鿴ԴMAC�����õ�MAC��ַһ�£�") {
						# ץ���鿴�Ƿ���Я����¡���mac
						# һ��pingһ��ץ��
						tc_cap_filter = "ether src host #{@tc_mac1}"
						puts "Capture filter:#{tc_cap_filter}"
						capfile = "#{@ts_cap_packetpath}/mac_clone_pptp_input.pcap"
						begin
								thr = Thread.new { ping(@ts_web, @tc_ping_num) }
								sleep @tc_wait_time
								@tc_dumpcap.dumpcap_a(capfile, @ts_server_lannic, @ts_cap_timeout, tc_cap_filter)
								packets = @tc_dumpcap.capinfos(capfile)
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
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ����������
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#ѡ��mac��¡
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end
						# ȡ����¡
						clone_switch_on = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						if clone_switch_on.exists?
								clone_switch_on.click
						end
						clone_switch_off = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_off)
						assert(clone_switch_off.exists?, "��¡����δ�ر�!")
						#ȷ��ȡ����¡
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_wait_time #�޸�mac��Ҫ�������磬�ȴ���������
						#�ҵ�����Ŀ¼ҳ���DIV
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#�ҵ�������DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#�鿴��¡��mac��ַ��Ϣ
						@browser.refresh
						system_ver = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						@ts_wan_mac_pattern1 =~system_ver
						tc_wan_mac = Regexp.last_match(1)
						puts "Current WAN MAC :#{tc_wan_mac}"
						assert_equal(@ts_wan_mac, tc_wan_mac, "WAN MAC��PC MAC��һ��,��¡ʧ��!")
				}

				operate("7.��LAN PC��ping ������IP��ַ��ץ���鿴ԴMAC�Ƿ���DUT Ĭ��WAN��MAC��ַһ�£�") {
						# ץ���鿴�Ƿ���Я����¡���mac
						# һ��pingһ��ץ��
						tc_cap_filter = "ether src host #{@ts_wan_mac}"
						puts "Capture filter:#{tc_cap_filter}"
						capfile = "#{@ts_cap_packetpath}/mac_clone_pptp_default.pcap"
						begin
								thr = Thread.new { ping(@ts_web, @tc_ping_num) }
								sleep @tc_wait_time
								@tc_dumpcap.dumpcap_a(capfile, @ts_server_lannic, @ts_cap_timeout, tc_cap_filter)
								packets = @tc_dumpcap.capinfos(capfile)
								puts "Capture packets num:#{packets}"
								assert(packets.to_i>0, "MAC��ַ��¡ʧ��,δץ����¡��İ�!")
						rescue => e
								puts e.message.to_s
						ensure
								thr.kill if thr.alive? #ǿ��ɱ��
								taskkill(@tc_task) if tasklist_exists?(@tc_task)
						end
				}

				operate("8������MAC��ַ��¡��ʽ�л�5�����ϣ�DUT�Ƿ������쳣��") {

				}


		end

		def clearup

				operate("1���ָ�Ĭ��DHCP����") {
						@tc_dumpcap.netsh_disc_all #�Ͽ�wifi����
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe

						flag = false
						#����wan���ӷ�ʽΪ��������
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag = true
						end

						#��ѯ�Ƿ�ΪΪdhcpģʽ
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#����WIRE WANΪDHCPģʽ
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_net_wait_time
						end
				}

				operate("2 ȡ����¡") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

						#ѡ����������
						networking      = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#ѡ��mac��¡
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end

						#�رտ�¡����
						clone_switch = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						clone_switch.exists?
						if clone_switch.exists?
								clone_switch.click
								@advance_iframe.button(id: @ts_tag_sbm).click
								puts "Watin for netreseting..."
								sleep @tc_net_wait_time #�޸�mac��Ҫ�������磬�ȴ���������
						end
				}
		end

}
