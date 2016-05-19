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

				operate("1、进入DUT管理页面，去勾选“开启IP带宽控制”选项框，查看自动带宽，上下行速率，流量控制规则页面是否可以设置；") {
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

						####未配置宽带控制时下载统计
						#下载前先删除已经存在的文件
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
						tshark_duration(@tc_cap_path1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============capture second time================="
						tshark_duration(@tc_cap_path2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						puts "=============capture three time================="
						sleep @tc_cap_gap
						tshark_duration(@tc_cap_path3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1   = capinfos_all(@tc_cap_path1)
						puts "实际下载速率为#{rs1[:bit_rate]}bps".encode("GBK")
						flag1 = rs1[:bit_rate]>@tc_bandwidth_avrage
						puts "=============Statistics second time================="
						rs2   = capinfos_all(@tc_cap_path2)
						puts "实际下载速率为#{rs2[:bit_rate]}bps".encode("GBK")
						flag2 = rs2[:bit_rate]>@tc_bandwidth_avrage
						puts "=============Statistics three time================="
						rs3          = capinfos_all(@tc_cap_path3)
						puts "实际下载速率为#{rs3[:bit_rate]}bps".encode("GBK")
						flag3        = rs3[:bit_rate]>@tc_bandwidth_avrage
						#至少有两次下载速率达到90Mbps
						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "路由器带宽异常")

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
						###
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end

						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
						#设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@ts_pc_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@ts_pc_ip.split(".").last)
						#选择最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
						#取消流量控制
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						if qos_sw.checked?
								qos_sw.click
						end
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
								if Process.detach(@tc_ftp_pid2).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid2)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1   = capinfos_all(@tc_cap_path4)
						puts "实际下载速率为#{rs1[:bit_rate]}bps".encode("GBK")
						flag4 = rs1[:bit_rate]>@tc_bandwidth_avrage
						puts "=============Statistics second time================="
						rs2   = capinfos_all(@tc_cap_path5)
						puts "实际下载速率为#{rs2[:bit_rate]}bps".encode("GBK")
						flag5 = rs2[:bit_rate]>@tc_bandwidth_avrage
						puts "=============Statistics three time================="
						rs3   = capinfos_all(@tc_cap_path6)
						puts "实际下载速率为#{rs3[:bit_rate]}bps".encode("GBK")
						flag6 = rs3[:bit_rate]>@tc_bandwidth_avrage

						rs_rate_flag = (flag4&&flag5||flag6)||(flag4||flag5&&flag6)||(flag4&&flag6||flag5)
						assert(rs_rate_flag, "关闭带宽控制，路由器下载异常")
				}

				operate("2、重启DUT，查看步骤1结果是否生效。") {
						#此脚本不重启,其它用例中已经有重启
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
				operate("2 关闭带宽控制") {
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
