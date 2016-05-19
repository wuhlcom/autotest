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
				@tc_net_time            = 45
				#kbps
				@tc_bandwidth_total     = 100000
				@tc_bandwidth_limit     = 1024
				#bps
				@tc_bandwidth_limit_bps = 1048576
				@tc_bandwidth_total_bps = 102400000
				# e:/Automation/frame/ftp_client.rb
				@tc_ftp_client          = File.absolute_path("../ftp_client.rb", __FILE__)
				@tc_cap_limit_before1   = "D:/ftpcaps/ftp_limit_before1.pcap"
				@tc_cap_limit_before2   = "D:/ftpcaps/ftp_limit_before2.pcap"
				@tc_cap_limit_before3   = "D:/ftpcaps/ftp_limit_before3.pcap"

				@tc_cap_total_before1     = "D:/ftpcaps/ftp_total_before1.pcap"
				@tc_cap_total_before2     = "D:/ftpcaps/ftp_total_before2.pcap"
				@tc_cap_total_before3     = "D:/ftpcaps/ftp_total_before3.pcap"
				@tc_output_time           = 5
				@tc_cap_time              = 5
				@tc_ftp_filter            = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action            = "get"
				@tc_tag_client_bandsw     = "button"
				@tc_tag_client_bandsw_on  = "on"
				@tc_tag_client_bandsw_off = "off"
				# rs                        = ipconfig(@ts_ipconf_all)
				# @ts_pc_ip                 = rs[@ts_nicname][:ip][0]
				@tc_qos_ip1               = "1"
				@tc_qos_ip2               = "254"
		end

		def process

				operate("1、进入DUT 带宽控制页面，查看带宽大小，流量控制规则页面是否出现，是否可以设置；") {
						@browser.span(id: @ts_tag_netset).click
						@wan_iframe= @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开WAN设置失败")
						#设置为dhcp接入
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
				}

				# operate("2、勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps；添加一条流量控制规则，如IP地址范围输入192.168.1.2，运行模式设置受限最大上行带宽为100kbps；对该条规则进行关闭操作，保存，查看规则是否可以配置；") {
				operate("2、勾选“开启IP带宽控制”选项框，设置申请带宽为100000kbps；添加一条流量控制规则，如IP地址范围输入#{@ts_pc_ip}，运行模式设置受限最大带宽为1000kbps") {
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
						###勾选流量控制开头
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
						#设置总流量
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
						#设置流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_qos_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_qos_ip2)
						#选择最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)

						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
						####配置宽带控制时但开关未打开时下载统计
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
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
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
						loss_speed1            = ((banwith_before_reboot1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2                    = capinfos_all(@tc_cap_limit_before2)
						banwith_before_reboot2 = rs2[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed2            = ((banwith_before_reboot2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3                    = capinfos_all(@tc_cap_limit_before3)
						banwith_before_reboot3 = rs3[:bit_rate]
						puts "实际下载速率为#{banwith_before_reboot3}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed3            = ((banwith_before_reboot3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC带宽限制为#{@tc_bandwidth_limit}不生效")
				}

				# operate("3、在IP地址为192.168.1.2的PC上运行FTP下载") {
				operate("3、关闭在IP地址为#{@ts_pc_ip}的带宽限制，流量与总带宽差不多") {
						#取消客户端带宽限制
						client_bandsw = @advance_iframe.table(class_name: @ts_tag_band_tb).trs[1][4].button(type: @tc_tag_client_bandsw)
						if client_bandsw.class_name==@tc_tag_client_bandsw_on
								client_bandsw.click
								#提交
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_qos_time
						end

						####配置宽带控制时但开关未打开时下载统计
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
								if Process.detach(@tc_ftp_pid2).alive? #抓完包后杀死进程
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
						loss_speed1           = ((banwith_total_before1-@tc_bandwidth_total_bps).to_f.abs/@tc_bandwidth_total_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============close client band limit Statistics second time================="
						rs2                   = capinfos_all(@tc_cap_total_before2)
						banwith_total_before2 = rs2[:bit_rate]
						puts "实际下载速率为#{banwith_total_before2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed2           = ((banwith_total_before2-@tc_bandwidth_total_bps).to_f.abs/@tc_bandwidth_total_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============close client band limit Statistics three time================="
						rs3                   = capinfos_all(@tc_cap_total_before3)
						banwith_total_before3 = rs3[:bit_rate]
						puts "实际下载速率为#{banwith_total_before3}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed3           = ((banwith_total_before3-@tc_bandwidth_total_bps).to_f.abs/@tc_bandwidth_total_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "关闭PC带宽限制功能，PC带宽仍被限制")
						#=end
				}

				operate("4、重启DUT，查看步骤1、2,3结果是否仍然同上") {
						#在其它用例已经有重启测试这里不实现重启
				}


		end

		def clearup

				operate("1 停止下载") {
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

				operate("2 恢复默认配置") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

						#打开流量管理
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end

						#打开流量控制
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end

						#删除规则1
						@advance_iframe.td(text: "1").parent.tds[5].link.click

						####关闭总开关
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						if qos_sw.checked?
								qos_sw.click
								#提交
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_qos_time
						end
				}
		end

}
