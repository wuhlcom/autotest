#
# description:
# 测试默认状态下流量
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.1", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_ftp_time        = 15
				@tc_cap_gap         = 5
				@tc_qos_time        = 5
				#kpbs
				@tc_bandwidth_total = 100000
				@tc_bandwidth_limit = 1024
				#bps
				@tc_bandwidth_avrage= 83886080 #80Mbps
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

						####未配置宽带控制时下载统计
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw #关闭带宽控制
						@options_page.save_traffic #提交
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
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics first time================="
						rs1   = capinfos_all(@tc_cap_path1)
						puts "实际下载速率为#{rs1[:bit_rate]}bps".encode("GBK")
						#只要大于90M就认为是正常
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
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存
				}
		end

}
