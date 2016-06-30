#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.19", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                   = DRbObject.new_with_uri(@ts_drb_server)
				#kpbs
				@tc_bandwidth_total     = 1000 #�ܴ���
				@tc_bandwidth_limit     = 800
				#bps
				@tc_bandwidth_total_bps = 1024000
				@tc_bandwidth_limit_bps = 819200
				@tc_status_time         = 10 #״̬ҳ��ȴ�
				@tc_cap_wifi_gap        = 10 #����ץ�����
				@tc_cap_wifi_time       = 120 #ץ��ǰ�ȴ�
				@tc_lan_time            = 35 #lan���õȴ�
				@tc_net_time            = 90 #��������
				@tc_qos_time            = 3 #QOS�·����õȴ�
				@tc_cap_gap             = 10 #����ץ�����
				@tc_ftp_time            = 90 #ץ��ǰ�ȴ�
				@tc_wait_time           = 5
				#Ҫʹץ�İ�������һ���ļ���@tc_output_time������ڻ����@tc_cap_time
				@tc_output_time         = 10
				@tc_cap_time            = 10 #ץ��ʱ��
				# e:/autotest/frame/ftp_client.rb
				@tc_ftp_client          = File.absolute_path("../ftp_client.rb", __FILE__)
				#���߿ͻ�������
				@tc_cap_wired_client1   = "D:/ftpcaps/ftp_wired_band1.pcapng"
				@tc_cap_wired_client2   = "D:/ftpcaps/ftp_wired_band2.pcapng"
				@tc_cap_wired_client3   = "D:/ftpcaps/ftp_wired_band3.pcapng"

				@tc_cap_wired_client4    = "D:/ftpcaps/ftp_wired_band4.pcapng"
				@tc_cap_wired_client5    = "D:/ftpcaps/ftp_wired_band5.pcapng"
				@tc_cap_wired_client6    = "D:/ftpcaps/ftp_wired_band6.pcapng"

				#���߿ͻ�������
				@tc_cap_wireless_client1 = "D:/ftpcaps/ftp_wireless_band1.pcapng"
				@tc_cap_wireless_client2 = "D:/ftpcaps/ftp_wireless_band2.pcapng"
				@tc_cap_wireless_client3 = "D:/ftpcaps/ftp_wireless_band3.pcapng"
				@tc_ftp_action           = "get"
		end

		def process

				operate("1��AP����ΪPPPOE��ʽ����������IP������ƣ������ܴ���Ϊ1000kbps") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@sys_page.open_systatus_page(@browser.url)
						wan_addr = @sys_page.get_wan_ip
						wan_type = @sys_page.get_wan_type
						puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{wan_addr}".to_gbk
						puts "WAN״̬��ʾ��������Ϊ��#{wan_type}".to_gbk
						assert_match @ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pppoe }/, wan_type, '�������ʹ���'

						rs = ping(@ts_wan_client_ip)
						assert(rs, "�޷�pingͨftp������")

						@wifi_page  = RouterPageObject::WIFIPage.new(@browser)
						wifi_config = @wifi_page.modify_ssid_mode_pwd(@browser.url, "autotest")
						#������������
						puts "wifi ssid: #{wifi_config[:ssid]},passwd:#{wifi_config[:pwd]}"
						rs1 = @wifi.connect(wifi_config[:ssid], @ts_wifi_flag, wifi_config[:pwd])
						assert rs1, 'wifi����ʧ��'
						rs2 =@wifi.ping(@ts_wan_client_ip)
						assert(rs2, "wiif�ͻ����޷�pingͨftp������")

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

						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
				}

				operate("2�����赱ǰAP�ĵ�ַΪ192.168.100.1����������1�͹���2������1IP��ַΪ192.168.100.100������Ϊ������С��������Ϊ800kbps������2IP��ַΪ192.168.100.101������Ϊ��������������Ϊ800kbps") {
						#����1
						#�����������Ƶ�IP,����ip��Χ,���ñ�����С����
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_pc_ip.split(".").last, @tc_pc_ip.split(".").last, @ts_tag_bandensure, @tc_bandwidth_limit)
						@options_page.add_item
						#�����������Ƶ�IP,����ip��Χ,��������������
						@options_page.set_client_bw(2, @tc_wifi_ip.split(".").last, @tc_wifi_ip.split(".").last, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
				}

				operate("3��PC1��ʼ����") {
						file_dir = File.dirname(@ts_ftp_download)
						#���Ŀ¼�������򴴽�Ŀ¼
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(@ts_ftp_download, ".*")
						Dir.glob("#{file_dir}/*") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rfҪ����
						}

						@tc_ftp_pid1 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						puts "sleep  #{@tc_ftp_time} for ftp download..."
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
				}

				operate("4��PC1����FTP���أ��鿴��������Ϊ����") {
						#ͳ�����߿ͻ�������������������
						puts "=============Statistics wired bandwith first time================="
						rs1            = capinfos_all(@tc_cap_wired_client1)
						banwith_wired1 = rs1[:bit_rate]
						puts "ֻ��ִ�л����߿ͻ�������ʱ��ʵ������Ϊ:#{banwith_wired1}bps".encode("GBK")
						loss_speed1 = (banwith_wired1-@tc_bandwidth_limit_bps)
						puts "���߿ͻ���ʵ��������������С���ϴ������ʵĲ�Ϊ:#{ loss_speed1}bps".encode("GBK")
						#��������������С���ϴ�����ô����ʱ�����ʻ���ڵ����趨��@tc_bandwidth_limit_bps
						if loss_speed1>0
								flag1 = true
						else
								#���û�д��ڻ����@tc_bandwidth_limit_bps,С��@tc_bandwidth_limit_bps��ΧҲά����10%����
								#10%�������
								if loss_speed1.abs/@tc_bandwidth_limit_bps<0.1
										flag1 = true
								else
										puts "��������δ�ﵽ��С���ϴ���#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag1 = false
								end
						end

						#����ʱ����ҪС���ܴ�������
						if banwith_wired1<@tc_bandwidth_total_bps
								flag1_total = true
						else
								#����ͻ������ش����ܴ���ҲӦ��ά����10%���ҵķ�Χ
								if (banwith_wired1-@tc_bandwidth_total_bps).to_f/@tc_bandwidth_limit_bps<0.1
										flag1_total = true
								else
										puts "�������������ܴ����ܴ�������ʧ��!".encode("GBK")
										flag1_total= false
								end
						end
						flag1 = flag1_total&&flag1
						puts "=============Statistics wired bandwith second time================="
						rs2            = capinfos_all(@tc_cap_wired_client2)
						banwith_wired2 = rs2[:bit_rate]
						puts "ֻ��ִ�л����߿ͻ�������ʱ��ʵ������Ϊ:#{banwith_wired2}bps".encode("GBK")
						loss_speed2 = (banwith_wired2-@tc_bandwidth_limit_bps)
						puts "���߿ͻ���ʵ��������������С���ϴ������ʵĲ�Ϊ:#{ loss_speed2}bps".encode("GBK")
						#��������������С���ϴ�����ô����ʱ�����ʻ���ڵ����趨��@tc_bandwidth_limit_bps
						if loss_speed2>0
								flag2 = true
						else
								#���û�д��ڻ����@tc_bandwidth_limit_bps,С��@tc_bandwidth_limit_bps��ΧҲά����10%����
								#10%�������
								if loss_speed2.abs/@tc_bandwidth_limit_bps<0.1
										flag2 = true
								else
										puts "��������δ�ﵽ��С���ϴ���#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag2 = false
								end
						end
						#����ʱ����ҪС���ܴ�������
						if banwith_wired2<@tc_bandwidth_total_bps
								flag2_total = true
						else
								#����ͻ������ش����ܴ���ҲӦ��ά����10%���ҵķ�Χ
								if (banwith_wired2-@tc_bandwidth_total_bps).to_f/@tc_bandwidth_limit_bps<0.1
										flag2_total = true
								else
										puts "�������������ܴ����ܴ�������ʧ��!".encode("GBK")
										flag2_total= false
								end
						end
						flag2 = flag2_total&&flag2

						puts "=============Statistics wired bandwith third time================="
						rs3            = capinfos_all(@tc_cap_wired_client3)
						banwith_wired3 = rs3[:bit_rate]
						puts "ֻ��ִ�л����߿ͻ�������ʱ��ʵ������Ϊ:#{banwith_wired3}bps".encode("GBK")
						loss_speed3 = (banwith_wired3-@tc_bandwidth_limit_bps)
						puts "���߿ͻ���ʵ��������������С���ϴ������ʵĲ�Ϊ:#{loss_speed3}bps".encode("GBK")
						#��������������С���ϴ�����ô����ʱ�����ʻ���ڵ����趨��@tc_bandwidth_limit_bps
						if loss_speed3>0
								flag3 = true
						else
								#���û�д��ڻ����@tc_bandwidth_limit_bps,С��@tc_bandwidth_limit_bps��ΧҲά����10%����
								#10%�������
								if loss_speed3.abs/@tc_bandwidth_limit_bps<0.1
										flag3 = true
								else
										puts "��������δ�ﵽ��С���ϴ���#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag3 = false
								end
						end

						#����ʱ����ҪС���ܴ�������
						if banwith_wired3<@tc_bandwidth_total_bps
								flag3_total = true
						else
								#����ͻ������ش����ܴ���ҲӦ��ά����10%���ҵķ�Χ
								if (banwith_wired3-@tc_bandwidth_total_bps).to_f/@tc_bandwidth_limit_bps<0.1
										flag3_total = true
								else
										puts "�������������ܴ����ܴ�������ʧ��!".encode("GBK")
										flag3_total= false
								end
						end
						flag3        = flag3_total&&flag3
						# ֻҪ����������ʵ�����ص������������������Ƶ�����һ����pass
						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC����δ�ﵽ��С���ϴ���#{@tc_bandwidth_limit_bps}")
				}

				operate("5��PC2����FTP���أ��ٲ鿴��ʱPC1��PC2���������ʸ��Ƕ���") {
						#���߿ͻ��������ص�ͬʱ�����߿ͻ��˽�������
						#���߿ͻ��˱��ϴ���Ϊ@tc_bandwidth_limit_bps�����߿ͻ���������Ϊ@tc_bandwidth_limit_bps
						#�������ͻ���ʵ������ܴﵽ��������Ӧ������ ���߿ͻ�������������СΪtc_bandwidth_limit_bps���һ���ڴ�ֵ�����ͻ�����������֮�����ܴ����༴��
						act_download_speed = @tc_bandwidth_total_bps-@tc_bandwidth_limit_bps
						puts "wireless can use  #{act_download_speed}bps"
						@tc_drb_ftp_pid = @wifi.drb_ftp_client(@ts_wan_client_ip, @ts_ftp_usr, @ts_ftp_pw, @ts_ftp_block, @tc_ftp_action, @ts_ftp_srv_file, @ts_ftp_download)
						puts "wait for download ..."
						sleep @tc_cap_wifi_time #�ȴ������������ʴﵽ�ȶ�ֵ
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
						puts "ִ�л����߿ͻ������ص�ͬʱ��DRB���߿ͻ��˽������أ���ʵ������Ϊ:#{banwith_wireless1}bps".encode("GBK")

						puts "=============Statistics wireless bandwith second time================="
						rs2               = @wifi.capinfos_all(@tc_cap_wireless_client2)
						banwith_wireless2 = rs2[:bit_rate]
						puts "ִ�л����߿ͻ������ص�ͬʱ��DRB���߿ͻ��˽������أ���ʵ������Ϊ:#{banwith_wireless2}bps".encode("GBK")

						puts "=============Statistics wireless bandwith three time================="
						rs3               = @wifi.capinfos_all(@tc_cap_wireless_client3)
						banwith_wireless3 = rs3[:bit_rate]
						puts "ִ�л����߿ͻ������ص�ͬʱ��DRB���߿ͻ��˽������أ���ʵ������Ϊ:#{banwith_wireless3}bps".encode("GBK")
						@tc_wireless_speeds    = [banwith_wireless1, banwith_wireless2, banwith_wireless3]
						@tc_wireless_agv_speed = (banwith_wireless1+banwith_wireless2+banwith_wireless3)/3
						puts "����ƽ����������Ϊ#{@tc_wireless_agv_speed}".to_gbk

						#�ٴ�ץ��ͳ�����߿ͻ�������������������
						#������С������ô������������Ӧ�ô��ڻ����@tc_bandwidth_limit_bps�������С��@tc_bandwidth_limit_bps(0.1�������)
						#���ع�����ץ������
						puts "=============wired client capture first time================="
						tshark_duration(@tc_cap_wired_client4, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap

						puts "=============wired client capture second time================="
						tshark_duration(@tc_cap_wired_client5, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap

						puts "=============wired client capture three time================="
						tshark_duration(@tc_cap_wired_client6, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						puts "=============Statistics wired bandwith fourth time================="
						rs1            = capinfos_all(@tc_cap_wired_client4)
						banwith_wired4 = rs1[:bit_rate]
						puts "�����ͻ���ͬʱ���أ�ִ�л����߿ͻ���ʵ����������: #{banwith_wired4}bps".encode("GBK")
						loss_speed4 = (banwith_wired4-@tc_bandwidth_limit_bps)
						puts "�����ͻ���ͬʱ���أ�ִ�л����߿ͻ���ʵ��������������С���ϴ������ʵĲ�Ϊ:#{loss_speed4}bps".encode("GBK")
						#��������������С���ϴ�����ô����ʱ�����ʻ���ڵ����趨��@tc_bandwidth_limit_bps
						if loss_speed4>0
								flag1 = true
						else
								#���û�д��ڻ����@tc_bandwidth_limit_bps,С��@tc_bandwidth_limit_bps��ΧҲά����10%����
								#10%�������
								if loss_speed4.abs/@tc_bandwidth_limit_bps<0.1
										flag1 = true
								else
										puts "��������δ�ﵽ��С���ϴ���#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag1=false
								end
						end

						puts "=============Statistics wired bandwith fifth time================="
						rs2            = capinfos_all(@tc_cap_wired_client5)
						banwith_wired5 = rs2[:bit_rate]
						puts "�����ͻ���ͬʱ���أ�ִ�л����߿ͻ���ʵ����������: #{banwith_wired5}bps".encode("GBK")
						loss_speed5 = (banwith_wired5-@tc_bandwidth_limit_bps)
						puts "�����ͻ���ͬʱ���أ�ִ�л����߿ͻ���ʵ��������������С���ϴ������ʵĲ�Ϊ:#{loss_speed5}bps".encode("GBK")
						if loss_speed5>0
								flag2 = true
						else
								#10%�������
								if loss_speed5.abs/@tc_bandwidth_limit_bps<0.1
										flag2 = true
								else
										puts "��������δ�ﵽ��С���ϴ���#{@tc_bandwidth_limit_bps}".encode("GBK")
										flag2=false
								end
						end

						puts "=============Statistics wired bandwith sixth time================="
						rs3            = capinfos_all(@tc_cap_wired_client6)
						banwith_wired6 = rs3[:bit_rate]
						puts "�����ͻ���ͬʱ���أ�ִ�л����߿ͻ���ʵ����������: #{banwith_wired6}bps".encode("GBK")
						loss_speed6 = (banwith_wired6-@tc_bandwidth_limit_bps)
						puts "�����ͻ���ͬʱ���أ�ִ�л����߿ͻ���ʵ��������������С���ϴ������ʵĲ�Ϊ:#{loss_speed6}bps".encode("GBK")
						if loss_speed6>0
								flag3 = true
						else
								#10%�������
								if loss_speed6.abs/@tc_bandwidth_limit_bps<0.1
										flag3 = true
								else
										puts "��������δ�ﵽ��С���ϴ���#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag3=false
								end
						end
						rs_rate_flag_wired = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag_wired, "PC����δ�ﵽ��С���ϴ���#{@tc_bandwidth_limit_bps}bps")
						@tc_wired_speeds    = [banwith_wired4, banwith_wired5, banwith_wired6]
						@tc_wired_agv_speed = (banwith_wired4+ banwith_wired5+banwith_wired6)/3
						puts "����ƽ����������Ϊ#{@tc_wired_agv_speed}".to_gbk

						download_speed_total = @tc_wireless_agv_speed+@tc_wired_agv_speed
						puts "���ͻ���ͬʱ����ʵ��������Ϊ#{download_speed_total}bps".encode("GBK")
						puts "�ܴ�������Ϊ#{@tc_bandwidth_total_bps}bps".encode("GBK")

						#�����ͻ����������ʺͲ�����@tc_bandwidth_total_bps���������Ϊ10%
						rs_total = (download_speed_total-@tc_bandwidth_total_bps).abs.to_f/@tc_bandwidth_total_bps
						assert(rs_total<0.1, "�����������������ܴ���#{@tc_bandwidth_total_bps}bps����")
						#ֹͣ��������
						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

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
						@options_page.delete_item_all
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #����

						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.modify_default_ssid(@browser.url)
				}

				operate("3 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
