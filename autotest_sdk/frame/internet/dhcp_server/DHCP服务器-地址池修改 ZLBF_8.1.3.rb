#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                  = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time          = 5
				@tc_dhcp_pool_time     = 35
				@tc_wait_for_login     = 60
				@tc_wait_for_reboot    = 130
				@tc_wpa_value          = "WPAPSKWPA2PSK"
				@ts_tag_reset          = "aui_content"
				@tc_tag_net_reset_tip  = "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_reboot_confirm = "aui_state_highlight"
				@tc_tag_reboot_cancel  = "ȡ��"
				@tc_tag_rebooting      = "aui_content"

				@tc_static_ip  =@ts_default_ip.sub(/\.\d+$/, '.123')
				@tc_static_args={nicname: @ts_nicname, source: "static", ip: "#{@tc_static_ip}", mask: "255.255.255.0"}
				@tc_dhcp_args  ={nicname: @ts_nicname, source: "dhcp"}

				@default_lan_start=@ts_default_ip.sub(/\.\d+$/, ".100")
				@default_lan_end  =@ts_default_ip.sub(/\.\d+$/, ".200")

				@new_lan_start1=@ts_default_ip.sub(/\.\d+$/, ".80")
				@new_lan_end1  =@ts_default_ip.sub(/\.\d+$/, ".90")
				@new_lan_end2  =@ts_default_ip.sub(/\.\d+$/, ".80")

		end

		def process

				operate("1 ����������") {
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@ts_tag_lan_src}/i, @lan_iframe.src, '����������ʧ�ܣ�'
				}

				operate("2 ����·����wifi") {
						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "�ָ�Ĭ�ϵļ����뷽ʽ��#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#��������Ч
								puts "Waiting for wifi config changed..."
								sleep @tc_wait_for_login
						end
						@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
						@current_pw   = @passwd_input.value
						puts "wifi passwd:#{@current_pw}"

						ssid_name = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						flag      ="1"
						rs1       = @wifi.connect(ssid_name, flag, @current_pw)
						assert rs1, 'wifi����ʧ��'
						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif�ͻ����޷�pingͨ·����'
				}

				operate("3 �޸�DHCP��ַ�ط�Χ") {
						@lan_iframe.text_field(:id, @ts_tag_lanstart).set(@new_lan_start1)
						@lan_iframe.text_field(:id, @ts_tag_lanend).set(@new_lan_end1)
						@lan_iframe.button(:id, @ts_tag_sbm).click

						#<div class="aui_content" style="padding: 20px 25px;">���óɹ������Ժ�......�������磬���������������������ӡ�</div>
						# Watir::Wait.until(@tc_wait_time, "�ȴ�����������ʾ����ʧ��") {
						# 		lan_reseting = @lan_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_lan_reset_text)
						# 		lan_reseting.present?
						# }
						#�°汾�޸ĵ�ַ�ط�Χ������ת����¼���� wuhongliang 2015-8-19
						# rs = @browser.text_field(:name, @usr_text_id).wait_until_present(@tc_wait_for_login)
						# assert rs, '��ת����¼ҳ��ʧ�ܣ�'
				}

				operate("4 �޸ĵ�ַ�غ����»�ȡIP��ַ") {
						#�޸ĵ�ַ�ط�Χ��ȴ�dhcp��������
						sleep @tc_dhcp_pool_time
						ip_flag=false
						ip_release(@ts_nicname)
						ip_renew(@ts_nicname)
						3.times do |i|
								ip_info = ipconfig()
								sleep 5
								ipaddr =ip_info[@ts_nicname][:ip]
								p "�޸ĵ�ַ�غ��#{i+1}�β�ѯ#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
								unless ipaddr.empty?
										ip_flag = ipaddr[0]>=@new_lan_start1 && ipaddr[0]<=@new_lan_end1
								end
								break if ip_flag
						end
						assert ip_flag, "�޸ĵ�ַ�غ�,·��������,�ͻ���δ����µ�ַ�ص�ַ"

						@wifi.ip_release(@ts_wlan_nicname)
						@wifi.ip_renew(@ts_wlan_nicname)
						wip_flag=false
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep 15
								wipaddr =wip_info[@ts_wlan_nicname][:ip]
								p "�޸ĵ�ַ�غ��#{i+1}�β�ѯ#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
								unless wipaddr.empty?
										wip_flag = wipaddr[0]>=@new_lan_start1 && wipaddr[0]<=@new_lan_end1
								end
								break if wip_flag
						end
						assert wip_flag, "�޸ĵ�ַ�غ�,·����������,wifi�ͻ���δ����µ�ַ�ص�ַ"
				}

				operate("5 ����·����") {
						#���µ�¼·����
						#rs_login = login(@browser, @ts_default_ip)
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_reboot).click

						reboot_confirm = @browser.button(class_name: @tc_tag_reboot_confirm)
						assert reboot_confirm.exists?, "δ��ʾ����·����Ҫȷ��!"
						reboot_confirm.click
						#<div class="aui_content" style="padding: 20px 25px;">���������У����Ե�...</div>
						# Watir::Wait.until(@tc_wait_time, "����·��������������ʾδ����".to_gbk) {
						# 		@browser.div(:class_name, @tc_tag_rebooting).visible?
						# }
						sleep @tc_wait_for_reboot
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_wait_for_login)
						assert rs, '��ת����¼ҳ��ʧ�ܣ�'
				}

				operate("6,·������������֤�ͻ����Ƿ��ȡip��ַ") {
						ip_flag=false
						3.times do |i|
								ip_info = ipconfig()
								sleep 2
								ipaddr =ip_info[@ts_nicname][:ip]
								p "·�����������#{i+1}�β�ѯ#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
								unless ipaddr.empty?
										ip_flag = ipaddr[0]>=@new_lan_start1 && ipaddr[0]<=@new_lan_end1
								end
								break if ip_flag
						end
						assert ip_flag, "�޸ĵ�ַ�غ�,·��������,�ͻ���δ����µ�ַ�ص�ַ"

						wip_flag=false
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep 20
								wipaddr =wip_info[@ts_wlan_nicname][:ip]
								p "·�����������#{i+1}�β�ѯ#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
								unless wipaddr.empty?
										wip_flag = wipaddr[0]>=@new_lan_start1 && wipaddr[0]<=@new_lan_end1
								end
								break if wip_flag
						end
						assert wip_flag, "�޸ĵ�ַ�غ�,·����������,wifi�ͻ���δ����µ�ַ�ص�ַ"
				}

				operate("7 ��СIP��ַ�ط�Χ") {
						#���µ�¼·����
						rs_login=login_no_default_ip(@browser)
						@browser.span(:id => @ts_tag_lan).click if rs_login
						@lan_iframe = @browser.iframe

						@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "disabled")
						sleep 5
						@lan_iframe.text_field(:id, @ts_tag_lanend).set(@new_lan_end2)
						@lan_iframe.button(:id, @ts_tag_sbm).click

						# Watir::Wait.until(@tc_wait_time, "�ȴ�����LAN��ʾ����ʧ��") {
						# 		lan_reseting = @lan_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_lan_reset_text)
						# 		lan_reseting.present?
						# }
				}

				operate("8 ��СIP��ַ�ط�Χ�����»�ȡIP��ַ") {
						#�޸ĵ�ַ�ط�Χ��ȴ�dhcp��������
						sleep @tc_dhcp_pool_time
						ip_flag=false
						ip_release(@ts_nicname)
						ip_renew(@ts_nicname)
						3.times do |i|
								ip_info = ipconfig()
								sleep 3
								ipaddr =ip_info[@ts_nicname][:ip]
								p "��СIP��ַ�ط�Χ���#{i+1}�β�ѯ#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
								unless ipaddr.empty?
										ip_flag = ipaddr[0]>=@new_lan_start1 && ipaddr[0]<=@new_lan_end1
								end
								break if ip_flag
						end
						assert ip_flag, "��СIP��ַ�ط�Χ��,�ͻ���δ����µ�ַ�ص�ַ"

						@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
						sleep 10
						@wifi.ip_release(@ts_wlan_nicname)
						@wifi.ip_renew(@ts_wlan_nicname)
						wip_flag=false
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep 15
								wipaddr =wip_info[@ts_wlan_nicname][:ip]
								p "��СIP��ַ�ط�Χ���#{i+1}�β�ѯ#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
								unless wipaddr.empty?
										wip_flag = wipaddr[0]>=@new_lan_start1 && wipaddr[0]<=@new_lan_end1
								end
								break if wip_flag
						end
						assert_equal false, wip_flag, "��СIP��ַ�ط�Χ��,wifi�ͻ���Ӧ���޷���ȡIP����ʵ�ʻ��IP��ַ"
				}

				operate("9 �ָ�Ĭ�ϵ�ַ�ط�Χ") {
						@lan_iframe.text_field(:id, @ts_tag_lanstart).set(@default_lan_start)
						@lan_iframe.text_field(:id, @ts_tag_lanend).set(@default_lan_end)
						@lan_iframe.button(:id, @ts_tag_sbm).click
						#�޸ĵ�ַ�ط�Χ��ȴ�dhcp��������
						sleep @tc_dhcp_pool_time
				}


		end

		def clearup

				operate("1 �ָ�Ĭ�ϵ�ַ��") {
						@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
						sleep 10
						p "�Ͽ�wifi����".to_gbk
						@wifi.netsh_disc_all #�Ͽ�wifi����
						sleep @tc_wait_time
						ping_test = ping(@ts_default_ip)
						unless ping_test
								netsh_if_ip_setip(@tc_static_args)
						end

						# rs_login= login(@browser, @ts_default_ip)
						# if rs_login
						@browser.refresh
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						flag_start  = @lan_iframe.text_field(:id, @ts_tag_lanstart).value==@default_lan_start
						flag_end    = @lan_iframe.text_field(:id, @ts_tag_lanend).value==@default_lan_start
						puts "DHCP��ַ���Ѿ��ָ�".to_gbk if flag_start&&flag_end
						unless flag_start&&flag_end
								#�ָ�Ĭ�ϵ�dhcp��ַ��
								@lan_iframe.text_field(:id, @ts_tag_lanstart).set(@default_lan_start)
								@lan_iframe.text_field(:id, @ts_tag_lanend).set(@default_lan_end)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_dhcp_pool_time
						end
						# end
				}

				operate("2 �ָ�����״̬") {
						netsh_if_ip_setip(@tc_dhcp_args)
						rs = @wifi.netsh_if_shif(@ts_wlan_nicname)
						if rs[:admin_state]=="disabled"
								@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
						end
				}

		end

}
