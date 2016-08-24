#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.4", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time           = 2
				@tc_ftp_time            = 15
				@tc_cap_gap             = 5
				@tc_qos_time            = 5
				#kbps
				@tc_bandwidth_total     = 10000
				@tc_bandwidth_limit     = 1024
				#bps
				@tc_bandwidth_limit_bps = 1048576
				@tc_bandwidth_total_bps = 10240000
				# e:/Automation/frame/ftp_client.rb
				@tc_ftp_client          = File.absolute_path("../ftp_client.rb", __FILE__)
				@tc_cap_limit_before1   = "D:/ftpcaps/ftp_limit_before1.pcap"
				@tc_cap_limit_before2   = "D:/ftpcaps/ftp_limit_before2.pcap"
				@tc_cap_limit_before3   = "D:/ftpcaps/ftp_limit_before3.pcap"

				@tc_cap_total_before1 = "D:/ftpcaps/ftp_total_before1.pcap"
				@tc_cap_total_before2 = "D:/ftpcaps/ftp_total_before2.pcap"
				@tc_cap_total_before3 = "D:/ftpcaps/ftp_total_before3.pcap"
				@tc_output_time       = 5
				@tc_cap_time          = 5
				@tc_ftp_filter        = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action        = "get"
				@tc_qos_ip1           = "1"
				@tc_qos_ip2           = "254"
				@tc_item_use          = "失效"
		end

		def process

				operate("1、进入DUT 带宽控制页面，查看带宽大小，流量控制规则页面是否出现，是否可以设置；") {
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

				operate("2、勾选“开启IP带宽控制”选项框，设置申请带宽为100000kbps；添加一条流量控制规则，如IP地址范围输入#{@ts_pc_ip}，运行模式设置受限最大带宽为#{@tc_bandwidth_limit}kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存

						####配置宽带控制时,下载统计
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
						tshark_duration(@tc_cap_limit_before1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_limit_before2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture three time================="
						tshark_duration(@tc_cap_limit_before3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1                    = capinfos_all(@tc_cap_limit_before1)
						banwith_before_reboot1 = rs1[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_limit_before2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed2 = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_limit_before3)
						banwith_before_reboot3 = rs3[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot3}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed3 = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3        = loss_speed3<=0.1
						#只要实际下载流量两次以上符合流量控制规则就认为正常
						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC带宽限制为#{@tc_bandwidth_limit}不生效")
				}

				operate("3、关闭在IP地址为#{@ts_pc_ip}的带宽限制，流量与总带宽差不多") {
						#取消客户端带宽限制
						@options_page.bw_status0=@tc_item_use
						@options_page.save_traffic #保存
						sleep @tc_qos_time
						####下载统计
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
						puts "=============close client band limit capture first time================="
						tshark_duration(@tc_cap_total_before1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============close client band limit capture second time================="
						tshark_duration(@tc_cap_total_before2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============close client band limit capture three time================="
						tshark_duration(@tc_cap_total_before3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if !@tc_ftp_pid2.nil? && Process.detach(@tc_ftp_pid2).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid2)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "============= close client band limit Statistics first time================="
						rs1                   = capinfos_all(@tc_cap_total_before1)
						banwith_total_before1 = rs1[:bit_rate]
						puts "实际下载速率为#{banwith_total_before1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_total_before1-@tc_bandwidth_total_bps).to_f.abs/@tc_bandwidth_total_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============close client band limit Statistics second time================="
						rs2                   = capinfos_all(@tc_cap_total_before2)
						banwith_total_before2 = rs2[:bit_rate]
						puts "实际下载速率为#{banwith_total_before2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed2 = ((banwith_total_before2-@tc_bandwidth_total_bps).to_f.abs/@tc_bandwidth_total_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============close client band limit Statistics three time================="
						rs3                   = capinfos_all(@tc_cap_total_before3)
						banwith_total_before3 = rs3[:bit_rate]
						puts "实际下载速率为#{banwith_total_before3}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed3 = ((banwith_total_before3-@tc_bandwidth_total_bps).to_f.abs/@tc_bandwidth_total_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "关闭PC带宽限制功能，PC带宽仍被限制")
				}

				operate("4、重启DUT，查看步骤1、2,3结果是否仍然同上") {
						#在其它用例已经有重启测试这里不实现重启
				}


		end

		def clearup

				operate("1 停止下载") {
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
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存
				}
		end

}
