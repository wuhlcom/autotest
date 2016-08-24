#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.19", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                   = DRbObject.new_with_uri(@ts_drb_server)
				#kpbs
				@tc_bandwidth_total     = 1000 #总带宽
				@tc_bandwidth_limit     = 800
				#bps
				@tc_bandwidth_total_bps = 1024000
				@tc_bandwidth_limit_bps = 819200
				@tc_status_time         = 10 #状态页面等待
				@tc_cap_wifi_gap        = 10 #无线抓包间隔
				@tc_cap_wifi_time       = 120 #抓包前等待
				@tc_lan_time            = 35 #lan设置等待
				@tc_net_time            = 90 #网络重起
				@tc_qos_time            = 3 #QOS下发配置等待
				@tc_cap_gap             = 10 #有线抓包间隔
				@tc_ftp_time            = 90 #抓包前等待
				@tc_wait_time           = 5
				#要使抓的包保存在一个文件中@tc_output_time必须大于或等于@tc_cap_time
				@tc_output_time         = 10
				@tc_cap_time            = 10 #抓包时长
				# e:/autotest/frame/ftp_client.rb
				@tc_ftp_client          = File.absolute_path("../ftp_client.rb", __FILE__)
				#有线客户端下载
				@tc_cap_wired_client1   = "D:/ftpcaps/ftp_wired_band1.pcapng"
				@tc_cap_wired_client2   = "D:/ftpcaps/ftp_wired_band2.pcapng"
				@tc_cap_wired_client3   = "D:/ftpcaps/ftp_wired_band3.pcapng"

				@tc_cap_wired_client4    = "D:/ftpcaps/ftp_wired_band4.pcapng"
				@tc_cap_wired_client5    = "D:/ftpcaps/ftp_wired_band5.pcapng"
				@tc_cap_wired_client6    = "D:/ftpcaps/ftp_wired_band6.pcapng"

				#无线客户端下载
				@tc_cap_wireless_client1 = "D:/ftpcaps/ftp_wireless_band1.pcapng"
				@tc_cap_wireless_client2 = "D:/ftpcaps/ftp_wireless_band2.pcapng"
				@tc_cap_wireless_client3 = "D:/ftpcaps/ftp_wireless_band3.pcapng"
				@tc_ftp_action           = "get"
		end

		def process

				operate("1、AP设置为PPPOE方式上网，开启IP带宽控制，设置总带宽为1000kbps") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@sys_page.open_systatus_page(@browser.url)
						wan_addr = @sys_page.get_wan_ip
						wan_type = @sys_page.get_wan_type
						puts "WAN状态显示获取的IP地址为：#{wan_addr}".to_gbk
						puts "WAN状态显示接入类型为：#{wan_type}".to_gbk
						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe }/, wan_type, '接入类型错误！'

						rs = ping(@ts_wan_client_ip)
						assert(rs, "无法ping通ftp服务器")

						@wifi_page  = RouterPageObject::WIFIPage.new(@browser)
						wifi_config = @wifi_page.modify_ssid_mode_pwd(@browser.url, "autotest")
						#连接无线网卡
						puts "wifi ssid: #{wifi_config[:ssid]},passwd:#{wifi_config[:pwd]}"
						rs1 = @wifi.connect(wifi_config[:ssid], @ts_wifi_flag, wifi_config[:pwd])
						assert rs1, 'wifi连接失败'
						rs2 =@wifi.ping(@ts_wan_client_ip)
						assert(rs2, "wiif客户端无法ping通ftp服务器")

						#获取无线网卡信息
						rs_wifi         = @wifi.ipconfig(@ts_ipconf_all)
						@tc_wifi_ip     = rs_wifi[@ts_wlan_nicname][:ip][0]
						pc_mac_address  = rs_wifi[@ts_wlan_nicname][:mac]
						@tc_wlan_pc_mac = pc_mac_address.gsub!("-", ":")
						puts "wlan pc mac:#{@tc_wlan_pc_mac}"
						puts "wlan pc ip:#{@tc_wifi_ip}"
						@tc_wlan_ftp_filter = "not ether src #{@tc_wlan_pc_mac}"

						#有线网卡信息获取
						rs_nic              = ipconfig(@ts_ipconf_all)
						@tc_pc_ip           = rs_nic[@ts_nicname][:ip][0]
						@tc_ftp_filter      = "not ether src #{@ts_pc_mac}"
						puts "pc mac:#{@ts_pc_mac}"
						puts "pc ip:#{@tc_pc_ip}"

						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
				}

				operate("2、假设当前AP的地址为192.168.100.1。开启规则1和规则2，规则1IP地址为192.168.100.100，类型为保障最小带宽，带宽为800kbps；规则2IP地址为192.168.100.101，类型为受限最大带宽，带宽为800kbps") {
						#规则1
						#设置流量控制的IP,设置ip范围,设置保障最小带宽
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_pc_ip.split(".").last, @tc_pc_ip.split(".").last, @ts_tag_bandensure, @tc_bandwidth_limit)
						@options_page.add_item
						#设置流量控制的IP,设置ip范围,设置受限最大带宽
						@options_page.set_client_bw(2, @tc_wifi_ip.split(".").last, @tc_wifi_ip.split(".").last, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
				}

				operate("3、PC1开始下载") {
						file_dir = File.dirname(@ts_ftp_download)
						#如果目录不存在则创建目录
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(@ts_ftp_download, ".*")
						Dir.glob("#{file_dir}/*") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rf要慎用
						}

						@tc_ftp_pid1 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						puts "sleep  #{@tc_ftp_time} for ftp download..."
						sleep @tc_ftp_time #等待ftp客户端下载

						#下载过程中抓包三次
						puts "=============wired client capture first time================="
						tshark_duration(@tc_cap_wired_client1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture second time================="
						tshark_duration(@tc_cap_wired_client2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture three time================="
						tshark_duration(@tc_cap_wired_client3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
				}

				operate("4、PC1进行FTP下载，查看下载速率为多少") {
						#统计有线客户端下载三次下载流量
						puts "=============Statistics wired bandwith first time================="
						rs1            = capinfos_all(@tc_cap_wired_client1)
						banwith_wired1 = rs1[:bit_rate]
						puts "只有执行机有线客户端下载时，实际速率为:#{banwith_wired1}bps".encode("GBK")
						loss_speed1 = (banwith_wired1-@tc_bandwidth_limit_bps)
						puts "有线客户端实际下载速率与最小保障带宽速率的差为:#{ loss_speed1}bps".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed1>0
								flag1 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed1.abs/@tc_bandwidth_limit_bps<0.1
										flag1 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag1 = false
								end
						end

						#下载时带宽要小于总带宽限制
						if banwith_wired1<@tc_bandwidth_total_bps
								flag1_total = true
						else
								#如果客户端下载大于总带宽，也应该维持在10%左右的范围
								if (banwith_wired1-@tc_bandwidth_total_bps).to_f/@tc_bandwidth_limit_bps<0.1
										flag1_total = true
								else
										puts "下载流量大于总带宽，总带宽限制失败!".encode("GBK")
										flag1_total= false
								end
						end
						flag1 = flag1_total&&flag1
						puts "=============Statistics wired bandwith second time================="
						rs2            = capinfos_all(@tc_cap_wired_client2)
						banwith_wired2 = rs2[:bit_rate]
						puts "只有执行机有线客户端下载时，实际速率为:#{banwith_wired2}bps".encode("GBK")
						loss_speed2 = (banwith_wired2-@tc_bandwidth_limit_bps)
						puts "有线客户端实际下载速率与最小保障带宽速率的差为:#{ loss_speed2}bps".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed2>0
								flag2 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed2.abs/@tc_bandwidth_limit_bps<0.1
										flag2 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag2 = false
								end
						end
						#下载时带宽要小于总带宽限制
						if banwith_wired2<@tc_bandwidth_total_bps
								flag2_total = true
						else
								#如果客户端下载大于总带宽，也应该维持在10%左右的范围
								if (banwith_wired2-@tc_bandwidth_total_bps).to_f/@tc_bandwidth_limit_bps<0.1
										flag2_total = true
								else
										puts "下载流量大于总带宽，总带宽限制失败!".encode("GBK")
										flag2_total= false
								end
						end
						flag2 = flag2_total&&flag2

						puts "=============Statistics wired bandwith third time================="
						rs3            = capinfos_all(@tc_cap_wired_client3)
						banwith_wired3 = rs3[:bit_rate]
						puts "只有执行机有线客户端下载时，实际速率为:#{banwith_wired3}bps".encode("GBK")
						loss_speed3 = (banwith_wired3-@tc_bandwidth_limit_bps)
						puts "有线客户端实际下载速率与最小保障带宽速率的差为:#{loss_speed3}bps".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed3>0
								flag3 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed3.abs/@tc_bandwidth_limit_bps<0.1
										flag3 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag3 = false
								end
						end

						#下载时带宽要小于总带宽限制
						if banwith_wired3<@tc_bandwidth_total_bps
								flag3_total = true
						else
								#如果客户端下载大于总带宽，也应该维持在10%左右的范围
								if (banwith_wired3-@tc_bandwidth_total_bps).to_f/@tc_bandwidth_limit_bps<0.1
										flag3_total = true
								else
										puts "下载流量大于总带宽，总带宽限制失败!".encode("GBK")
										flag3_total= false
								end
						end
						flag3        = flag3_total&&flag3
						# 只要有两次以上实际下载的流量满足与流量控制的设置一致则pass
						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}")
				}

				operate("5、PC2进行FTP下载，再查看此时PC1和PC2的下载速率各是多少") {
						#有线客户端在下载的同时，无线客户端进行下载
						#有线客户端保障带宽为@tc_bandwidth_limit_bps，无线客户端最大带宽为@tc_bandwidth_limit_bps
						#这样两客户端实际最大能达到下载速率应该满足 有线客户端下载速率最小为tc_bandwidth_limit_bps左右或大于此值且两客户端下载速率之和与总带宽差不多即可
						act_download_speed = @tc_bandwidth_total_bps-@tc_bandwidth_limit_bps
						puts "wireless can use  #{act_download_speed}bps"
						@tc_drb_ftp_pid = @wifi.drb_ftp_client(@ts_wan_client_ip, @ts_ftp_usr, @ts_ftp_pw, @ts_ftp_block, @tc_ftp_action, @ts_ftp_srv_file, @ts_ftp_download)
						puts "wait for download ..."
						sleep @tc_cap_wifi_time #等待无线下载速率达到稳定值
						#下载过程中抓包三次
						puts "=============wireless client capture first time================="
						@wifi.tshark_duration(@tc_cap_wireless_client1, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_cap_wifi_gap
						puts "=============wireless client capture second time================="
						@wifi.tshark_duration(@tc_cap_wireless_client2, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_cap_wifi_gap
						puts "=============wireless client capture three time================="
						@wifi.tshark_duration(@tc_cap_wireless_client3, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid)

						#统计下载三次下载流量
						puts "=============Statistics wireless bandwith first time================="
						rs1               = @wifi.capinfos_all(@tc_cap_wireless_client1)
						banwith_wireless1 = rs1[:bit_rate]
						puts "执行机有线客户端下载的同时，DRB无线客户端进行下载，其实际速率为:#{banwith_wireless1}bps".encode("GBK")

						puts "=============Statistics wireless bandwith second time================="
						rs2               = @wifi.capinfos_all(@tc_cap_wireless_client2)
						banwith_wireless2 = rs2[:bit_rate]
						puts "执行机有线客户端下载的同时，DRB无线客户端进行下载，其实际速率为:#{banwith_wireless2}bps".encode("GBK")

						puts "=============Statistics wireless bandwith three time================="
						rs3               = @wifi.capinfos_all(@tc_cap_wireless_client3)
						banwith_wireless3 = rs3[:bit_rate]
						puts "执行机有线客户端下载的同时，DRB无线客户端进行下载，其实际速率为:#{banwith_wireless3}bps".encode("GBK")
						@tc_wireless_speeds    = [banwith_wireless1, banwith_wireless2, banwith_wireless3]
						@tc_wireless_agv_speed = (banwith_wireless1+banwith_wireless2+banwith_wireless3)/3
						puts "无线平均下载速率为#{@tc_wireless_agv_speed}".to_gbk

						#再次抓包统计有线客户端下载三次下载流量
						#保障最小带宽，那么有线下载速率应该大于或等于@tc_bandwidth_limit_bps，最多略小于@tc_bandwidth_limit_bps(0.1左右误差)
						#下载过程中抓包三次
						puts "=============wired client capture first time================="
						tshark_duration(@tc_cap_wired_client4, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap

						puts "=============wired client capture second time================="
						tshark_duration(@tc_cap_wired_client5, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap

						puts "=============wired client capture three time================="
						tshark_duration(@tc_cap_wired_client6, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						puts "=============Statistics wired bandwith fourth time================="
						rs1            = capinfos_all(@tc_cap_wired_client4)
						banwith_wired4 = rs1[:bit_rate]
						puts "两个客户端同时下载，执行机有线客户端实际下载速率: #{banwith_wired4}bps".encode("GBK")
						loss_speed4 = (banwith_wired4-@tc_bandwidth_limit_bps)
						puts "两个客户端同时下载，执行机有线客户端实际下载速率与最小保障带宽速率的差为:#{loss_speed4}bps".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed4>0
								flag1 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed4.abs/@tc_bandwidth_limit_bps<0.1
										flag1 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag1=false
								end
						end

						puts "=============Statistics wired bandwith fifth time================="
						rs2            = capinfos_all(@tc_cap_wired_client5)
						banwith_wired5 = rs2[:bit_rate]
						puts "两个客户端同时下载，执行机有线客户端实际下载速率: #{banwith_wired5}bps".encode("GBK")
						loss_speed5 = (banwith_wired5-@tc_bandwidth_limit_bps)
						puts "两个客户端同时下载，执行机有线客户端实际下载速率与最小保障带宽速率的差为:#{loss_speed5}bps".encode("GBK")
						if loss_speed5>0
								flag2 = true
						else
								#10%左右误差
								if loss_speed5.abs/@tc_bandwidth_limit_bps<0.1
										flag2 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}".encode("GBK")
										flag2=false
								end
						end

						puts "=============Statistics wired bandwith sixth time================="
						rs3            = capinfos_all(@tc_cap_wired_client6)
						banwith_wired6 = rs3[:bit_rate]
						puts "两个客户端同时下载，执行机有线客户端实际下载速率: #{banwith_wired6}bps".encode("GBK")
						loss_speed6 = (banwith_wired6-@tc_bandwidth_limit_bps)
						puts "两个客户端同时下载，执行机有线客户端实际下载速率与最小保障带宽速率的差为:#{loss_speed6}bps".encode("GBK")
						if loss_speed6>0
								flag3 = true
						else
								#10%左右误差
								if loss_speed6.abs/@tc_bandwidth_limit_bps<0.1
										flag3 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps".encode("GBK")
										flag3=false
								end
						end
						rs_rate_flag_wired = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag_wired, "PC流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps")
						@tc_wired_speeds    = [banwith_wired4, banwith_wired5, banwith_wired6]
						@tc_wired_agv_speed = (banwith_wired4+ banwith_wired5+banwith_wired6)/3
						puts "有线平均下载速率为#{@tc_wired_agv_speed}".to_gbk

						download_speed_total = @tc_wireless_agv_speed+@tc_wired_agv_speed
						puts "两客户端同时下载实际总速率为#{download_speed_total}bps".encode("GBK")
						puts "总带宽限制为#{@tc_bandwidth_total_bps}bps".encode("GBK")

						#两个客户端下载速率和不超过@tc_bandwidth_total_bps，设置误差为10%
						rs_total = (download_speed_total-@tc_bandwidth_total_bps).abs.to_f/@tc_bandwidth_total_bps
						assert(rs_total<0.1, "下载总流量与设置总带宽#{@tc_bandwidth_total_bps}bps不符")
						#停止有线下载
						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#停止无线下载
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
						@wifi.netsh_disc_all #断开无线连接
				}

		end

		def clearup

				operate("1 关闭下载和断开无线连接") {
						@wifi.netsh_disc_all #断开wifi连接
						####停止所有下载进程
						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
				}

				operate("2 删除流量控制配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.delete_item_all
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存

						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.modify_default_ssid(@browser.url)
				}

				operate("3 恢复为默认的接入方式，DHCP接入") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
