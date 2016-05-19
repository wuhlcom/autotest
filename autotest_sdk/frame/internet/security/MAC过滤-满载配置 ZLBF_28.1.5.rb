#
# description:
#��Ʒ��bug
# δ����MAC��������
# �����޷�����ɾ��
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_28.1.5", "level" => "P3", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi = DRbObject.new_with_uri(@ts_drb_server)
				@ts_download_directory.gsub!("\\", "\/")
				@tc_file_name          = "RT2880_Settings.dat"
				@tc_wifi_flag          = "1"
				@tc_wait_time          = 2
				@tc_filter_time        = 3
				@tc_reboot_time        = 120
				@tc_relogin_time       = 80
				@tc_net_time           = 50
				@tc_status_time        = 10
				@tc_download_conf_time = 20
				@tc_mac_error          = "MAC���˹������ֻ�����32��"
				@tc_tag_table          = "macguolv"
				@tc_tag_inport         = "filename"
				@tc_tag_update_btn     = "update_submit_btn"
				# @tc_wifi_mac           = "08:57:00:97:1E:A8"
		end

		def process

				operate("1��AP������·�ɷ�ʽ�£�") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "��WAN״̬ʧ�ܣ�")
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#���ж��Ƿ�Ϊdhcpģʽ�������������Ϊdhcpģʽ
						unless wan_type=~/#{@ts_wan_mode_dhcp}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								puts "����WANΪDHCP����".encode("GBK")
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "����������ʧ��")
								#������������
								rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
								unless rs1=~/#{@ts_tag_select_state}/
										@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								end

								#�������dhcp�����������Ϊdhcp����
								dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
								dhcp_radio.click
								#�ύ
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								#���²鿴����״̬
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, "���´�WAN״̬ʧ�ܣ�")
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						end
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

						wan_type =~/(#{@ts_wan_mode_dhcp})/
						puts "WAN״̬��ʾ��������Ϊ��#{Regexp.last_match(1)}".to_gbk

						assert_match(@ts_tag_ip_regxp, wan_addr, 'dhcp��ȡip��ַʧ�ܣ�')
						assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���')

						rs = ping(@ts_web)
						assert(rs, "����ǰPC�޷�����")
						puts "PC1 TCP server connect"
						client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						assert(client.tcp_state, "����ǰPC����TCP����ʧ��")

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "����������ʧ��!")
						ssid        = @lan_iframe.text_field(id: @ts_tag_ssid).value
						select_list = @lan_iframe.select_list(id: @ts_tag_sec_select_list)

						if select_list.selected?(@ts_sec_mode_wpa)
								passwd=@lan_iframe.text_field(id: @ts_tag_input_pw).value
						else
								puts "�ָ�Ĭ�ϵļ����뷽ʽ��#{@ts_sec_mode_wpa}".to_gbk
								select_list.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#��������Ч
								puts "Waiting for wifi config changed..."
								sleep @tc_wait_net_reset
								passwd = @ts_default_wlan_pw
						end
						puts "��ǰSSID��Ϊ��#{ssid},����:#{passwd}".to_gbk
						rs = @wifi.connect(ssid, @tc_wifi_flag, passwd)
						assert rs, "WIFI����ʧ��"
						wifi_rs = @wifi.ping(@ts_web)
						assert wifi_rs, "WIFI�ͻ����޷���������"
				}

				operate("2����ӻ��ڵ�MAC��ַ���˹���32����������꣨�������õĹ�������Ŀ����������������PC1��PC2��MAC��ַ���������ã�") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ��ȫ����
						security_set = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#ѡ�����ǽ����
						fwset      = @advance_iframe.link(id: @ts_tag_fwset)
						fwset_state= fwset.parent.class_name
						unless fwset_state==@ts_tag_liclass
								fwset.click
						end

						#���ܿ���
						fw_switch = @advance_iframe.button(id: @ts_tag_security_sw, class_name: @ts_tag_btn_off)
						if fw_switch.exists?
								fw_switch.click
						end

						#��mac���˿���
						mac_switch = @advance_iframe.button(id: @ts_tag_security_mac, class_name: @ts_tag_btn_off)
						if mac_switch.exists?
								mac_switch.click
						end

						#����
						@advance_iframe.button(id: @ts_tag_security_save).click
						sleep @tc_filter_time

						#��MAC��������
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end
						fwstatus = @advance_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fwstatus, "����ǽ�ܿ��ش�ʧ��")
						mac_status = @advance_iframe.span(id: @ts_tag_fwmac).text
						assert_equal(@ts_tag_fw_open, mac_status, "MAC���˿��ش�ʧ��")

						#������߿ͻ��˹�������
						puts "���PC1 MAC #{@ts_pc_mac}Ϊ��������".encode("GBK")
						@advance_iframe.span(id: @ts_tag_additem).click
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(@ts_pc_mac)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@ts_nicname)
						sleep @tc_wait_time
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#����Ϊ��Ч
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end
						#����mac��������
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time

						#������߿ͻ��˹�������
						wifi         = @wifi.ipconfig(@ts_ipconf_all)
						wifi_mac     = wifi[@ts_wlan_nicname][:mac]
						@tc_wifi_mac = wifi_mac.gsub("-", ":")
						puts "���PC2 MAC #{@tc_wifi_mac}Ϊ��������".encode("GBK")
						@advance_iframe.span(id: @ts_tag_additem).click
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(@tc_wifi_mac)
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@ts_wlan_nicname)
						wifi_select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#����Ϊ��Ч
						unless wifi_select_list.selected?(@ts_tag_filter_use)
								wifi_select_list.select(/#{@ts_tag_filter_use}/)
						end
						#����mac��������
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time

						#�鿴���߿ͻ���mac���������Ƿ�ɹ�
						mac_filter_item = @advance_iframe.td(text: @ts_pc_mac).parent
						desc            = mac_filter_item[1].text
						status          = mac_filter_item[2].text
						assert(mac_filter_item.exists?, "��������������")
						assert_equal(@ts_nicname, desc, "����������������ȷ")
						assert_equal(@ts_tag_filter_use, status, "��������״̬����ȷ")
						#�鿴���߿ͻ���mac���������Ƿ�ɹ�
						wifi_mac_filter_item = @advance_iframe.td(text: @tc_wifi_mac).parent
						wifi_desc            = wifi_mac_filter_item[1].text
						wifi_status          = wifi_mac_filter_item[2].text
						assert(wifi_mac_filter_item.exists?, "���߿ͻ��˹�������������")
						assert_equal(@ts_wlan_nicname, wifi_desc, "���߿ͻ��˹���������������ȷ")
						assert_equal(@ts_tag_filter_use, wifi_status, "���߿ͻ��˹�������״̬����ȷ")

						#������߿ͻ��˹�������
						tc_mac  = "00:11:22:33:44:00"
						tc_desc = "00"
						i       = 3
						30.times do
								puts "��ӵ�#{i}��MAC��ַ����MAC��ַΪ#{tc_mac}".encode("GBK")
								@advance_iframe.span(id: @ts_tag_additem).click
								@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac)
								@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(tc_desc)
								wifi_select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
								#����Ϊ��Ч
								unless wifi_select_list.selected?(@ts_tag_filter_use)
										wifi_select_list.select(/#{@ts_tag_filter_use}/)
								end
								#����mac��������
								@advance_iframe.button(id: @ts_tag_save_filter).click
								sleep @tc_filter_time
								tc_mac = tc_mac.succ
								tc_desc=tc_desc.succ
								i      +=1
						end
						tc_mac ="00:11:22:33:44:30"
						tc_desc="30"
						puts "��ӵ�33��MAC��ַ����,MAC��ַΪ#{tc_mac}".encode("GBK")
						@advance_iframe.span(id: @ts_tag_additem).click
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac)
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(tc_desc)
						wifi_select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#����Ϊ��Ч
						unless wifi_select_list.selected?(@ts_tag_filter_use)
								wifi_select_list.select(/#{@ts_tag_filter_use}/)
						end
						#����mac��������
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "��ʾMAC��ַ��ʽ����")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "��ʾ���ݴ���")

						puts "PC1 TCP server connect"
						wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wired_client.tcp_state, "����PC1 #{@ts_pc_mac}��PC1����TCP���ӳɹ�")
						puts "PC2 TCP server connect"
						wireless_client = @wifi.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wireless_client.tcp_state, "����PC2 #{@tc_wifi_mac}��PC2����TCP���ӳɹ�")
				}

				operate("3������AP���鿴�豸���޶����õ��쳣����") {
						@browser.span(id: @ts_tag_reboot).click
						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "δ��ʾ����·����Ҫȷ��!"
						reboot_confirm.click
						sleep @tc_reboot_time
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, '��ת����¼ҳ��ʧ�ܣ�'
						login_no_default_ip(@browser) #���µ�¼
				}

				operate("4��PC1��PC2�ܷ����PC3��FTP����������Ƿ�ɹ���") {
						puts "PC1 TCP server connect"
						wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wired_client.tcp_state, "����PC1 #{@ts_pc_mac}��PC1����TCP���ӳɹ�")
						puts "PC2 TCP server connect"
						wireless_client = @wifi.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wireless_client.tcp_state, "����PC2 #{@tc_wifi_mac}��PC2����TCP���ӳɹ�")
				}

				operate("5���������ļ�����Ϊ�ļ�1�����и�λ�������ٽ������ļ�1�����豸����鵼���Ƿ���ȷ��PC1��PC2�ܷ����PC3��FTP����������Ƿ�ɹ���") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ��ϵͳ���á�
						sysset      = @advance_iframe.link(id: @ts_tag_op_system)
						sysset_name = sysset.class_name
						unless sysset_name == @ts_tag_select_state
								sysset.click
								sleep @tc_wait_time
						end

						#ѡ�񡰻ָ��������á���ǩ
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time

						#�жϵ�ǰ����Ŀ¼�Ƿ��������ļ������������������
						config_file_old = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
						unless config_file_old.nil?
								puts "ɾ���ɵ������ļ�:#{config_file_old}".encode("GBK")
								File.delete(config_file_old)
						end

						#���������ļ�
						@advance_iframe.button(id: @ts_tag_export).click
						sleep @tc_download_conf_time
						config_download = Dir.glob(@ts_download_directory+"/*").any? { |file| file=~/#{@tc_file_name}$/ }
						assert(config_download, "MAC���������ļ�����ʧ�ܣ�")
				}

				operate("6�����������ļ���ָ�·����Ϊ��������") {
						#������ָ��������á���ť
						@advance_iframe.button(id: @ts_tag_reset_factory).click
						sleep @tc_wait_time
						reset_confirm_tip = @advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reset_text)
						assert reset_confirm_tip.visible?, "δ�����ָ�������ʾ!"
						#ȷ�ϻָ�����ֵ
						reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						reset_confirm.click
						sleep @tc_wait_time
						puts "Waitfing for system reboot...."
						sleep @tc_reboot_time #����������Ͽ����������������ʹ��sleep���ȴ�����������Watir::Wait���ȴ�
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "�ָ��������ú�δ��ת��·������¼ҳ��!"
				}

				operate("7���ָ��������ú����µ�¼,�鿴MAC���˹����Ƿ�ɾ��") {
						login_no_default_ip(@browser) #���µ�¼
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ��ȫ����
						security_set = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#��MAC��������
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end

						fwstatus = @advance_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_close, fwstatus, "�ָ��������ú����ǽ��δ�ر�")
						mac_status = @advance_iframe.span(id: @ts_tag_fwmac).text
						assert_equal(@ts_tag_fw_close, mac_status, "�ָ��������ú�MAC���˿���δ�ر�")

						#�鿴���߿ͻ���mac���������Ƿ�ɹ�
						#������ֻ��һ�б�����tr���ʾ���й���ɾ��
						table_tr = @advance_iframe.table(class_name: @tc_tag_table).trs.size
						assert_equal(1, table_tr, "�ָ��������ú�MAC���˹���δɾ��")
				}

				operate("8�����������ļ�") {
						#ѡ��ϵͳ���á�
						sysset = @advance_iframe.link(id: @ts_tag_op_system).class_name
						unless sysset == @ts_tag_select_state
								@advance_iframe.link(id: @ts_tag_op_system).click
								sleep @tc_wait_time
						end

						#ѡ�񡰻ָ��������á���ǩ
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time
						config_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
						#����Ҳ��������ļ�
						refute(config_file.nil?, "�����ļ�����")
						#���������ļ�
						@advance_iframe.file_field(id: @tc_tag_inport).set(config_file)
						sleep @tc_wait_time
						@advance_iframe.button(id: @tc_tag_update_btn).click

						#�ȴ����õ������
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #����������Ͽ����������������ʹ��sleep���ȴ�����������Watir::Wait���ȴ�
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "��ת����¼ҳ��ʧ��!"

						#���µ�¼·����
						login_no_default_ip(@browser)
				}

				operate("9�����������ļ���PC1��PC2���������Ƿ�ɹ���") {
						puts "PC1 TCP server connect"
						wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wired_client.tcp_state, "����PC1 #{@ts_pc_mac}��PC1����TCP���ӳɹ�")
						puts "PC2 TCP server connect"
						wireless_client = @wifi.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wireless_client.tcp_state, "����PC2 #{@tc_wifi_mac}��PC2����TCP���ӳɹ�")
				}

				operate("10 ���������ļ���鿴����ǽ���غ�MAC���������Ƿ�����") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ��ȫ����
						security_set = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#��MAC��������
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end
						fwstatus = @advance_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fwstatus, "�������ú����ǽ�ܿ��ر��ر�")
						mac_status = @advance_iframe.span(id: @ts_tag_fwmac).text
						assert_equal(@ts_tag_fw_open, mac_status, "�������ú�MAC���˿��ر��ر�")

						#�鿴���߿ͻ���mac���������Ƿ�ɹ�
						puts "�������ú��ѯ��1��MAC #{@ts_pc_mac}����".encode("GBK")
						mac_filter_item = @advance_iframe.td(text: @ts_pc_mac).parent
						desc            = mac_filter_item[1].text
						status          = mac_filter_item[2].text
						assert(mac_filter_item.exists?, "�������ú�MAC #{@ts_pc_mac}��������������")
						assert_equal(@ts_nicname, desc, "�������ú�MAC #{@ts_pc_mac}����������������ȷ")
						assert_equal(@ts_tag_filter_use, status, "�������ú�MAC #{@ts_pc_mac}��������״̬����ȷ")
						#�鿴���߿ͻ���mac���������Ƿ�ɹ�
						puts "�������ú��ѯ��2��MAC #{@tc_wifi_mac}����".encode("GBK")
						wifi_mac_filter_item = @advance_iframe.td(text: @tc_wifi_mac).parent
						wifi_desc            = wifi_mac_filter_item[1].text
						wifi_status          = wifi_mac_filter_item[2].text
						assert(wifi_mac_filter_item.exists?, "�������ú����߿ͻ��˹�������������")
						assert_equal(@ts_wlan_nicname, wifi_desc, "�������ú����߿ͻ��˹���������������ȷ")
						assert_equal(@ts_tag_filter_use, wifi_status, "�������ú����߿ͻ��˹�������״̬����ȷ")

						#������߿ͻ��˹�������
						tc_mac  = "00:11:22:33:44:00"
						tc_desc = "00"
						i       = 3
						30.times do
								puts "�������ú��ѯ��#{i}��MAC #{tc_mac}����".encode("GBK")
								mac_filter_item = @advance_iframe.td(text: tc_mac).parent
								desc            = mac_filter_item[1].text
								status          = mac_filter_item[2].text
								assert(mac_filter_item.exists?, "�������ú�MAC#{tc_mac}��������������")
								assert_equal(tc_desc, desc, "�������ú�MAC#{tc_mac}��������ȷ")
								assert_equal(@ts_tag_filter_use, status, "�������ú�MAC#{tc_mac}״̬����ȷ")
								tc_mac = tc_mac.succ
								tc_desc= tc_desc.succ
								i      +=1
						end
				}

		end

		def clearup

				operate("1���ָ�����ǽĬ������") {
						@wifi.netsh_disc_all #�Ͽ�wifi����
						unless @browser.link(id: @ts_tag_options).exists?
								login_recover(@browser, @ts_default_ip)
						end
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						#ѡ��ȫ����
						security_set    = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#ѡ�����ǽ����
						fwset      = @advance_iframe.link(id: @ts_tag_fwset)
						fwset_state= fwset.parent.class_name
						unless fwset_state==@ts_tag_liclass
								fwset.click
						end

						#�ر��ܿ���
						fw_switch = @advance_iframe.button(id: @ts_tag_security_sw, class_name: @ts_tag_btn_on)
						if fw_switch.exists?
								fw_switch.click
						end

						#�ر�mac���˿���
						mac_switch = @advance_iframe.button(id: @ts_tag_security_mac, class_name: @ts_tag_btn_on)
						if mac_switch.exists?
								mac_switch.click
						end

						#����
						@advance_iframe.button(id: @ts_tag_security_save).click
						sleep @tc_filter_time

						#��mac��������
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end

						#ɾ�����й��˹���
						@advance_iframe.span(id: @ts_tag_alldel).click
						sleep @tc_filter_time
				}
		end

}
