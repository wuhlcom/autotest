#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.38", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_dumpcap    = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_wait_time  = 2
				@tc_clone_time = 15
				@tc_net_time   = 60
				@tc_mac1       = "00:11:00:00:00:01"
				@tc_mac2       = "00:11:00:00:00:02"
				@tc_ping_num   = 500
				@tc_task       = "ping.exe"
		end

		def process

				operate("1、在BAS启用抓包；") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "打开WAN状态失败！")
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#先判断是否为PPPOE模式如果不是则设置为PPPOE模式
						unless wan_type=~/#{@ts_wan_mode_pppoe}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "打开外网设置失败")

								#设置为有线连接
								rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
								unless rs1=~/#{@ts_tag_select_state}/
										@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								end

								#如果不是静态接入就先设置为静态接入
								pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
								pppoe_radio_state = pppoe_radio.checked?
								unless pppoe_radio_state
										pppoe_radio.click
										sleep @tc_wait_time
										puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
										@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
										@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
										@wan_iframe.button(id: @ts_tag_sbm).click
										sleep @tc_net_time
								end

								#重新查看网络状态
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, "重新打开WAN状态失败！")
								wan_type = @status_iframe.b(:id => @tag_wan_type).parent.text
						end
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

						mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						mask =~@ts_tag_ip_regxp
						puts "WAN状态显示掩码为：#{Regexp.last_match(1)}".to_gbk

						gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						gateway_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示网关为：#{Regexp.last_match(1)}".to_gbk

						dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
						dns_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示DNS为：#{Regexp.last_match(1)}".to_gbk

						wan_type =~/(#{@ts_wan_mode_pppoe})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

						assert_match @ts_tag_ip_regxp, wan_addr, '获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
						assert_match @ts_tag_ip_regxp, mask, '获取ip地址掩码失败！'
						assert_match @ts_tag_ip_regxp, gateway_addr, '获取网关ip地址失败！'
						assert_match @ts_tag_ip_regxp, dns_addr, '获取dns ip地址失败！'
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2.选择“使用计算机MAC地址”查看地址文本框中显示MAC地址是否与登录主机的MAC地址一致，保存；") {
						#克隆前检查WAN MAC与PC MAC是否一致
						puts "PC MAC address: #{@ts_pc_mac}"
						puts "Router Wan default MAC address: #{@ts_wan_mac}"
						refute_equal(@ts_pc_mac, @ts_wan_mac, "WAN MAC与PC MAC一样可能已经克隆了!")
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择网络设置
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#选择mac克隆
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end

						#打开克隆开关
						clone_switch = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_off)
						#clone_switch.enabled?
						if clone_switch.exists?
								clone_switch.click
						end
						clone_switch_on = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						assert(clone_switch_on.exists?, "克隆开关未打开!")
						#克隆地址
						@advance_iframe.button(id: @ts_tag_fillmac).click
						#获取克隆地址
						clone_mac_addr = @advance_iframe.text_field(id: @ts_tag_pcmac).value
						puts "Clone MAC address: #{clone_mac_addr}"
						assert_equal(@ts_pc_mac.upcase, clone_mac_addr.upcase, "MAC地址克隆失败!")
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time #修改mac后要重启网络，等待网络重启
						#关闭高级设置
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#找到背景根DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#隐藏背景根DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#查看克隆后mac地址信息
						@browser.refresh #刷新页面
						system_ver = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						@ts_wan_mac_pattern1 =~system_ver
						@tc_wan_mac1 = Regexp.last_match(1)
						puts "Current WAN MAC :#{@tc_wan_mac1}"
						assert_equal(@ts_pc_mac, @tc_wan_mac1, "WAN MAC与PC MAC不一致,克隆失败!")
				}

				operate("3.在LAN PC端ping 服务器IP地址，抓包查看源MAC是否与主机的MAC地址一致；") {
						#抓包查看是否报文携带克隆后的mac
						#一边ping一边抓包
						tc_cap_filter = "ether src host #{@ts_pc_mac}"
						puts "Capture filter:#{tc_cap_filter}"
						capfile = "#{@ts_cap_packetpath}/mac_clone_pppoe_pc.pcap"
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
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择网络设置
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#选择mac克隆
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end

						clone_switch_on = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						assert(clone_switch_on.exists?, "克隆开关未打开!")
						#输入mac地址
						@advance_iframe.text_field(id: @ts_tag_pcmac).set(@tc_mac1)
						#确认克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time #修改mac后要重启网络，等待网络重启
						#找到共享目录页面根DIV
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#找到背景根DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#隐藏共享目录页面根DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#隐藏背景根DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#查看克隆后mac地址信息
						@browser.refresh
						system_ver = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						@ts_wan_mac_pattern1 =~system_ver
						@tc_wan_mac2 = Regexp.last_match(1)
						puts "Current WAN MAC :#{@tc_wan_mac2}"
						assert_equal(@tc_mac1, @tc_wan_mac2, "WAN MAC与PC MAC不一致,克隆失败!")
				}

				operate("5.在LAN PC端ping 服务器IP地址，抓包查看源MAC与设置的MAC地址一致；") {
						#抓包查看是否报文携带克隆后的mac
						#一边ping一边抓包
						tc_cap_filter = "ether src host #{@tc_mac1}"
						puts "Capture filter:#{tc_cap_filter}"
						capfile = "#{@ts_cap_packetpath}/mac_clone_pppoe_input.pcap"
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
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择网络设置
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#选择mac克隆
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end
						# 取消克隆
						clone_switch_on = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						if clone_switch_on.exists?
								clone_switch_on.click
						end
						clone_switch_off = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_off)
						assert(clone_switch_off.exists?, "克隆开关未关闭!")
						#确认取消克隆
						@advance_iframe.button(id: @ts_tag_sbm).click
						# Watir::Wait.until(@tc_wait_time, "克隆成功提示未出现") {
						# 	@clone_tip=@advance_ifrmame.div(class_name: @ts_tag_reset, text: /#{@ts_tag_pptp_set}/)
						# 	@clone_tip.present?
						# }
						# Watir::Wait.while(@tc_clone_time, "克隆设置成功提示未消失") {
						# 	@clone_tip.present?
						# }
						sleep @tc_net_time #修改mac后要重启网络，等待网络重启
						#找到共享目录页面根DIV
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#找到背景根DIV
						background_zindex= (zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#隐藏共享目录页面根DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#隐藏背景根DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#查看克隆后mac地址信息
						@browser.refresh
						system_ver = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						@ts_wan_mac_pattern1 =~system_ver
						tc_wan_mac = Regexp.last_match(1)
						puts "Current WAN MAC :#{tc_wan_mac}"
						assert_equal(@ts_wan_mac, tc_wan_mac, "WAN MAC与PC MAC不一致,克隆失败!")
				}

				operate("7.在LAN PC端ping 服务器IP地址，抓包查看源MAC是否与DUT 默认WAN口MAC地址一致；") {
						#抓包查看是否报文携带克隆后的mac
						#一边ping一边抓包
						tc_cap_filter = "ether src host #{@ts_wan_mac}"
						puts "Capture filter:#{tc_cap_filter}"
						capfile = "#{@ts_cap_packetpath}/mac_clone_pppoe_default.pcap"
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

				operate("8、三种MAC地址克隆方式切换5次以上，DUT是否会出现异常；") {

				}

		end

		def clearup

				operate("1 恢复默认DHCP接入") {
						@tc_dumpcap.netsh_disc_all #断开wifi连接
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe

						flag = false
						#设置wan连接方式为网线连接
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag = true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#设置WIRE WAN为DHCP模式
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate("2 取消克隆") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

						#选择网络设置
						networking      = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@ts_tag_select_state
								networking.click
						end

						#选择mac克隆
						clone_mac      = @advance_iframe.link(id: @ts_tag_clone_mac)
						clone_mac_state= clone_mac.parent.class_name
						unless clone_mac_state==@ts_tag_liclass
								clone_mac.click
						end

						#关闭克隆开关
						clone_switch = @advance_iframe.button(id: @ts_tag_clone_sw, class_name: @ts_tag_btn_on)
						clone_switch.exists?
						if clone_switch.exists?
								clone_switch.click
								@advance_iframe.button(id: @ts_tag_sbm).click
								puts "waiting for netresting..."
								sleep @tc_net_time #修改mac后要重启网络，等待网络重启
						end
				}
		end

}
