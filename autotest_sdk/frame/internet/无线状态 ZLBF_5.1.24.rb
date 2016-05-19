#
#description:
# ������Ի���״̬�������ŵ�
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
		attr = {"id" => "ZLBF_5.1.24", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time          = 2
				@tc_status_time        = 5
				@tc_channelset_time    = 10
				@tc_channelchange_time = 30
				@tc_net_time           = 50
				@tc_tag_adsave_cont    = "aui_content"
				@tc_ssid1              = "zhilu_autossid1"
				@tc_ssid2              = "zhilu_autossid2"
				@tc_none_value         = "NONE"
				@tc_systatus_none      = "NONE"
				@ts_sec_mode_wpa       = 'WPA-PSK/WPA2-PSK'
				@tc_wpa_value          = "WPAPSKWPA2PSK"
				@tc_tag_checkbox       = "pwdshow"
				@tc_tag_on_off         = "WIRELESS-ONOFF"
				@tc_tag_on             = "On"
				@ts_tag_ssid_name      = "WIRELESS-SSID"
				@tc_tag_wifi_encryption= "WIRELESS-ENCRY"
				@tc_tag_wifi_channel   = "WIRELESS-CH"

				@tc_tag_wifiset           = "wifi_advance.asp"
				@tc_tag_liclass           = "active"
				@tc_tag_selected_status   = "selected"
				@tc_tag_wifi_channel_list = "sz11gChannel"
				@tc_channel_value         = "9"
				@tc_channel               = "2452MHz (Channel 9)"

		end

		def process

				operate("1 ��������������") {
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@ts_tag_lan_src}/i, @lan_iframe.src, "����������ʧ��!"
				}

				operate("2 �޸�WIFI�����뷽ʽΪ#{@ts_sec_mode_none}") {
						@tc_default_ssid = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						puts "��ǰ·�ɵ�SSIDΪ:#{@tc_default_ssid}".to_gbk
						puts "�޸�SSIDΪ��#{@tc_ssid1}".to_gbk
						ssid_obj = @lan_iframe.text_field(:id, @ts_tag_ssid)
						ssid_obj.set(@tc_ssid1)
						puts "�޸ļ��ܷ�ʽΪ��#{@ts_sec_mode_none}".to_gbk
						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_none)
								select.select(@ts_sec_mode_none)
						end
						@lan_iframe.button(:id, @ts_tag_sbm).click
						puts "sleep #{@tc_net_time} seconds for net reseting..."
						sleep @tc_net_time
				}

				operate("3 �޸ļ��ܷ�ʽΪ#{@ts_sec_mode_none}��鿴��������״̬") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_status_time, "����״̬����δ����") {
								@systatus_iframe = @browser.iframe(:src, @ts_tag_status_iframe_src)
								@systatus_iframe.present?
						}

						wifi_on_off = @systatus_iframe.b(:id => @tc_tag_on_off).parent.text
						wifi_on_off =~ /(#{@tc_tag_on})$/
						puts "״̬ҳ����ʾ����״̬Ϊ��#{Regexp.last_match(1)}".to_gbk

						wifi_ssid = @systatus_iframe.b(:id => @ts_tag_ssid_name).parent.text
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

				operate("4 �޸�WIFI�����뷽ʽΪ#{@ts_sec_mode_wpa}") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						#��lan����
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						puts "�޸�SSIDΪ��#{@tc_ssid2}".to_gbk
						ssid_obj= @lan_iframe.text_field(:id, @ts_tag_ssid)
						ssid_obj.set(@tc_ssid2)

						puts "�޸ļ��ܷ�ʽΪ��#{@ts_sec_mode_wpa}".to_gbk
						select       = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						passwd_input =@lan_iframe.text_field(id: @ts_tag_ssid_pwd)
						unless select.selected?(@ts_sec_mode_wpa)
								select.select(@ts_sec_mode_wpa)
								passwd_input.set(@ts_default_wlan_pw)
						end
						@lan_iframe.button(:id, @ts_tag_sbm).click
						puts "sleep #{@tc_net_time} seconds for net reseting..."
						sleep @tc_net_time
				}

				operate("5  �޸��ŵ�") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.refresh #����ˢ��
						sleep @tc_wait_time
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_status_time, "�߼����ý���δ��") {
								@browser.iframe(:src, @ts_tag_advance_src).present?
						}
						@advance_iframe = @browser.iframe(:src, @ts_tag_advance_src)
						#ѡ����������
						networking      = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@tc_tag_selected_status
								networking.click
						end
						#ѡ����������
						wifiset             = @advance_iframe.link(href: @tc_tag_wifiset)
						wifiset_parent_class=wifiset.parent.class_name
						unless wifiset_parent_class==@tc_tag_liclass
								wifiset.click
						end
						#
						channel_select      = @advance_iframe.select_list(id: @tc_tag_wifi_channel_list)
						@tc_default_channel = channel_select.selected_options[0].text
						unless channel_select.selected?(@tc_channel)
								channel_select.select(@tc_channel)
								sleep 1
								@advance_iframe.button(id: @ts_tag_sbm).click
								puts "change channel to #{@tc_channel} "

								Watir::Wait.while(@tc_channelset_time, "�ȴ�����������ʾ��ʧ".to_gbk) {
										advance_save_cont = @advance_iframe.div(class_name: @tc_tag_adsave_cont)
										advance_save_cont.present?
								}
								#�ȴ���һ���޸��ŵ�������Ч
								puts "waiting for channel changed..."
								sleep @tc_channelchange_time
						end
				}

				operate("6 �޸ļ��ܷ�ʽΪ#{@ts_sec_mode_wpa}��鿴��������״̬") {
						#�ҵ�����Ŀ¼ҳ���DIV
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#�ҵ�������DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#���ع���Ŀ¼ҳ���DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#���ر�����DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)
						@browser.refresh #����ˢ��
						sleep @tc_wait_time
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_status_time, "����״̬����δ����") {
								@browser.iframe(:src, @ts_tag_status_iframe_src).present?
						}
						@systatus_iframe = @browser.iframe(:src, @ts_tag_status_iframe_src)
						wifi_on_off      = @systatus_iframe.b(:id => @tc_tag_on_off).parent.text
						wifi_on_off =~ /(#{@tc_tag_on})$/
						puts "״̬ҳ����ʾ����״̬Ϊ��#{Regexp.last_match(1)}".to_gbk

						wifi_ssid = @systatus_iframe.b(:id => @ts_tag_ssid_name).parent.text
						wifi_ssid =~ /(#{@tc_ssid2})$/
						puts "״̬ҳ����ʾ����SSIDΪ��#{Regexp.last_match(1)}".to_gbk

						wifi_encryption = @systatus_iframe.b(:id => @tc_tag_wifi_encryption).parent.text
						wifi_encryption =~ /(#{@ts_sec_mode_wpa}$)/
						puts "״̬ҳ����ʾ���߼��ܷ�ʽΪ��#{Regexp.last_match(1)}".to_gbk

						wifi_channel = @systatus_iframe.b(:id => @tc_tag_wifi_channel).parent.text
						wifi_channel =~ /(\d{1,2}$)/
						puts "״̬ҳ����ʾ�����ŵ�Ϊ��#{Regexp.last_match(1)}".to_gbk

						wifi_on_off     = @systatus_iframe.b(:id => @tc_tag_on_off).parent.text
						wifi_ssid       = @systatus_iframe.b(:id => @ts_tag_ssid_name).parent.text
						wifi_encryption = @systatus_iframe.b(:id => @tc_tag_wifi_encryption).parent.text
						wifi_channel    = @systatus_iframe.b(:id => @tc_tag_wifi_channel).parent.text

						assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI״̬����ȷ!")
						assert_match(/#{@tc_ssid2}$/, wifi_ssid, "SSID��ʾ����ȷ")
						assert_match(/#{@ts_sec_mode_wpa}$/, wifi_encryption, "���ܷ�ʽ��ʾ����")
						assert_match(/#{@tc_channel_value}$/, wifi_channel, "�ŵ���ʾ����")
				}

		end

		def clearup

				operate("1 �ָ�Ĭ�ϼ��ܷ�ʽ��Ĭ��SSID") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_lan).exists?
								login_recover(@browser, @ts_default_ip)
						end

						#��lan����
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						ssid_obj    = @lan_iframe.text_field(:id, @ts_tag_ssid)
						ssid_value  = ssid_obj.value
						puts "��ǰSSIDΪ#{ssid_value}".to_gbk
						flag = false
						if !@tc_default_ssid.nil? &&(ssid_value!=@tc_default_ssid)
								unless ssid_value==@tc_default_ssid
										puts "�޸�SSIDΪĬ��SSID��#{@tc_default_ssid}".to_gbk
										flag=true
										@lan_iframe.text_field(:id, @ts_tag_ssid).set(@tc_default_ssid)
								end
						end

						unless @lan_iframe.select_list(id: @ts_tag_sec_select_list).selected?(@ts_sec_mode_wpa)
								puts "�޸ļ��ܷ�ʽΪĬ�ϼ��ܷ�ʽ��#{@ts_sec_mode_wpa}".to_gbk
								flag=true
								@lan_iframe.select_list(id: @ts_tag_sec_select_list).select(@ts_sec_mode_wpa)
								@lan_iframe.text_field(id: @ts_tag_ssid_pwd).set(@ts_default_wlan_pw)
						end

						if flag
								@lan_iframe.button(:id, @ts_tag_sbm).click
								puts "sleep #{@tc_net_time} second for net reseting..."
								sleep @tc_net_time
						end
				}

				operate("2 �ָ�Ĭ���ŵ�") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@tc_tag_selected_status
								networking.click
						end
						wifiset             = @advance_iframe.link(href: @tc_tag_wifiset)
						wifiset_parent_class=wifiset.parent.class_name
						unless wifiset_parent_class==@tc_tag_liclass
								wifiset.click
						end
						channel_select = @advance_iframe.select_list(id: @tc_tag_wifi_channel_list)
						unless @tc_default_channel.nil?
								unless channel_select.selected?(@tc_default_channel)
										puts "�ָ�ΪĬ���ŵ���#{@tc_default_channel}".to_gbk
										channel_select.select(@tc_default_channel)
										sleep 1
										@advance_iframe.button(id: @ts_tag_sbm).click
										puts "sleep #{@tc_net_time+20} seconds for net reseting..."
								end
						end
				}
		end

}
