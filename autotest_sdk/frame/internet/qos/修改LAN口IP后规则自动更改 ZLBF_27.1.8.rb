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
				#统计三次
				@tc_cap_before1         = "D:/ftpcaps/lanip_change_before1.pcap"
				@tc_cap_before2         = "D:/ftpcaps/lanip_change_before2.pcap"
				@tc_cap_before3         = "D:/ftpcaps/lanip_change_before3.pcap"
				#统计三次
				@tc_cap_after1          = "D:/ftpcaps/lanip_change_after1.pcap"
				@tc_cap_after2          = "D:/ftpcaps/lanip_change_after2.pcap"
				@tc_cap_after3          = "D:/ftpcaps/lanip_change_after3.pcap"
				@tc_output_time         = 5
				@tc_qos_time            = 3
				@tc_cap_time            = 5
				@tc_cap_gap             = 5
				@tc_ftp_time            = 15
				@tc_reboot_time         = 120
				@tc_relogin_time        = 80
				@tc_wait_time            = 5
				@tc_ftp_client          = File.absolute_path("../ftp_client.rb", __FILE__)
				@tc_ftp_filter          = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action          = "get"
				@tc_lan_ip1             = "192.168.123.1"
				@tc_qos_ip1             = "1"
				@tc_qos_ip2             = "254"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为#{@tc_bandwidth_total}kbps") {
						#打开高级设置
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						#打开流量管理
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end
						sleep @tc_wait_time #流量管理界面响应较慢，增加延迟
						#打开流量控制
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end
						sleep @tc_wait_time #流量管理界面响应较慢，增加延迟
						####开启总开关
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
						####设置总带宽
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
				}

				operate("2、假设当前LAN口IP地址为192.168.1.1，设置规则1的地址段为192.168.1.2到192.168.1.10，设置最大受限带宽为100kbps，并保存本条规则") {
						#设置流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_qos_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_qos_ip2)
						#选择最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
				}

				operate("3、下接电脑的IP地址为192.168.1.2，进行FTP下载，验证流量是否受限为100kbps") {
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
						tshark_duration(@tc_cap_before1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_before2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture three time================="
						tshark_duration(@tc_cap_before3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1                    = capinfos_all(@tc_cap_before1)
						banwith_before_reboot1 = rs1[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1            = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_before2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed2            = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_before3)
						banwith_before_reboot3 = rs3[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot3}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed3            = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC带宽限制为#{@tc_bandwidth_limit}不生效")
				}

				operate("4、修改LAN口IP地址为192.168.2.1，修改完成后，查看规则1的地址段是否自动变更为192.168.2.2到192.168.2.10，其他数据不变") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")
						@lan_iframe.text_field(:id, @ts_tag_lanip).set(@tc_lan_ip1)
						@lan_iframe.button(:id, @ts_tag_sbm).click
						puts "等待路由器重起...".encode("GBK")
						sleep @tc_reboot_time
						rs = @browser.text_field(:name, @usr_text_id).wait_until_present(@tc_relogin_time)
						assert rs, '跳转到登录页面失败！'
						#重新登录路由器
						login_no_default_ip(@browser)
						@browser.span(:id => @ts_tag_lan).click
				}

				operate("5、下接电脑的IP地址为192.168.2.2，进行FTP下载，验证流量是否受限为100kbps") {
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
						tshark_duration(@tc_cap_after1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_after2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture three time================="
						tshark_duration(@tc_cap_after3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid2).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid2)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1                    = capinfos_all(@tc_cap_after1)
						banwith_before_reboot1 = rs1[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1            = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_after2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed2            = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_after3)
						banwith_before_reboot3 = rs3[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot3}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed3            = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "修改LAN IP地址后，PC带宽限制为#{@tc_bandwidth_limit}不生效")
				}


		end

		def clearup

				operate("1 停止所有下载进程") {
						####停止所有下载进程
						begin
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end

						begin
								if Process.detach(@tc_ftp_pid2).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid2)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid2} error:#{ex.message.to_s}"
						end
				}
				operate("恢复默认配置") {
						login_recover(@browser, @ts_default_ip)
				}
		end

}
