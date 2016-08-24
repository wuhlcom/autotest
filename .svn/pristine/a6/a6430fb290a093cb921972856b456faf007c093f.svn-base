#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wifi_flag      = "1"
				@wifi              = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time      = 3
				@tc_wait_net_reset = 35
				@tc_conn_time      = 15
				@tc_tag_lan        = "set_wifi"

				@tc_tag_checkbox      = "pwdshow"
				@tc_tag_errmsg        = "error_msg"
				@tc_tag_lan_iframe_src= "lanset.asp"
				@tc_tag_ssid          = "ssid"
				@tc_tag_select_list   = "security_mode"
				@tc_sec_mode_wpa      = 'WPA-PSK/WPA2-PSK'
				@tc_wpa_value         = "WPAPSKWPA2PSK"
				@tc_tag_input_pw      = "input_password1"

				@tc_tag_net_reset_tip = "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_reset_tip     = "aui_content"
				@tc_pw_errinfo        = "密码只能是数字和字母,且长度是8-63个字符之间"

				@tc_num_letter   = "123"*10+"Adf"*10+"12k"
				@tc_pw_64        = "1"*64
				@tc_pw_7         = "a"*7
				@tc_pw_space1    = " 25678df"
				@tc_pw_space2    = "25678df "
				@tc_pw_space3    = "25678 df"
				@tc_pw_specail   = "25678%df"
				@tc_wlan_pw_arr1 = ["ABCDEFGH", "AyzkEDXf", "51d2A3bck", @tc_num_letter]
				@tc_wlan_pw_arr2 = [@tc_pw_7, @tc_pw_space1, @tc_pw_space2, @tc_pw_space3, @tc_pw_specail, @tc_pw_64]

		end

		def process

				operate("1 打开网络连接设置") {
						@browser.span(:id => @tc_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@tc_tag_lan_iframe_src}/i, @lan_iframe.src, "打开内网设置失败!"
				}

				operate("2 连接路由器WIFI") {
						#如果加密方式不WPA就修改为WPA
						select = @lan_iframe.select_list(id: @tc_tag_select_list)
						unless select.selected?(@tc_sec_mode_wpa)
								puts "恢复默认的加密码方式：#{@tc_sec_mode_wpa}".to_gbk
								select.select(@tc_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @tc_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#等配置生效
								puts "Waiting for wifi config changed..."
								sleep @tc_wait_net_reset+10
						end
						#如果加密密码不为默认密码就修改为默认密码
						if select.selected?(@tc_sec_mode_wpa)
								curr_pw = @lan_iframe.text_field(id: @tc_tag_input_pw).value
								unless curr_pw==@ts_default_wlan_pw
										@lan_iframe.text_field(id: @tc_tag_input_pw).set(@ts_default_wlan_pw)
										@lan_iframe.button(:id, @ts_tag_sbm).click
										#等配置生效
										puts "Waiting for wifi config changed..."
										sleep @tc_wait_net_reset+10
								end
						end

						@tc_ssid_name = @lan_iframe.text_field(:id, @tc_tag_ssid).value
						puts "当前SSID名为：#{@tc_ssid_name}".to_gbk
						rs = @wifi.connect(@tc_ssid_name, @tc_wifi_flag)
						assert rs, "WIFI连接失败"
				}

				operate("3 修改WIFI密码后重新连接") {
						@select = @lan_iframe.select_list(id: @tc_tag_select_list)
						unless @select.selected?(@tc_sec_mode_wpa)
								@select.select(@tc_sec_mode_wpa)
						end
						passwd_input =@lan_iframe.text_field(id: @tc_tag_input_pw)
						@tc_wlan_pw_arr1.each do |pw|
								puts("修改密码为：#{pw}".to_gbk)
								passwd_input.set(pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_wait_net_reset
								#只修改密码不会进行页面跳转 wuhongliang 2015-8-19
								rs1 = @wifi.connect(@tc_ssid_name, @tc_wifi_flag, pw)
								assert rs1, "WIFI连接失败"
								sleep @tc_conn_time
								rs2 = @wifi.ping(@ts_default_ip)
								assert rs2, "WIFI连接失败未获取IP地址"
						end
				}

				operate("4 非法用户名和密码无法保存") {
						passwd_input =@lan_iframe.text_field(id: @tc_tag_input_pw)
						@tc_wlan_pw_arr2.each do |pw|
								puts("修改密码为：#{pw}".to_gbk)
								passwd_input.set(pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								errinfo = @lan_iframe.span(id: @tc_tag_errmsg).text
								puts("ERROR:#{errinfo}".to_gbk)
								assert_equal(@tc_pw_errinfo, errinfo, "非密码也能保存")
						end
				}
		end

		def clearup
				operate("恢复默认密码") {
						@wifi.netsh_disc_all #断开wifi连接
						if @browser.text_field(:name, @ts_tag_usr).exists?
								login_no_default_ip(@browser)
						end

						if @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.span(:id => @tc_tag_lan).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @tc_tag_lan).click
						@lan_iframe = @browser.iframe
						if @lan_iframe.checkbox(id: @tc_tag_checkbox).set?
								current_pw = @lan_iframe.text_field(id: @tc_tag_input_pw).value
						else
								@lan_iframe.checkbox(id: @tc_tag_checkbox).set
								current_pw = @lan_iframe.text_field(id: @tc_tag_input_pw).value
						end
						@lan_iframe.checkbox.set(false)
						puts "current_pw:#{current_pw}"
						puts "default_pw:#{@ts_default_wlan_pw}"

						@select = @lan_iframe.select_list(id: @tc_tag_select_list)
						unless @select.selected?(@tc_sec_mode_wpa)
								@select.select(@tc_sec_mode_wpa)
						end
						passwd_input =@lan_iframe.text_field(id: @tc_tag_input_pw)
						unless current_pw == @ts_default_wlan_pw
								puts "修改密码为默认密码".to_gbk
								passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_wait_net_reset
						end
				}
		end

}
