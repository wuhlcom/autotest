#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {

		attr = {"id" => "ZLBF_27.1.8", "level" => "P2", "auto" => "n"}

		def prepare
				#kbps
				@tc_bandwidth_total     = 100000
				@tc_bandwidth_limit     = 1024
				#bps
				@tc_bandwidth_limit_bps = 1048576
				#ͳ������
				@tc_cap_before1         = "D:/ftpcaps/lanip_change_before1.pcap"
				@tc_cap_before2         = "D:/ftpcaps/lanip_change_before2.pcap"
				@tc_cap_before3         = "D:/ftpcaps/lanip_change_before3.pcap"
				#ͳ������
				@tc_cap_after1          = "D:/ftpcaps/lanip_change_after1.pcap"
				@tc_cap_after2          = "D:/ftpcaps/lanip_change_after2.pcap"
				@tc_cap_after3          = "D:/ftpcaps/lanip_change_after3.pcap"
				@tc_output_time         = 5
				@tc_cap_time            = 5
				@tc_cap_gap             = 5
				@tc_ftp_time            = 15
				@tc_ftp_client          = File.absolute_path("../ftp_client.rb", __FILE__)
				@tc_ftp_filter          = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action          = "get"
				@tc_lan_ip1             = "192.168.123.1"
				@tc_qos_ip1             = "1"
				@tc_qos_ip2             = "254"
		end

		def process

				operate("1������DUT �������ҳ�棬·����ΪDHCPC����,��ѡ������IP������ơ�ѡ��������������Ϊ10000kbps") {
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

						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
				}

				operate("2�����赱ǰLAN��IP��ַΪ192.168.1.1�����ù���1�ĵ�ַ��Ϊ192.168.1.2��192.168.1.5������������޴���Ϊ100kbps�������汾������") {
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
				}

				operate("3���½ӵ��Ե�IP��ַΪ192.168.1.2������FTP����") {
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
						puts "=============capture first time================="
						tshark_duration(@tc_cap_before1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_before2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture three time================="
						tshark_duration(@tc_cap_before3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#ͳ������������������
						puts "=============Statistics first time================="
						rs1                    = capinfos_all(@tc_cap_before1)
						banwith_before_reboot1 = rs1[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot1}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed1 = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_before2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot2}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed2 = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_before3)
						banwith_before_reboot3 = rs3[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot3}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed3 = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC��������Ϊ#{@tc_bandwidth_limit}����Ч")
				}

				operate("4���ֱ��޸ĵ��Ե�IP��ַΪ192.168.1.3��192.168.1.5������FTP����") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.lan_ip_config(@tc_lan_ip1, @browser.url)

						file_dir = File.dirname(@ts_ftp_download)
						#���Ŀ¼�������򴴽�Ŀ¼
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(@ts_ftp_download, ".*")
						Dir.glob("#{file_dir}/*") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rfҪ����
						}

						@tc_ftp_pid2 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						sleep @tc_ftp_time #�ȴ�ftp�ͻ�������

						#���ع�����ץ������
						puts "=============capture first time================="
						tshark_duration(@tc_cap_after1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_after2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture three time================="
						tshark_duration(@tc_cap_after3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if !@tc_ftp_pid2.nil? && Process.detach(@tc_ftp_pid2).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid2)
								end #ֹͣ����
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#ͳ������������������
						puts "=============Statistics first time================="
						rs1                    = capinfos_all(@tc_cap_after1)
						banwith_before_reboot1 = rs1[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot1}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed1 = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_after2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot2}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed2 = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_after3)
						banwith_before_reboot3 = rs3[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot3}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed3 = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "�޸�LAN IP��ַ��PC��������Ϊ#{@tc_bandwidth_limit}����Ч")
				}

		end

		def clearup

				operate("1 ֹͣ�������ؽ���") {
						####ֹͣ�������ؽ���
						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end

						begin
								if !@tc_ftp_pid2.nil? && Process.detach(@tc_ftp_pid2).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid2)
								end #ֹͣ����
						rescue => ex
								puts "kill #{@tc_ftp_pid2} error:#{ex.message.to_s}"
						end
				}

				operate("2 �ָ�Ĭ������") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						if @lan_page.login_with_exists(@browser.url)
								rs_login = login_no_default_ip(@browser) #���µ�¼
								p rs_login[:flag]
								p rs_login[:message]
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.recover_factory(@browser.url)

						# #�������ʽ�ظ��������ã���ֹ·������¼ʧ�������޷��ָ�Ĭ������
						# lan_ip = ipconfig[@ts_nicname][:gateway][0]
						# telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
						# exp_ralink_init
				}

		end

}
