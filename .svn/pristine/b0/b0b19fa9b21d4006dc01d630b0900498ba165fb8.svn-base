#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.11", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time            = 2
				@tc_ftp_time             = 30
				@tc_cap_gap              = 10
				@tc_cap_wifi_gap         = 30
				@tc_qos_time             = 5
				@tc_net_time             = 40
				@tc_reboot_time          = 120
				#kbps
				@tc_bandwidth_total      = 100000 #10M
				@tc_bandwidth_limit      = 1024 #1M
				#bps
				@tc_bandwidth_total_bps  = 102400000
				@tc_bandwidth_limit_bps  = 1048576
				# e:/Automation/frame/ftp_client.rb
				@tc_ftp_client           = File.absolute_path("../ftp_client.rb", __FILE__)
				@tc_cap_wired_client1    = "D:/ftpcaps/ftp_wired_client1.pcapng"
				@tc_cap_wired_client2    = "D:/ftpcaps/ftp_wired_client2.pcapng"
				@tc_cap_wired_client3    = "D:/ftpcaps/ftp_wired_client3.pcapng"

				@tc_cap_wireless_client1 = "D:/ftpcaps/ftp_wireless_client1.pcapng"
				@tc_cap_wireless_client2 = "D:/ftpcaps/ftp_wireless_client2.pcapng"
				@tc_cap_wireless_client3 = "D:/ftpcaps/ftp_wireless_client3.pcapng"
				#要使抓的包保存在一个文件中@tc_output_time必须大于或等于@tc_cap_time
				@tc_output_time          = 5
				@tc_cap_time             = 5
				rs                       = ipconfig(@ts_ipconf_all)
				@ts_pc_mac               = rs[@ts_nicname][:mac]
				@ts_pc_ip                = rs[@ts_nicname][:ip][0]
				@tc_ftp_filter           = "not ether src #{@ts_pc_mac}"
				@tc_ftp_action           = "get"
				@tc_drb_ftp_pid          = nil
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {
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

						rs = ping(@ts_wan_client_ip)
						assert(rs, "无法ping通ftp服务器")

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "打开内网设置失败!")
						ssid        = @lan_iframe.text_field(id: @ts_tag_ssid).value
						select_list = @lan_iframe.select_list(id: @ts_tag_sec_select_list)

						if select_list.selected?(@ts_sec_mode_wpa)
								passwd=@lan_iframe.text_field(id: @ts_tag_input_pw).value
						else
								puts "恢复默认的加密码方式：#{@ts_sec_mode_wpa}".to_gbk
								select_list.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#等配置生效
								puts "Waiting for wifi config changed..."
								sleep @tc_reboot_time
								passwd = @ts_default_wlan_pw
						end
						puts "当前SSID名为：#{ssid},passwd:#{passwd}".to_gbk
						rs    = @wifi.connect(ssid, @ts_wifi_flag, passwd)
						assert rs, "WIFI连接失败"
						ip_info     = @wifi.netsh_if_ip_show(nicname: @ts_wlan_nicname, type: "addresses")
						@tc_wifi_ip = ip_info[:ip][0]
				}

				operate("2、假设当前LAN口地址为192.168.100.1，设置规则1地址段为192.168,100.2到192.168,100.2，规则为受限最大带宽，带宽为300kbps；设置规则2地址段为192.168,100.3到192.168,100.3，规则为受限最大带宽，带宽为300kbps；设置规则3地址段为192.168,100.4到192.168,100.4，规则为受限最大带宽，带宽为300kbps；启用规以上规则") {
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
						###总开关打开
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
						#设置总带宽
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
						#第一条规则：设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@ts_pc_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@ts_pc_ip.split(".").last)
						#选择最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#第二条规则：设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_wifi_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_wifi_ip.split(".").last)
						#选择最大宽带
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandlimit)
						#限制宽带
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit)

						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
				}

				operate("3、AP下接3台电脑，PC1-PC3地址分别为192.168.100.2-4，首先在PC1上使用FTP下载，然后再用PC2 FTP下载，然后再用PC3 FTP下载，统计当前的PC1，PC2和PC3的流量情况") {
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
						puts "=============wired client capture first time================="
						tshark_duration(@tc_cap_wired_client1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture second time================="
						tshark_duration(@tc_cap_wired_client2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture three time================="
						tshark_duration(@tc_cap_wired_client3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)

						begin
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								assert(false, "captrue packet error:#{ex.message.to_s}")
						end

						#统计下载三次下载流量
						puts "=============Statistics wired bandwith first time================="
						rs1            = capinfos_all(@tc_cap_wired_client1)
						banwith_wired1 = rs1[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_wired1}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_wired1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.1

						puts "=============Statistics wired bandwith second time================="
						rs2            = capinfos_all(@tc_cap_wired_client2)
						banwith_wired2 = rs2[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_wired2}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed2 = ((banwith_wired2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.1

						puts "=============Statistics wired bandwith three time================="
						rs3            = capinfos_all(@tc_cap_wired_client3)
						banwith_wired3 = rs3[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_wired3}bps".encode("GBK")
						#误差在10%左右,实测带宽-限定带宽/限定带宽
						loss_speed3 = ((banwith_wired3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.1

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC带宽限制为#{@tc_bandwidth_limit}不生效")
				}
				operate("客户端2下载") {
						#无线客户端
						rs                  = @wifi.ipconfig("all")
						pc_mac_address      = rs[@ts_wlan_nicname][:mac]
						@ts_wlan_pc_mac     = pc_mac_address.gsub!("-", ":")
						@ts_wlan_pc_ip      = rs[@ts_wlan_nicname][:ip][0]
						@tc_wlan_ftp_filter = "not ether src #{@ts_wlan_pc_mac}"
						# sleep @tc_ftp_time #等待ftp客户端下载
						@tc_drb_ftp_pid     = @wifi.drb_ftp_client(@ts_wan_client_ip, @ts_ftp_usr, @ts_ftp_pw, @ts_ftp_block, @tc_ftp_action, @ts_ftp_srv_file, @ts_ftp_download)
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
						puts "无线客户端实际下载速率为#{banwith_wireless1}bps".encode("GBK")
						#误差在20%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_wireless1-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed1
						flag1 = loss_speed1<=0.2

						puts "=============Statistics wireless bandwith second time================="
						rs2               = @wifi.capinfos_all(@tc_cap_wireless_client2)
						banwith_wireless2 = rs2[:bit_rate]
						puts "无线客户端实际下载速率为#{banwith_wireless2}bps".encode("GBK")
						#误差在20%左右,实测带宽-限定带宽/限定带宽
						loss_speed2 = ((banwith_wireless2-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed2
						flag2 = loss_speed2<=0.2

						puts "=============Statistics wireless bandwith three time================="
						rs3               = @wifi.capinfos_all(@tc_cap_wireless_client3)
						banwith_wireless3 = rs3[:bit_rate]
						puts "无线客户端实际下载速率为#{banwith_wireless3}bps".encode("GBK")
						#误差在20%左右,实测带宽-限定带宽/限定带宽
						loss_speed3 = ((banwith_wireless3-@tc_bandwidth_limit_bps).to_f.abs/@tc_bandwidth_limit_bps)
						puts loss_speed3
						flag3 = loss_speed3<=0.2

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "无线客户端带宽限制为#{@tc_bandwidth_limit}不生效")
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
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
				}

				operate("2 删除qos配置") {
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
