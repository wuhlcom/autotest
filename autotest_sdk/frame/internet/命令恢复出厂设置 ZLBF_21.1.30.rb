#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.30", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time      = 3
				@tc_net_time       = 60
				@tc_ralink_time    = 120
				@tc_static_ip      = "10.10.10.54"
				@tc_static_mask    = "255.255.255.0"
				@tc_static_gateway = "10.10.10.1"
				@tc_static_dns     = "10.10.10.1"
				@tc_lan_ip         = "192.168.90.1"
				@tc_lan_start      = "192.168.90.50"
				@tc_lan_end        = "192.168.90.100"
				@tc_static_backdns = "8.8.8.8"
				@tc_wifi_ssid      = "wifi_llp"
				@tc_wifi_safe      = "None"
				@tc_clear_config   = "ralink_init clear 2860;\nralink_init renew 2860 /etc_ro/Wireless/RT2860AP/RT2860_default_vlan\n"
				# @tc_init_config    = "ralink_init renew 2860 /etc_ro/Wireless/RT2860AP/RT2860_default_vlan"
				@flag              = false
				# @lanip_changeflag  = false
				@dut_ip            = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
		end

		def process

				operate("1����¼DUT����ҳ�棻") {
						#�Ȼָ��������ã��鿴Ĭ��ֵ
						telnet_init(@default_url, @ts_default_usr, @ts_default_pw)
						exp_ralink_init(@tc_clear_config)
						sleep @tc_ralink_time
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_default(@browser) #���µ�¼
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe    = @browser.iframe(src: @ts_tag_status_iframe_src)
						@wan_default_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text #Ĭ�Ͻ��뷽ʽ
						p "Ĭ�Ͻ��뷽ʽ�ǣ�#{@wan_default_type}".to_gbk
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "����������ʧ�ܣ�")
						@lan_ip_default    = @lan_iframe.text_field(id: @ts_tag_lanip).value
						@lan_start_default = @lan_iframe.text_field(id: @ts_tag_lanstart).value
						@lan_end_default   = @lan_iframe.text_field(id: @ts_tag_lanend).value
						@lan_ssid_default  = @lan_iframe.text_field(id: @ts_tag_ssid).value
						p "Ĭ������IP��#{@lan_ip_default}".to_gbk
						p "Ĭ�Ͽ�ʼ��ַ�أ�#{@lan_start_default}".to_gbk
						p "Ĭ�Ͻ�����ַ�أ�#{@lan_end_default}".to_gbk
						p "Ĭ��ssid��#{@lan_ssid_default}".to_gbk
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						@fire_wall_default = @option_iframe.button(id: @ts_tag_security_sw).class_name
						@ip_btn_default    = @option_iframe.button(id: @ts_tag_security_ip).class_name
						p "Ĭ�Ϸ���ǽ����״̬��#{@fire_wall_default}".to_gbk
						p "Ĭ��IP���˿���״̬��#{@ip_btn_default}".to_gbk
						@option_iframe.link(id: @ts_tag_application).click #Ӧ������
						vir_btn = @option_iframe.button(id: @ts_tag_virtualsrv_sw) #���������
						vir_btn.wait_until_present(@tc_wait_time)
						@vir_btn_default = vir_btn.class_name
						p "Ĭ���������������״̬��#{@ip_btn_default}".to_gbk
						@option_iframe.link(id: @ts_tag_dmz).click #DMZ
						dmz_btn = @option_iframe.button(id: @ts_tag_dmzsw)
						dmz_btn.wait_until_present(@tc_wait_time)
						@dmz_btn_default = dmz_btn.class_name
						p "Ĭ��DMZ����״̬��#{@ip_btn_default}".to_gbk
						@option_iframe.link(id: @ts_tag_ddns).click #ddns
						ddns_btn = @option_iframe.button(id: @ts_tag_ddns_sw)
						ddns_btn.wait_until_present(@tc_wait_time)
						@ddns_btn_default = ddns_btn.class_name
						p "Ĭ��DDNS����״̬��#{@ip_btn_default}".to_gbk
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2������WAN����Ϊ��̬IP��ַ��ʽ���޸�LAN��IP��ַ���޸ĵ�ַ�ط�Χ���޸�����SSID���޸����߰�ȫ���޸����߸߼���������Ӷ˿�ת�����򡢶˿ڴ����������URL���˹���IP��˿ڹ��˹��򡢿���UPNP���ܡ�����DMZ���ܡ�����DDNS���ܡ��޸ĵ�¼�����ҳ�����п����õ�ѡ�") {
						p "����WAN����Ϊ��̬IP��ַ��ʽ".to_gbk
						@browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "������ʧ�ܣ�")
						rs1 = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						rs1.wait_until_present(@tc_wait_time)
						unless rs1.class_name =~/ #{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						static_radio       = @wan_iframe.radio(id: @ts_tag_wired_static) #ѡ���ֶ���ʽ����
						static_radio_state = static_radio.checked?
						unless static_radio_state
								static_radio.click
						end
						@wan_iframe.text_field(id: @ts_tag_staticIp).wait_until_present(@tc_wait_time)
						@wan_iframe.text_field(id: @ts_tag_staticIp).set(@tc_static_ip)
						@wan_iframe.text_field(id: @ts_tag_staticNetmask).set(@tc_static_mask)
						@wan_iframe.text_field(id: @ts_tag_staticGateway).set(@tc_static_gateway)
						@wan_iframe.text_field(id: @ts_tag_staticPriDns).set(@tc_static_dns)
						if @wan_iframe.text_field(id: @ts_tag_backupDns).exists?
								@wan_iframe.text_field(id: @ts_tag_backupDns).set(@tc_static_backdns)
						end
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						p "�޸�LAN��IP��ַ���޸ĵ�ַ�ط�Χ���޸�����SSID".to_gbk
						@browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "����������ʧ�ܣ�")
						# @lan_iframe.text_field(id: @ts_tag_lanip).set(@tc_lan_ip)
						# @lan_iframe.text_field(id: @ts_tag_lanstart).set(@tc_lan_start)
						# @lan_iframe.text_field(id: @ts_tag_lanend).set(@tc_lan_end)
						@lan_iframe.text_field(id: @ts_tag_ssid).set(@tc_wifi_ssid)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
						# @lanip_changeflag = true
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_default(@browser, @tc_lan_ip) #���µ�¼
						end
						p "�޸�����������".to_gbk
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						#��ȫ����
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						#�򿪷���ǽ�ܿ���
						fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
						fire_wall_btn.click
						#��IP����
						ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
						ip_btn.click
						@option_iframe.button(id: @ts_tag_security_save).click #����
						sleep @tc_wait_time

						#��Ӧ������
						@option_iframe.link(id: @ts_tag_application).click #Ӧ������
						vir_btn = @option_iframe.button(id: @ts_tag_virtualsrv_sw)
						vir_btn.wait_until_present(@tc_wait_time)
						vir_btn.click
						@option_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time
						#����DMZ
						@option_iframe.link(id: @ts_tag_dmz).click #DMZ
						dmz_btn = @option_iframe.button(id: @ts_tag_dmzsw)
						dmz_btn.wait_until_present(@tc_wait_time)
						dmz_btn.click
						@option_iframe.text_field(id: @ts_tag_dmzip).set(@dut_ip)
						@option_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						#����DDNS
						@option_iframe.link(id: @ts_tag_ddns).click #ddns
						ddns_btn = @option_iframe.button(id: @ts_tag_ddns_sw)
						ddns_btn.wait_until_present(@tc_wait_time)
						ddns_btn.click
						@option_iframe.text_field(id: @ts_tag_ddns_host).set(@dut_ip)
						@option_iframe.text_field(id: @ts_tag_ddns_user).set(@ts_default_usr)
						@option_iframe.text_field(id: @ts_tag_ddns_pwd).set(@ts_default_pw)
						@option_iframe.button(id: @ts_tag_ddns_save).click
						sleep @tc_wait_time
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("3��ʹ��������и�λ���鿴���õĲ����Ƿ�ȫ����λ�ɳ���Ĭ��״̬��") {
						telnet_init(@default_url, @ts_default_usr, @ts_default_pw)
						exp_ralink_init(@tc_clear_config)
						sleep @tc_ralink_time
						#��һ����־λ��������ִ�е���ʱ����ʾ�ű��ѽ����˻ָ��������ã���ʱ����clearup�лָ����������ˣ������ִ��clearup�����
						@flag = true
						p "�鿴�����Ƿ�ָ�".to_gbk
						login_default(@browser) #���µ�¼
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						@status_iframe.b(id: @ts_tag_wan_type).wait_until_present(@tc_wait_time)
						wan_type = @status_iframe.b(id: @ts_tag_wan_type).parent.text
						assert_equal(@wan_default_type, wan_type, '�������ʹ���δ�ָ�Ĭ�Ͻ��룡')
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "����������ʧ�ܣ�")
						# lan_ip    = @lan_iframe.text_field(id: @ts_tag_lanip).value
						# lan_start = @lan_iframe.text_field(id: @ts_tag_lanstart).value
						# lan_end   = @lan_iframe.text_field(id: @ts_tag_lanend).value
						lan_ssid = @lan_iframe.text_field(id: @ts_tag_ssid).value
						# assert_equal(@lan_ip_default, lan_ip, "����IPδ�ָ���Ĭ������")
						# assert_equal(@lan_start_default, lan_start, "����IPδ�ָ���Ĭ������")
						# assert_equal(@lan_end_default, lan_end, "����IPδ�ָ���Ĭ������")
						assert_equal(@lan_ssid_default, lan_ssid, "����IPδ�ָ���Ĭ������")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw).class_name
						ip_btn        = @option_iframe.button(id: @ts_tag_security_ip).class_name
						@option_iframe.link(id: @ts_tag_application).click #Ӧ������
						vir_btn = @option_iframe.button(id: @ts_tag_virtualsrv_sw) #���������
						vir_btn.wait_until_present(@tc_wait_time)
						vir_btn_value = vir_btn.class_name
						@option_iframe.link(id: @ts_tag_dmz).click #DMZ
						dmz_btn = @option_iframe.button(id: @ts_tag_dmzsw)
						dmz_btn.wait_until_present(@tc_wait_time)
						dmz_btn_value = dmz_btn.class_name
						@option_iframe.link(id: @ts_tag_ddns).click #ddns
						ddns_btn = @option_iframe.button(id: @ts_tag_ddns_sw)
						ddns_btn.wait_until_present(@tc_wait_time)
						ddns_btn_value = ddns_btn.class_name

						assert_equal(@fire_wall_default, fire_wall_btn, "����ǽ����δ�ָ���Ĭ��ֵ")
						assert_equal(@ip_btn_default, ip_btn, "IP���˿���δ�ָ���Ĭ��ֵ")
						assert_equal(@vir_btn_default, vir_btn_value, "�������������δ�ָ���Ĭ��ֵ")
						assert_equal(@dmz_btn_default, dmz_btn_value, "DMZ����δ�ָ���Ĭ��ֵ")
						assert_equal(@ddns_btn_default, ddns_btn_value, "DDNS����δ�ָ���Ĭ��ֵ")

				}


		end

		def clearup
				operate("�ָ�Ĭ�ϳ�������") {
						unless @flag
								# if @lanip_changeflag
								# 		lan_ip = @tc_lan_ip
								# else
								lan_ip = @default_url
								# end
								telnet_init(lan_ip, @ts_default_usr, @ts_default_pw)
								exp_ralink_init(@tc_clear_config)
								sleep @tc_ralink_time
						end
				}
		end

}
