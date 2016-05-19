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
				@wifi               = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time       = 2
				@tc_wireless_client = 5

				@tc_static_ip  = @ts_default_ip.sub(/\.\d+$/, '.123')
				@tc_static_args= {nicname: @ts_nicname, source: "static", ip: "#{@tc_static_ip}", mask: "255.255.255.0"}
				@tc_dhcp_args  = {nicname: @ts_nicname, source: "dhcp"}

				@tc_default_lan_start= "100"
				@tc_default_lan_end  = "200"
				@tc_lan_start1       = "80"
				@tc_lan_end1         = "90"
				@tc_lan_end2         = "80"

		end

		def process

				operate("1 ����������") {
				}

				operate("2 ����·����wifi") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url, @ts_wifi_ssid1)
						@wifi_ssid1 = rs_wifi[:ssid]
						@wifi_pw    = rs_wifi[:pwd]
						puts "��ǰSSID1��Ϊ#{@wifi_ssid1}".to_gbk
						puts "��ǰSSID1 ���ܷ�ʽΪ#{@wifi_page.ssid1_pwmode}".to_gbk
						puts "WIFI����Ϊ��#{@wifi_pw}".to_gbk
						rs1 = @wifi.connect(@wifi_ssid1, @ts_wifi_flag, @wifi_pw)
						assert rs1, 'WIFI����ʧ��'
						rs2 = @wifi.ping(@ts_default_ip)
						assert rs2, 'WIFI�ͻ����޷�pingͨ·����'
				}

				operate("3 �޸�DHCP��ַ�ط�Χ") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						@tc_lan_start_pre = @lan_page.lan_startip_pre
						@tc_lan_startip1  = @tc_lan_start_pre+@tc_lan_start1
						@tc_lan_end_pre   = @lan_page.lan_endip_pre
						@tc_lan_endip1    =@tc_lan_end_pre+@tc_lan_end1
						puts "�޸ĵ�ַ�ط�ΧΪ #{@tc_lan_startip1}-#{@tc_lan_endip1}".to_gbk
						@lan_page.lan_startip_set(@tc_lan_start1)
						@lan_page.lan_endip_set(@tc_lan_end1)
						@lan_page.btn_save_lanset
				}

				operate("4 �޸ĵ�ַ�غ����»�ȡIP��ַ") {
						ip_flag=false
						ip_release(@ts_nicname)
						ip_renew(@ts_nicname)
						3.times do |i|
								ip_info = ipconfig()
								sleep @tc_wireless_client
								ipaddr =ip_info[@ts_nicname][:ip]
								p "�޸ĵ�ַ�غ��#{i+1}�β�ѯ#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
								unless ipaddr.empty?
										ip_flag = ipaddr[0]>=@tc_lan_startip1 && ipaddr[0]<=@tc_lan_endip1
								end
								break if ip_flag
						end
						assert ip_flag, "�޸ĵ�ַ�غ�,·��������,�ͻ���δ����µ�ַ�ص�ַ"

						@wifi.ip_release(@ts_wlan_nicname)
						@wifi.ip_renew(@ts_wlan_nicname)
						wip_flag=false
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep @tc_wireless_client
								wipaddr =wip_info[@ts_wlan_nicname][:ip]
								p "�޸ĵ�ַ�غ��#{i+1}�β�ѯ#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
								unless wipaddr.empty?
										wip_flag = wipaddr[0]>=@tc_lan_startip1 && wipaddr[0]<=@tc_lan_endip1
								end
								break if wip_flag
						end
						assert wip_flag, "�޸ĵ�ַ�غ�,·����������,wifi�ͻ���δ����µ�ַ�ص�ַ"
				}

				operate("5 ����·����") {
						@lan_page.reboot
						@login_page = RouterPageObject::LoginPage.new(@browser)
						login_ui    = @login_page.login_with_exists(@browser.url)
						assert(login_ui, "������δ��ת����¼ҳ�棡")
				}

				operate("6,·������������֤�ͻ����Ƿ��ȡip��ַ") {
						ip_flag=false
						3.times do |i|
								ip_info = ipconfig()
								sleep @tc_wireless_client
								ipaddr =ip_info[@ts_nicname][:ip]
								p "·�����������#{i+1}�β�ѯ#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
								unless ipaddr.empty?
										ip_flag = ipaddr[0]>=@tc_lan_startip1 && ipaddr[0]<=@tc_lan_endip1
								end
								break if ip_flag
						end
						assert ip_flag, "�޸ĵ�ַ�غ�,·��������,�ͻ���δ����µ�ַ�ص�ַ"

						wip_flag=false
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep @tc_wireless_client
								wipaddr =wip_info[@ts_wlan_nicname][:ip]
								p "·�����������#{i+1}�β�ѯ#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
								unless wipaddr.empty?
										wip_flag = wipaddr[0]>=@tc_lan_startip1 && wipaddr[0]<=@tc_lan_endip1
								end
								break if wip_flag
						end
						assert wip_flag, "�޸ĵ�ַ�غ�,·����������,wifi�ͻ���δ����µ�ַ�ص�ַ"
				}

				operate("7 ��СIP��ַ�ط�Χ") {
						#������ʼ�����������ַһ��
						#���µ�¼·����
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
						#�Ƚ������߿ͻ���
						@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "disabled")
						sleep @tc_wireless_client
						@lan_page.lan_endip_config(@tc_lan_end2, @browser.url)
				}

				operate("8 ��СIP��ַ�ط�Χ�����»�ȡIP��ַ") {
						ip_flag=false
						ip_release(@ts_nicname)
						ip_renew(@ts_nicname)
						3.times do |i|
								ip_info = ipconfig()
								sleep @tc_wireless_client
								ipaddr =ip_info[@ts_nicname][:ip]
								p "��СIP��ַ�ط�Χ���#{i+1}�β�ѯ#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
								unless ipaddr.empty?
										ip_flag = ipaddr[0]==@tc_lan_startip1
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
								sleep @tc_wireless_client
								wipaddr =wip_info[@ts_wlan_nicname][:ip]
								p "��СIP��ַ�ط�Χ���#{i+1}�β�ѯ#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
								unless wipaddr.empty?
										wip_flag = wipaddr[0]>=@tc_lan_startip1 && wipaddr[0]<=@tc_lan_startip1
								end
								break if wip_flag
						end
						assert_equal false, wip_flag, "��СIP��ַ�ط�Χ��,wifi�ͻ���Ӧ���޷���ȡIP����ʵ�ʻ��IP��ַ"
				}

				operate("9 �ָ�Ĭ�ϵ�ַ�ط�Χ") {

				}


		end

		def clearup

				operate("1 �ָ�Ĭ�ϵ�ַ��") {
						@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
						sleep @tc_wireless_client
						p "�Ͽ�WIFI����".to_gbk
						@wifi.netsh_disc_all #�Ͽ�wifi����
						sleep @tc_wait_time
						ping_test = ping(@ts_default_ip)
						unless ping_test
								netsh_if_ip_setip(@tc_static_args)
						end

						@browser.refresh
						@lan_page = RouterPageObject::LanPage.new(@browser)
						if @lan_page.login_with_exists(@browser.url)
								@lan_page.login_with(@ts_default_usr,@ts_default_pw,@browser.url)
						end

						@lan_page.open_lan_page(@browser.url)
						@tc_lan_startnum = @lan_page.lan_startip
						@tc_lan_endnum   = @lan_page.lan_endip
						flag_start       = @tc_lan_startnum==@tc_default_lan_start
						flag_end         = @tc_lan_endnum==@tc_default_lan_end

						unless flag_start&&flag_end
								puts "DHCP��ַ�ػָ�Ĭ��ֵ".to_gbk if flag_start&&flag_end
								@lan_page.lan_startip_set(@tc_default_lan_start)
								@lan_page.lan_endip_set(@tc_default_lan_end)
								@lan_page.btn_save_lanset
						end

						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.modify_default_ssid(@browser.url, @ts_wifi_ssid1)
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
