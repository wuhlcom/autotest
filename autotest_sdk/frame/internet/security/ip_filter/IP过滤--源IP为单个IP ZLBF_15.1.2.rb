#
# description:
# author:liluping
# date:2015-09-16
#
testcase {

		attr = {"id" => "ZLBF_15.1.2", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_dumpcap               = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_dumpcap_pc2           = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_wifi_flag             = "1"
				@tc_wait_time             = 2
				@tc_wifi_wait             = 10
				@tc_net_time              = 50
				@tc_reboot_time           = 120
				@tc_relogin_time           = 80
				@tc_tag_button_switch_off = "off"
				@tc_tag_button_switch_on  = "on"
				@tc_ping_num = 5
		end

		def process

				operate("1��DUT�Ľ�������ѡ��ΪDHCP���������ã�PC1����Ϊ�Զ���ȡIP��ַ���磺192.168.100.100��") {
						#�鿴WAN���뷽ʽ�Ƿ�ΪDHCP
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#�������DHCP���޸�ΪDHCP
						unless wan_type =~ /#{@ts_wan_mode_dhcp}/
								puts "�л�ΪDHCP���뷽ʽ".to_gbk
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "����������ʧ��")
								@wan_iframe.link(:id => @ts_tag_wired_mode_link).click #ѡ����������
								dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
								unless dhcp_radio.checked?
										dhcp_radio.click
								end
								#�������ã��л�ΪDHCPģʽ
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "sleep #{@tc_net_time} second for net reseting..."
								sleep @tc_net_time
						end

						rs = ping(@ts_web)
						assert(rs, "����ԴIP����ǰ���߿ͻ����޷�pingͨ#{@ts_web}")

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						#������������
						#��lan����
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, '����������ʧ�ܣ�')
						#��lan���ò�Ϊwpa������Ϊwpa
						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "�ָ�Ĭ�ϵļ����뷽ʽ��#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@lan_iframe.text_field(id: @ts_tag_input_pw).set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#��������Ч
								puts "sleep #{@tc_net_time} second for wifi config changing..."
								sleep @tc_net_time
						end
						@tc_dut_pw   = @lan_iframe.text_field(id: @ts_tag_input_pw).value
						@tc_dut_ssid = @lan_iframe.text_field(:id, @ts_tag_ssid).value

						puts "Dut ssid: #{@tc_dut_ssid},passwd:#{@tc_dut_pw}"
						p "PC2����DUT".to_gbk
						rs1 = @tc_dumpcap_pc2.connect(@tc_dut_ssid, @tc_wifi_flag, @tc_dut_pw, @ts_wlan_nicname)
						assert rs1, 'wifi����ʧ��'

						rs2 =@tc_dumpcap_pc2.ping(@ts_web)
						assert(rs2, "����IP����ǰWIFI�ͻ����޷�ping#{@ts_web}")
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2���Ƚ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ����棻") {
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						#ѡ��ȫ����
						option_link = @option_iframe.link(id: @ts_tag_security)
						option_link.click

						#ѡ�����ǽ����
						@option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_tag_fwset)
						option_fw_iframe.click
						sleep @tc_wait_time

						puts "��������ǽ�ܿ���IP���˿���".to_gbk
						#���ܿ���
						btn_fw_off = @option_iframe.button(id: @ts_tag_security_sw, class_name: @tc_tag_button_switch_off)
						if btn_fw_off.exists?
								btn_fw_off.click
						end
						#��IP���˿���
						btn_ip_off = @option_iframe.button(id: @ts_tag_security_ip, class_name: @tc_tag_button_switch_off)
						if btn_ip_off.exists?
								btn_ip_off.click
						end
						#��������
						@option_iframe.button(id: @ts_tag_security_save).click
						sleep @tc_wait_time
				}

				operate("3�����һ��IP���˹�������ԴIPΪ192.168.100.100���˿�Ϊ1~65535��Э��ΪTCP/UDP��Ŀ�ĵ�ַ��Ŀ�Ķ˿ڲ���������ã�") {
						#��IP���˽���
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_ip_set)
						option_fw_iframe.click
						@tc_pc_ip = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
						p "���ù���ԴIP��#{@tc_pc_ip}".to_gbk
						@option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
						@option_iframe.text_field(id: @ts_ip_src).set(@tc_pc_ip) #����ԴIP
						@option_iframe.button(id: @ts_tag_save_filter).click #����
						sleep @tc_wait_time
						#�鿴����ǽ���ã��ж��Ƿ�����������Ŀ
						fw_state = @option_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fw_state, "����ǽ�ܿ��ش�ʧ��")
						ip_filter_state = @option_iframe.span(id: @ts_tag_ip_filter_state).text
						assert_equal(@ts_tag_fw_open, ip_filter_state, "IP���˿��ش�ʧ��")
						#��ȡ��Ŀ�е�Դip
						@source_ip = @option_iframe.table(id: @ts_iptable, class_name: @ts_tag_mac_table).trs[1][1].text
						@source_ip =~ /(\d+\.\d+\.\d+\.\d+)\-/i
						assert_equal($1, @tc_pc_ip, "���IP����ʧ��!")
						############################# ���涼�ǻ�ȡtr,td�����ݵķ��� ##################################
						# @option_iframe.td(text: "192.168.100.100-".parent[1].text

						# p @option_iframe.td(text: "ALL")
						# p @option_iframe.td(text: "ALL").parent
						# p @option_iframe.td(text: "ALL").parent[0].text
						# p @option_iframe.td(text: "ALL").parent[1].text

						# p @option_iframe.table(id: "iptable", class_name: "macguolv").trs
						# p @option_iframe.table(id: "iptable", class_name: "macguolv").trs[0]
						# p @option_iframe.table(id: "iptable", class_name: "macguolv").trs[0][0].text.to_gbk

						# p @option_iframe.table(id: "iptable", class_name: "macguolv").tbody.trs
						# p @option_iframe.table(id: "iptable", class_name: "macguolv").tbody.trs[0]
						# p @option_iframe.table(id: "iptable", class_name: "macguolv").tbody.trs[0][0].text.to_gbk
						##############################################################################################
				}

				operate("4����PC���������ping������ping��IPΪ���������ڵĵ�ַ��Ȼ���ڷ������鿴�Ƿ���ץ�����ݰ���") {
						#��֤ip�Ƿ����
						puts "��֤ip�����Ƿ���Ч".to_gbk
						p "��ȡ#{@ts_web}��Ӧ������IP".to_gbk
						ns     = Addrinfo.ip(@ts_web) #��ѯ��url��Ӧ��ip
						net_ip = ns.ip_address
						p "#{@ts_web}�Ķ�Ӧ������IPΪ��#{net_ip}".to_gbk

						rs = ping(net_ip, @tc_ping_num)
						refute(rs, "IP����ʧ�ܣ�����IPΪ#{@tc_pc_ip}����#{@tc_pc_ip}����pingͨ#{@ts_web}")

						puts "��pc2��ping #{@ts_web}".to_gbk
						wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
						ts          = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
						assert(ts, "IP�����쳣������IPΪ#{@tc_pc_ip}����IP #{wireless_ip}����pingͨ#{@ts_web}")
						#Ϊ��ֹ���������������ȡ��IP�Ǳ����˵�IP������ǰ�ȶϿ���������
						p "�Ͽ�wifi����".to_gbk
						@tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����
				}

				operate("7������DUT���鿴���˹����Ƿ���Ч") {
						@browser.span(id: @ts_tag_reboot).parent.click #���������ť
						@browser.button(class_name: @ts_tag_reboot_confirm).click
						puts "·���������У����Ժ�...".to_gbk
						sleep @tc_reboot_time
						login_ui = @browser.text_field(name: @usr_text_id).wait_until_present(@tc_relogin_time)
						assert(login_ui, "������δ������¼ҳ�棡")
						login_no_default_ip(@browser)

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						#ѡ��ȫ����
						option_link = @option_iframe.link(id: @ts_tag_security)
						option_link.click
						sleep @tc_wait_time
						#IP����
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_ip_set)
						option_fw_iframe.click

						#�鿴����ǽ���ã��ж��Ƿ�����������Ŀ
						fw_state = @option_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fw_state, "���������ǽ�ܿ��ش�ʧ��")
						ip_filter_state = @option_iframe.span(id: @ts_tag_ip_filter_state).text
						assert_equal(@ts_tag_fw_open, ip_filter_state, "������IP���˿��ش�ʧ��")
						#��ȡ��Ŀ�е�Դip
						@source_ip = @option_iframe.table(id: @ts_iptable, class_name: @ts_tag_mac_table).trs[1][1].text
						@source_ip =~ /(\d+\.\d+\.\d+\.\d+)\-/i
						assert_equal($1, @tc_pc_ip, "������ԴIP���˹���ʧ!")

						#��֤ip�Ƿ����
						puts "��֤ip�Ƿ����".to_gbk
						ns     = Addrinfo.ip(@ts_web) #��ѯ��url��Ӧ��ip
						net_ip = ns.ip_address
						p "��ȡ#{@ts_web}��Ӧ������IPΪ#{net_ip}".to_gbk

						tc_dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
						puts "������鿴��������IPΪ#{tc_dut_ip}"

						puts "����������������������"
						@tc_dumpcap_pc2.netsh_conn(@tc_dut_ssid)
						sleep @tc_wifi_wait
						wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
						puts "������鿴��������IPΪ#{wireless_ip}"

						#������������߻�õ��ǹ������õ�IP��Ҳ�п��������ǹ���IP,Ҳ�п��ܻ�ȡ��IP�����ǹ���IP
						if tc_dut_ip==@tc_pc_ip
								puts "ִ��PC����������".to_gbk
								rs = ping(@ts_web)
								refute(rs, "������ԴIP����ʧ��,#{tc_dut_ip}��pingͨ#{@ts_web}!")
								puts "��PC2��ping #{@ts_web}".to_gbk
								ts = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
								assert(ts, "����IP�����쳣������IPΪ#{@tc_pc_ip}����IPΪ#{wireless_ip}����pingͨ#{@ts_web}")
						elsif wireless_ip==@tc_pc_ip
								puts "��������������".to_gbk
								rs = ping(@ts_web)
								assert(rs, "������ԴIP����ʧ��,#{tc_dut_ip}����pingͨ#{@ts_web}!")
								puts "��PC2��ping #{@ts_web}".to_gbk
								ts = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
								refute(ts, "����IP�����쳣����IPΪ#{@tc_pc_ip}����IP#{wireless_ip}��pingͨ#{@ts_web}")
						else
								puts "��δ������".to_gbk
								assert(false, "�ű���Ҫ����")
						end
				}


		end

		def clearup

				operate("1 �ָ�Ĭ������") {
						p "�Ͽ�wifi����".to_gbk
						@tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����
						sleep @tc_wait_time
						p "1 �رշ���ǽ�ܿ��غ�IP���˿���".to_gbk
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						#�򿪰�ȫ����
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						option_link    = @option_iframe.link(id: @ts_tag_security)
						option_link.click
						#����ǽ����
						@option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_tag_fwset)
						option_fw_iframe.click
						sleep @tc_wait_time
						puts "�رշ���ǽ�ܿ��غ�IP���˿���".to_gbk
						btn_fw_on = @option_iframe.button(id: @ts_tag_security_sw, class_name: @tc_tag_button_switch_on)
						if btn_fw_on.exists?
								btn_fw_on.click
						end
						btn_ip_on = @option_iframe.button(id: @ts_tag_security_ip, class_name: @tc_tag_button_switch_on)
						if btn_ip_on.exists?
								btn_ip_on.click
						end

						@option_iframe.button(id: @ts_tag_security_save).click
						p "2 ɾ�����еĹ��˹���".to_gbk
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_ip_set)
						option_fw_iframe.click
						@option_iframe.span(id: @ts_tag_del_ipfilter_btn).click
						sleep @tc_wait_time
				}

		end

}
