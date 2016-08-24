#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.59", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_dumpcap       = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_wait_time     = 2
				@tc_clone_time    = 10
				@tc_net_time      = 15
				@tc_net_wait_time = 60
				@tc_mac1          = "00:13:00:00:00:01"
				@tc_mac2          = "00:13:00:00:00:02"
				@tc_ping_num      = 300
				@tc_task          = "ping.exe"
		end

		def process

				operate("1、在BAS启用抓包；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						puts "设置接入方式为PPTP".to_gbk
						@options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_addr = @systatus_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'PPTP获取IP地址失败！'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！'
				}

				operate("2.选择“使用计算机MAC地址”查看地址文本框中显示MAC地址是否与登录主机的MAC地址一致，保存；") {
						@options_page.select_clone_mac
						@options_page.clone_open
						@options_page.clone_btn
						@options_page.save_clone
						puts "克隆操作后，查看是否克隆成功".to_gbk

						@systatus_page.open_systatus_page(@browser.url)
						wan_mac = @systatus_page.get_wan_mac.upcase
						puts "查询到克隆后WAN MAC为#{wan_mac}".to_gbk
						puts "被克隆的网卡MAC地址为#{@ts_pc_mac}".to_gbk
						assert_equal(@ts_pc_mac, wan_mac, "MAC地址克隆失败!")
				}

				operate("3.在LAN PC端ping 服务器IP地址，抓包查看源MAC是否与主机的MAC地址一致；") {
						#抓包查看是否报文携带克隆后的mac
						#一边ping一边抓包
						tc_cap_filter = "ether src host #{@ts_pc_mac}"
						puts "Capture filter:#{tc_cap_filter}"
						capfile = "#{@ts_cap_packetpath}/mac_clone_pptp_pc.pcap"
						begin
								thr = Thread.new { ping(@ts_web, @tc_ping_num) }
								sleep @tc_wait_time
								@tc_dumpcap.dumpcap_a(capfile, @ts_server_lannic, @ts_cap_timeout, tc_cap_filter)
								packets = @tc_dumpcap.capinfos(capfile)
								puts "Capture packets num:#{packets}"
								assert(packets.to_i>0, "MAC地址克隆失败,未抓到克隆后的包!")
						rescue => e
								puts e.message.to_s
						ensure
								thr.kill if thr.alive? #强制杀死
								taskkill(@tc_task) if tasklist_exists?(@tc_task)
						end
				}

				operate("4.选择“使用指定MAC地址”，输入设置的MAC地址，保存；") {
						puts "输入MAC：#{@tc_mac1} 进行克隆".to_gbk
						@options_page.set_clone_mac(@tc_mac1,@browser.url)
						#查看克隆后mac地址信息
						@systatus_page.open_systatus_page(@browser.url)
						wan_mac = @systatus_page.get_wan_mac
						puts "查询到克隆后WAN MAC为#{wan_mac}".to_gbk
						assert_equal(@tc_mac1.upcase, wan_mac.upcase, "输入#{@tc_mac1}克隆后,克隆失败!")
				}

				operate("5.在LAN PC端ping 服务器IP地址，抓包查看源MAC与设置的MAC地址一致；") {
						# 抓包查看是否报文携带克隆后的mac
						# 一边ping一边抓包
						tc_cap_filter = "ether src host #{@tc_mac1}"
						puts "Capture filter:#{tc_cap_filter}"
						capfile = "#{@ts_cap_packetpath}/mac_clone_pptp_input.pcap"
						begin
								thr = Thread.new { ping(@ts_web, @tc_ping_num) }
								sleep @tc_wait_time
								@tc_dumpcap.dumpcap_a(capfile, @ts_server_lannic, @ts_cap_timeout, tc_cap_filter)
								packets = @tc_dumpcap.capinfos(capfile)
								puts "Capture packets num:#{packets}"
								assert(packets.to_i>0, "MAC地址克隆失败,未抓到克隆后的包!")
						rescue => e
								puts e.message.to_s
						ensure
								thr.kill if thr.alive? #强制杀死
								taskkill(@tc_task) if tasklist_exists?(@tc_task)
						end
				}

				operate("6、选择“使用缺省地址”，保存；") {
						#关闭克隆就会使用路由器默认MAC
						@options_page.shutdown_clone(@browser.url)
						#查看克隆后mac地址信息
						@systatus_page.open_systatus_page(@browser.url)
						@tc_wan_mac = @systatus_page.get_wan_mac.upcase
						puts "关闭克隆后,查询到克隆后WAN MAC为#{@tc_wan_mac}".to_gbk
						refute_equal(@tc_mac1, @tc_wan_mac, "关闭克隆后,克隆恢复失败!")
				}

				operate("7.在LAN PC端ping 服务器IP地址，抓包查看源MAC是否与DUT 默认WAN口MAC地址一致；") {
						# 抓包查看是否报文携带克隆后的mac
						# 一边ping一边抓包
						tc_cap_filter = "ether src host #{@tc_wan_mac}"
						puts "Capture filter:#{tc_cap_filter}"
						capfile = "#{@ts_cap_packetpath}/mac_clone_pptp_default.pcap"
						begin
								thr = Thread.new { ping(@ts_web, @tc_ping_num) }
								sleep @tc_wait_time
								@tc_dumpcap.dumpcap_a(capfile, @ts_server_lannic, @ts_cap_timeout, tc_cap_filter)
								packets = @tc_dumpcap.capinfos(capfile)
								puts "Capture packets num:#{packets}"
								assert(packets.to_i>0, "MAC地址克隆失败,未抓到克隆后的包!")
						rescue => e
								puts e.message.to_s
						ensure
								thr.kill if thr.alive? #强制杀死
								taskkill(@tc_task) if tasklist_exists?(@tc_task)
						end
				}

				# operate("8、三种MAC地址克隆方式切换5次以上，DUT是否会出现异常；") {
				#
				# }

		end

		def clearup

				operate("1 取消克隆") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.shutdown_clone(@browser.url)
				}

				operate("2 恢复默认方式:DHCP") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
