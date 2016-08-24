#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {

		attr = {"id" => "ZLBF_27.1.3", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_wait_time         = 2
				@tc_ftp_time          = 15
				@tc_cap_gap           = 5
				@tc_qos_time          = 5
				@tc_net_time          = 45

				#kpbs 最小值
				# @tc_bandwidth_limit1     = 1 #目前最小值是1，但1有问题的，已经提单将最小值改为512
				@tc_bandwidth_min     = 512
				#bps
				# @tc_bandwidth_limit1_bps = 1024 #1kbps
				@tc_bandwidth_min_bps = 524288 #1kbps

				#kbps 中间值
				@tc_bandwidth_mid     = 2048
				@tc_bandwidth_mid_bps = 2097152 #1024kbps

				#kbps 最大值
				@tc_bandwidth_max     = 100000
				#bps
				@tc_bandwidth_max_bps = 102400000

				# e:/Automation/frame/ftp_client.rb
				@tc_ftp_client        = File.absolute_path("../ftp_client.rb", __FILE__)
				#最小带宽限制时下载，下载三次，至少有两个与带宽限制值差不多则成功
				@tc_cap_path_min_1    = "D:/ftpcaps/ftp_downmin_1.pcapng"
				@tc_cap_path_min_2    = "D:/ftpcaps/ftp_downmin_2.pcapng"
				@tc_cap_path_min_3    = "D:/ftpcaps/ftp_downmin_3.pcapng"

				#带宽限制中的某个值，下载三次，至少有两个与带宽限制值差不多则成功
				@tc_cap_path_mid_1    = "D:/ftpcaps/ftp_downmid_1.pcapng"
				@tc_cap_path_mid_2    = "D:/ftpcaps/ftp_downmid_2.pcapng"
				@tc_cap_path_mid_3    = "D:/ftpcaps/ftp_downmid_3.pcapng"

				#最大带宽限制值，下载三次，至少有两个与带宽限制值差不多则成功
				@tc_cap_path_max_1    = "D:/ftpcaps/ftp_downmax_1.pcapng"
				@tc_cap_path_max_2    = "D:/ftpcaps/ftp_downmax_2.pcapng"
				@tc_cap_path_max_3    = "D:/ftpcaps/ftp_downmax_3.pcapng"
				@tc_output_time       = 5
				@tc_cap_time          = 5
				@tc_ftp_filter        = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action        = "get"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框") {
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
						###打开流量限制开关
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
				}

				#用例描述有问题
				# operate("2、输入申请带宽值为非数字，例如输入字母，汉字，特殊字符，空格等字符，点击保存") {
				operate("2、设置带宽为最小值#{@tc_bandwidth_min}kpbs,查看带宽是否受限") {
						#设置总带宽
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_min)
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
						tshark_duration(@tc_cap_path_min_1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_path_min_2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						puts "=============capture three time================="
						sleep @tc_cap_gap
						tshark_duration(@tc_cap_path_min_3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1               = capinfos_all(@tc_cap_path_min_1)
						banwith_min_rate1 = rs1[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_min_rate1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_min_rate1-@tc_bandwidth_min_bps).to_f.abs/@tc_bandwidth_min_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2               = capinfos_all(@tc_cap_path_min_2)
						banwith_min_rate2 = rs2[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_min_rate2}bps".encode("GBK")
						loss_speed2 = ((banwith_min_rate2-@tc_bandwidth_min_bps).to_f.abs/@tc_bandwidth_min_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3               = capinfos_all(@tc_cap_path_min_3)
						banwith_min_rate3 = rs3[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_min_rate3}bps".encode("GBK")
						loss_speed3 = ((banwith_min_rate3-@tc_bandwidth_min_bps).to_f.abs/@tc_bandwidth_min_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "总带宽限制为#{@tc_bandwidth_min}不生效")
				}

				# operate("3、输入申请带宽值为0，小数，负数，点击保存") {
				operate("3、输入申请带宽值为中间值#{@tc_bandwidth_mid},点击保存") {
						#设置总带宽
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_mid)
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

						@tc_ftp_pid2 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						sleep @tc_ftp_time #等待ftp客户端下载

						#下载过程中抓包三次
						puts "=============capture first time================="
						tshark_duration(@tc_cap_path_mid_1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_path_mid_2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						puts "=============capture three time================="
						sleep @tc_cap_gap
						tshark_duration(@tc_cap_path_mid_3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid2).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid2)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1               = capinfos_all(@tc_cap_path_mid_1)
						banwith_mid_rate1 = rs1[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_mid_rate1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_mid_rate1-@tc_bandwidth_mid_bps).to_f.abs/@tc_bandwidth_mid_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2               = capinfos_all(@tc_cap_path_mid_2)
						banwith_mid_rate2 = rs2[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_mid_rate2}bps".encode("GBK")
						loss_speed2 = ((banwith_mid_rate2-@tc_bandwidth_mid_bps).to_f.abs/@tc_bandwidth_mid_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1
						puts "=============Statistics three time================="
						rs3               = capinfos_all(@tc_cap_path_mid_3)
						banwith_mid_rate3 = rs3[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_mid_rate3}bps".encode("GBK")
						loss_speed3 = ((banwith_mid_rate3-@tc_bandwidth_mid_bps).to_f.abs/@tc_bandwidth_mid_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "总带宽限制为#{@tc_bandwidth_mid}不生效")
				}

				operate("4、输入申请带宽值为最大值#{@tc_bandwidth_max}，点击保存") {
						#设置总带宽
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_max)
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

						@tc_ftp_pid3 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						sleep @tc_ftp_time #等待ftp客户端下载

						#下载过程中抓包三次
						puts "========After QOS configed=================="
						puts "=============capture first time================="
						tshark_duration(@tc_cap_path_max_1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_path_max_1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						puts "=============capture three time================="
						sleep @tc_cap_gap
						tshark_duration(@tc_cap_path_max_1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid3).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid3)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1               = capinfos_all(@tc_cap_path_max_1)
						banwith_max_rate1 = rs1[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_max_rate1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_max_rate1-@tc_bandwidth_max_bps).to_f.abs/@tc_bandwidth_max_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1


						puts "=============Statistics second time================="
						rs2               = capinfos_all(@tc_cap_path_max_1)
						banwith_max_rate2 = rs2[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_max_rate2}bps".encode("GBK")
						loss_speed2 = ((banwith_max_rate2-@tc_bandwidth_max_bps).to_f.abs/@tc_bandwidth_max_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1


						puts "=============Statistics three time================="
						rs3               = capinfos_all(@tc_cap_path_max_1)
						banwith_max_rate3 = rs3[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_max_rate3}bps".encode("GBK")
						loss_speed3 = ((banwith_max_rate3-@tc_bandwidth_max_bps).to_f.abs/@tc_bandwidth_max_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "总带宽限制为#{@tc_bandwidth_max}不生效")
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

						begin
								if Process.detach(@tc_ftp_pid3).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid3)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid3} error:#{ex.message.to_s}"
						end
				}

				operate("2、取消带宽控制") {
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
