#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                  = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time          = 5
				@tc_dhcp_pool_time     = 35
				@tc_wait_for_login     = 60
				@tc_wait_for_reboot    = 130
				@tc_wpa_value          = "WPAPSKWPA2PSK"
				@ts_tag_reset          = "aui_content"
				@tc_tag_net_reset_tip  = "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_reboot_confirm = "aui_state_highlight"
				@tc_tag_reboot_cancel  = "取消"
				@tc_tag_rebooting      = "aui_content"

				@tc_static_ip  =@ts_default_ip.sub(/\.\d+$/, '.123')
				@tc_static_args={nicname: @ts_nicname, source: "static", ip: "#{@tc_static_ip}", mask: "255.255.255.0"}
				@tc_dhcp_args  ={nicname: @ts_nicname, source: "dhcp"}

				@default_lan_start=@ts_default_ip.sub(/\.\d+$/, ".100")
				@default_lan_end  =@ts_default_ip.sub(/\.\d+$/, ".200")

				@new_lan_start1=@ts_default_ip.sub(/\.\d+$/, ".80")
				@new_lan_end1  =@ts_default_ip.sub(/\.\d+$/, ".90")
				@new_lan_end2  =@ts_default_ip.sub(/\.\d+$/, ".80")

		end

		def process

				operate("1 打开内网设置") {
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@ts_tag_lan_src}/i, @lan_iframe.src, '打开内网设置失败！'
				}

				operate("2 连接路由器wifi") {
						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "恢复默认的加密码方式：#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#等配置生效
								puts "Waiting for wifi config changed..."
								sleep @tc_wait_for_login
						end
						@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
						@current_pw   = @passwd_input.value
						puts "wifi passwd:#{@current_pw}"

						ssid_name = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						flag      ="1"
						rs1       = @wifi.connect(ssid_name, flag, @current_pw)
						assert rs1, 'wifi连接失败'
						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif客户端无法ping通路由器'
				}

				operate("3 修改DHCP地址池范围") {
						@lan_iframe.text_field(:id, @ts_tag_lanstart).set(@new_lan_start1)
						@lan_iframe.text_field(:id, @ts_tag_lanend).set(@new_lan_end1)
						@lan_iframe.button(:id, @ts_tag_sbm).click

						#<div class="aui_content" style="padding: 20px 25px;">设置成功，请稍候......重置网络，如果网络断连，请重新连接。</div>
						# Watir::Wait.until(@tc_wait_time, "等待重启网络提示出现失败") {
						# 		lan_reseting = @lan_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_lan_reset_text)
						# 		lan_reseting.present?
						# }
						#新版本修改地址池范围不会跳转到登录界面 wuhongliang 2015-8-19
						# rs = @browser.text_field(:name, @usr_text_id).wait_until_present(@tc_wait_for_login)
						# assert rs, '跳转到登录页面失败！'
				}

				operate("4 修改地址池后重新获取IP地址") {
						#修改地址池范围后等待dhcp服务正常
						sleep @tc_dhcp_pool_time
						ip_flag=false
						ip_release(@ts_nicname)
						ip_renew(@ts_nicname)
						3.times do |i|
								ip_info = ipconfig()
								sleep 5
								ipaddr =ip_info[@ts_nicname][:ip]
								p "修改地址池后第#{i+1}次查询#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
								unless ipaddr.empty?
										ip_flag = ipaddr[0]>=@new_lan_start1 && ipaddr[0]<=@new_lan_end1
								end
								break if ip_flag
						end
						assert ip_flag, "修改地址池后,路由器重启,客户端未获得新地址池地址"

						@wifi.ip_release(@ts_wlan_nicname)
						@wifi.ip_renew(@ts_wlan_nicname)
						wip_flag=false
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep 15
								wipaddr =wip_info[@ts_wlan_nicname][:ip]
								p "修改地址池后第#{i+1}次查询#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
								unless wipaddr.empty?
										wip_flag = wipaddr[0]>=@new_lan_start1 && wipaddr[0]<=@new_lan_end1
								end
								break if wip_flag
						end
						assert wip_flag, "修改地址池后,路由器重启后,wifi客户端未获得新地址池地址"
				}

				operate("5 重启路由器") {
						#重新登录路由器
						#rs_login = login(@browser, @ts_default_ip)
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_reboot).click

						reboot_confirm = @browser.button(class_name: @tc_tag_reboot_confirm)
						assert reboot_confirm.exists?, "未提示重启路由器要确认!"
						reboot_confirm.click
						#<div class="aui_content" style="padding: 20px 25px;">正在重启中，请稍等...</div>
						# Watir::Wait.until(@tc_wait_time, "重启路由器正在重启提示未出现".to_gbk) {
						# 		@browser.div(:class_name, @tc_tag_rebooting).visible?
						# }
						sleep @tc_wait_for_reboot
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_wait_for_login)
						assert rs, '跳转到登录页面失败！'
				}

				operate("6,路由器重启后验证客户端是否获取ip地址") {
						ip_flag=false
						3.times do |i|
								ip_info = ipconfig()
								sleep 2
								ipaddr =ip_info[@ts_nicname][:ip]
								p "路由器重启后第#{i+1}次查询#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
								unless ipaddr.empty?
										ip_flag = ipaddr[0]>=@new_lan_start1 && ipaddr[0]<=@new_lan_end1
								end
								break if ip_flag
						end
						assert ip_flag, "修改地址池后,路由器重启,客户端未获得新地址池地址"

						wip_flag=false
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep 20
								wipaddr =wip_info[@ts_wlan_nicname][:ip]
								p "路由器重启后第#{i+1}次查询#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
								unless wipaddr.empty?
										wip_flag = wipaddr[0]>=@new_lan_start1 && wipaddr[0]<=@new_lan_end1
								end
								break if wip_flag
						end
						assert wip_flag, "修改地址池后,路由器重启后,wifi客户端未获得新地址池地址"
				}

				operate("7 缩小IP地址池范围") {
						#重新登录路由器
						rs_login=login_no_default_ip(@browser)
						@browser.span(:id => @ts_tag_lan).click if rs_login
						@lan_iframe = @browser.iframe

						@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "disabled")
						sleep 5
						@lan_iframe.text_field(:id, @ts_tag_lanend).set(@new_lan_end2)
						@lan_iframe.button(:id, @ts_tag_sbm).click

						# Watir::Wait.until(@tc_wait_time, "等待重启LAN提示出现失败") {
						# 		lan_reseting = @lan_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_lan_reset_text)
						# 		lan_reseting.present?
						# }
				}

				operate("8 缩小IP地址池范围后重新获取IP地址") {
						#修改地址池范围后等待dhcp服务正常
						sleep @tc_dhcp_pool_time
						ip_flag=false
						ip_release(@ts_nicname)
						ip_renew(@ts_nicname)
						3.times do |i|
								ip_info = ipconfig()
								sleep 3
								ipaddr =ip_info[@ts_nicname][:ip]
								p "缩小IP地址池范围后第#{i+1}次查询#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
								unless ipaddr.empty?
										ip_flag = ipaddr[0]>=@new_lan_start1 && ipaddr[0]<=@new_lan_end1
								end
								break if ip_flag
						end
						assert ip_flag, "缩小IP地址池范围后,客户端未获得新地址池地址"

						@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
						sleep 10
						@wifi.ip_release(@ts_wlan_nicname)
						@wifi.ip_renew(@ts_wlan_nicname)
						wip_flag=false
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep 15
								wipaddr =wip_info[@ts_wlan_nicname][:ip]
								p "缩小IP地址池范围后第#{i+1}次查询#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
								unless wipaddr.empty?
										wip_flag = wipaddr[0]>=@new_lan_start1 && wipaddr[0]<=@new_lan_end1
								end
								break if wip_flag
						end
						assert_equal false, wip_flag, "缩小IP地址池范围后,wifi客户端应该无法获取IP，但实际获得IP地址"
				}

				operate("9 恢复默认地址池范围") {
						@lan_iframe.text_field(:id, @ts_tag_lanstart).set(@default_lan_start)
						@lan_iframe.text_field(:id, @ts_tag_lanend).set(@default_lan_end)
						@lan_iframe.button(:id, @ts_tag_sbm).click
						#修改地址池范围后等待dhcp服务正常
						sleep @tc_dhcp_pool_time
				}


		end

		def clearup

				operate("1 恢复默认地址池") {
						@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
						sleep 10
						p "断开wifi连接".to_gbk
						@wifi.netsh_disc_all #断开wifi连接
						sleep @tc_wait_time
						ping_test = ping(@ts_default_ip)
						unless ping_test
								netsh_if_ip_setip(@tc_static_args)
						end

						# rs_login= login(@browser, @ts_default_ip)
						# if rs_login
						@browser.refresh
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						flag_start  = @lan_iframe.text_field(:id, @ts_tag_lanstart).value==@default_lan_start
						flag_end    = @lan_iframe.text_field(:id, @ts_tag_lanend).value==@default_lan_start
						puts "DHCP地址池已经恢复".to_gbk if flag_start&&flag_end
						unless flag_start&&flag_end
								#恢复默认的dhcp地址池
								@lan_iframe.text_field(:id, @ts_tag_lanstart).set(@default_lan_start)
								@lan_iframe.text_field(:id, @ts_tag_lanend).set(@default_lan_end)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_dhcp_pool_time
						end
						# end
				}

				operate("2 恢复网卡状态") {
						netsh_if_ip_setip(@tc_dhcp_args)
						rs = @wifi.netsh_if_shif(@ts_wlan_nicname)
						if rs[:admin_state]=="disabled"
								@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
						end
				}

		end

}
