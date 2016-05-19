#
# description:
#�ܴ������Ʋ��Ǻ�׼
#�����ܴ���Ϊ1000��ʵ�ʿɴ�1200-1400
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.12", "level" => "P4", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                    = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wifi_flag            = "1"
				#kpbs
				@tc_bandwidth_total      = 1000
				@tc_bandwidth_limit1     = 400
				@tc_bandwidth_limit2     = 800
				#bps
				@tc_bandwidth_total_bps  = 1024000
				@tc_bandwidth_limit1_bps = 409600
				@tc_bandwidth_limit2_bps = 819200

				@tc_cap_wifi_gap         = 10
				@tc_lan_time             = 35
				@tc_net_time             = 60
				@tc_qos_time             = 3
				@tc_cap_gap              = 5
				@tc_ftp_time             = 30
				@tc_wait_time            = 5
				#Ҫʹץ�İ�������һ���ļ���@tc_output_time������ڻ����@tc_cap_time
				@tc_output_time          = 5
				@tc_cap_time             = 5
				# e:/autotest/frame/ftp_client.rb
				@tc_ftp_client           = File.absolute_path("../ftp_client.rb", __FILE__)
				#���߿ͻ�������
				@tc_cap_wired_client1    = "D:/ftpcaps/ftp_wired_download1.pcapng"
				@tc_cap_wired_client2    = "D:/ftpcaps/ftp_wired_download2.pcapng"
				@tc_cap_wired_client3    = "D:/ftpcaps/ftp_wired_download3.pcapng"
				#���߿ͻ�������
				@tc_cap_wireless_client1 = "D:/ftpcaps/ftp_wireless_download1.pcapng"
				@tc_cap_wireless_client2 = "D:/ftpcaps/ftp_wireless_download2.pcapng"
				@tc_cap_wireless_client3 = "D:/ftpcaps/ftp_wireless_download3.pcapng"
				@tc_ftp_action           = "get"
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ1000kbps") {
						#����ܷ�pingͨftp������
						rs = ping(@ts_wan_client_ip)
						#���ping��ͨ�����·�������뷽ʽ�Ƿ�Ϊdhcp
						if !rs
								#�鿴WAN�Ƿ�ΪDHCP���룬�ж��Ƿ�
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, '��WAN״̬ʧ�ܣ�')
								wan_addr = @status_iframe.b(:id => @tag_wan_ip).parent.text
								wan_type = @status_iframe.b(:id => @tag_wan_type).parent.text
								#�������DHCP���룬�޸�ΪDHCP��ʽ
								if wan_type !~ /#{@ts_wan_mode_dhcp}/
										@browser.span(:id => @ts_tag_netset).click
										@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
										assert(@wan_iframe.exists?, '����������ʧ�ܣ�')

										rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
										unless rs1=~/#{@ts_tag_select_state}/
												@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
										end

										dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
										dhcp_radio_state = dhcp_radio.checked?
										unless dhcp_radio_state
												dhcp_radio.click
												@wan_iframe.button(:id, @ts_tag_sbm).click
												puts "waiting for net rebooting..."
												sleep @tc_net_time
										end
										rs2 = ping(@ts_wan_client_ip)
										assert(rs2, 'FTP�������޷�pingͨ����·������·״̬')
										if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
												@browser.execute_script(@ts_close_div)
										end
								else
										assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp��ȡip��ַʧ�ܣ�'
								end
						end

						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, '����������ʧ�ܣ�')
						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "�ָ�Ĭ�ϵļ����뷽ʽ��#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#��������Ч
								puts "Waiting for wifi config changed..."
								sleep @tc_lan_time
						end
						@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
						@current_pw   = @passwd_input.value
						puts "wifi passwd:#{@current_pw}"
						ssid_name = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						rs1       = @wifi.connect(ssid_name, @tc_wifi_flag, @current_pw)
						assert rs1, 'wifi����ʧ��'
						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif�ͻ����޷�pingͨ·����'

						#��ȡ����������Ϣ
						rs_wifi         = @wifi.ipconfig(@ts_ipconf_all)
						@tc_wifi_ip     = rs_wifi[@ts_wlan_nicname][:ip][0]
						pc_mac_address  = rs_wifi[@ts_wlan_nicname][:mac]
						@tc_wlan_pc_mac = pc_mac_address.gsub!("-", ":")
						puts "wlan pc mac:#{@tc_wlan_pc_mac}"
						puts "wlan pc ip:#{@tc_wifi_ip}"
						@tc_wlan_ftp_filter = "not ether src #{@tc_wlan_pc_mac}"

						#����������Ϣ��ȡ
						rs_nic              = ipconfig(@ts_ipconf_all)
						@tc_pc_ip           = rs_nic[@ts_nicname][:ip][0]
						@tc_ftp_filter      = "not ether src #{@ts_pc_mac}"
						puts "pc mac:#{@ts_pc_mac}"
						puts "pc ip:#{@tc_pc_ip}"

						#�ر�lan����
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						#�򿪸߼�����
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��")
						#����������
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end
						sleep @tc_wait_time #�������������Ӧ�����������ӳ�
						#����������
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end
						sleep @tc_wait_time #�������������Ӧ�����������ӳ�
						####�����ܿ���
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
						####�����ܴ���
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
				}

				operate("2�����赱ǰLAN�ڵ�ַΪ192.168.100.1�����ù���1��ַ��Ϊ192.168,100.2��192.168,100.2������Ϊ��������������Ϊ800kbps�����ù���2��ַ��Ϊ192.168,100.3��192.168,100.3������Ϊ��������������Ϊ400kbps���������") {
						#����1
						#�����������Ƶ�IP,����ip��Χ
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_wifi_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_wifi_ip.split(".").last)
						#ѡ������������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit1)

						#����2
						#�����������Ƶ�IP,����ip��Χ
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_pc_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_pc_ip.split(".").last)
						#ѡ������������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit2)
						#�ύ
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
				}

				operate("3��AP�½�2̨���ԣ�PC1-PC2��ַ�ֱ�Ϊ192.168.100.2-3��PC1��PC2�������أ�ͳ�Ƶ�ǰ��PC1��PC2��PC3���������") {
						#���߿ͻ��˿�ʼ����
						@tc_drb_ftp_pid = @wifi.drb_ftp_client(@ts_wan_client_ip, @ts_ftp_usr, @ts_ftp_pw, @ts_ftp_block, @tc_ftp_action, @ts_ftp_srv_file, @ts_ftp_download)
						#��������Ŀ¼
						file_dir        = File.dirname(@ts_ftp_download)
						#���Ŀ¼�������򴴽�Ŀ¼
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(@ts_ftp_download, ".*")
						Dir.glob("#{file_dir}/*") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rfҪ����
						}
						#���߿ͻ�������
						@tc_ftp_pid1 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						sleep @tc_ftp_time #�ȴ�ftp�ͻ��������ȶ����ٿ�ʼץ��ͳ��
				}

				operate("4 ͳ�����ش����Ƿ�����ܴ����޶�") {
						#ͳ���������ش���
						#���ع�����ץ������
						puts "=============wireless client capture first time================="
						@wifi.tshark_duration(@tc_cap_wireless_client1, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_cap_wifi_gap
						puts "=============wireless client capture second time================="
						@wifi.tshark_duration(@tc_cap_wireless_client2, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_cap_wifi_gap
						puts "=============wireless client capture third time================="
						@wifi.tshark_duration(@tc_cap_wireless_client3, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid)

						#ͳ������������������
						puts "=============Statistics wireless bandwith first time================="
						rs1               = @wifi.capinfos_all(@tc_cap_wireless_client1)
						banwith_wireless1 = rs1[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wireless1}bps".encode("GBK")

						puts "=============Statistics wireless bandwith second time================="
						rs2               = @wifi.capinfos_all(@tc_cap_wireless_client2)
						banwith_wireless2 = rs2[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wireless2}bps".encode("GBK")

						puts "=============Statistics wireless bandwith third time================="
						rs3               = @wifi.capinfos_all(@tc_cap_wireless_client3)
						banwith_wireless3 = rs3[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wireless3}bps".encode("GBK")
						@tc_wireless_speeds   = [banwith_wireless1, banwith_wireless2, banwith_wireless3]
						@tc_wireless_ave_speed=(banwith_wireless1+banwith_wireless2+banwith_wireless3)/3

						#���ع�����ץ������
						puts "=============wired client capture first time================="
						tshark_duration(@tc_cap_wired_client1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture second time================="
						tshark_duration(@tc_cap_wired_client2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture third time================="
						tshark_duration(@tc_cap_wired_client3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						#ͳ������������������
						puts "=============Statistics wired bandwith first time================="
						rs1            = capinfos_all(@tc_cap_wired_client1)
						banwith_wired1 = rs1[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wired1}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						# loss_speed1 = ((banwith_wired1-@tc_bandwidth_limit2_bps).to_f.abs/@tc_bandwidth_limit2_bps)

						puts "=============Statistics wired bandwith second time================="
						rs2            = capinfos_all(@tc_cap_wired_client2)
						banwith_wired2 = rs2[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wired2}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						# loss_speed2 = ((banwith_wired2-@tc_bandwidth_limit2_bps).to_f.abs/@tc_bandwidth_limit2_bps)

						puts "=============Statistics wired bandwith third time================="
						rs3            = capinfos_all(@tc_cap_wired_client3)
						banwith_wired3 = rs3[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wired3}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						# loss_speed3 = ((banwith_wired3-@tc_bandwidth_limit2_bps).to_f.abs/@tc_bandwidth_limit2_bps)
						@tc_wired_speeds   = [banwith_wired1, banwith_wired2, banwith_wired3]
						@tc_wired_ave_speed=(banwith_wired1+banwith_wired2+banwith_wired3)/3

						#ֹͣ��������
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
						#ֹͣ��������
						begin
								if Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end
						# assert(rs_rate_flag_wired, "PC��������Ϊ#{@tc_bandwidth_limit2}����Ч")

						#���ߺ����߿ͻ��������������������Ĵ����࣬���10%
						total_downspeed = @tc_wireless_ave_speed+@tc_wired_ave_speed
						puts "total download bandwidth  #{total_downspeed}bps"
						puts "total download bandwidth limited #{@tc_bandwidth_total_bps}bps"
						loss_speed_total = ((total_downspeed-@tc_bandwidth_total_bps).to_f.abs/@tc_bandwidth_total_bps)
						puts loss_speed_total
						flag = loss_speed_total<=0.3
						assert(flag, "�ͻ������������ܺʹ����ܴ�������")
				}


		end

		def clearup

				operate("�ر����غͶϿ���������") {
						@wifi.netsh_disc_all #�Ͽ�wifi����
						####ֹͣ�������ؽ���
						begin
								if Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
				}

				operate("ɾ��������������") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						# unless @advance_iframe.nil? || @advance_iframe.exists?
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						# end

						#����������
						bandwith        = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end

						#����������
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end

						#ɾ������1
						@advance_iframe.td(text: "1").parent.tds[5].link.click
						#ɾ������2
						@advance_iframe.td(text: "2").parent.tds[5].link.click

						####�ر��ܿ���
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						if qos_sw.checked?
								qos_sw.click
								#�ύ
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_qos_time
						end
				}
		end

}
