#
# description:
#总带宽限制不是很准
#限制总带宽为1000，实际可达1200-1400
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.12", "level" => "P4", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                    = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wifi_flag            = "1"
				#kpbs
				@tc_bandwidth_total      = 1000
				@tc_bandwidth_limit1     = 800
				@tc_bandwidth_limit2     = 400
				#bps
				@tc_bandwidth_total_bps  = 1024000
				@tc_bandwidth_limit1_bps = 409600
				@tc_bandwidth_limit2_bps = 819200

				@tc_cap_wifi_gap         = 10
				@tc_qos_time             = 3
				@tc_cap_gap              = 5
				@tc_ftp_time             = 30
				@tc_wait_time            = 5
				#要使抓的包保存在一个文件中@tc_output_time必须大于或等于@tc_cap_time
				@tc_output_time          = 5
				@tc_cap_time             = 5
				# e:/autotest/frame/ftp_client.rb
				@tc_ftp_client           = File.absolute_path("../ftp_client.rb", __FILE__)
				#有线客户端下载
				@tc_cap_wired_client1    = "D:/ftpcaps/ftp_wired_download1.pcapng"
				@tc_cap_wired_client2    = "D:/ftpcaps/ftp_wired_download2.pcapng"
				@tc_cap_wired_client3    = "D:/ftpcaps/ftp_wired_download3.pcapng"
				#无线客户端下载
				@tc_cap_wireless_client1 = "D:/ftpcaps/ftp_wireless_download1.pcapng"
				@tc_cap_wireless_client2 = "D:/ftpcaps/ftp_wireless_download2.pcapng"
				@tc_cap_wireless_client3 = "D:/ftpcaps/ftp_wireless_download3.pcapng"
				@tc_ftp_action           = "get"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {
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

						#连接无线网卡
						@wifi_page  = RouterPageObject::WIFIPage.new(@browser)
						wifi_config = @wifi_page.modify_ssid_mode_pwd(@browser.url, "autotest")
						#连接无线网卡
						puts "wifi ssid: #{wifi_config[:ssid]},passwd:#{wifi_config[:pwd]}"
						rs1 = @wifi.connect(wifi_config[:ssid], @ts_wifi_flag, wifi_config[:pwd])
						assert rs1, 'wifi连接失败'
						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wifi客户端无法ping通路由器'

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
				}

				operate("2、假设当前LAN口地址为192.168.100.1，设置规则1地址段为192.168,100.2到192.168,100.2，规则为受限最大带宽，带宽为800kbps；设置规则2地址段为192.168,100.3到192.168,100.3，规则为受限最大带宽，带宽为400kbps，点击保存") {
						#打开高级设置
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
						#规则1
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_pc_ip.split(".").last, @tc_pc_ip.split(".").last, @ts_tag_bandlimit, @tc_bandwidth_limit1)
						#规则2
						@options_page.add_item
						@options_page.set_client_bw(2, @tc_wifi_ip.split(".").last, @tc_wifi_ip.split(".").last, @ts_tag_bandlimit, @tc_bandwidth_limit2)
						@options_page.save_traffic #保存
				}

				operate("3、AP下接2台电脑，PC1-PC2地址分别为192.168.100.2-3，PC1和PC2进行下载，统计当前的PC1，PC2和PC3的流量情况") {
						#无线客户端开始下载
						@tc_drb_ftp_pid = @wifi.drb_ftp_client(@ts_wan_client_ip, @ts_ftp_usr, @ts_ftp_pw, @ts_ftp_block, @tc_ftp_action, @ts_ftp_srv_file, @ts_ftp_download)
						#设置下载目录
						file_dir        = File.dirname(@ts_ftp_download)
						#如果目录不存在则创建目录
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(@ts_ftp_download, ".*")
						Dir.glob("#{file_dir}/*") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rf要慎用
						}
						#有线客户端下载
						@tc_ftp_pid1 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						sleep @tc_ftp_time #等待ftp客户端下载稳定后再开始抓包统计
				}

				operate("4 统计下载带宽是否符合总带宽限定") {
						#统计无线下载带宽
						#下载过程中抓包三次
						puts "=============wireless client capture first time================="
						@wifi.tshark_duration(@tc_cap_wireless_client1, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_cap_wifi_gap
						puts "=============wireless client capture second time================="
						@wifi.tshark_duration(@tc_cap_wireless_client2, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_cap_wifi_gap
						puts "=============wireless client capture third time================="
						@wifi.tshark_duration(@tc_cap_wireless_client3, @ts_wlan_nicname, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid)

						#统计下载三次下载流量
						puts "=============Statistics wireless bandwith first time================="
						rs1               = @wifi.capinfos_all(@tc_cap_wireless_client1)
						banwith_wireless1 = rs1[:bit_rate]
						puts "无线客户端实际下载速率为#{banwith_wireless1}bps".encode("GBK")

						puts "=============Statistics wireless bandwith second time================="
						rs2               = @wifi.capinfos_all(@tc_cap_wireless_client2)
						banwith_wireless2 = rs2[:bit_rate]
						puts "无线客户端实际下载速率为#{banwith_wireless2}bps".encode("GBK")

						puts "=============Statistics wireless bandwith third time================="
						rs3               = @wifi.capinfos_all(@tc_cap_wireless_client3)
						banwith_wireless3 = rs3[:bit_rate]
						puts "无线客户端实际下载速率为#{banwith_wireless3}bps".encode("GBK")
						@tc_wireless_speeds   = [banwith_wireless1, banwith_wireless2, banwith_wireless3]
						@tc_wireless_ave_speed= (banwith_wireless1+banwith_wireless2+banwith_wireless3)/3

						#下载过程中抓包三次
						puts "=============wired client capture first time================="
						tshark_duration(@tc_cap_wired_client1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture second time================="
						tshark_duration(@tc_cap_wired_client2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture third time================="
						tshark_duration(@tc_cap_wired_client3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						#统计下载三次下载流量
						puts "=============Statistics wired bandwith first time================="
						rs1            = capinfos_all(@tc_cap_wired_client1)
						banwith_wired1 = rs1[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_wired1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						# loss_speed1 = ((banwith_wired1-@tc_bandwidth_limit2_bps).to_f.abs/@tc_bandwidth_limit2_bps)

						puts "=============Statistics wired bandwith second time================="
						rs2            = capinfos_all(@tc_cap_wired_client2)
						banwith_wired2 = rs2[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_wired2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						# loss_speed2 = ((banwith_wired2-@tc_bandwidth_limit2_bps).to_f.abs/@tc_bandwidth_limit2_bps)

						puts "=============Statistics wired bandwith third time================="
						rs3            = capinfos_all(@tc_cap_wired_client3)
						banwith_wired3 = rs3[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_wired3}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						# loss_speed3 = ((banwith_wired3-@tc_bandwidth_limit2_bps).to_f.abs/@tc_bandwidth_limit2_bps)
						@tc_wired_speeds   = [banwith_wired1, banwith_wired2, banwith_wired3]
						@tc_wired_ave_speed=(banwith_wired1+banwith_wired2+banwith_wired3)/3

						#停止无线下载
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
						#停止有线下载
						begin
								if !@tc_ftp_pid1.nil? && Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end
						# assert(rs_rate_flag_wired, "PC带宽限制为#{@tc_bandwidth_limit2}不生效")

						#有线和无线客户端下载最大速率与申请的带宽差不多，误差10%
						total_downspeed = @tc_wireless_ave_speed+@tc_wired_ave_speed
						puts "total download bandwidth  #{total_downspeed}bps"
						puts "total download bandwidth limited #{@tc_bandwidth_total_bps}bps"
						loss_speed_total = ((total_downspeed-@tc_bandwidth_total_bps).to_f.abs/@tc_bandwidth_total_bps)
						puts loss_speed_total
						flag = loss_speed_total<=0.1
						assert(flag, "客户端下载速率总和大于总带宽限制")
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
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存

						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.modify_default_ssid(@browser.url)
				}
		end

}
