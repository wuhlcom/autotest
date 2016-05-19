#
# description:
# ����ֻ������̨�������ͻ���
# author:wuhongliang
# date:2015-10-29 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.4", "level" => "P1", "auto" => "n"}

		def prepare

				DRb.start_service
				@wifi            = DRbObject.new_with_uri(@ts_drb_server)
				@tc_net_time     = 50
				@tc_wait_time    = 2
				@tc_wifi_enable  = "enabled"
				@tc_wifi_disable = "disabled"

				@default_lan_start= @ts_default_ip.sub(/\.\d+$/, ".100")
				@default_lan_end  = @ts_default_ip.sub(/\.\d+$/, ".200")

				@new_lan_start1= @ts_default_ip.sub(/\.\d+$/, ".40")
				@new_lan_end1  = @ts_default_ip.sub(/\.\d+$/, ".50")

		end

		def process

				operate("1��PC1��PC2��PC3�����Զ���ȡIP��ַ���鿴��ȡ��IP��ַ���磺192.168.1.100��192.168.1.101��192.168.102��") {
						#���ߵ����Ӿ��ǵ�ǰִ�л��������ò�����Ƿ���IP��ַ�������������ʧ�ܣ��ű������޷�ִ��
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "�������ô�ʧ��!")

						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "�ָ�Ĭ�ϵļ����뷽ʽ��#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#��������Ч
								puts "Waiting for wifi config changed..."
								sleep @tc_net_time
						end
						@current_pw = @lan_iframe.text_field(:id, @ts_tag_input_pw).value
						@ssid_name  = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						puts "��ǰSSID:#{@ssid_name},����:#{@current_pw}".encode("GBK")
						rs1 = @wifi.connect(@ssid_name, @ts_wifi_flag, @current_pw)
						assert rs1, 'wifi����ʧ��'
						rs2 = @wifi.ping(@ts_default_ip)
						assert rs2, 'wifi�ͻ����޷�pingͨ·����'
						#�Ͽ�������������
						@wifi.netsh_disc_all #�Ͽ�wifi����
				}

				operate("2����½·����������������") {
						#�Ͽ������������Ӻ����õ����ַ�ͽ�����ַһ��
						#��������Ҫ�ͷź����»�ȡһ�ε�ַ
						#Ȼ���ٴ���������
						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						@current_startip = tc_startip_field.value
						puts "��ǰLAN��ַ����ʼIPΪ#{@current_startip}".encode("GBK")
						puts "�޸ĵ�ַ�ؽ���IPΪ#{@new_lan_start1}".encode("GBK")
						tc_startip_field.set(@new_lan_start1)
						#��ȡ��ǰ������ַ
						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						@current_endip = tc_endip_field.value
						puts "��ǰLAN��ַ�ؽ���IPΪ#{@current_endip}".encode("GBK")
						puts "�޸ĵ�ַ�ؽ���IPΪ#{@new_lan_start1}".encode("GBK")
						#�޸�dhcp������ַ
						tc_endip_field.set(@new_lan_start1)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
				}

				operate("3������HDCP��ַ�ط�Χ ��:192.168.1.100~101��") {
						#�ڶ����Ѿ�ʵ��
				}

				operate("4��PC1��PC2��PC3 DOS����ipconfig/release�ֶ��ͷ�IP��ַ��������ipconfig/renew���»�ȡIP��ַ���鿴��ȡ��IP��ַ�Ƿ���ȷ��") {
						ip_addr=""
						ip_release(@ts_nicname)
						ip_renew(@ts_nicname)
						3.times do |i|
								ip_info = ipconfig()
								sleep @tc_wait_time
								ip_addr =ip_info[@ts_nicname][:ip]
								p "��#{i+1}�β�ѯ#{@ts_nicname} ip: #{ip_addr.join(",")}".to_gbk
								break unless ip_info[@ts_nicname][:ip].empty?
						end
						assert_equal(@new_lan_start1, ip_addr[0], "��ַ�ط�Χ��,#{@ts_nicname}δ��õ�ַ")
						#��������������
						rs1 = @wifi.connect(@ssid_name, @ts_wifi_flag, @current_pw)
						sleep 10
						wip_addr=""
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep 15
								wip_addr =wip_info[@ts_wlan_nicname][:ip]
								p "��#{i+1}�β�ѯ#{@ts_wlan_nicname} ip: #{wip_addr.join(",")}".to_gbk
						end
						assert_match(/^169/, wip_addr[0], "wifi�ͻ���Ӧ���޷���ȡIP����ʵ�ʻ��IP��ַ")
				}


		end

		def clearup

				operate("�ָ�Ĭ�ϵ�ַ�ط�Χ") {
						@wifi.netsh_disc_all #�Ͽ�wifi����
						#ɾ�����������ļ� �Ӷ��ﵽ�Ͽ����ӵ�Ŀ��
						profiles = @wifi.show_profiles
						profiles[@ts_wlan_nicname].each { |profile|
								@wifi.netsh_dp(profile, @ts_wlan_nicname)
						}

						flag_pool        = false
						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						current_startip  = tc_startip_field.value
						unless current_startip==@current_startip
								tc_startip_field.set(@current_startip)
								flag_pool=true
						end

						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						current_endip  = tc_endip_field.value
						unless current_endip==@current_endip
								tc_endip_field.set(@current_endip)
								flag_pool=true
						end

						if flag_pool
								@lan_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}

		end

}
