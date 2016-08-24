#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.22", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                   = DRbObject.new_with_uri(@ts_drb_server)
				#kpbs
				@tc_bandwidth_total     = 1000
				@tc_bandwidth_limit     = 800
				#bps
				@tc_bandwidth_total_bps = 1024000
				@tc_bandwidth_limit_bps = 819200
				@tc_status_time         = 10 #状态页面等待
				@tc_drb_cap_gap         = 10 #无线抓包间隔
				@tc_drb_cap_time        = 120 #抓包前等待
				@tc_lan_time            = 35 #lan设置等待
				@tc_net_time            = 90 #网络重起
				@tc_qos_time            = 3 #QOS下发配置等待
				@tc_cap_gap             = 10 #有线抓包间隔
				@tc_ftp_time            = 90 #抓包前等待
				@tc_scan_time           = 10 #扫描上层AP
				@tc_ap_apply_time       = 30 #上层AP点击应用等待时长
				@tc_wait_time           = 5
				@tc_nic_time            = 10 #网卡启用禁用间隔
				@tc_repeater_time       = 10 #中继成功等待时间
				@tc_reboot_time         = 120
				#要使抓的包保存在一个文件中@tc_output_time必须大于或等于@tc_cap_time
				@tc_output_time         = 10
				@tc_cap_time            = 10 #抓包时长
				# e:/autotest/frame/ftp_client.rb
				@tc_ftp_client          = File.absolute_path("../ftp_client.rb", __FILE__)
				#有线客户端下载
				@tc_cap_wired_client1   = "D:/ftpcaps/ftp_wired_bridge_band1.pcapng"
				@tc_cap_wired_client2   = "D:/ftpcaps/ftp_wired_bridge_band2.pcapng"
				@tc_cap_wired_client3   = "D:/ftpcaps/ftp_wired_bridge_band3.pcapng"

				@tc_cap_wired_client4 = "D:/ftpcaps/ftp_wired_bridge_band4.pcapng"
				@tc_cap_wired_client5 = "D:/ftpcaps/ftp_wired_bridge_band5.pcapng"
				@tc_cap_wired_client6 = "D:/ftpcaps/ftp_wired_bridge_band6.pcapng"

				#DRB有线客户端下载
				@tc_cap_drb_client1   = "D:/ftpcaps/ftp_drb_bridge_band1.pcapng"
				@tc_cap_drb_client2   = "D:/ftpcaps/ftp_drb_bridge_band2.pcapng"
				@tc_cap_drb_client3   = "D:/ftpcaps/ftp_drb_bridge_band3.pcapng"
				@tc_ftp_action        = "get"
				@tc_ap_pw             = "zhilutest"
		end

		def process

				operate("1、AP设置为桥接方式上网，开启IP带宽控制，设置总带宽为1000kbps") {
						#登录上层AP,获取SSID和密码
						@browser_ap = Watir::Browser.new :firefox, :profile => "default"
						@browser_ap.goto(@ts_tag_ap_url)
						@browser_ap.button(id: @ts_ap_login_btn).click
						@ap_frame = @browser_ap.frame(src: @ts_tag_ap_src)
						@ap_frame.link(href: @ts_ap_wireless).wait_until_present(@tc_wait_time)
						@ap_frame.link(href: @ts_ap_wireless).click
						@tc_ap_ssidname = @ap_frame.text_field(name: @ts_tag_ap_ssid).value
						puts "上层AP SSID为:#{@tc_ap_ssidname}".encode("GBK")
						if @ap_frame.select_list(id: @ts_ap_safe_option).selected?(@ts_tag_ap_aes)
								@tc_ap_wifipw = @ap_frame.text_field(name: @ts_tag_ap_pw).value #获取密码
						else
								#如果上层设置加密方式不为@ts_tag_ap_aes侧修改为@ts_tag_ap_aes
								puts "恢复上层AP默认的加密码方式为：#{@ts_tag_ap_aes}".to_gbk
								@ap_frame.select_list(id: @ts_ap_safe_option).select(@ts_tag_ap_aes)
								@ap_frame.text_field(name: @ts_tag_ap_pw).set(@tc_ap_pw) #设置密码
								@ap_frame.button(name: @ts_tag_ap_save).click
								#等配置生效
								puts "waiting for ap wlan config changed..."
								sleep @tc_ap_apply_time
								@tc_ap_wifipw = @tc_ap_pw
						end

						puts "上层AP WIFI密码为:#{@tc_ap_wifipw}".encode("GBK")

						@browser.span(:id => @ts_tag_netset).click
						sleep @tc_wait_time
						@wan_iframe = @browser.iframe(src:@ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')
						#设置为无线接入
						rs1= @wan_iframe.link(id: @ts_tag_wlan_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.link(id: @ts_tag_wlan_link).click
						end

						#选择桥模式
						unless @wan_iframe.radio(id: @ts_tag_bridge_radio).checked?
								@wan_iframe.radio(id: @ts_tag_bridge_radio).click
						end

						flag= false
						5.times do |i|
								#点击扫描
								puts "扫描上层AP SSID 第#{i+1}次".encode("GBK")
								@wan_iframe.button(id: @ts_search_net).click
								sleep @tc_scan_time
								Watir::Wait.until(@tc_scan_time, "扫描出现异常") {
										@wan_iframe.select_list(id: @ts_ssid_list).exists?
								}
								if @wan_iframe.select_list(id: @ts_ssid_list).include?(@tc_ap_ssidname)
										flag = true
										break
								end
						end
						assert(flag, "未扫描到上层设备的SSID:#{@tc_ap_ssidname}")
						#桥接上层AP
						@wan_iframe.select_list(id: @ts_ssid_list).select(@tc_ap_ssidname)
						#设置桥接密码
						@wan_iframe.text_field(id: @ts_net_pwd).set(@tc_ap_wifipw)
						# 设置dut ssid,passwd
						# @wan_iframe.text_field(id:@ts_dut_wifi_ssid)
						# unless @wan_iframe.select_list(id: @ts_ssid_list).select?(@ts_sec_mode_wpa)
						# 		@wan_iframe.select_list(id: @ts_ssid_list).select(@ts_sec_mode_wpa)
						# end
						@wan_iframe.button(id: @ts_tag_sbm).click
						#等待桥接成功
						sleep @tc_repeater_time
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						#点击状态页面有时显示是空白页,增加点击次数
						3.times do
								@browser.refresh
								sleep @tc_wait_time
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								break if @status_iframe.b(:id => @ts_tag_wan_ip).exists?
								sleep @tc_status_time
						end
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						/\n(?<access_type>\w+)/=~wan_type
						puts "WAN状态显示接入类型为：#{access_type}".to_gbk

						assert_match(/#{@ts_tag_ip_regxp}/, wan_addr, '桥接失败未获取到IP地址！')
						assert_match(/#{@ts_wan_mode_bridge}/, access_type, '接入类型错误！')

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@wifi.enable_wired_nic
						sleep @tc_nic_time

						#获取DRB客户端有线网卡信息
						rs_drb_pc         = @wifi.ipconfig(@ts_ipconf_all)
						@tc_drb_wired_ip  = rs_drb_pc[@ts_nicname_three][:ip][0]
						pc_mac_address    = rs_drb_pc[@ts_nicname_three][:mac]
						@tc_drb_wired_mac = pc_mac_address.gsub!("-", ":")
						puts "DRB PC 有线网卡MAC:#{@tc_drb_wired_mac}".encode("GBK")
						puts "DRB PC 有线网卡IP:#{@tc_drb_wired_ip}".encode("GBK")
						@tc_wlan_ftp_filter = "not ether src #{@tc_drb_wired_mac}"

						#执行机有线网卡信息获取
						rs_nic              = ipconfig(@ts_ipconf_all)
						@tc_pc_ip           = rs_nic[@ts_nicname][:ip][0]
						@tc_ftp_filter      = "not ether src #{@ts_pc_mac}"
						puts "pc mac:#{@ts_pc_mac}"
						puts "pc ip:#{@tc_pc_ip}"

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
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_drb_wired_ip.split(".").last)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_drb_wired_ip.split(".").last)
						#选择受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
				}

				operate("3、删除旧的下载内容") {
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
						puts "=============wired client capture third time================="
						tshark_duration(@tc_cap_wired_client3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
				}

				operate("4、PC1进行FTP下载，查看下载速率为多少") {
						#统计有线客户端下载三次下载流量
						puts "=============Statistics wired bandwith first time================="
						rs1            = capinfos_all(@tc_cap_wired_client1)
						banwith_wired1 = rs1[:bit_rate]
						puts "只有执行机有线客户端下载时，实际速率为:#{banwith_wired1}bps".encode("GBK")
						loss_speed1 = (banwith_wired1-@tc_bandwidth_limit_bps)
						puts "有线客户端实际下载速率与最小保障带宽速率的差为:#{loss_speed1}".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed1>0
								flag1 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed1.abs/@tc_bandwidth_limit_bps<0.1
										flag1 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}".encode("GBK")
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
						puts "有线客户端实际下载速率与最小保障带宽速率的差为:#{loss_speed2}bps".encode("GBK")
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
						flag3 = flag3_total&&flag3

						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "PC流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}")
				}

				operate("5、PC2进行FTP下载，再查看此时PC1和PC2的下载速率各是多少") {
						#有线客户端在下载的同时，无线客户端进行下载
						#有线客户端保障带宽为@tc_bandwidth_limit_bps，无线客户端最大带宽为@tc_bandwidth_limit_bps
						#这样无线客户端实际最大能达到下载速率为		@tc_bandwidth_total_bps-@tc_bandwidth_limit_bps
						act_download_speed = @tc_bandwidth_total_bps-@tc_bandwidth_limit_bps
						puts "DRB client can use  #{act_download_speed}bps bandwidth"
						@tc_drb_ftp_pid = @wifi.drb_ftp_client(@ts_wan_client_ip, @ts_ftp_usr, @ts_ftp_pw, @ts_ftp_block, @tc_ftp_action, @ts_ftp_srv_file, @ts_ftp_download)
						puts "sleep #{@tc_drb_cap_time} seconds  for downloading ..."
						sleep @tc_drb_cap_time #等待无线下载速率达到稳定值
						#下载过程中抓包三次
						puts "=============DRB client capture first time================="
						@wifi.tshark_duration(@tc_cap_drb_client1, @ts_nicname_three, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_drb_cap_gap
						puts "=============DRB client capture second time================="
						@wifi.tshark_duration(@tc_cap_drb_client2, @ts_nicname_three, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						sleep @tc_drb_cap_gap
						puts "=============DRB client capture three time================="
						@wifi.tshark_duration(@tc_cap_drb_client3, @ts_nicname_three, @tc_output_time, @tc_cap_time, @tc_wlan_ftp_filter)
						@wifi.drb_stop_ftp_client(@tc_drb_ftp_pid)

						#统计下载三次下载流量
						puts "=============Statistics DRB download speed first time================="
						rs1                 = @wifi.capinfos_all(@tc_cap_drb_client1)
						drb_download_speed1 = rs1[:bit_rate]
						puts "执行机有线客户端下载的同时，DRB有线客户端进行下载，其实际速率为:#{drb_download_speed1}bps".encode("GBK")
						#误差在20%左右,实测带宽-限定带宽/限定带宽
						loss_speed1 = ((drb_download_speed1-act_download_speed).to_f.abs/act_download_speed)
						puts "DRB有线网卡实际下载速率与剩余带宽的差为:#{loss_speed1}bps".encode("GBK")
						#无线客户端下载速率必定会小于受限最大带宽
						flag1 = drb_download_speed1<@tc_bandwidth_limit_bps

						puts "=============Statistics DRB download speed second time================="
						rs2                 = @wifi.capinfos_all(@tc_cap_drb_client2)
						drb_download_speed2 = rs2[:bit_rate]
						puts "执行机有线客户端下载的同时，DRB有线客户端进行下载，其实际速率为:#{drb_download_speed2}bps".encode("GBK")
						#误差在20%左右,实测带宽-限定带宽/限定带宽
						loss_speed2 = ((drb_download_speed2-act_download_speed).to_f.abs/act_download_speed)
						puts "DRB有线网卡实际下载速率与剩余带宽的差为:#{ loss_speed2}bps".encode("GBK")
						flag2 = drb_download_speed2<@tc_bandwidth_limit_bps

						puts "=============Statistics DRB download speed third time================="
						rs3                 = @wifi.capinfos_all(@tc_cap_drb_client3)
						drb_download_speed3 = rs3[:bit_rate]
						puts "执行机有线客户端下载的同时，DRB有线客户端进行下载，其实际速率为:#{drb_download_speed3}bps".encode("GBK")
						#误差在20%左右,实测带宽-限定带宽/限定带宽
						loss_speed3 = ((drb_download_speed3-act_download_speed).to_f.abs/act_download_speed)
						puts "DRB有线网卡实际下载速率与剩余带宽的差为:#{ loss_speed3}bps".encode("GBK")
						flag3        = drb_download_speed3<@tc_bandwidth_limit_bps
						#判断无线下载是否在正常范围
						rs_rate_flag = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag, "无线客户端带宽限制为#{@tc_bandwidth_limit_bps}不生效")
						@tc_wireless_speeds    = [drb_download_speed1, drb_download_speed2, drb_download_speed3]
						@tc_wireless_agv_speed = (drb_download_speed1+drb_download_speed2+drb_download_speed3)/3

						#再次抓包统计有线客户端下载三次下载流量
						#保障最小带宽，那么有线下载速率应该大于或等于@tc_bandwidth_limit_bps，最多略小于@tc_bandwidth_limit_bps(0.2左右误差)
						#下载过程中抓包三次
						puts "=============wired client capture first time================="
						tshark_duration(@tc_cap_wired_client4, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture second time================="
						tshark_duration(@tc_cap_wired_client5, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						sleep @tc_cap_gap
						puts "=============wired client capture third time================="
						tshark_duration(@tc_cap_wired_client6, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
						puts "=============Statistics wired bandwith fourth time================="
						rs1            = capinfos_all(@tc_cap_wired_client4)
						banwith_wired4 = rs1[:bit_rate]
						puts "两个客户端同时下载，执行机有线客户端实际下载速率: #{banwith_wired4}bps".encode("GBK")
						loss_speed4 = (banwith_wired4-@tc_bandwidth_limit_bps)
						puts "两个客户端同时下载，执行机有线客户端实际下载速率与最小保障带宽速率的差为:#{loss_speed4}".encode("GBK")
						#有线网卡设置最小保障带宽，那么下载时的速率会大于等于设定的@tc_bandwidth_limit_bps
						if loss_speed4>0
								flag1 = true
						else
								#如果没有大于或等于@tc_bandwidth_limit_bps,小于@tc_bandwidth_limit_bps范围也维持在10%左右
								#10%左右误差
								if loss_speed4.abs/@tc_bandwidth_limit_bps<0.1
										flag1 = true
								else
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}".encode("GBK")
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
										puts "下载流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}".encode("GBK")
										flag3=false
								end
						end
						rs_rate_flag_wired = (flag1&&flag2||flag3)||(flag1||flag2&&flag3)||(flag1&&flag3||flag2)
						assert(rs_rate_flag_wired, "PC流量未达到最小保障带宽#{@tc_bandwidth_limit_bps}")
						@tc_wired_speeds     = [banwith_wired4, banwith_wired5, banwith_wired6]
						@tc_wired_agv_speeds = (banwith_wired4+ banwith_wired5+banwith_wired6)/3

						download_speed_total = @tc_wireless_agv_speed+@tc_wired_agv_speeds
						puts "两个客户端同时实际总速率为#{download_speed_total}bps".encode("GBK")
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
				}


		end

		def clearup
				operate("1 关闭下载和断开DRB连接") {
						@wifi.enable_wireless_nic
						@browser_ap.close unless @browser_ap.nil?
						sleep @tc_nic_time
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
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						unless @advance_iframe.nil? || @advance_iframe.exists?
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end

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

				operate("3 恢复为默认的接入方式，DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式为网线连接
						rs1         =@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        =false
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag=true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.attribute_value(:checked)

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state == "true"
								dhcp_radio.click
								flag=true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_reboot_time #桥模式返回DHCP模式要重启路由器，而不是只重启网络
						end
				}
		end

}
