#
# description:
#DHCP服务器-地址池修改 ZLBF_8.1.3，已覆盖此测试点
# 这里只用了两台电脑做客户端
# author:wuhongliang
# date:2015-10-29 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.4", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time        = 2
				@tc_wireless_client  = 5
				@tc_wifi_time        = 30
				@tc_static_ip  = @ts_default_ip.sub(/\.\d+$/, '.123')
				@tc_static_args= {nicname: @ts_nicname, source: "static", ip: "#{@tc_static_ip}", mask: "255.255.255.0"}
				@tc_dhcp_args  = {nicname: @ts_nicname, source: "dhcp"}
				@tc_default_lan_start= "100"
				@tc_default_lan_end  = "200"
				@tc_lan_start        = "40"
				@tc_lan_end          = "50"

		end

		def process

				operate("1、PC1、PC2、PC3设置自动获取IP地址，查看获取的IP地址，如：192.168.1.100，192.168.1.101，192.168.102；") {
						#有线连接就是当前执行机，可以用不检查是否有IP地址，如果有线连接失败，脚本根本无法执行
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url, @ts_wifi_ssid1)
						@wifi_ssid1 = rs_wifi[:ssid]
						@wifi_pw    = rs_wifi[:pwd]
						puts "当前SSID1名为#{@wifi_ssid1}".to_gbk
						puts "当前SSID1 加密方式为#{@wifi_page.ssid1_pwmode}".to_gbk
						puts "WIFI密码为：#{@wifi_pw}".to_gbk

						#pc2连接dut无线
						p "PC2连接wifi".to_gbk
						rs   = @wifi.connect(@wifi_ssid1, @ts_wifi_flag, @wifi_pw, @ts_wlan_nicname)
						assert(rs, "PC2 wifi连接失败")
						rs2 = @wifi.ping(@ts_default_ip)
						assert rs2, 'WIFI客户端无法ping通路由器'
						#断开无线网卡连接
						@wifi.netsh_disc_all #断开wifi连接
				}

				operate("2、登陆路由器进入内网设置") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						@tc_lan_start_pre = @lan_page.lan_startip_pre
						@tc_lan_startip1  = @tc_lan_start_pre+@tc_lan_start
						@tc_lan_end_pre   = @lan_page.lan_endip_pre
						@tc_lan_endip1    =@tc_lan_end_pre+@tc_lan_start
				}

				operate("3、更改HDCP地址池范围 如:192.168.1.100~101；") {
						puts "修改地址池范围为 #{@tc_lan_startip1}-#{@tc_lan_endip1}".to_gbk
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_lan_start)
						@lan_page.btn_save_lanset
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
								# break unless ip_info[@ts_nicname][:ip].empty?
						end
						assert_equal(@tc_lan_startip1, ip_addr[0], "地址池范围后,#{@ts_nicname}未获得地址")
						#无线网卡重连接
						rs1 = @wifi.connect(@wifi_ssid1, @ts_wifi_flag, @wifi_pw)
						sleep 10
						wip_addr=""
						3.times do |i|
								wip_info =@wifi.ipconfig()
								sleep @tc_wireless_client
								wip_addr =wip_info[@ts_wlan_nicname][:ip]
								p "第#{i+1}次查询#{@ts_wlan_nicname} ip: #{wip_addr.join(",")}".to_gbk
						end
						assert_match(/^169/, wip_addr[0], "wifi客户端应该无法获取IP，但实际获得IP地址")
				}

		end

		def clearup

				operate("1 恢复默认地址池") {
						@wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
						sleep @tc_wireless_client
						p "断开WIFI连接".to_gbk
						@wifi.netsh_disc_all #断开wifi连接
						sleep @tc_wait_time
						ping_test = ping(@ts_default_ip)
						unless ping_test
								netsh_if_ip_setip(@tc_static_args)
								sleep @tc_wait_time
						end

						@browser.refresh
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						@tc_lan_startnum = @lan_page.lan_startip
						@tc_lan_endnum   = @lan_page.lan_endip
						flag_start       = @tc_lan_startnum==@tc_default_lan_start
						flag_end         = @tc_lan_endnum==@tc_default_lan_end
						unless flag_start&&flag_end
								puts "DHCP地址池恢复默认值".to_gbk if flag_start&&flag_end
								@lan_page.lan_startip_set(@tc_default_lan_start)
								@lan_page.lan_endip_set(@tc_default_lan_end)
								@lan_page.btn_save_lanset
						end
						netsh_if_ip_setip(@tc_dhcp_args)
						@browser.refresh
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.modify_default_ssid(@browser.url, @ts_wifi_ssid1)
				}

		end

}
