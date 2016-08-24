#
# description:
# 这里只用了两台电脑做客户端
# author:wuhongliang
# date:2015-10-29 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.4", "level" => "P1", "auto" => "n"}

		def prepare

				DRb.start_service
				@wifi            = DRbObject.new_with_uri(@ts_drb_server)
				@tc_net_time     = 50
				@tc_wait_time    = 2
				@tc_wifi_enable  = "enabled"
				@tc_wifi_disable = "disabled"

				@default_lan_start= @ts_default_ip.sub(/\.\d+$/, ".100")
				@default_lan_end  = @ts_default_ip.sub(/\.\d+$/, ".200")

				@new_lan_start1= @ts_default_ip.sub(/\.\d+$/, ".40")
				@new_lan_end1  = @ts_default_ip.sub(/\.\d+$/, ".50")

		end

		def process

				operate("1、PC1、PC2、PC3设置自动获取IP地址，查看获取的IP地址，如：192.168.1.100，192.168.1.101，192.168.102；") {
						#有线的连接就是当前执行机，可以用不检查是否有IP地址，如果有线连接失败，脚本根本无法执行
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")

						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_wpa)
								puts "恢复默认的加密码方式：#{@ts_sec_mode_wpa}".to_gbk
								select.select(@ts_sec_mode_wpa)
								@passwd_input = @lan_iframe.text_field(id: @ts_tag_input_pw)
								@passwd_input.set(@ts_default_wlan_pw)
								@lan_iframe.button(:id, @ts_tag_sbm).click
								#等配置生效
								puts "Waiting for wifi config changed..."
								sleep @tc_net_time
						end
						@current_pw = @lan_iframe.text_field(:id, @ts_tag_input_pw).value
						@ssid_name  = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						puts "当前SSID:#{@ssid_name},密码:#{@current_pw}".encode("GBK")
						rs1 = @wifi.connect(@ssid_name, @ts_wifi_flag, @current_pw)
						assert rs1, 'wifi连接失败'
						rs2 = @wifi.ping(@ts_default_ip)
						assert rs2, 'wifi客户端无法ping通路由器'
						#断开无线网卡连接
						@wifi.netsh_disc_all #断开wifi连接
				}

				operate("2、登陆路由器进入内网设置") {
						#断开无线网卡连接后设置地起地址和结束地址一样
						#有线网卡要释放和重新获取一次地址
						#然后再打开无线连接
						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						@current_startip = tc_startip_field.value
						puts "当前LAN地址池起始IP为#{@current_startip}".encode("GBK")
						puts "修改地址池结束IP为#{@new_lan_start1}".encode("GBK")
						tc_startip_field.set(@new_lan_start1)
						#获取当前结束地址
						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						@current_endip = tc_endip_field.value
						puts "当前LAN地址池结束IP为#{@current_endip}".encode("GBK")
						puts "修改地址池结束IP为#{@new_lan_start1}".encode("GBK")
						#修改dhcp结束地址
						tc_endip_field.set(@new_lan_start1)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
				}

				operate("3、更改HDCP地址池范围 如:192.168.1.100~101；") {
						#第二步已经实现
				}

				operate("4、PC1、PC2、PC3 DOS输入ipconfig/release手动释放IP地址，再输入ipconfig/renew重新获取IP地址，查看获取的IP地址是否正确；") {
						ip_addr=""
						ip_release(@ts_nicname)
						ip_renew(@ts_nicname)
						3.times do |i|
								ip_info = ipconfig()
								sleep @tc_wait_time
								ip_addr =ip_info[@ts_nicname][:ip]
								p "第#{i+1}次查询#{@ts_nicname} ip: #{ip_addr.join(",")}".to_gbk
								break unless ip_info[@ts_nicname][:ip].empty?
						end
						assert_equal(@new_lan_start1, ip_addr[0], "地址池范围后,#{@ts_nicname}未获得地址")
						#无线网卡重连接
						rs1 = @wifi.connect(@ssid_name, @ts_wifi_flag, @current_pw)
						sleep 10
						wip_addr=""
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep 15
								wip_addr =wip_info[@ts_wlan_nicname][:ip]
								p "第#{i+1}次查询#{@ts_wlan_nicname} ip: #{wip_addr.join(",")}".to_gbk
						end
						assert_match(/^169/, wip_addr[0], "wifi客户端应该无法获取IP，但实际获得IP地址")
				}


		end

		def clearup

				operate("恢复默认地址池范围") {
						@wifi.netsh_disc_all #断开wifi连接
						#删除配置配置文件 从而达到断开连接的目的
						profiles = @wifi.show_profiles
						profiles[@ts_wlan_nicname].each { |profile|
								@wifi.netsh_dp(profile, @ts_wlan_nicname)
						}

						flag_pool        = false
						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						current_startip  = tc_startip_field.value
						unless current_startip==@current_startip
								tc_startip_field.set(@current_startip)
								flag_pool=true
						end

						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						current_endip  = tc_endip_field.value
						unless current_endip==@current_endip
								tc_endip_field.set(@current_endip)
								flag_pool=true
						end

						if flag_pool
								@lan_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}

		end

}
