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
				@tc_bandwidth_limit1     = 800
				@tc_bandwidth_limit2     = 400
				#bps
				@tc_bandwidth_total_bps  = 1024000
				@tc_bandwidth_limit1_bps = 409600
				@tc_bandwidth_limit2_bps = 819200

				@tc_cap_wifi_gap         = 10
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
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪDHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						wan_type = sys_page.get_wan_type
						wan_addr = sys_page.get_wan_ip
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'

						#������������
						@wifi_page  = RouterPageObject::WIFIPage.new(@browser)
						wifi_config = @wifi_page.modify_ssid_mode_pwd(@browser.url, "autotest")
						#������������
						puts "wifi ssid: #{wifi_config[:ssid]},passwd:#{wifi_config[:pwd]}"
						rs1 = @wifi.connect(wifi_config[:ssid], @ts_wifi_flag, wifi_config[:pwd])
						assert rs1, 'wifi����ʧ��'
						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wifi�ͻ����޷�pingͨ·����'

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
				}

				operate("2�����赱ǰLAN�ڵ�ַΪ192.168.100.1�����ù���1��ַ��Ϊ192.168,100.2��192.168,100.2������Ϊ��������������Ϊ800kbps�����ù���2��ַ��Ϊ192.168,100.3��192.168,100.3������Ϊ��������������Ϊ400kbps���������") {
						#�򿪸߼�����
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
						#����1
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_pc_ip.split(".").last, @tc_pc_ip.split(".").last, @ts_tag_bandlimit, @tc_bandwidth_limit1)
						#����2
						@options_page.add_item
						@options_page.set_client_bw(2, @tc_wifi_ip.split(".").last, @tc_wifi_ip.split(".").last, @ts_tag_bandlimit, @tc_bandwidth_limit2)
						@options_page.save_traffic #����
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
						@tc_wireless_ave_speed= (banwith_wireless1+banwith_wireless2+banwith_wireless3)/3

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
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
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
						flag = loss_speed_total<=0.1
						assert(flag, "�ͻ������������ܺʹ����ܴ�������")
				}


		end

		def clearup

				operate("1 �ر����غͶϿ���������") {
						@wifi.netsh_disc_all #�Ͽ�wifi����
						####ֹͣ�������ؽ���
						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
				}

				operate("2 ɾ��������������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #����

						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.modify_default_ssid(@browser.url)
				}
		end

}
