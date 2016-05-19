#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                 = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time         = 5
				@tc_net_time          = 50
				@tc_tag_lan           = "set_wifi"
				@tc_tag_lan_iframe_src= "lanset.asp"
				@tc_tag_ssid          = "ssid"
				@tc_tag_select_list   = "security_mode"
				@tc_sec_mode_wpa      = 'WPA-PSK/WPA2-PSK'
				@tc_wpa_value         = "WPAPSKWPA2PSK"
				@tc_tag_input_pw      = "input_password1"

				@tc_tag_net_reset_tip= "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_button       = "button"

				@tc_static_ip          = @ts_default_ip.sub(/\.\d+$/, '.123')
				@tc_static_args        = {nicname: @ts_nicname, source: "static", ip: "#{@tc_static_ip}", mask: "255.255.255.0"}
				@tc_dhcp_args          = {nicname: @ts_nicname, source: "dhcp"}
				@tc_show_dut_args      = {type: "addresses", nicname: @ts_nicname}
				@tc_show_wireless_args = {type: "addresses", nicname: @ts_wlan_nicname}
		end

		def process
				operate("1 打开内网设置") {
						@browser.span(:id => @tc_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@tc_tag_lan_iframe_src}/i, @lan_iframe.src, '打开内网设置失败！'
				}

				operate("2 连接路由器wifi") {
						select = @lan_iframe.select_list(id: @tc_tag_select_list)
						unless select.selected?(@tc_sec_mode_wpa)
								puts "恢复默认的加密码方式：#{@tc_sec_mode_wpa}".to_gbk
								select.select(@tc_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @tc_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#等配置生效
								puts "Waiting for wifi config changed..."
								sleep @tc_wait_net_reset
						end
						@passwd_input = @lan_iframe.text_field(id: @tc_tag_input_pw)
						@current_pw   = @passwd_input.value
						puts "wifi passwd:#{@current_pw}"

						ssid_name = @lan_iframe.text_field(:id, @tc_tag_ssid).value
						flag      ="1"
						rs1       = @wifi.connect(ssid_name, flag, @current_pw)
						assert rs1, 'wifi连接失败'
						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif客户端无法ping通路由器'
				}

				operate("3 禁用DHCP功能") {
						#dhcp开关关闭
						dhcp_button=@lan_iframe.button(:type, @tc_tag_button)
						if dhcp_button.class_name=="on"
								@lan_iframe.button(:type, @tc_tag_button).click
								#提交
								@lan_iframe.button(:id, @ts_tag_sbm).click
								Watir::Wait.until(@tc_wait_time, "等待重启LAN提示出现失败") {
										lan_reseting = @lan_iframe.div(class_name: @ts_tag_rebooting, text: @ts_tag_lan_reset_text)
										lan_reseting.present?
								}
								sleep @tc_net_time
								#等待页面跳转 C021版本后不再跳转到登录界面
								# rs = @browser.text_field(:name, @usr_text_id).wait_until_present(@tc_net_time)
								# assert rs, '跳转到登录页面失败！'
						end
				}

				operate("4 关闭DHCP功能后重新获取ip地址") {
						rs_ip_release=ip_release(@ts_nicname)
						assert rs_ip_release, '释放ip地址失败！'
						rs_ip_renew= ip_renew(@ts_nicname)
						assert_equal(false, rs_ip_renew, '更新ip地址操作应失败,但却成功了！')

						ip_info = netsh_if_ip_show(@tc_show_dut_args)
						flag    = ip_info[:ip].empty? || ip_info[:ip][0]=~/^169/
						p "#{@ts_nicname} ip: #{ip_info[:ip].join(",")}"
						assert flag, '应获取ip地址失败，但却获取ip地址成功！'

						rs_wip_release =@wifi.ip_release(@ts_wlan_nicname)
						assert rs_wip_release, 'wifi释放ip地址失败！'

						rs_wip_renew=@wifi.ip_renew(@ts_wlan_nicname)
						assert_equal(false, rs_wip_renew, 'wifi更新ip地址操作应失败,但却成功了！')

						wip_info = @wifi.netsh_if_ip_show(@tc_show_wireless_args)
						wflag    = wip_info[:ip].empty? || wip_info[:ip][0]=~/^169/
						p "#{@ts_wlan_nicname} ip: #{wip_info[:ip].join(",")}"
						assert wflag, 'wifi应获取ip地址失败，但却获取ip地址成功！'
				}

				operate("5 重新打开DHCP开关") {
						#要打开dhcp开关先要设置一个静态ip与路由器相连
						rs = netsh_if_ip_setip(@tc_static_args)
						assert rs, "设置静态ip失败"
						ping_test = ping(@ts_default_ip, @ts_nicname)
						assert_equal(true, ping_test, "设置静态ip后，无法ping通路由器！")

						rs_login = login(@browser, @ts_default_ip)
						@browser.span(:id => @tc_tag_lan).click if rs_login
						@lan_iframe = @browser.iframe
						assert_match /#{@tc_tag_lan_iframe_src}/i, @lan_iframe.src, '打开内网设置失败！'

						dhcp_button=@lan_iframe.button(:type, @tc_tag_button)
						if dhcp_button.class_name=="off"
								@lan_iframe.button(:type, @tc_tag_button).click
								#提交
								@lan_iframe.button(:id, @ts_tag_sbm).click
								Watir::Wait.until(@tc_wait_time, "等待重启LAN提示出现失败") {
										lan_reseting = @lan_iframe.div(class_name: @ts_tag_rebooting, text: @ts_tag_lan_reset_text)
										lan_reseting.present?
								}
								sleep @tc_net_time
						end
				}

				operate("6 重新打开DHCP功能后重新获取ip地址") {
						set_dhcp = netsh_if_ip_setip(@tc_dhcp_args)
						assert set_dhcp, '恢复dhcp功能后，还原网卡为dhcp模式！'

						sleep 3
						rs_ip_release=ip_release(@ts_nicname)
						assert rs_ip_release, '释放ip地址失败！'

						rs_ip_renew= ip_renew(@ts_nicname)
						assert rs_ip_renew, '更新ip地址操作失败'

						ip_info = netsh_if_ip_show(@tc_show_dut_args)
						p "#{@ts_nicname} ip: #{ip_info[:ip].join(",")}"

						rs1 =ping(@ts_default_ip)
						assert rs1, '客户端无法ping通路由器'

						rs_wip_release =@wifi.ip_release(@ts_wlan_nicname)
						assert rs_wip_release, 'wifi释放ip地址失败！'

						rs_wip_renew=@wifi.ip_renew(@ts_wlan_nicname)
						assert rs_wip_renew, 'wifi更新ip地址操作失败！'

						wip_info = @wifi.netsh_if_ip_show(@tc_show_wireless_args)
						p "#{@ts_wlan_nicname} ip: #{wip_info[:ip].join(",")}"


						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif客户端无法ping通路由器'
				}

		end

		def clearup

				operate("还原路由器DHCP默认开关设置") {
						@wifi.netsh_disc_all #断开wifi连接
						ping_test = ping(@ts_default_ip)
						unless ping_test
								netsh_if_ip_setip(@tc_static_args)
								sleep 5
						end

						rs_login=login(@browser, @ts_default_ip)
						@browser.span(:id => @tc_tag_lan).click if rs_login
						@lan_iframe = @browser.iframe

						dhcp_button=@lan_iframe.button(:type, @tc_tag_button)
						if dhcp_button.class_name=="off"
								@lan_iframe.button(:type, @tc_tag_button).click
								#提交
								@lan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}

				operate("恢复网卡默认设置") {
						rs_state=netsh_if_ip_show(@tc_show_dut_args)
						netsh_if_ip_setip(@tc_dhcp_args) if rs_state[:dhcp_state]=="no"
						sleep @tc_wait_time
				}
		end

}
