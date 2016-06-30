#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.5", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time           = 2
				@tc_ftp_time            = 15
				@tc_cap_gap             = 5
				#kbps
				@tc_bandwidth_total     = 100000
				@tc_bandwidth_limit     = 1024
				#bps
				@tc_bandwidth_limit_bps = 1048576
				# e:/Automation/frame/ftp_client.rb
				@tc_ftp_client          = File.absolute_path("../ftp_client.rb", __FILE__)
				#ͳ������
				@tc_cap_reboot_before1  = "D:/ftpcaps/ftp_reboot_before1.pcap"
				@tc_cap_reboot_before2  = "D:/ftpcaps/ftp_reboot_before2.pcap"
				@tc_cap_reboot_before3  = "D:/ftpcaps/ftp_reboot_before3.pcap"
				#ͳ������
				@tc_cap_reboot_after1   = "D:/ftpcaps/ftp_reboot_after1.pcap"
				@tc_cap_reboot_after2   = "D:/ftpcaps/ftp_reboot_after2.pcap"
				@tc_cap_reboot_after3   = "D:/ftpcaps/ftp_reboot_after3.pcap"
				@tc_output_time         = 5
				@tc_cap_time            = 5
				@tc_ftp_filter          = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action          = "get"
				@tc_qos_ip1             = "1"
				@tc_qos_ip2             = "254"
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ10000kbps��") {
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
				}

				operate("2�����һ���������ƹ�����IP��ַ��Χ����192.168.1.2������ģʽ��������������д���Ϊ100kbps���������������򣬱��棬�鿴�����Ƿ�������ã�") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
				}

				operate("3����IP��ַΪ#{@ts_pc_ip}��PC�Ͻ���FTP����") {
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
						tshark_duration(@tc_cap_reboot_before1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_reboot_before2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture three time================="
						tshark_duration(@tc_cap_reboot_before3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#ͳ������������������
						puts "=============Statistics first time================="
						rs1                    = capinfos_all(@tc_cap_reboot_before1)
						banwith_before_reboot1 = rs1[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot1}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed1 = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_reboot_before2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot2}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed2 = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_reboot_before3)
						banwith_before_reboot3 = rs3[:bit_rate]
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed3            = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC��������Ϊ#{@tc_bandwidth_limit}����Ч")
				}

				operate("4������DUT���鿴����1��2,3����Ƿ���Ȼͬ��") {
						@browser.refresh
						sleep 2
						@wan_page.reboot
						rs = @wan_page.login_with_exists(@browser.url)
						assert rs, "��ת����¼ҳ��ʧ��!"
						#���µ�¼
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
						####������,�������ʱ������δ��ʱ����ͳ��
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
						tshark_duration(@tc_cap_reboot_after1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_reboot_after2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture three time================="
						tshark_duration(@tc_cap_reboot_after3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if !@tc_ftp_pid2.nil? && Process.detach(@tc_ftp_pid2).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid2)
								end #ֹͣ����
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#ͳ������������������
						puts "=============Statistics first time================="
						rs1                    = capinfos_all(@tc_cap_reboot_before1)
						banwith_before_reboot1 = rs1[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot1}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed1 = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_reboot_before2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot2}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed2 = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_reboot_before3)
						banwith_before_reboot3 = rs3[:bit_rate]
						puts "ʵ����������Ϊ#{banwith_before_reboot3}bps".encode("GBK")
						#�����10%����,ʵ�����-�޶�����/�޶�����
						loss_speed3 = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "������PC��������Ϊ#{@tc_bandwidth_limit}����Ч")
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
						if @wan_page.login_with_exists(@browser.url)
								rs_login = login_no_default_ip(@browser) #���µ�¼
								p rs_login[:flag]
								p rs_login[:message]
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #����
				}

		end

}
