#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.11", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time            = 2
				@tc_ftp_time             = 30
				@tc_cap_gap              = 10
				@tc_cap_wifi_gap         = 30
				@tc_qos_time             = 5
				@tc_net_time             = 40
				@tc_reboot_time          = 120
				#kbps
				@tc_bandwidth_total      = 100000 #10M
				@tc_bandwidth_limit      = 1024 #1M
				#bps
				@tc_bandwidth_total_bps  = 102400000
				@tc_bandwidth_limit_bps  = 1048576
				# e:/Automation/frame/ftp_client.rb
				@tc_ftp_client           = File.absolute_path("../ftp_client.rb", __FILE__)
				@tc_cap_wired_client1    = "D:/ftpcaps/ftp_wired_client1.pcapng"
				@tc_cap_wired_client2    = "D:/ftpcaps/ftp_wired_client2.pcapng"
				@tc_cap_wired_client3    = "D:/ftpcaps/ftp_wired_client3.pcapng"

				@tc_cap_wireless_client1 = "D:/ftpcaps/ftp_wireless_client1.pcapng"
				@tc_cap_wireless_client2 = "D:/ftpcaps/ftp_wireless_client2.pcapng"
				@tc_cap_wireless_client3 = "D:/ftpcaps/ftp_wireless_client3.pcapng"
				#Ҫʹץ�İ�������һ���ļ���@tc_output_time������ڻ����@tc_cap_time
				@tc_output_time          = 5
				@tc_cap_time             = 5
				rs                       = ipconfig(@ts_ipconf_all)
				@ts_pc_mac               = rs[@ts_nicname][:mac]
				@ts_pc_ip                = rs[@ts_nicname][:ip][0]
				@tc_ftp_filter           = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action           = "get"
				@tc_drb_ftp_pid          = nil
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ1000kbps") {
						@browser.span(id: @ts_tag_netset).click
						@wan_iframe= @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "��WAN����ʧ��")
						#����Ϊdhcp����
						@wan_iframe.span(id: @ts_tag_wired_mode_span).click
						wired_dhcp = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						unless wired_dhcp.checked?
								@wan_iframe.radio(id: @ts_tag_wired_dhcp).click
								@wan_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_net_time
						end

						rs = ping(@ts_wan_client_ip)
						assert(rs, "�޷�pingͨftp������")

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
								sleep @tc_reboot_time
								passwd = @ts_default_wlan_pw
						end
						puts "��ǰSSID��Ϊ��#{ssid},passwd:#{passwd}".to_gbk
						rs    = @wifi.connect(ssid, @ts_wifi_flag, passwd)
						assert rs, "WIFI����ʧ��"
						ip_info     = @wifi.netsh_if_ip_show(nicname: @ts_wlan_nicname, type: "addresses")
						@tc_wifi_ip = ip_info[:ip][0]
				}

				operate("2�����赱ǰLAN�ڵ�ַΪ192.168.100.1�����ù���1��ַ��Ϊ192.168,100.2��192.168,100.2������Ϊ��������������Ϊ300kbps�����ù���2��ַ��Ϊ192.168,100.3��192.168,100.3������Ϊ��������������Ϊ300kbps�����ù���3��ַ��Ϊ192.168,100.4��192.168,100.4������Ϊ��������������Ϊ300kbps�����ù����Ϲ���") {
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
						###�ܿ��ش�
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
						#�����ܴ���
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
						#��һ����������ip��Χ
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@ts_pc_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@ts_pc_ip.split(".").last)
						#ѡ�������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#�ڶ�����������ip��Χ
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_wifi_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_wifi_ip.split(".").last)
						#ѡ�������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit)

						#�ύ
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
				}

				operate("3��AP�½�3̨���ԣ�PC1-PC3��ַ�ֱ�Ϊ192.168.100.2-4��������PC1��ʹ��FTP���أ�Ȼ������PC2 FTP���أ�Ȼ������PC3 FTP���أ�ͳ�Ƶ�ǰ��PC1��PC2��PC3���������") {
						file_dir = File.dirname(@ts_ftp_download)
						#���Ŀ¼�������򴴽�Ŀ¼
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(@ts_ftp_download, ".*")
						Dir.glob("#{file_dir}/*") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rfҪ����
						}

						@tc_ftp_pid1 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						sleep @tc_ftp_time #�ȴ�ftp�ͻ�������

						#���ع�����ץ������
						puts "=============wired client capture first time================="
						tshark_duration(@tc_cap_wired_client1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture second time================="
						tshark_duration(@tc_cap_wired_client2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture three time================="
						tshark_duration(@tc_cap_wired_client3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#ͳ������������������
						puts "=============Statistics wired bandwith first time================="
						rs1            = capinfos_all(@tc_cap_wired_client1)
						banwith_wired1 = rs1[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wired1}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed1 = ((banwith_wired1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics wired bandwith second time================="
						rs2            = capinfos_all(@tc_cap_wired_client2)
						banwith_wired2 = rs2[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wired2}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed2 = ((banwith_wired2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics wired bandwith three time================="
						rs3            = capinfos_all(@tc_cap_wired_client3)
						banwith_wired3 = rs3[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wired3}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed3 = ((banwith_wired3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC��������Ϊ#{@tc_bandwidth_limit}����Ч")
				}
				operate("�ͻ���2����") {
						#���߿ͻ���
						rs                  = @wifi.ipconfig("all")
						pc_mac_address      = rs[@ts_wlan_nicname][:mac]
						@ts_wlan_pc_mac     = pc_mac_address.gsub!("-", ":")
						@ts_wlan_pc_ip      = rs[@ts_wlan_nicname][:ip][0]
						@tc_wlan_ftp_filter = "not ether src #{@ts_wlan_pc_mac}"
						# sleep @tc_ftp_time #�ȴ�ftp�ͻ�������
						@tc_drb_ftp_pid     = @wifi.drb_ftp_client(@ts_wan_client_ip, @ts_ftp_usr, @ts_ftp_pw, @ts_ftp_block, @tc_ftp_action, @ts_ftp_srv_file, @ts_ftp_download)
						#���ع�����ץ������
						puts "=============wireless client capture first time================="
						@wifi.tshark_duration(@tc_cap_wireless_client1, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_cap_wifi_gap
						puts "=============wireless client capture second time================="
						@wifi.tshark_duration(@tc_cap_wireless_client2, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_cap_wifi_gap
						puts "=============wireless client capture three time================="
						@wifi.tshark_duration(@tc_cap_wireless_client3, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid)

						#ͳ������������������
						puts "=============Statistics wireless bandwith first time================="
						rs1               = @wifi.capinfos_all(@tc_cap_wireless_client1)
						banwith_wireless1 = rs1[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wireless1}bps".encode("GBK")
						#�����20%����,ʵ�����-�޶�����/�޶�����
						loss_speed1 = ((banwith_wireless1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.2

						puts "=============Statistics wireless bandwith second time================="
						rs2               = @wifi.capinfos_all(@tc_cap_wireless_client2)
						banwith_wireless2 = rs2[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wireless2}bps".encode("GBK")
						#�����20%����,ʵ�����-�޶�����/�޶�����
						loss_speed2 = ((banwith_wireless2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.2

						puts "=============Statistics wireless bandwith three time================="
						rs3               = @wifi.capinfos_all(@tc_cap_wireless_client3)
						banwith_wireless3 = rs3[:bit_rate]
						puts "���߿ͻ���ʵ����������Ϊ#{banwith_wireless3}bps".encode("GBK")
						#�����20%����,ʵ�����-�޶�����/�޶�����
						loss_speed3 = ((banwith_wireless3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.2

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "���߿ͻ��˴�������Ϊ#{@tc_bandwidth_limit}����Ч")
						#ֹͣ��������
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
						@wifi.netsh_disc_all #�Ͽ���������
				}


		end

		def clearup

				operate("1 �ر����غͶϿ���������") {
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

				operate("2 ɾ��qos����") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						#����������
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
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
