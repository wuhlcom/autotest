#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.7", "level" => "P1", "auto" => "n"}

		def prepare

				DRb.start_service
				@wifi = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time        = 3
				@tc_wait_relogin     = 150
				@tc_wait_net_reset   = 30
				@tc_net_reset        = 15
				@tc_wpa_value        = "WPAPSKWPA2PSK"
				@ts_tag_lan_reset    ="aui_content"
				@tc_tag_net_reset_tip= "aui_state_noTitle aui_state_focus aui_state_lock"

				@tc_lan_ip1 = "172.168.100.1"
				@tc_lan_ip2 = "11.0.0.1"

		end


		def process

				operate("1 打开内网设置") {
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@ts_tag_lan_src}/i, @lan_iframe.src, '打开内网设置失败！'
				}

				operate("2 连接路由器wifi") {
						ssid_name = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "恢复默认的加密码方式：#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#等配置生效
								puts "Waiting for wifi config changed..."
								sleep @tc_wait_net_reset
						end
						@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
						@current_pw   = @passwd_input.value
						puts "wifi passwd:#{@current_pw}"

						flag  = "1"
						rs    = @wifi.connect(ssid_name, flag, @current_pw)
						assert rs, 'wifi连接失败'
				}

				operate("3 查看客户端信息") {
						ip_info     = ipconfig("all")
						dns_servers = ip_info[@ts_nicname][:dns_server]
						rs1         = dns_servers.any? { |dns_server| dns_server=~/#{@ts_default_ip}/ }
						assert rs1, "DNS地址不正确"

						wifi_info     = @wifi.ipconfig("all")
						wifi_ip       = wifi_info[@ts_wlan_nicname][:ip][0]
						sub_default_ip=@ts_default_ip.sub(/\.\d+$/, "")
						assert_match(/#{sub_default_ip}/, wifi_ip, "wlan客户端地址不正确")
						wifi_gw = wifi_info[@ts_wlan_nicname][:gateway][0]
						assert_equal @ts_default_ip, wifi_gw, "wlan客户端网关地址不正确"
						wifi_dns_servers = wifi_info[@ts_wlan_nicname][:dns_server]
						rs2              = wifi_dns_servers.any? { |wifi_dns_server| wifi_dns_server=~/#{@ts_default_ip}/ }
						assert(rs2, "wifi客户端DNS地址不正确")
				}

				operate("4 修改lan ip为B类地址") {
						@lan_iframe.text_field(:id, @ts_tag_lanip).set(@tc_lan_ip1)
						sleep 3
						@lan_iframe.text_field(id: @ts_tag_lanstart).focus
						@lan_iframe.text_field(:id, @ts_tag_lanend).focus
						@lan_iframe.button(:id, @ts_tag_sbm).click

						#<div class="aui_content" style="padding: 20px 25px;">设置成功，请稍候......重置网络，如果网络断连，请重新连接。</div>
						Watir::Wait.until(@tc_wait_time, "等待重启网络提示出现失败") {
								lan_reseting = @lan_iframe.div(class_name: @ts_tag_rebooting, text: @ts_tag_lan_reset_text)
								lan_reseting.present?
						}
						rs = @browser.text_field(:name, @usr_text_id).wait_until_present(@tc_wait_relogin)
						assert rs, '跳转到登录页面失败！'
						#重新登录路由器
						login_no_default_ip(@browser)
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
				}

				operate("5 修改为B类地址后pc重新获取ip地址") {
						sleep @tc_net_reset
						ip_info     = ipconfig("all")
						dns_servers = ip_info[@ts_nicname][:dns_server]
						rs1         = dns_servers.any? { |dns_server| dns_server=~/#{@tc_lan_ip1}/ }
						assert rs1, "DNS地址不正确"
						wifi_info     = @wifi.ipconfig("all")
						wifi_ip       = wifi_info[@ts_wlan_nicname][:ip][0]
						sub_default_ip=@tc_lan_ip1.sub(/\.\d+$/, "")
						assert_match /#{sub_default_ip}/, wifi_ip, "wlan客户端地址不正确"

						wifi_gw = wifi_info[@ts_wlan_nicname][:gateway][0]
						assert_equal @tc_lan_ip1, wifi_gw, "wlan客户端网关地址不正确"
						wifi_dns_servers = wifi_info[@ts_wlan_nicname][:dns_server]
						rs2              = wifi_dns_servers.any? { |wifi_dns_server| wifi_dns_server=~/#{@tc_lan_ip1}/ }
						assert rs2, "wifi客户端DNS地址不正确"
				}

				operate("8 恢复Lan默认配置") {
						@lan_iframe.text_field(:id, @ts_tag_lanip).set(@ts_default_ip)
						@lan_iframe.button(:id, @ts_tag_sbm).click
						#<div class="aui_content" style="padding: 20px 25px;">设置成功，请稍候......重置网络，如果网络断连，请重新连接。</div>
						Watir::Wait.until(@tc_wait_time, "等待重启LAN网络提示出现失败") {
								lan_reseting = @lan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
								lan_reseting.present?
						}
						rs = @browser.text_field(:name, @usr_text_id).wait_until_present(@tc_wait_relogin)
						assert rs, '恢复Lan默认配置,跳转到登录页面失败！'
				}

		end

		def clearup

				operate("1 恢复Lan默认配置") {
						@wifi.netsh_disc_all #断开wifi连接
						rs1 = ping(@ts_default_ip)
						if rs1 == true
								puts "路由器已是默认配置".to_gbk
						else
								login_recover(@browser, @ts_default_ip)
						end
				}

		end

}
