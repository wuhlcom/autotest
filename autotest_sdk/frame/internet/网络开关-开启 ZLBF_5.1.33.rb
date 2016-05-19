#
# description:
# bug
# 重启前网络客户是打开状态
# 重启后，无线客户端ip地址和客户端名显示不正确
# 重启后，有线客户端名称显示不正确
#路由器会截断过长的名字,所以名字过长时只能用正则来匹配是否显示名称
# ipconfig/relealse ipconfig/renew后才能恢复正常
# author:wuhongliang
# date:2015-06-30 14:12:40
# modify:
#
testcase {

		attr = {"id" => "ZLBF_5.1.33", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time        = 2
				@tc_wait_device_list = 10
				@tc_reboot_time      = 120
				@tc_relogin_time     = 80
				@tc_net_time         = 60
				@tc_tag_device_btn   = "button"
				@tc_tag_btn_on_kick  = "on kick"
				@tc_tag_btn_kick_on  = "kick on"
				@tc_tag_btn_off_kick = "off kick"
				@tc_tag_btn_kick_off = "kick off"

				# @tc_client_name1       = "zhilutest1-PC" #有线网卡
				@tc_client_name1     = get_host_name
				puts "执行机名为:#{@tc_client_name1}".encode("GBK")
				@tc_tag_confirm = "确认"
				@tc_tag_cannel  = "取消"
		end

		def process

				operate("1 无线客户端连接路由器") {
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
						assert(rs, "PC无法上网")

						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "打开内网设置失败")

						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "恢复默认的加密码方式：#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@lan_iframe.text_field(id: @ts_tag_input_pw).set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for wifi config changed..."
								sleep @tc_net_time
						end

						ssid_name     = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
						@current_pw   = @passwd_input.value
						puts "ssid name : #{ssid_name}".encode("GBK")
						puts "wifi passwd:#{@current_pw}"

						flag = "1"
						rs2  = @wifi.connect(ssid_name, flag, @current_pw)
						assert rs2, "wifi连接失败"
						rs3 = @wifi.ping(@ts_web)
						assert(rs3, "无线客户端PC无法上网")

						@tc_client_name2 = @wifi.get_host_name
						puts "无线客户端名为：#{@tc_client_name2}".encode("GBK")
				}

				operate("2 打开客户端设备连接页面") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						tc_devices_list = @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id)
						tc_devices_list.wait_until_present(@tc_wait_time)
						tc_devices_list.click
						sleep @tc_wait_device_list
						@browser.iframe(src: @ts_tag_devices_iframe_src).wait_until_present(@tc_wait_device_list)
						@tc_devices_iframe = @browser.iframe(src: @ts_tag_devices_iframe_src)
						assert(@tc_devices_iframe.exists?, "打开设备列表失败！")
				}

				operate("3 关闭客户端网络连接前检查网络连接状态") {
						#刷新一次设备列表
						@tc_devices_iframe.link(id: @ts_tag_refresh_btn).click
						sleep @tc_wait_device_list
						@tc_devices_table = @tc_devices_iframe.table(id: @ts_device_list_id)
						@tc_table_tbody   = @tc_devices_table.tbody
						@tc_rows          = @tc_table_tbody.rows.to_a

						#判断客户端是否显示,使用正则表达式，因为路由器会截断过长的名字
						rs1               = @tc_rows.any? { |tc_row| @tc_client_name1=~/#{tc_row[3].text}/ }
						assert(rs1, "客户端#{@tc_client_name1}不存在!")
						rs2 = @tc_rows.any? { |tc_row| @tc_client_name2=~/#{tc_row[3].text}/ }
						assert(rs2, "客户端#{@tc_client_name2}不存在!")
						#由于客户端1，2的顺序可能每次不一样，所以要使用循环来处理
						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name    = tc_row[3].text
								tc_client_btn_raw = tc_row[4]
								next if @tc_client_name1 !~/#{tc_client_name}/ && @tc_client_name2 !~/#{tc_client_name}/ #排除其它非测试连接上来的客户端
								puts "查看客户端网络开关状态 #{tc_client_name}".encode("GBK")
								raw_client_btn = tc_client_btn_raw.button(class_name: /#{@tc_tag_btn_on_kick}|#{@tc_tag_btn_kick_on}/)
								assert(raw_client_btn.exists?, "客户端#{tc_client_name}网络被禁用或不存在!")
								puts "禁用网络前测试客户端#{tc_client_name}网络开关是否正常".to_gbk
								if @tc_client_name1 =~/#{tc_client_name}/
										rs = ping(@ts_web)
								else
										rs =@wifi.ping(@ts_web)
								end
								assert rs, "禁用网络前客户端#{tc_client_name}无法连接网络!"
						end
				}

				operate("4 关闭有线客户端网络连接") {
						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name    = tc_row[3].text
								tc_client_btn_raw = tc_row[4]
								next if @tc_client_name1 !~/#{tc_client_name}/ #只要不是@tc_client_name1就跳过
								#禁用有线网卡
								raw_client_btn = tc_client_btn_raw.button(class_name: /#{@tc_tag_btn_on_kick}|#{@tc_tag_btn_kick_on}/)
								puts "禁用客户端#{tc_client_name}网络连接".to_gbk
								raw_client_btn.click
								sleep @tc_wait_time
								#确认禁用
								@tc_devices_iframe.button(:text, @tc_tag_confirm).click
								sleep @tc_wait_device_list
						end
						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name = tc_row[3].text
								next if @tc_client_name1 !~/#{tc_client_name}/ && @tc_client_name2 !~/#{tc_client_name}/
								if @tc_client_name1 =~/#{tc_client_name}/
										p "关闭有线客户端后,有线客户端ping外网".encode("GBK")
										rs = ping(@ts_web)
										assert !rs, "禁用网络后客户端#{tc_client_name}仍能连接网络!"
								else
										p "关闭有线客户端后,无线客户端ping外网".encode("GBK")
										rs =@wifi.ping(@ts_web)
										assert(rs, "禁用客户端#{@tc_client_name1}网络后,客户端#{tc_client_name}也不能连接网络了!")
								end
						end
				}

				operate("5 关闭无线客户端网络连接") {
						#第四步禁用有线网络,第五步禁用无线网络
						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name    = tc_row[3].text
								tc_client_btn_raw = tc_row[4]
								next if @tc_client_name2 !~/#{tc_client_name}/ #只要客户端名不为@tc_clinet_name2就跳过
								raw_client_btn = tc_client_btn_raw.button(class_name: /#{@tc_tag_btn_on_kick}|#{@tc_tag_btn_kick_on}/)
								assert(raw_client_btn.exists?, "客户端#{tc_client_name}在列表中不存在")
								puts "禁用客户端#{tc_client_name}网络连接".to_gbk
								raw_client_btn.click
								sleep @tc_wait_time
								@tc_devices_iframe.button(:text, @tc_tag_confirm).click
								sleep @tc_wait_device_list
						end
						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name = tc_row[3].text
								next if @tc_client_name1 !~/#{tc_client_name}/ && @tc_client_name2 !~/#{tc_client_name}/ #排除干扰客户端
								if @tc_client_name =~/#{tc_client_name}/
										rs = ping(@ts_web)
								else
										rs =@wifi.ping(@ts_web)
								end
								assert(!rs, "禁用客户端网络连接后,客户端#{tc_client_name}仍能连接网络!")
						end
				}

				operate("6 开启有线客户端网络连接") {
						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name    = tc_row[3].text
								tc_client_btn_raw = tc_row[4]
								next if @tc_client_name1 !~/#{tc_client_name}/
								raw_client_btn = tc_client_btn_raw.button(class_name: /#{@tc_tag_btn_kick_off}|#{@tc_tag_btn_off_kick}/)
								assert(raw_client_btn.exists?, "客户端#{tc_client_name}在列表中不存在")
								puts "启用客户端#{tc_client_name}网络连接".to_gbk
								raw_client_btn.click
								sleep @tc_wait_time
								@tc_devices_iframe.button(:text, @tc_tag_confirm).click
								sleep @tc_wait_device_list
						end

						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name = tc_row[3].text
								next if @tc_client_name1 !~/#{tc_client_name}/ && @tc_client_name2 !~/#{tc_client_name}/
								if @tc_client_name1 =~/#{tc_client_name}/
										rs = ping(@ts_web)
										assert(rs, "启用客户端#{tc_client_name}网络后客户端#{tc_client_name}不能连接网络!")
								else
										rs =@wifi.ping(@ts_web)
										assert(!rs, "启用客户端#{@tc_client_name1}网络后，客户端#{tc_client_name}也能连接网络了!")
								end
						end
				}

				operate("7 开启无线客户端网络连接") {
						#第6步启用有线网络,第7步启用无线网络
						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name    = tc_row[3].text
								tc_client_btn_raw = tc_row[4]
								next if @tc_client_name2 !~/#{tc_client_name}/
								raw_client_btn = tc_client_btn_raw.button(class_name: /#{@tc_tag_btn_kick_off}|#{@tc_tag_btn_off_kick}/)
								assert(raw_client_btn.exists?, "客户端#{tc_client_name}在列表中不存在")
								puts "启用客户端#{tc_client_name}网络连接".to_gbk
								raw_client_btn.click
								sleep @tc_wait_time
								@tc_devices_iframe.button(:text, @tc_tag_confirm).click
								sleep @tc_wait_device_list
						end

						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name = tc_row[3].text
								next if @tc_client_name1 !~/#{tc_client_name}/ && @tc_client_name2 !~/#{tc_client_name}/
								if @tc_client_name1 !~/#{tc_client_name}/
										rs = ping(@ts_web)
										assert(rs, "启用客户端#{@tc_client_name1}网络后客户端#{tc_client_name}不能连接网络!")
								else
										rs =@wifi.ping(@ts_web)
										assert(rs, "启用客户端#{@tc_client_name2}网络后，客户端#{tc_client_name}不能连接网络!")
								end
						end
				}

				operate("8 重启路由器") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						#重启路由器
						@browser.span(id: @ts_tag_reboot).click
						div_parent = @browser.div(class_name: @ts_tag_net_reset_tip)
						assert div_parent.exists?, "未弹出重启路由器提示!"

						reboot_confirm = div_parent.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "未提示重启路由器要确认!"
						reboot_confirm.click
						#<div class="aui_content" style="padding: 20px 25px;">正在重启中，请稍等...</div>
						# Watir::Wait.until(@tc_wait_time, "重启路由器正在重启提示未出现") {
						# 		div_parent.div(:class_name, @ts_tag_rebooting).exists?
						# }
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须增加sleep等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "跳转到登录页面失败!"
						login_no_default_ip(@browser)
				}

				operate("9 重启路由器后,重新登录路由器，打开客户端连接页面") {
						tc_devices_list = @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id)
						tc_devices_list.wait_until_present(@tc_wait_time)
						tc_devices_list.click
						@browser.iframe(src: @ts_tag_devices_iframe_src).wait_until_present(@tc_wait_device_list)
						@tc_devices_iframe = @browser.iframe(src: @ts_tag_devices_iframe_src)
						assert(@tc_devices_iframe.exists?, "打开设备列表失败！")
				}

				operate("10 重启路由器后,检查网络开关功能") {
						#重启前网络开关开启，重启后应该仍是开户状态
						#刷新一次设备列表
						@tc_devices_iframe.link(id: @ts_tag_refresh_btn).click
						sleep @tc_wait_device_list
						@tc_devices_table = @tc_devices_iframe.table(id: @ts_device_list_id)
						@tc_table_tbody   = @tc_devices_table.tbody
						@tc_rows          = @tc_table_tbody.rows.to_a

						rs1 = @tc_rows.any? { |tc_row| @tc_client_name1 !~/#{tc_row[3].text}/ }
						assert(rs1, "重启后客户端#{@tc_client_name1}不存在!")
						rs2 = @tc_rows.any? { |tc_row| @tc_client_name2 !~/#{tc_row[3].text}/ }
						assert(rs2, "重启后客户端#{@tc_client_name2}不存在!")

						@tc_rows.each_with_index do |tc_row, index|
								next if index == 0
								tc_client_name    = tc_row[3].text
								tc_client_btn_raw = tc_row[4]
								next if @tc_client_name1 !~/#{tc_client_name}/ && @tc_client_name2 !~/#{tc_client_name}/ #排除干扰客户端
								raw_client_btn = tc_client_btn_raw.button(class_name: /#{@tc_tag_btn_on_kick}|#{@tc_tag_btn_kick_on}/)
								assert(raw_client_btn, "重启后客户端#{tc_client_name}网络连接自动禁用了!")

								puts "重启后测试客户端#{tc_client_name}网络连接".to_gbk
								if @tc_client_name1=~/#{tc_client_name}/
										rs = ping(@ts_web)
								else
										rs =@wifi.ping(@ts_web)
								end
								assert(rs, "重启后,客户端#{tc_client_name}无法连接网络!")
						end
				}
		end

		def clearup

				operate("1 恢复网络开关为默认状态") {
						#断开wifi连接
						@wifi.netsh_disc_all unless @wifi.nil?
						if !@tc_rows.nil? && @tc_rows[0].exist?
								#这里要重新获取一次网络状态
								puts "Devices List Page is open"
								@tc_devices_table = @tc_devices_iframe.table(id: @ts_device_list_id)
								@tc_table_tbody   = @tc_devices_table.tbody
								@tc_rows          = @tc_table_tbody.rows.to_a
						elsif @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id).exists?
								puts "Device list not open,reopen it"
								tc_devices_list = @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id)
								tc_devices_list.wait_until_present(@tc_wait_time)
								tc_devices_list.click
								sleep @tc_wait_device_list
								@browser.iframe(src: @ts_tag_devices_iframe_src).wait_until_present(@tc_wait_device_list)
								@tc_devices_iframe = @browser.iframe(src: @ts_tag_devices_iframe_src)
								@tc_devices_table  = @tc_devices_iframe.table(id: @ts_device_list_id)
								@tc_table_tbody    = @tc_devices_table.tbody
								@tc_rows           = @tc_table_tbody.rows.to_a
						elsif @browser.text_field(:name, @ts_tag_usr).exists?
								puts "router logout, relogin"
								login_no_default_ip(@browser)
								tc_devices_list = @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id)
								tc_devices_list.wait_until_present(@tc_wait_time)
								tc_devices_list.click
								sleep @tc_wait_device_list
								@browser.iframe(src: @ts_tag_devices_iframe_src).wait_until_present(@tc_wait_device_list)
								@tc_devices_iframe = @browser.iframe(src: @ts_tag_devices_iframe_src)
								@tc_devices_table  = @tc_devices_iframe.table(id: @ts_device_list_id)
								@tc_table_tbody    = @tc_devices_table.tbody
								@tc_rows           = @tc_table_tbody.rows.to_a
						else
								puts "relogin router"
								login_recover(@browser, @ts_default_ip)
								tc_devices_list = @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id)
								tc_devices_list.wait_until_present(@tc_wait_time)
								tc_devices_list.click
								sleep @tc_wait_device_list
								@browser.iframe(src: @ts_tag_devices_iframe_src).wait_until_present(@tc_wait_device_list)
								@tc_devices_iframe = @browser.iframe(src: @ts_tag_devices_iframe_src)
								@tc_devices_table  = @tc_devices_iframe.table(id: @ts_device_list_id)
								@tc_table_tbody    = @tc_devices_table.tbody
								@tc_rows           = @tc_table_tbody.rows.to_a
						end

						if !@tc_rows.nil?
								@tc_rows.each_with_index do |tc_row, index|
										next if index == 0
										tc_client_name    = tc_row[3].text
										tc_client_btn_raw = tc_row[4]
										raw_client_btn    = tc_client_btn_raw.button(class_name: /#{@tc_tag_btn_kick_off}|#{@tc_tag_btn_off_kick}/)
										if raw_client_btn.exists?
												puts "恢复客户端#{tc_client_name}网络连接".to_gbk
												raw_client_btn.click
												sleep @tc_wait_time
												@tc_devices_iframe.button(:text, @tc_tag_confirm).click
												sleep @tc_wait_device_list
										end
								end
						end
				}

		end

}
