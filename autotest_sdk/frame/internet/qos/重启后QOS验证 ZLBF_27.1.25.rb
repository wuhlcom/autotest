#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.25", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                   = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wifi_flag           = "1"
				#kpbs
				@tc_bandwidth_total     = 1000
				@tc_bandwidth_limit     = 800
				#bps
				@tc_bandwidth_total_bps = 1024000
				@tc_bandwidth_limit_bps = 819200

				@tc_cap_wifi_gap      = 10 #无线抓包间隔
				@tc_cap_wifi_time     = 120 #抓包前等待
				@tc_lan_time          = 35 #lan设置
				@tc_net_time          = 60 #网络重起
				@tc_qos_time          = 3 #QOS配置下发
				@tc_cap_gap           = 10 #有线抓包间隔
				@tc_ftp_time          = 90 #有线抓包前等待
				@tc_reboot_time       = 120 #路由器重起
				@tc_relogin_time      = 80 #路由器重起后登录等待
				@tc_wait_time         = 5
				#要使抓的包保存在一个文件中@tc_output_time必须大于或等于@tc_cap_time
				@tc_output_time       = 10
				@tc_cap_time          = 10
				# e:/autotest/frame/ftp_client.rb
				@tc_ftp_client        = File.absolute_path("../ftp_client.rb", __FILE__)
				#有线客户端下载
				@tc_cap_wired_client1 = "D:/ftpcaps/ftp_wired_reboot1.pcapng"
				@tc_cap_wired_client2 = "D:/ftpcaps/ftp_wired_reboot2.pcapng"
				@tc_cap_wired_client3 = "D:/ftpcaps/ftp_wired_reboot3.pcapng"

				@tc_cap_wired_client4    = "D:/ftpcaps/ftp_wired_reboot4.pcapng"
				@tc_cap_wired_client5    = "D:/ftpcaps/ftp_wired_reboot5.pcapng"
				@tc_cap_wired_client6    = "D:/ftpcaps/ftp_wired_reboot6.pcapng"

				#无线客户端下载
				@tc_cap_wireless_client1 = "D:/ftpcaps/ftp_wireless_reboot1.pcapng"
				@tc_cap_wireless_client2 = "D:/ftpcaps/ftp_wireless_reboot2.pcapng"
				@tc_cap_wireless_client3 = "D:/ftpcaps/ftp_wireless_reboot3.pcapng"
				@tc_ftp_action           = "get"
		end

		def process

				operate("1、开启IP带宽控制，设置总带宽为1000kbps") {
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

						#连接无线网卡
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
						ssid_name     = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						puts "wifi ssid: #{ssid_name},passwd:#{@current_pw}"
						rs1 = @wifi.connect(ssid_name, @tc_wifi_flag, @current_pw)
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

				operate("2、假设当前AP的地址为192.168.100.1。开启规则1和规则2，规则1IP地址为192.168.100.100，类型为保障最小带宽，带宽为800kbps；规则2IP地址为192.168.100.101，类型为受限最大带宽，带宽为800kbps") {
						#规则1
						#设置流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_pc_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_pc_ip.split(".").last)
						#选择保障最小带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandensure)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)

						#规则2
						#设置流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_wifi_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_wifi_ip.split(".").last)
						#选择受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
				}

				operate("3、PC1的地址为192.168.100.100，PC2的地址为192.168.100.101,配置QOS规则") {
						#规则1
						#设置流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_pc_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_pc_ip.split(".").last)
						#选择保障最小带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandensure)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)

						#规则2
						#设置流量控制的IP,设置ip范围
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_wifi_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_wifi_ip.split(".").last)
						#选择受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
				}

				operate("4、重启路由器") {
						#找到页面根DIV
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#找到背景根DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#隐藏共享目录页面根DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#隐藏背景根DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#重启路由器
						@browser.span(id: @ts_tag_reboot).click
						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "未提示重启路由器要确认!"
						reboot_confirm.click
						puts "Waitfing for system reboot...."
						sleep @tc_reboot_time
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "跳转到登录页面失败!"
						login_no_default_ip(@browser)
				}

				operate("5、PC1进行FTP下载，查看下载速率为多少") {
						#PC1先进行下载并查看下载速率
						file_dir = File.dirname(@ts_ftp_download)
						#如果目录不存在则创建目录
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(@ts_ftp_download, ".*")
						Dir.glob("#{file_dir}/*") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rf要慎用
						}

						@tc_ftp_pid1 = Process.spawn("ruby #{@tc_ftp_client} #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} #{@tc_ftp_action}", STDERR => :out)
						puts "sleep #{@tc_ftp_time} second for ftp download..."
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

						#统计有线客户端下载三次下载流量
						puts "=============Statistics wired bandwith first time================="
						rs1            = capinfos_all(@tc_cap_wired_client1)
						banwith_wired1 = rs1[:bit_rate]
						puts "有线客户端实际下载速率为#{banwith_wired1}bps".encode("GBK")
						loss_speed1 = (banwith_wired1-@tc_bandwidth_limit_bps)
						puts "有线客户端实际下载与受限最大带宽的差为:#{loss_speed1}bps".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed1>0
								flag1 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed1.abs/@tc_bandwidth_limit_bps<0.1
										flag1 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps"
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
						puts "有线客户端实际下载速率为#{banwith_wired2}bps".encode("GBK")
						loss_speed2 = (banwith_wired2-@tc_bandwidth_limit_bps)
						puts "有线客户端实际下载与受限最大带宽的差为:#{loss_speed2}bps".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed2>0
								flag2 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed2.abs/@tc_bandwidth_limit_bps<0.1
										flag2 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps"
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
						puts "有线客户端实际下载速率为#{banwith_wired3}bps".encode("GBK")
						loss_speed3 = (banwith_wired3-@tc_bandwidth_limit_bps)
						puts "有线客户端实际下载与受限最大带宽的差为:#{loss_speed3}bps".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed3>0
								flag3 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed3.abs/@tc_bandwidth_limit_bps<0.1
										flag3 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}"
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
						flag3 = flag3_total&&flag3

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}")
				}

				operate("6、PC2进行FTP下载，再查看此时PC1和PC2的下载速率各是多少") {
						#有线客户端在下载一段时间后，无线客户端进行下载
						#有线客户端保障带宽为@tc_bandwidth_limit_bps，无线客户端最大带宽为@tc_bandwidth_limit_bps
						#这样无线客户端实际最大能达到下载速率为		@tc_bandwidth_total_bps-@tc_bandwidth_limit_bps
						act_download_speed = @tc_bandwidth_total_bps-@tc_bandwidth_limit_bps
						puts "wireless can use  #{act_download_speed}bps"
						@tc_drb_ftp_pid = @wifi.drb_ftp_client(@ts_wan_client_ip, @ts_ftp_usr, @ts_ftp_pw, @ts_ftp_block, @tc_ftp_action, @ts_ftp_srv_file, @ts_ftp_download)
						puts "sleep #{@tc_cap_wifi_time} seconds for download ..."
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
						puts "有线客户端的同时，无线客户端进行下载，其实际下载速率为#{banwith_wireless1}bps".encode("GBK")
						#误差在20%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((banwith_wireless1-act_download_speed).to_f.abs/act_download_speed)
						puts "无线客户端实际下载速率与剩余带宽的差为:#{loss_speed1}bps".encode("GBK")
						#无线客户端下载速率必定会小于受限最大带宽
						flag1 = banwith_wireless1<@tc_bandwidth_limit_bps

						puts "=============Statistics wireless bandwith second time================="
						rs2               = @wifi.capinfos_all(@tc_cap_wireless_client2)
						banwith_wireless2 = rs2[:bit_rate]
						puts "有线客户端的同时，无线客户端进行下载，其实际下载速率为#{banwith_wireless2}bps".encode("GBK")
						#误差在20%左右,实测带宽-限定带宽/限定带宽
						loss_speed2 = ((banwith_wireless2-act_download_speed).to_f.abs/act_download_speed)
						puts "无线客户端实际下载速率与剩余带宽的差为:#{loss_speed2}bps".encode("GBK")
						flag2 = banwith_wireless2<@tc_bandwidth_limit_bps

						puts "=============Statistics wireless bandwith three time================="
						rs3               = @wifi.capinfos_all(@tc_cap_wireless_client3)
						banwith_wireless3 = rs3[:bit_rate]
						puts "有线客户端的同时，无线客户端进行下载，其实际下载速率为#{banwith_wireless3}bps".encode("GBK")
						#误差在20%左右,实测带宽-限定带宽/限定带宽
						loss_speed3 = ((banwith_wireless3-act_download_speed).to_f.abs/act_download_speed)
						puts "无线客户端实际下载速率与剩余带宽的差为:#{loss_speed3}bps".encode("GBK")
						flag3        = banwith_wireless3<@tc_bandwidth_limit_bps
						#判断无线下载是否在正常范围
						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "无线客户端带宽限制为#{@tc_bandwidth_limit_bps}不生效")
						@tc_wireless_speeds    = [banwith_wireless1, banwith_wireless2, banwith_wireless3]
						@tc_wireless_agv_speed = (banwith_wireless1+banwith_wireless2+banwith_wireless3)/3

						#再次抓包统计有线客户端下载三次下载流量
						#保障最小带宽，那么有线下载速率应该大于或等于@tc_bandwidth_limit_bps，最多略小于@tc_bandwidth_limit_bps(0.2左右误差)
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
						puts "两客户端都在下载时，统计到有线客户端实际下载速率#{banwith_wired4}bps".encode("GBK")
						loss_speed4 = (banwith_wired4-@tc_bandwidth_limit_bps)
						puts "两客户端都在下载时，有线客户端实际下载速率与限制的速率的差为#{loss_speed4}bps".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed4>0
								flag1 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed4.abs/@tc_bandwidth_limit_bps<0.1
										flag1 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps"
										flag1=false
								end
						end

						puts "=============Statistics wired bandwith fifth time================="
						rs2            = capinfos_all(@tc_cap_wired_client5)
						banwith_wired5 = rs2[:bit_rate]
						puts "两客户端都在下载时，统计到有线客户端实际下载速率#{banwith_wired5}bps".encode("GBK")
						loss_speed5 = (banwith_wired5-@tc_bandwidth_limit_bps)
						puts "两客户端都在下载时，有线客户端实际下载速率与限制的速率的差为#{loss_speed5}bps".encode("GBK")
						if loss_speed5>0
								flag2 = true
						else
								#10%左右误差
								if loss_speed5.abs/@tc_bandwidth_limit_bps<0.1
										flag2 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}"
										flag2=false
								end
						end

						puts "=============Statistics wired bandwith sixth time================="
						rs3            = capinfos_all(@tc_cap_wired_client6)
						banwith_wired6 = rs3[:bit_rate]
						puts "两客户端都在下载时，统计到有线客户端实际下载速率#{banwith_wired6}bps".encode("GBK")
						loss_speed6 = (banwith_wired6-@tc_bandwidth_limit_bps)
						puts "两客户端都在下载时，有线客户端实际下载速率与限制的速率的差为#{loss_speed6}bps".encode("GBK")
						if loss_speed6>0
								flag3 = true
						else
								#10%左右误差
								if loss_speed6.abs/@tc_bandwidth_limit_bps<0.1
										flag3 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps"
										flag3=false
								end
						end
						rs_rate_flag_wired = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag_wired, "PC流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}bps")
						@tc_wired_speeds     = [banwith_wired4, banwith_wired5, banwith_wired6]
						@tc_wired_agv_speeds = (banwith_wired4+ banwith_wired5+banwith_wired6)/3

						download_speed_total = @tc_wireless_agv_speed+@tc_wired_agv_speeds
						puts "实际下载总速率为#{download_speed_total}".encode("GBK")
						#两个客户端下载速率和不超过@tc_bandwidth_total_bps
						rs_total = (download_speed_total-@tc_bandwidth_total_bps).abs.to_f/@tc_bandwidth_total_bps
						assert(rs_total<0.2, "下载总流量与设置总带宽#{@tc_bandwidth_total_bps}不符")
						#停止有线下载
						begin
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
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
								if Process.detach(@tc_ftp_pid1).alive? #抓完包后杀死进程
										Process.kill(9, @tc_ftp_pid1)
								end #停止下载
						rescue => ex
								puts "kill #{@tc_ftp_pid1} error:#{ex.message.to_s}"
						end
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid) unless @tc_drb_ftp_pid.nil?
				}

				operate("2 删除QOS配置") {
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
