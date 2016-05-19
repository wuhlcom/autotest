#
# description:
# author:liluping
# date:2015-09-19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_15.1.3", "level" => "P2", "auto" => "n"}

		def prepare

				DRb.start_service
				@tc_dumpcap               = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_dumpcap_pc2           = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_wifi_flag             = "1"
				@tc_wait_time             = 2
				@tc_net_time              = 60
				@tc_tag_button_switch_off = "off"
				@tc_tag_button_switch_on  = "on"
				@tc_ping_num              = 5
		end

		def process

				operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
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
						assert(rs2, "设置源IP过滤前WIFI客户端无法ping#{@ts_web}")

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、启用IP过滤功能，设置源IP为一地址段（如192.168.100.100~192.168.100.102），端口为1-65535，协议为TCP/UDP，保存配置，从PC向服务器作ping操作，ping的IP为过滤网段内的地址，然后在服务器查看是否能抓到数据包。") {
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

						#打开IP过滤界面
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_ip_set)
						option_fw_iframe.click
						ipinfo     = ipconfig("all")[@ts_nicname]
						@tc_pc_ip  = ipinfo[:ip][0] #获取dut网卡ip
						@tc_pc_gw  = ipinfo[:gateway][0]
						@tc_pc_dns = ipinfo[:dns_server][0]
						p "设置过滤源IP起始IP：#{@tc_pc_ip}".to_gbk
						#生成IP地址结束范围
						@tc_pc_ip =~ /(\d+\.\d+\.\d+\.)(\d+)/
						last_ipnumber = $2.to_i + 100
						last_ipnumber = 254 if last_ipnumber.to_i > 254
						source_endip  = $1 + last_ipnumber.to_s
						p "设置过滤源IP结束IP：#{source_endip}".to_gbk
						#生成静态IP地址
						static_ipnum  = $2.to_i - 1
						static_ip     = $1 + static_ipnum.to_s
						static_ip     = $1 + (last_ipnumber+1).to_s if static_ipnum == 0 #192.168.100.1

						@option_iframe.span(id: @ts_tag_additem).click #添加新条目
						@option_iframe.text_field(id: @ts_ip_src).set(@tc_pc_ip) #设置源IP网段
						@option_iframe.text_field(id: @ts_ip_src_end).set(source_endip)
						@option_iframe.button(id: @ts_tag_save_filter).click #保存
						sleep @tc_wait_time

						#查看防火墙配置，判断是否生成了新条目
						fw_state = @option_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fw_state, "防火墙总开关打开失败")
						ip_filter_state = @option_iframe.span(id: @ts_tag_ip_filter_state).text
						assert_equal(@ts_tag_fw_open, ip_filter_state, "IP过滤开关打开失败")
						source_ip = @option_iframe.table(id: @ts_iptable, class_name: @ts_tag_mac_table).trs[1][1].text
						assert(source_ip, "添加IP过滤失败!")

						#验证ip是否过滤
						p "获取#{@ts_web}对应的网络IP".to_gbk
						ns     = Addrinfo.ip(@ts_web) #查询该url对应的ip
						net_ip = ns.ip_address
						p "#{@ts_web}的网络IP是：#{net_ip}".to_gbk

						rs = ping(net_ip, @tc_ping_num)
						refute(rs, "IP过滤失败，过滤IP为#{@tc_pc_ip}，但#{@tc_pc_ip}仍能ping通#{@ts_web}")

						p "PC2上配置静态IP，要求IP在过滤网段#{source_ip}之外".to_gbk
						puts "配置静态IP信息如下:".to_gbk
						p wireless_ip = static_ip
						p wireless_mask = "255.255.255.0"
						p wireless_gw = @tc_pc_gw
						p wireless_dns = @tc_pc_dns

						#设置静态IP
						args                = {}
						args[:ip]           = wireless_ip
						args[:mask]         = wireless_mask
						args[:gateway]      = wireless_gw
						args[:nicname]      = @ts_wlan_nicname
						args[:source]       = "static"
						#DNS参数
						dns_args            ={}
						dns_args[:nicname]  = @ts_wlan_nicname
						dns_args[:source]   = "static"
						dns_args[:dns_addr] = wireless_dns
						#设置静态IP
						rs                  = @tc_dumpcap_pc2.netsh_if_ip_setip(args)
						#设置静态DNS
						@tc_dumpcap_pc2.netsh_if_ip_setdns(dns_args)
						#查询静态IP配置
						puts "查询静态IP配置".to_gbk
						p @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname]
						if rs
								ts = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
								assert(ts, "IP过滤异常，过滤IP为#{@tc_pc_ip}-#{source_endip}，但IP #{wireless_ip}不能ping通#{@ts_web}")
						else
								assert(false, "PC2配置静态IP失败！")
						end
				}
		end

		def clearup
				operate("1 恢复默认配置") {
						p "断开wifi连接".to_gbk
						@tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
						sleep @tc_wait_time
						p "PC2恢复DHCP模式".to_gbk
						args           = {}
						args[:nicname] = @ts_wlan_nicname
						args[:source]  = "dhcp"
						rs             = @tc_dumpcap_pc2.netsh_if_ip_setip(args)
						unless rs
								p "PC2恢复DHCP连接模式失败！".to_gbk
								ts = @tc_dumpcap_pc2.netsh_if_ip_setip(args)
								p "再次尝试修改后，PC2恢复DHCP模式".to_gbk if ts
						end
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
						p "删除所有的过滤规则".to_gbk
						@option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
						option_fw_iframe = @option_iframe.link(id: @ts_ip_set)
						option_fw_iframe.click
						@option_iframe.span(id: @ts_tag_del_ipfilter_btn).click
						sleep @tc_wait_time
				}
		end

}
