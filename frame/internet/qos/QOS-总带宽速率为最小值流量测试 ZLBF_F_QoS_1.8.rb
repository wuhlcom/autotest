#
# description:
# 总带宽限制应该限制WAN口入方向的流量，而不是LAN侧流量
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {

		attr = {"id" => "ZLBF_27.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_ftp_time       = 15
				@tc_cap_gap        = 5
				#bps
				@ts_bw_min_bps     = @ts_bw_min.to_i*1024
				@tc_ftp_client     = File.absolute_path("../ftp_client.rb", __FILE__)
				#最大带宽限制值，下载三次，至少有两个与带宽限制值差不多则成功
				@tc_cap_path_max_1 = "D:/ftpcaps/ftp_downmax_1.pcapng"
				@tc_cap_path_max_2 = "D:/ftpcaps/ftp_downmax_2.pcapng"
				@tc_cap_path_max_3 = "D:/ftpcaps/ftp_downmax_3.pcapng"
				@tc_output_time    = 5
				@tc_cap_time       = 5
				@tc_ftp_filter     = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action     = "get"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框") {
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

						#打开高级设置
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
				}

				operate("2、输入申请带宽值为最大值#{@ts_bw_min}，点击保存") {
						@options_page.set_total_bw(@ts_bw_min) #设置总带宽
						@options_page.save_traffic #保存
				}

				operate("3、客户端进行下载测试") {
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
						loss_speed1 = ((banwith_max_rate1-@ts_bw_min_bps).to_f.abs/@ts_bw_min_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics second time================="
						rs2               = capinfos_all(@tc_cap_path_max_1)
						banwith_max_rate2 = rs2[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_max_rate2}bps".encode("GBK")
						loss_speed2 = ((banwith_max_rate2-@ts_bw_min_bps).to_f.abs/@ts_bw_min_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics three time================="
						rs3               = capinfos_all(@tc_cap_path_max_1)
						banwith_max_rate3 = rs3[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_max_rate3}bps".encode("GBK")
						loss_speed3 = ((banwith_max_rate3-@ts_bw_min_bps).to_f.abs/@ts_bw_min_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "总带宽限制为#{@ts_bw_min}不生效")
				}

		end

		def clearup

				operate("1 停止下载") {
						####停止所有下载进程
						begin
								if !@tc_ftp_pid3.nil? && Process.detach(@tc_ftp_pid3).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid3)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid3} error:#{ex.message.to_s}"
						end
				}

				operate("2、取消带宽控制") {
						if @options_page.total_bw?
								@options_page.unselect_traffic_sw
								@options_page.save_traffic(10)
						else
								@options_page = RouterPageObject::OptionsPage.new(@browser)
								@options_page.select_traffic_ctl(@browser.url)
								@options_page.unselect_traffic_sw
								@options_page.save_traffic(10)
						end
				}
		end

}
