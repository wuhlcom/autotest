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
				@tc_bandwidth_limit1     = 400
				@tc_bandwidth_limit2     = 800
				#bps
				@tc_bandwidth_total_bps  = 1024000
				@tc_bandwidth_limit1_bps = 409600
				@tc_bandwidth_limit2_bps = 819200

				@tc_cap_wifi_gap         = 10
				@tc_lan_time             = 35
				@tc_net_time             = 60
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
						#检查能否ping通ftp服务器
						rs = ping(@ts_wan_client_ip)
						#如果ping不通，检查路由器接入方式是否为dhcp
						if !rs
								#查看WAN是否为DHCP接入，判断是否
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, '打开WAN状态失败！')
								wan_addr = @status_iframe.b(:id => @tag_wan_ip).parent.text
								wan_type = @status_iframe.b(:id => @tag_wan_type).parent.text
								#如果不是DHCP接入，修改为DHCP方式
								if wan_type !~ /#{@ts_wan_mode_dhcp}/
										@browser.span(:id => @ts_tag_netset).click
										@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
										assert(@wan_iframe.exists?, '打开外网设置失败！')

										rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
										unless rs1=~/#{@ts_tag_select_state}/
												@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
										end

										dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
										dhcp_radio_state = dhcp_radio.checked?
										unless dhcp_radio_state
												dhcp_radio.click
												@wan_iframe.button(:id, @ts_tag_sbm).click
												puts "waiting for net rebooting..."
												sleep @tc_net_time
										end
										rs2 = ping(@ts_wan_client_ip)
										assert(rs2, 'FTP服务器无法ping通请检查路由器线路状态')
										if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
												@browser.execute_script(@ts_close_div)
										end
								else
										assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
								end
						end

						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, '打开内网设置失败！')
						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "恢复默认的加密码方式：#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#等配置生效
								puts "Waiting for wifi config changed..."
								sleep @tc_lan_time
						end
						@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
						@current_pw   = @passwd_input.value
						puts "wifi passwd:#{@current_pw}"
						ssid_name = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						rs1       = @wifi.connect(ssid_name, @tc_wifi_flag, @current_pw)
						assert rs1, 'wifi连接失败'
						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif客户端无法ping通路由器'

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

						#关闭lan设置
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
						####开启总开关
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
						####设置总带宽
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
				}

				operate("2、假设当前LAN口地址为192.168.100.1，设置规则1地址段为192.168,100.2到192.168,100.2，规则为受限最大带宽，带宽为800kbps；设置规则2地址段为192.168,100.3到192.168,100.3，规则为受限最大带宽，带宽为400kbps，点击保存") {
						#规则1
						#设置流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_wifi_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_wifi_ip.split(".").last)
						#选择受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit1)

						#规则2
						#设置流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_pc_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_pc_ip.split(".").last)
						#选择受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit2)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
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
						@tc_wireless_ave_speed=(banwith_wireless1+banwith_wireless2+banwith_wireless3)/3

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
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
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
						flag = loss_speed_total<=0.3
						assert(flag, "客户端下载速率总和大于总带宽限制")
				}


		end

		def clearup

				operate("关闭下载和断开无线连接") {
						@wifi.netsh_disc_all #断开wifi连接
						####停止所有下载进程
						begin
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
				}

				operate("删除流量控制配置") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						# unless @advance_iframe.nil? || @advance_iframe.exists?
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						# end

						#打开流量管理
						bandwith        = @advance_iframe.link(id: @ts_tag_bandwidth)
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
						#删除规则2
						@advance_iframe.td(text: "2").parent.tds[5].link.click

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
