#
# description:
# 客户端MAC过滤规则无法删除
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_28.1.4", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi           = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wifi_flag   = "1"
				@tc_wait_time   = 2
				@tc_filter_time = 5
				@tc_net_time    = 50
				@tc_tag_time    = 15
		end

		def process

				operate("1、AP工作在路由方式下；") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "打开WAN状态失败！")
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#先判断是否为dhcp模式如果不是则设置为dhcp模式
						unless wan_type=~/#{@ts_wan_mode_dhcp}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								puts "设置WAN为DHCP接入".encode("GBK")
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "打开外网设置失败")
								#设置有线连接
								rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
								unless rs1=~/#{@ts_tag_select_state}/
										@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								end

								#如果不是dhcp接入就先设置为dhcp接入
								dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
								dhcp_radio.click
								#提交
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								#重新查看网络状态
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, "重新打开WAN状态失败！")
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						end
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

						wan_type =~/(#{@ts_wan_mode_dhcp})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

						assert_match(@ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！')
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						rs = ping(@ts_web)
						assert(rs, "过滤前PC无法上网")
						puts "PC1 TCP server connect"
						client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						assert(client.tcp_state, "过滤前PC进行TCP连接失败")

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
								@lan_iframe.text_field(id: @ts_tag_input_pw).set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#等配置生效
								puts "sleep #{@tc_net_time} seconds for wifi config changing..."
								sleep @tc_net_time
								passwd = @ts_default_wlan_pw
						end
						puts "当前SSID名为：#{ssid},密码:#{passwd}".to_gbk
						rs = @wifi.connect(ssid, @tc_wifi_flag, passwd)
						assert rs, "WIFI连接失败"
						wifi_rs = @wifi.ping(@ts_web)
						assert wifi_rs, "WIFI客户端无法连接外网"
				}

				operate("2、添加基于的MAC地址过滤规则，其中有两条是PC1、PC2的MAC地址，保存配置；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择安全设置
						security_set = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#选择防火墙设置
						fwset      = @advance_iframe.link(id: @ts_tag_fwset)
						fwset_state= fwset.parent.class_name
						unless fwset_state==@ts_tag_liclass
								fwset.click
						end

						#打开总开关
						fw_switch = @advance_iframe.button(id: @ts_tag_security_sw, class_name: @ts_tag_btn_off)
						if fw_switch.exists?
								fw_switch.click
						end

						#打开mac过滤开关
						mac_switch = @advance_iframe.button(id: @ts_tag_security_mac, class_name: @ts_tag_btn_off)
						if mac_switch.exists?
								mac_switch.click
						end

						#保存
						@advance_iframe.button(id: @ts_tag_security_save).click
						sleep @tc_filter_time

						#打开MAC过滤设置
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end
						fwstatus = @advance_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fwstatus, "防火墙总开关打开失败")
						mac_status = @advance_iframe.span(id: @ts_tag_fwmac).text
						assert_equal(@ts_tag_fw_open, mac_status, "MAC过滤开关打开失败")

						#添加有线客户端过滤条件
						puts "添加PC1 MAC #{@ts_pc_mac}为过滤条件".encode("GBK")
						@advance_iframe.span(id: @ts_tag_additem).click
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(@ts_pc_mac)
						sleep @tc_wait_time
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@ts_nicname)
						sleep @tc_wait_time
						select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless select_list.selected?(@ts_tag_filter_use)
								select_list.select(/#{@ts_tag_filter_use}/)
						end
						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time

						#添加无线客户端过滤条件
						wifi           = @wifi.ipconfig(@ts_ipconf_all)
						wifi_mac       = wifi[@ts_wlan_nicname][:mac]
						@wifi_mac_addr = wifi_mac.gsub("-", ":")
						puts "添加PC2 MAC #{@wifi_mac_addr}为过滤条件".encode("GBK")
						@advance_iframe.span(id: @ts_tag_additem).click
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(@wifi_mac_addr)
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@ts_wlan_nicname)
						wifi_select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless wifi_select_list.selected?(@ts_tag_filter_use)
								wifi_select_list.select(/#{@ts_tag_filter_use}/)
						end
						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time

						#查看有线客户端mac过滤设置是否成功
						mac_filter_item = @advance_iframe.td(text: @ts_pc_mac).parent
						desc            = mac_filter_item[1].text
						status          = mac_filter_item[2].text
						assert(mac_filter_item.exists?, "过滤条件不存在")
						assert_equal(@ts_nicname, desc, "过滤条件描述不正确")
						assert_equal(@ts_tag_filter_use, status, "过滤条件状态不正确")
						#查看无线客户端mac过滤设置是否成功
						wifi_mac_filter_item = @advance_iframe.td(text: @wifi_mac_addr).parent
						wifi_desc            = wifi_mac_filter_item[1].text
						wifi_status          = wifi_mac_filter_item[2].text
						assert(wifi_mac_filter_item.exists?, "无线客户端过滤条件不存在")
						assert_equal(@ts_wlan_nicname, wifi_desc, "无线客户端过滤条件描述不正确")
						assert_equal(@ts_tag_filter_use, wifi_status, "无线客户端过滤条件状态不正确")
				}

				operate("3、PC1和PC2能否访问PC3的FTP或访问外网是否成功；") {
						puts "PC1 TCP server connect"
						wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wired_client.tcp_state, "过滤PC1 #{@ts_pc_mac}，PC1进行TCP连接成功")
						puts "PC2 TCP server connect"
						wireless_client = @wifi.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wireless_client.tcp_state, "过滤PC2 #{@wifi_mac_addr}，PC2进行TCP连接成功")
				}

				operate("4、删除PC1的规则，查看界面是否删除成功，PC1和PC2都访问PC3的FTP或访问外网是否成功；") {
						mac_filter_item = @advance_iframe.td(text: @ts_pc_mac).parent
						mac_filter_item[3].link(class_name: @ts_tag_del).click
						sleep @tc_wait_time
						refute(@advance_iframe.td(text: @ts_pc_mac).exists?, "PC1规则删除失败!")

						puts "PC1 TCP server connect"
						wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						assert(wired_client.tcp_state, "删除PC1 #{@ts_pc_mac} MAC过滤，PC1进行TCP连接失败")
						puts "PC2 TCP server connect"
						wireless_client = @wifi.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wireless_client.tcp_state, "过滤PC2 #{@wifi_mac_addr}，PC2进行TCP连接成功")
				}

				operate("5、点击下面的“删除所有条目”，查看界面是否删除成功，PC1和PC2都访问PC3的FTP或访问外网是否成功。") {
						#删除所有过滤规则
						@advance_iframe.span(id: @ts_tag_alldel).click
						sleep @tc_wait_time
						refute(@advance_iframe.td(text: @wifi_mac_addr).exists?, "规则删除所有规则失败!")
						#验证PC2是否连接，PC1删除规则连接测试在步骤4中已经实现
						puts "PC2 TCP server connect"
						wireless_client = @wifi.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
						assert(wireless_client.tcp_state, "所有过滤规则删除后，PC2进行TCP连接失败")
				}


		end

		def clearup

				operate("1、恢复防火墙默认设置") {
						@wifi.netsh_disc_all #断开wifi连接
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						#选择安全设置
						security_set    = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#选择防火墙设置
						fwset      = @advance_iframe.link(id: @ts_tag_fwset)
						fwset_state= fwset.parent.class_name
						unless fwset_state==@ts_tag_liclass
								fwset.click
						end

						#关闭总开关
						fw_switch = @advance_iframe.button(id: @ts_tag_security_sw, class_name: @ts_tag_btn_on)
						if fw_switch.exists?
								fw_switch.click
						end

						#关闭mac过滤开关
						mac_switch = @advance_iframe.button(id: @ts_tag_security_mac, class_name: @ts_tag_btn_on)
						if mac_switch.exists?
								mac_switch.click
						end

						#保存
						@advance_iframe.button(id: @ts_tag_security_save).click
						sleep @tc_filter_time

						#打开mac过滤设置
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end

						#删除所有过滤规则
						@advance_iframe.span(id: @ts_tag_alldel).click
						sleep @tc_wait_time
				}
		end

}
