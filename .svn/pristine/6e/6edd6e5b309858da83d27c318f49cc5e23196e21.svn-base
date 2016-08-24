#
# description:
# author:liluping
# date:2015-09-16
#
testcase {

		attr = {"id" => "ZLBF_15.1.2", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_dumpcap               = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_dumpcap_pc2           = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_wifi_flag             = "1"
				@tc_wait_time             = 2
				@tc_wifi_wait             = 10
				@tc_net_time              = 50
				@tc_reboot_time           = 120
				@tc_relogin_time           = 80
				@tc_tag_button_switch_off = "off"
				@tc_tag_button_switch_on  = "on"
				@tc_ping_num = 5
		end

		def process

				operate("1、DUT的接入类型选择为DHCP，保存配置，PC1设置为自动获取IP地址，如：192.168.100.100；") {
						#查看WAN接入方式是否为DHCP
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#如果不是DHCP则修改为DHCP
						unless wan_type =~ /#{@ts_wan_mode_dhcp}/
								puts "切换为DHCP接入方式".to_gbk
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "打开外网设置失败")
								@wan_iframe.link(:id => @ts_tag_wired_mode_link).click #选择网线连接
								dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
								unless dhcp_radio.checked?
										dhcp_radio.click
								end
								#保存设置，切换为DHCP模式
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "sleep #{@tc_net_time} second for net reseting..."
								sleep @tc_net_time
						end

						rs = ping(@ts_web)
						assert(rs, "设置源IP过滤前有线客户端无法ping通#{@ts_web}")

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						#连接无线网卡
						#打开lan设置
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, '打开内网设置失败！')
						#若lan设置不为wpa则设置为wpa
						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "恢复默认的加密码方式：#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@lan_iframe.text_field(id: @ts_tag_input_pw).set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#等配置生效
								puts "sleep #{@tc_net_time} second for wifi config changing..."
								sleep @tc_net_time
						end
						@tc_dut_pw   = @lan_iframe.text_field(id: @ts_tag_input_pw).value
						@tc_dut_ssid = @lan_iframe.text_field(:id, @ts_tag_ssid).value

						puts "Dut ssid: #{@tc_dut_ssid},passwd:#{@tc_dut_pw}"
						p "PC2连接DUT".to_gbk
						rs1 = @tc_dumpcap_pc2.connect(@tc_dut_ssid, @tc_wifi_flag, @tc_dut_pw, @ts_wlan_nicname)
						assert rs1, 'wifi连接失败'

						rs2 =@tc_dumpcap_pc2.ping(@ts_web)
						assert(rs2, "设置IP过滤前WIFI客户端无法ping#{@ts_web}")
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、先进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						#选择安全设置
						option_link = @option_iframe.link(id: @ts_tag_security)
						option_link.click

						#选择防火墙设置
						@option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_tag_fwset)
						option_fw_iframe.click
						sleep @tc_wait_time

						puts "开启防火墙总开关IP过滤开关".to_gbk
						#打开总开关
						btn_fw_off = @option_iframe.button(id: @ts_tag_security_sw, class_name: @tc_tag_button_switch_off)
						if btn_fw_off.exists?
								btn_fw_off.click
						end
						#打开IP过滤开关
						btn_ip_off = @option_iframe.button(id: @ts_tag_security_ip, class_name: @tc_tag_button_switch_off)
						if btn_ip_off.exists?
								btn_ip_off.click
						end
						#保存配置
						@option_iframe.button(id: @ts_tag_security_save).click
						sleep @tc_wait_time
				}

				operate("3、添加一条IP过滤规则，设置源IP为192.168.100.100，端口为1~65535，协议为TCP/UDP，目的地址和目的端口不填，保存配置；") {
						#打开IP过滤界面
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_ip_set)
						option_fw_iframe.click
						@tc_pc_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
						p "设置过滤源IP：#{@tc_pc_ip}".to_gbk
						@option_iframe.span(id: @ts_tag_additem).click #添加新条目
						@option_iframe.text_field(id: @ts_ip_src).set(@tc_pc_ip) #设置源IP
						@option_iframe.button(id: @ts_tag_save_filter).click #保存
						sleep @tc_wait_time
						#查看防火墙配置，判断是否生成了新条目
						fw_state = @option_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fw_state, "防火墙总开关打开失败")
						ip_filter_state = @option_iframe.span(id: @ts_tag_ip_filter_state).text
						assert_equal(@ts_tag_fw_open, ip_filter_state, "IP过滤开关打开失败")
						#获取条目中的源ip
						@source_ip = @option_iframe.table(id: @ts_iptable, class_name: @ts_tag_mac_table).trs[1][1].text
						@source_ip =~ /(\d+\.\d+\.\d+\.\d+)\-/i
						assert_equal($1, @tc_pc_ip, "添加IP过滤失败!")
						############################# 下面都是获取tr,td中数据的方法 ##################################
						# @option_iframe.td(text: "192.168.100.100-".parent[1].text

						# p @option_iframe.td(text: "ALL")
						# p @option_iframe.td(text: "ALL").parent
						# p @option_iframe.td(text: "ALL").parent[0].text
						# p @option_iframe.td(text: "ALL").parent[1].text

						# p @option_iframe.table(id: "iptable", class_name: "macguolv").trs
						# p @option_iframe.table(id: "iptable", class_name: "macguolv").trs[0]
						# p @option_iframe.table(id: "iptable", class_name: "macguolv").trs[0][0].text.to_gbk

						# p @option_iframe.table(id: "iptable", class_name: "macguolv").tbody.trs
						# p @option_iframe.table(id: "iptable", class_name: "macguolv").tbody.trs[0]
						# p @option_iframe.table(id: "iptable", class_name: "macguolv").tbody.trs[0][0].text.to_gbk
						##############################################################################################
				}

				operate("4、从PC向服务器作ping操作，ping的IP为过滤网段内的地址，然后在服务器查看是否能抓到数据包；") {
						#验证ip是否过滤
						puts "验证ip过滤是否生效".to_gbk
						p "获取#{@ts_web}对应的网络IP".to_gbk
						ns     = Addrinfo.ip(@ts_web) #查询该url对应的ip
						net_ip = ns.ip_address
						p "#{@ts_web}的对应的网络IP为：#{net_ip}".to_gbk

						rs = ping(net_ip, @tc_ping_num)
						refute(rs, "IP过滤失败，过滤IP为#{@tc_pc_ip}，但#{@tc_pc_ip}仍能ping通#{@ts_web}")

						puts "在pc2上ping #{@ts_web}".to_gbk
						wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
						ts          = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
						assert(ts, "IP过滤异常，过滤IP为#{@tc_pc_ip}，但IP #{wireless_ip}不能ping通#{@ts_web}")
						#为防止无线网卡重启后获取的IP是被过滤的IP，重启前先断开无线连接
						p "断开wifi连接".to_gbk
						@tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
				}

				operate("7、重启DUT，查看过滤规则是否生效") {
						@browser.span(id: @ts_tag_reboot).parent.click #点击重启按钮
						@browser.button(class_name: @ts_tag_reboot_confirm).click
						puts "路由器重启中，请稍后...".to_gbk
						sleep @tc_reboot_time
						login_ui = @browser.text_field(name: @usr_text_id).wait_until_present(@tc_relogin_time)
						assert(login_ui, "重启后未弹出登录页面！")
						login_no_default_ip(@browser)

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						#选择安全设置
						option_link = @option_iframe.link(id: @ts_tag_security)
						option_link.click
						sleep @tc_wait_time
						#IP过滤
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_ip_set)
						option_fw_iframe.click

						#查看防火墙配置，判断是否生成了新条目
						fw_state = @option_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fw_state, "重启后防火墙总开关打开失败")
						ip_filter_state = @option_iframe.span(id: @ts_tag_ip_filter_state).text
						assert_equal(@ts_tag_fw_open, ip_filter_state, "重启后IP过滤开关打开失败")
						#获取条目中的源ip
						@source_ip = @option_iframe.table(id: @ts_iptable, class_name: @ts_tag_mac_table).trs[1][1].text
						@source_ip =~ /(\d+\.\d+\.\d+\.\d+)\-/i
						assert_equal($1, @tc_pc_ip, "重启后源IP过滤规则丢失!")

						#验证ip是否过滤
						puts "验证ip是否过滤".to_gbk
						ns     = Addrinfo.ip(@ts_web) #查询该url对应的ip
						net_ip = ns.ip_address
						p "获取#{@ts_web}对应的网络IP为#{net_ip}".to_gbk

						tc_dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
						puts "重启后查看有线网卡IP为#{tc_dut_ip}"

						puts "重启后无线网卡重新连接"
						@tc_dumpcap_pc2.netsh_conn(@tc_dut_ssid)
						sleep @tc_wifi_wait
						wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
						puts "重启后查看无线网卡IP为#{wireless_ip}"

						#重启后可能有线获得的是过滤设置的IP，也有可能无线是过滤IP,也有可能获取的IP都不是过滤IP
						if tc_dut_ip==@tc_pc_ip
								puts "执行PC网卡被过滤".to_gbk
								rs = ping(@ts_web)
								refute(rs, "重启后源IP过滤失败,#{tc_dut_ip}能ping通#{@ts_web}!")
								puts "在PC2上ping #{@ts_web}".to_gbk
								ts = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
								assert(ts, "重启IP过滤异常，过滤IP为#{@tc_pc_ip}，但IP为#{wireless_ip}不能ping通#{@ts_web}")
						elsif wireless_ip==@tc_pc_ip
								puts "无线网卡被过滤".to_gbk
								rs = ping(@ts_web)
								assert(rs, "重启后源IP过滤失败,#{tc_dut_ip}不能ping通#{@ts_web}!")
								puts "在PC2上ping #{@ts_web}".to_gbk
								ts = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
								refute(ts, "重启IP过滤异常过滤IP为#{@tc_pc_ip}，但IP#{wireless_ip}能ping通#{@ts_web}")
						else
								puts "都未被过滤".to_gbk
								assert(false, "脚本需要适配")
						end
				}


		end

		def clearup

				operate("1 恢复默认配置") {
						p "断开wifi连接".to_gbk
						@tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
						sleep @tc_wait_time
						p "1 关闭防火墙总开关和IP过滤开关".to_gbk
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						#打开安全设置
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						option_link    = @option_iframe.link(id: @ts_tag_security)
						option_link.click
						#防火墙设置
						@option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_tag_fwset)
						option_fw_iframe.click
						sleep @tc_wait_time
						puts "关闭防火墙总开关和IP过滤开关".to_gbk
						btn_fw_on = @option_iframe.button(id: @ts_tag_security_sw, class_name: @tc_tag_button_switch_on)
						if btn_fw_on.exists?
								btn_fw_on.click
						end
						btn_ip_on = @option_iframe.button(id: @ts_tag_security_ip, class_name: @tc_tag_button_switch_on)
						if btn_ip_on.exists?
								btn_ip_on.click
						end

						@option_iframe.button(id: @ts_tag_security_save).click
						p "2 删除所有的过滤规则".to_gbk
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_ip_set)
						option_fw_iframe.click
						@option_iframe.span(id: @ts_tag_del_ipfilter_btn).click
						sleep @tc_wait_time
				}

		end

}
