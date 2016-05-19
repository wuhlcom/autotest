#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time       = 2
				@tc_ftp_time        = 15
				@tc_cap_gap         = 5
				@tc_qos_time        = 5
				@tc_net_time        = 35
				#kpbs
				@tc_bandwidth_total = 100000
				@tc_bandwidth_limit = 1024
				#bps
				@tc_bandwidth_avrage= 94371840 #90Mbps
				# e:/Automation/frame/ftp_client.rb
				@tc_ftp_client      = File.absolute_path("../ftp_client.rb", __FILE__)
				@tc_cap_path1       = "D:/ftpcaps/ftp_down1.pcap"
				@tc_cap_path2       = "D:/ftpcaps/ftp_down2.pcap"
				@tc_cap_path3       = "D:/ftpcaps/ftp_down3.pcap"
				@tc_cap_path4       = "D:/ftpcaps/ftp_down4.pcap"
				@tc_cap_path5       = "D:/ftpcaps/ftp_down5.pcap"
				@tc_cap_path6       = "D:/ftpcaps/ftp_down6.pcap"
				@tc_output_time     = 5
				@tc_cap_time        = 5
				@tc_ftp_filter      = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action      = "get"
		end

		def process

				operate("1������DUT����ҳ�棬ȥ��ѡ������IP������ơ�ѡ��򣬲鿴�Զ��������������ʣ��������ƹ���ҳ���Ƿ�������ã�") {
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
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						####δ���ÿ������ʱ����ͳ��
						#����ǰ��ɾ���Ѿ����ڵ��ļ�
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
						tshark_duration(@tc_cap_path1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_path2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						puts "=============capture three time================="
						sleep @tc_cap_gap
						tshark_duration(@tc_cap_path3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#ͳ������������������
						puts "=============Statistics first time================="
						rs1   = capinfos_all(@tc_cap_path1)
						puts "ʵ����������Ϊ#{rs1[:bit_rate]}bps".encode("GBK")
						flag1 = rs1[:bit_rate]>@tc_bandwidth_avrage
						puts "=============Statistics second time================="
						rs2   = capinfos_all(@tc_cap_path2)
						puts "ʵ����������Ϊ#{rs2[:bit_rate]}bps".encode("GBK")
						flag2 = rs2[:bit_rate]>@tc_bandwidth_avrage
						puts "=============Statistics three time================="
						rs3          = capinfos_all(@tc_cap_path3)
						puts "ʵ����������Ϊ#{rs3[:bit_rate]}bps".encode("GBK")
						flag3        = rs3[:bit_rate]>@tc_bandwidth_avrage
						#�����������������ʴﵽ90Mbps
						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "·���������쳣")

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
						###
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end

						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
						#����ip��Χ
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@ts_pc_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@ts_pc_ip.split(".").last)
						#ѡ�������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#�ύ
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
						#ȡ����������
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						if qos_sw.checked?
								qos_sw.click
						end
						#�ύ
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time

						####���ÿ������ʱ������δ��ʱ����ͳ��
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
						puts "========After QOS configed=================="
						puts "=============capture first time================="
						tshark_duration(@tc_cap_path4, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_path5, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						puts "=============capture three time================="
						sleep @tc_cap_gap
						tshark_duration(@tc_cap_path6, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid2).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid2)
								end #ֹͣ����
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#ͳ������������������
						puts "=============Statistics first time================="
						rs1   = capinfos_all(@tc_cap_path4)
						puts "ʵ����������Ϊ#{rs1[:bit_rate]}bps".encode("GBK")
						flag4 = rs1[:bit_rate]>@tc_bandwidth_avrage
						puts "=============Statistics second time================="
						rs2   = capinfos_all(@tc_cap_path5)
						puts "ʵ����������Ϊ#{rs2[:bit_rate]}bps".encode("GBK")
						flag5 = rs2[:bit_rate]>@tc_bandwidth_avrage
						puts "=============Statistics three time================="
						rs3   = capinfos_all(@tc_cap_path6)
						puts "ʵ����������Ϊ#{rs3[:bit_rate]}bps".encode("GBK")
						flag6 = rs3[:bit_rate]>@tc_bandwidth_avrage

						rs_rate_flag = (flag4&&flag5||flag6)||(flag4||flag5&&flag6)||(flag4&&flag6||flag5)
						assert(rs_rate_flag, "�رմ�����ƣ�·���������쳣")
				}

				operate("2������DUT���鿴����1����Ƿ���Ч��") {
						#�˽ű�������,�����������Ѿ�������
				}

		end

		def clearup

				operate("1 ֹͣ����") {
						####ֹͣ�������ؽ���
						begin
								if Process.detach(@tc_ftp_pid1).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid1)
								end #ֹͣ����
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end

						begin
								if Process.detach(@tc_ftp_pid2).alive? #ץ�����ɱ������
										Process.kill(9, @tc_ftp_pid2)
								end #ֹͣ����
						rescue => ex
								puts "kill #{@tc_ftp_pid2} error:#{ex.message.to_s}"
						end
				}
				operate("2 �رմ������") {
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
