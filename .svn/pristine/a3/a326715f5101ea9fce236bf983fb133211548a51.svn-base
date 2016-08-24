#
# description:
#产品有bug
# 未限制MAC过滤条数
# 规则无法真正删除
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_28.1.5", "level" => "P3", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi = DRbObject.new_with_uri(@ts_drb_server)
				@ts_download_directory.gsub!("\\", "\/")
				@tc_file_name          = "RT2880_Settings.dat"
				@tc_wifi_flag          = "1"
				@tc_wait_time          = 2
				@tc_filter_time        = 3
				@tc_reboot_time        = 120
				@tc_relogin_time       = 80
				@tc_net_time           = 50
				@tc_status_time        = 10
				@tc_download_conf_time = 20
				@tc_mac_error          = "MAC过滤规则最多只能添加32条"
				@tc_tag_table          = "macguolv"
				@tc_tag_inport         = "filename"
				@tc_tag_update_btn     = "update_submit_btn"
				# @tc_wifi_mac           = "08:57:00:97:1E:A8"
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

						rs = ping(@ts_web)
						assert(rs, "过滤前PC无法上网")
						puts "PC1 TCP server connect"
						client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						assert(client.tcp_state, "过滤前PC进行TCP连接失败")

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
								sleep @tc_wait_net_reset
								passwd = @ts_default_wlan_pw
						end
						puts "当前SSID名为：#{ssid},密码:#{passwd}".to_gbk
						rs = @wifi.connect(ssid, @tc_wifi_flag, passwd)
						assert rs, "WIFI连接失败"
						wifi_rs = @wifi.ping(@ts_web)
						assert wifi_rs, "WIFI客户端无法连接外网"
				}

				operate("2、添加基于的MAC地址过滤规则，32条规则都添加完（运行设置的规则总数目），其中有两条是PC1、PC2的MAC地址，保存配置；") {
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
						wifi         = @wifi.ipconfig(@ts_ipconf_all)
						wifi_mac     = wifi[@ts_wlan_nicname][:mac]
						@tc_wifi_mac = wifi_mac.gsub("-", ":")
						puts "添加PC2 MAC #{@tc_wifi_mac}为过滤条件".encode("GBK")
						@advance_iframe.span(id: @ts_tag_additem).click
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(@tc_wifi_mac)
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
						wifi_mac_filter_item = @advance_iframe.td(text: @tc_wifi_mac).parent
						wifi_desc            = wifi_mac_filter_item[1].text
						wifi_status          = wifi_mac_filter_item[2].text
						assert(wifi_mac_filter_item.exists?, "无线客户端过滤条件不存在")
						assert_equal(@ts_wlan_nicname, wifi_desc, "无线客户端过滤条件描述不正确")
						assert_equal(@ts_tag_filter_use, wifi_status, "无线客户端过滤条件状态不正确")

						#添加无线客户端过滤条件
						tc_mac  = "00:11:22:33:44:00"
						tc_desc = "00"
						i       = 3
						30.times do
								puts "添加第#{i}条MAC地址规则，MAC地址为#{tc_mac}".encode("GBK")
								@advance_iframe.span(id: @ts_tag_additem).click
								@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac)
								@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(tc_desc)
								wifi_select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
								#设置为生效
								unless wifi_select_list.selected?(@ts_tag_filter_use)
										wifi_select_list.select(/#{@ts_tag_filter_use}/)
								end
								#保存mac过滤条件
								@advance_iframe.button(id: @ts_tag_save_filter).click
								sleep @tc_filter_time
								tc_mac = tc_mac.succ
								tc_desc=tc_desc.succ
								i      +=1
						end
						tc_mac ="00:11:22:33:44:30"
						tc_desc="30"
						puts "添加第33条MAC地址规则,MAC地址为#{tc_mac}".encode("GBK")
						@advance_iframe.span(id: @ts_tag_additem).click
						@advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(tc_mac)
						@advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(tc_desc)
						wifi_select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
						#设置为生效
						unless wifi_select_list.selected?(@ts_tag_filter_use)
								wifi_select_list.select(/#{@ts_tag_filter_use}/)
						end
						#保存mac过滤条件
						@advance_iframe.button(id: @ts_tag_save_filter).click
						sleep @tc_filter_time
						error_tip = @advance_iframe.p(id: @ts_tag_band_err)
						assert(error_tip.exists?, "提示MAC地址格式错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

						puts "PC1 TCP server connect"
						wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wired_client.tcp_state, "过滤PC1 #{@ts_pc_mac}，PC1进行TCP连接成功")
						puts "PC2 TCP server connect"
						wireless_client = @wifi.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wireless_client.tcp_state, "过滤PC2 #{@tc_wifi_mac}，PC2进行TCP连接成功")
				}

				operate("3、重启AP，查看设备有无丢配置等异常现象；") {
						@browser.span(id: @ts_tag_reboot).click
						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "未提示重启路由器要确认!"
						reboot_confirm.click
						sleep @tc_reboot_time
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, '跳转到登录页面失败！'
						login_no_default_ip(@browser) #重新登录
				}

				operate("4、PC1和PC2能否访问PC3的FTP或访问外网是否成功；") {
						puts "PC1 TCP server connect"
						wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wired_client.tcp_state, "过滤PC1 #{@ts_pc_mac}，PC1进行TCP连接成功")
						puts "PC2 TCP server connect"
						wireless_client = @wifi.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wireless_client.tcp_state, "过滤PC2 #{@tc_wifi_mac}，PC2进行TCP连接成功")
				}

				operate("5、将配置文件保存为文件1，进行复位操作，再将配置文件1导入设备，检查导入是否正确，PC1和PC2能否访问PC3的FTP或访问外网是否成功。") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择‘系统设置’
						sysset      = @advance_iframe.link(id: @ts_tag_op_system)
						sysset_name = sysset.class_name
						unless sysset_name == @ts_tag_select_state
								sysset.click
								sleep @tc_wait_time
						end

						#选择“恢复出厂设置”标签
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time

						#判断当前下载目录是否有配置文件，如果有则将其重命名
						config_file_old = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
						unless config_file_old.nil?
								puts "删除旧的配置文件:#{config_file_old}".encode("GBK")
								File.delete(config_file_old)
						end

						#导出配置文件
						@advance_iframe.button(id: @ts_tag_export).click
						sleep @tc_download_conf_time
						config_download = Dir.glob(@ts_download_directory+"/*").any? { |file| file=~/#{@tc_file_name}$/ }
						assert(config_download, "MAC过滤配置文件下载失败！")
				}

				operate("6、导出配置文件后恢复路由器为出厂设置") {
						#点击”恢复出厂设置“按钮
						@advance_iframe.button(id: @ts_tag_reset_factory).click
						sleep @tc_wait_time
						reset_confirm_tip = @advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reset_text)
						assert reset_confirm_tip.visible?, "未弹出恢复出厂提示!"
						#确认恢复出厂值
						reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						reset_confirm.click
						sleep @tc_wait_time
						puts "Waitfing for system reboot...."
						sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
				}

				operate("7、恢复出厂设置后重新登录,查看MAC过滤规则是否被删除") {
						login_no_default_ip(@browser) #重新登录
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择安全设置
						security_set = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#打开MAC过滤设置
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end

						fwstatus = @advance_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_close, fwstatus, "恢复出厂设置后防火墙总未关闭")
						mac_status = @advance_iframe.span(id: @ts_tag_fwmac).text
						assert_equal(@ts_tag_fw_close, mac_status, "恢复出厂设置后MAC过滤开关未关闭")

						#查看有线客户端mac过滤设置是否成功
						#表格如果只有一行标题行tr则表示所有规则被删除
						table_tr = @advance_iframe.table(class_name: @tc_tag_table).trs.size
						assert_equal(1, table_tr, "恢复出厂设置后MAC过滤规则未删除")
				}

				operate("8、导入配置文件") {
						#选择‘系统设置’
						sysset = @advance_iframe.link(id: @ts_tag_op_system).class_name
						unless sysset == @ts_tag_select_state
								@advance_iframe.link(id: @ts_tag_op_system).click
								sleep @tc_wait_time
						end

						#选择“恢复出厂设置”标签
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time
						config_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
						#如果找不到升级文件
						refute(config_file.nil?, "配置文件不存")
						#设置升级文件
						@advance_iframe.file_field(id: @tc_tag_inport).set(config_file)
						sleep @tc_wait_time
						@advance_iframe.button(id: @tc_tag_update_btn).click

						#等待配置导入完成
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "跳转到登录页面失败!"

						#重新登录路由器
						login_no_default_ip(@browser)
				}

				operate("9、导入配置文件后PC1和PC2访问外网是否成功；") {
						puts "PC1 TCP server connect"
						wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wired_client.tcp_state, "过滤PC1 #{@ts_pc_mac}，PC1进行TCP连接成功")
						puts "PC2 TCP server connect"
						wireless_client = @wifi.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
						refute(wireless_client.tcp_state, "过滤PC2 #{@tc_wifi_mac}，PC2进行TCP连接成功")
				}

				operate("10 导入配置文件后查看防火墙开关和MAC过滤配置是否正常") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择安全设置
						security_set = @advance_iframe.link(id: @ts_tag_security)
						unless security_set.class_name==@ts_tag_select_state
								security_set.click
						end

						#打开MAC过滤设置
						mac_filter       = @advance_iframe.link(id: @ts_tag_macfilter)
						mac_filter_state = mac_filter.parent.class_name
						unless mac_filter_state==@ts_tag_liclass
								mac_filter.click
						end
						fwstatus = @advance_iframe.span(id: @ts_tag_fwstatus).text
						assert_equal(@ts_tag_fw_open, fwstatus, "导入配置后防火墙总开关被关闭")
						mac_status = @advance_iframe.span(id: @ts_tag_fwmac).text
						assert_equal(@ts_tag_fw_open, mac_status, "导入配置后MAC过滤开关被关闭")

						#查看有线客户端mac过滤设置是否成功
						puts "导入配置后查询第1条MAC #{@ts_pc_mac}规则".encode("GBK")
						mac_filter_item = @advance_iframe.td(text: @ts_pc_mac).parent
						desc            = mac_filter_item[1].text
						status          = mac_filter_item[2].text
						assert(mac_filter_item.exists?, "导入配置后MAC #{@ts_pc_mac}过滤条件不存在")
						assert_equal(@ts_nicname, desc, "导入配置后MAC #{@ts_pc_mac}过滤条件描述不正确")
						assert_equal(@ts_tag_filter_use, status, "导入配置后MAC #{@ts_pc_mac}过滤条件状态不正确")
						#查看无线客户端mac过滤设置是否成功
						puts "导入配置后查询第2条MAC #{@tc_wifi_mac}规则".encode("GBK")
						wifi_mac_filter_item = @advance_iframe.td(text: @tc_wifi_mac).parent
						wifi_desc            = wifi_mac_filter_item[1].text
						wifi_status          = wifi_mac_filter_item[2].text
						assert(wifi_mac_filter_item.exists?, "导入配置后无线客户端过滤条件不存在")
						assert_equal(@ts_wlan_nicname, wifi_desc, "导入配置后无线客户端过滤条件描述不正确")
						assert_equal(@ts_tag_filter_use, wifi_status, "导入配置后无线客户端过滤条件状态不正确")

						#添加无线客户端过滤条件
						tc_mac  = "00:11:22:33:44:00"
						tc_desc = "00"
						i       = 3
						30.times do
								puts "导入配置后查询第#{i}条MAC #{tc_mac}规则".encode("GBK")
								mac_filter_item = @advance_iframe.td(text: tc_mac).parent
								desc            = mac_filter_item[1].text
								status          = mac_filter_item[2].text
								assert(mac_filter_item.exists?, "导入配置后MAC#{tc_mac}过滤条件不存在")
								assert_equal(tc_desc, desc, "导入配置后MAC#{tc_mac}描述不正确")
								assert_equal(@ts_tag_filter_use, status, "导入配置后MAC#{tc_mac}状态不正确")
								tc_mac = tc_mac.succ
								tc_desc= tc_desc.succ
								i      +=1
						end
				}

		end

		def clearup

				operate("1、恢复防火墙默认设置") {
						@wifi.netsh_disc_all #断开wifi连接
						unless @browser.link(id: @ts_tag_options).exists?
								login_recover(@browser, @ts_default_ip)
						end
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
						sleep @tc_filter_time
				}
		end

}
