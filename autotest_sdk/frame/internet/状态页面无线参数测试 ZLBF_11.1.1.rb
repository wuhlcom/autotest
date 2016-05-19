#
#description:
## ������Ե�����ϸ״̬
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.1", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time         = 2
				@tc_channelset_time   = 20
				@tc_wait_net_reset    = 60
				@tc_tag_net_reset_tip = "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_adsave_tip    = "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_reset_tip     = "aui_content"
				@tc_tag_adsave_cont   = "aui_content"
				@tc_default_ssid      = "WIFI_"+@ts_sub_mac
				puts "Default SSID:#{@tc_default_ssid}"
				@tc_ssid1              = "123456789_zhilu"
				@tc_ssid2              = "a"
				@tc_tag_lan            = "set_wifi"
				@tc_tag_lan_iframe_src = "lanset.asp"

				@tc_tag_ssid         = "ssid"
				@tc_tag_select_list  = "security_mode"
				#@tc_sec_mode_none    = '�޼���'#.encode("UTF-8") #�°汾����ʹ�á��޼��ܡ�������
				@tc_sec_mode_none    = "None"
				@tc_none_value       = "NONE"
				@tc_systatus_none    = "NONE"
				@tc_sec_mode_wpa     = 'WPA-PSK/WPA2-PSK'
				@tc_wpa_value        = "WPAPSKWPA2PSK"
				@tc_tag_checkbox     = "pwdshow"
				@tc_tag_input_pw     = "input_password1"
				@tc_default_pw       = "12345678"
				@tc_tag_systatus     = "systatus"
				@tc_tag_systatus_src = "systatus.asp"

				@tc_tag_on_off         = "WIRELESS-ONOFF"
				@tc_tag_on             = "On"
				@tc_tag_ssid_name      = "WIRELESS-SSID"
				@tc_tag_wifi_encryption= "WIRELESS-ENCRY"
				@tc_tag_wifi_channel   = "WIRELESS-CH"

				@tc_tag_options           = "options"
				@tc_tag_advance_src       = "advance.asp"
				@tc_tag_network           = "networksetting"
				@tc_tag_wifiset           = "wifi_advance.asp"
				@tc_tag_liclass           = "active"
				@tc_tag_selected_status   = "selected"
				@tc_tag_wifi_channel_list = "sz11gChannel"
				@tc_channel_value         = "1"
				@tc_channel               = "2412MHz (Channel 1)"
				@tc_default_channel_value = "Auto"
				@tc_default_channel       = "�Զ�ѡ��"

		end

		def process

				operate("1 ��������������") {
						@browser.span(:id => @tc_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@tc_tag_lan_iframe_src}/i, @lan_iframe.src, "����������ʧ��!"
				}

				operate("2 �޸�WIFI�����뷽ʽΪ#{@tc_sec_mode_none}") {
						puts "�޸�SSIDΪ��#{@tc_ssid1}".to_gbk
						ssid_obj = @lan_iframe.text_field(:id, @tc_tag_ssid)
						ssid_obj.set(@tc_ssid1)
						puts "�޸ļ��ܷ�ʽΪ��#{@tc_sec_mode_none}".to_gbk
						select = @lan_iframe.select_list(id: @tc_tag_select_list)
						unless select.selected?(@tc_sec_mode_none)
								select.select(@tc_sec_mode_none)
						end
						@lan_iframe.button(:id, @ts_tag_sbm).click
						puts "Waiting for net reseting..."
						sleep @tc_wait_net_reset
				}


				operate("3 �޸ļ��ܷ�ʽΪ#{@tc_sec_mode_none}��鿴ϵͳ��ϸ״̬") {
						if @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(:id => @tc_tag_systatus).wait_until_present(@tc_wait_time)
						@browser.link(:id => @tc_tag_systatus).click
						Watir::Wait.until(@tc_wait_time, "ϵͳ״̬����δ����") {
								@systatus_iframe = @browser.iframe(:src, @tc_tag_systatus_src)
								@systatus_iframe.present?
						}
						wifi_on_off = @systatus_iframe.b(:id => @tc_tag_on_off).parent.text
						wifi_on_off =~ /(#{@tc_tag_on})$/
						puts "״̬ҳ����ʾ����״̬Ϊ��#{Regexp.last_match(1)}".to_gbk
						wifi_ssid = @systatus_iframe.b(:id => @tc_tag_ssid_name).parent.text
						wifi_ssid =~ /(#{@tc_ssid1})$/
						puts "״̬ҳ����ʾ����SSIDΪ��#{Regexp.last_match(1)}".to_gbk

						wifi_encryption = @systatus_iframe.b(:id => @tc_tag_wifi_encryption).parent.text
						wifi_encryption =~ /(#{@tc_none_value}$)/
						puts "״̬ҳ����ʾ���߼��ܷ�ʽΪ��#{Regexp.last_match(1)}".to_gbk

						wifi_channel = @systatus_iframe.b(:id => @tc_tag_wifi_channel).parent.text
						wifi_channel =~ /(\d{1,2}$)/
						puts "״̬ҳ����ʾ�����ŵ�Ϊ��#{Regexp.last_match(1)}".to_gbk

						assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI״̬����ȷ!")
						assert_match(/#{@tc_ssid1}$/, wifi_ssid, "SSID��ʾ����ȷ")
						assert_match(/#{@tc_none_value}$/, wifi_encryption, "���ܷ�ʽ��ʾ����")
						assert_match(/\d{1,2}$/, wifi_channel, "�ŵ���ʾ����")
				}

				operate("4 �޸�WIFI�����뷽ʽΪ#{@tc_sec_mode_wpa}") {
						if @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						#��lan����
						@browser.span(:id => @tc_tag_lan).click
						@lan_iframe = @browser.iframe
						puts "�޸�SSIDΪ��#{@tc_ssid2}".to_gbk
						ssid_obj= @lan_iframe.text_field(:id, @tc_tag_ssid)
						ssid_obj.set(@tc_ssid2)
						puts "�޸ļ��ܷ�ʽΪ��#{@tc_sec_mode_wpa}".to_gbk
						select       = @lan_iframe.select_list(id: @tc_tag_select_list)
						passwd_input =@lan_iframe.text_field(id: @tc_tag_input_pw)
						unless select.selected?(@tc_sec_mode_wpa)
								select.select(@tc_sec_mode_wpa)
								passwd_input.set(@ts_default_wlan_pw)
						end
						@lan_iframe.button(:id, @ts_tag_sbm).click
						puts "Waiting for net reseting..."
						sleep @tc_wait_net_reset
				}

				operate("5  �޸��ŵ�") {
						@browser.link(id: @tc_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @tc_tag_options).click
						Watir::Wait.until(@tc_wait_time, "�߼����ý���δ��") {
								@advance_iframe = @browser.iframe(:src, @tc_tag_advance_src)
								@advance_iframe.present?
						}
						networking = @advance_iframe.link(id: @tc_tag_network)
						unless networking.class_name==@tc_tag_selected_status
								networking.click
						end
						wifiset             = @advance_iframe.link(href: @tc_tag_wifiset)
						wifiset_parent_class=wifiset.parent.class_name
						unless wifiset_parent_class==@tc_tag_liclass
								wifiset.click
						end
						channel_select = @advance_iframe.select_list(id: @tc_tag_wifi_channel_list)
						unless channel_select.selected?(@tc_channel)
								channel_select.select(@tc_channel)
								sleep 1
								@advance_iframe.button(id: @ts_tag_sbm).click

								Watir::Wait.while(@tc_channelset_time, "�ȴ�����������ʾ��ʧ".to_gbk) {
										advance_save_cont = @advance_iframe.div(class_name: @tc_tag_adsave_cont)
										advance_save_cont.present?
								}
						end
				}

				operate("6 �޸ļ��ܷ�ʽΪ#{@tc_sec_mode_wpa}��鿴ϵͳ��ϸ״̬") {
						if @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(:id => @tc_tag_systatus).wait_until_present(@tc_wait_time)
						@browser.link(:id => @tc_tag_systatus).click
						Watir::Wait.until(@tc_wait_time, "ϵͳ״̬����δ����") {
								@systatus_iframe = @browser.iframe(:src, @tc_tag_systatus_src)
								@systatus_iframe.present?
						}

						wifi_on_off = @systatus_iframe.b(:id => @tc_tag_on_off).parent.text
						wifi_on_off =~ /(#{@tc_tag_on})$/
						puts "״̬ҳ����ʾ����״̬Ϊ��#{Regexp.last_match(1)}".to_gbk

						wifi_ssid = @systatus_iframe.b(:id => @tc_tag_ssid_name).parent.text
						wifi_ssid =~ /(#{@tc_ssid2})$/
						puts "״̬ҳ����ʾ����SSIDΪ��#{Regexp.last_match(1)}".to_gbk

						wifi_encryption = @systatus_iframe.b(:id => @tc_tag_wifi_encryption).parent.text
						wifi_encryption =~ /(#{@tc_sec_mode_wpa}$)/
						puts "״̬ҳ����ʾ���߼��ܷ�ʽΪ��#{Regexp.last_match(1)}".to_gbk

						wifi_channel = @systatus_iframe.b(:id => @tc_tag_wifi_channel).parent.text
						wifi_channel =~ /(@tc_channel_value$)/
						puts "״̬ҳ����ʾ�����ŵ�Ϊ��#{Regexp.last_match(1)}".to_gbk

						wifi_on_off     = @systatus_iframe.b(:id => @tc_tag_on_off).parent.text
						wifi_ssid       = @systatus_iframe.b(:id => @tc_tag_ssid_name).parent.text
						wifi_encryption = @systatus_iframe.b(:id => @tc_tag_wifi_encryption).parent.text
						wifi_channel    = @systatus_iframe.b(:id => @tc_tag_wifi_channel).parent.text

						assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI״̬����ȷ!")
						assert_match(/#{@tc_ssid2}$/, wifi_ssid, "SSID��ʾ����ȷ")
						assert_match(/#{@tc_sec_mode_wpa}$/, wifi_encryption, "���ܷ�ʽ��ʾ����")
						assert_match(/#{@tc_channel_value}$/, wifi_channel, "�ŵ���ʾ����")
				}

		end

		def clearup

				operate("�ָ�Ĭ�ϼ��ܷ�ʽ��Ĭ��SSID") {
						if @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @tc_tag_lan).exists?
								login_recover(@browser, @ts_default_ip)
						end
						#��lan����
						@browser.span(:id => @tc_tag_lan).click
						@lan_iframe  = @browser.iframe
						ssid_obj     = @lan_iframe.text_field(:id, @tc_tag_ssid)
						select       = @lan_iframe.select_list(id: @tc_tag_select_list)
						passwd_input = @lan_iframe.text_field(id: @tc_tag_input_pw)
						ssid_value   = ssid_obj.value
						flag         = false

						if (ssid_value!=@tc_default_ssid) || !select.selected?(@tc_sec_mode_wpa)
								unless ssid_value==@tc_default_ssid
										puts "�޸�SSIDΪĬ��SSID��#{@tc_default_ssid}".to_gbk
										flag=true
										ssid_obj.set(@tc_default_ssid)
								end
								unless select.selected?(@tc_sec_mode_wpa)
										puts "�޸ļ��ܷ�ʽΪĬ�ϼ��ܷ�ʽ��#{@tc_sec_mode_wpa}".to_gbk
										flag=true
										select.select(@tc_sec_mode_wpa)
										passwd_input.set(@ts_default_wlan_pw)
								end
						end

						if flag
								@lan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reseting..."
								sleep @tc_wait_net_reset
						end
				}

				operate("�ָ�Ĭ���ŵ�Ϊ�Զ��ŵ�") {
						if @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.link(id: @tc_tag_options).wait_until_present(@tc_wait_time)
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @tc_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @tc_tag_options).click
						Watir::Wait.until(@tc_wait_time, "�߼����ý���δ��") {
								@advance_iframe = @browser.iframe(:src, @tc_tag_advance_src)
								@advance_iframe.present?
						}
						networking = @advance_iframe.link(id: @tc_tag_network)
						unless networking.class_name==@tc_tag_selected_status
								networking.click
						end
						wifiset             = @advance_iframe.link(href: @tc_tag_wifiset)
						wifiset_parent_class=wifiset.parent.class_name
						unless wifiset_parent_class==@tc_tag_liclass
								wifiset.click
						end
						channel_select = @advance_iframe.select_list(id: @tc_tag_wifi_channel_list)
						unless channel_select.selected?(@tc_default_channel)
								puts "�ָ�ΪĬ���ŵ���#{@tc_default_channel}".to_gbk
								channel_select.select(@tc_default_channel)
								sleep 1
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_channelset_time
						end
				}

		end

}
