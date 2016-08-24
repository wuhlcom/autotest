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
				#统计三次
				@tc_cap_reboot_before1  = "D:/ftpcaps/ftp_reboot_before1.pcap"
				@tc_cap_reboot_before2  = "D:/ftpcaps/ftp_reboot_before2.pcap"
				@tc_cap_reboot_before3  = "D:/ftpcaps/ftp_reboot_before3.pcap"
				#统计三次
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

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为DHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						wan_type = sys_page.get_wan_type
						wan_addr = sys_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
				}

				operate("2、添加一条流量控制规则，如IP地址范围输入192.168.1.2，运行模式设置受限最大上行带宽为100kbps；并开启该条规则，保存，查看规则是否可以配置；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
				}

				operate("3、在IP地址为#{@ts_pc_ip}的PC上进行FTP下载") {
						file_dir = File.dirname(@ts_ftp_download)
						#如果目录不存在则创建目录
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(@ts_ftp_download, ".*")
						Dir.glob("#{file_dir}/*") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rf要慎用
						}

						@tc_ftp_pid1 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						sleep @tc_ftp_time #等待ftp客户端下载

						#下载过程中抓包三次
						puts "=============capture first time================="
						tshark_duration(@tc_cap_reboot_before1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_reboot_before2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture three time================="
						tshark_duration(@tc_cap_reboot_before3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1                    = capinfos_all(@tc_cap_reboot_before1)
						banwith_before_reboot1 = rs1[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_reboot_before2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed2 = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_reboot_before3)
						banwith_before_reboot3 = rs3[:bit_rate]
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed3            = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC带宽限制为#{@tc_bandwidth_limit}不生效")
				}

				operate("4、重启DUT，查看步骤1、2,3结果是否仍然同上") {
						@wan_page.reboot
						rs = @wan_page.login_with_exists(@browser.url)
						assert rs, "跳转到登录页面失败!"
						#重新登录
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						####重启后,宽带控制时但开关未打开时下载统计
						file_dir = File.dirname(@ts_ftp_download)
						#如果目录不存在则创建目录
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(@ts_ftp_download, ".*")
						Dir.glob("#{file_dir}/*") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rf要慎用
						}

						@tc_ftp_pid2 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						sleep @tc_ftp_time #等待ftp客户端下载

						#下载过程中抓包三次
						puts "=============capture first time================="
						tshark_duration(@tc_cap_reboot_after1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_reboot_after2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture three time================="
						tshark_duration(@tc_cap_reboot_after3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if !@tc_ftp_pid2.nil? && Process.detach(@tc_ftp_pid2).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid2)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1                    = capinfos_all(@tc_cap_reboot_before1)
						banwith_before_reboot1 = rs1[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_reboot_before2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed2 = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_reboot_before3)
						banwith_before_reboot3 = rs3[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot3}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed3 = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "重启后PC带宽限制为#{@tc_bandwidth_limit}不生效")
				}

		end

		def clearup
				operate("1 停止所有下载进程") {
						####停止所有下载进程
						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end

						begin
								if !@tc_ftp_pid2.nil? && Process.detach(@tc_ftp_pid2).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid2)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid2} error:#{ex.message.to_s}"
						end
				}

				operate("2 恢复默认配置") {
						if @wan_page.login_with_exists(@browser.url)
								rs_login = login_no_default_ip(@browser) #重新登录
								p rs_login[:flag]
								p rs_login[:message]
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存
				}

		end

}
