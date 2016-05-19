#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.21", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time         = 2
				@tc_wifi_flag         = "1"
				@tc_channelset_time   = 15
				@tc_channel_change    = 40
				@tc_wait_net_reset    = 40
				@tc_tag_net_reset_tip = "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_adsave_tip    = "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_reset_tip     = "aui_content"
				@tc_tag_adsave_cont   = "aui_content"

				@tc_default_ssid = "WIFI_"+@ts_sub_mac
				puts "Default SSID:#{@tc_default_ssid}"
				@tc_ssid                  = "zhilutest#{@ts_sub_mac}"
				@tc_wpa_value             = "WPAPSKWPA2PSK"
				@tc_tag_checkbox          = "pwdshow"
				@tc_tag_input_pw          = "input_password1"
				@tc_default_pw            = "12345678"
				@tc_tag_wifiset           = "wifi_advance.asp"
				@tc_tag_liclass           = "active"
				@tc_tag_selected_status   = "selected"
				@tc_tag_wifi_channel_list = "sz11gChannel"
				@tc_channel_value_arr     =[]
				@tc_channel_arr           =[]
				"1".upto("13") do |channel|
						frequance        = (2407+5*channel.to_i)
						frequance_channel="#{frequance}MHz (Channel #{channel})"
						@tc_channel_value_arr<<channel
						@tc_channel_arr<<frequance_channel
				end
				print "�ŵ��б�:\n#{@tc_channel_arr.join("\n")}\n".to_gbk
				@tc_default_channel_value = "Auto"
				@tc_default_channel       = "�Զ�ѡ��"

		end

		def process

				operate("1 ��������������") {
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@ts_tag_lan_src}/i, @lan_iframe.src, "����������ʧ��!"
				}

				operate("2 �޸�WIFI SSID") {
						puts "�޸�SSIDΪ��#{@tc_ssid}".to_gbk
						ssid_obj = @lan_iframe.text_field(:id, @ts_tag_ssid)
						ssid_obj.set(@tc_ssid)

						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "�ָ�Ĭ�ϵļ����뷽ʽ��#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @tc_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
						end
						@lan_iframe.button(:id, @ts_tag_sbm).click
						#��������Ч
						puts "Waiting for wifi config changed..."
						sleep @tc_wait_net_reset
						@passwd_input = @lan_iframe.text_field(id: @tc_tag_input_pw)
						@current_pw   = @passwd_input.value
						puts "wifi passwd:#{@current_pw}"
				}

				operate("3 ������������·����") {
						rs    = @wifi.connect(@tc_ssid, @tc_wifi_flag, @current_pw)
						assert rs, "WIFI����ʧ��"
						sleep 10 #�ȴ����������ȶ�
				}

				operate("4  �޸��ŵ�") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_wait_time, "�߼����ý���δ��") {
								@advance_iframe = @browser.iframe(:src, @ts_tag_advance_src)
								@advance_iframe.present?
						}

						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@tc_tag_selected_status
								networking.click
						end
						sleep @tc_wait_time
						wifiset             = @advance_iframe.link(href: @tc_tag_wifiset)
						wifiset_parent_class=wifiset.parent.class_name
						unless wifiset_parent_class==@tc_tag_liclass
								wifiset.click
						end
						sleep @tc_wait_time
						channel_select = @advance_iframe.select_list(id: @tc_tag_wifi_channel_list)
						@tc_channel_arr.each_with_index do |channel, index|
								puts "·���������ŵ�Ϊ��#{channel}".to_gbk
								unless channel_select.selected?(channel)
										channel_select.select(channel)
										sleep 1
										@advance_iframe.button(id: @ts_tag_sbm).click
										Watir::Wait.while(@tc_channelset_time, "�ȴ������ŵ�����".to_gbk) {
												advance_save_cont = @advance_iframe.div(class_name: @tc_tag_adsave_cont)
												advance_save_cont.present?
										}
								end
								puts "�ȴ��ŵ��л�������".to_gbk
								sleep @tc_channel_change #�ȴ��ŵ��л�
								#��ѯ����ɨ�赽���ŵ�
								wifi_itf_info = @wifi.show_interfaces
								wifi_channel  = wifi_itf_info[@ts_wlan_nicname][:channel]
								puts "����ɨ�赽�ŵ�Ϊ:#{wifi_channel}".to_gbk
								assert_equal(@tc_channel_value_arr[index], wifi_channel, "����ɨ�赽�ŵ���·�������ò�һ�£�")
								sleep @tc_wait_time
								rs = @wifi.ping(@ts_default_ip)
								assert(rs, "�޸��ŵ���������·�����Ͽ����ӣ�")
						end
				}
		end

		def clearup

				operate("1 �ָ�Ĭ��SSID") {
						@wifi.netsh_disc_all #�Ͽ�wifi����
						if @browser.div(class_name: @ts_aui_state).exists?
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
						unless ssid_value==@tc_default_ssid
								puts "�޸�SSIDΪĬ��SSID��#{@tc_default_ssid}".to_gbk
								ssid_obj.set(@tc_default_ssid)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_wait_net_reset
						end
				}

				operate("2 �ָ��ŵ�Ϊ�Զ��ŵ�") {
						if @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						Watir::Wait.until(@tc_wait_time, "�߼����ý���δ��") {
								@advance_iframe = @browser.iframe(:src, @ts_tag_advance_src)
								@advance_iframe.present?
						}
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
