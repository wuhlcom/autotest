#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.18", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi               = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_wait_time       = 2
				@tc_wifi_time       = 30
				@tc_wifi_on         = "on"
				@tc_wifi_status_off = "OFF"
				@tc_wifi_status_on  = "ON"
				@tc_ssid_name       = "autotest_1094"
		end

		def process

				operate("1、进入路由器内网设置页面；") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name)
						puts "修改SSID1名字为#{@tc_ssid_name}".to_gbk
						ssid_mode = @wifi_page.ssid1_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID1密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						end
						@tc_ssid1_pw = @wifi_page.ssid1_pw
						@wifi_page.save_wifi_config
				}

				operate("2、设置无线开关为关；") {
						@wifi_page.select_2g_advset
						@wifi_page.turn_off_2g_sw
						@wifi_page.save_wifi_config
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						systatus = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_status_off, systatus, "无线开关关闭失败！")
						sleep @tc_wifi_time
				}

				operate("3、使用无线网卡扫描该SSID，是否可以扫描成功；手动输入连接该SSID，是否可以连接成功；") {
						rs = @wifi.scan_network_once(@tc_ssid_name)
						refute(rs[:flag], "无线开关关闭后应该无法扫描成功！")
						#手动输入配置查看是否连接成功
						ssid_hash ={:au_type => "WPA2PSK", :pass_type => "CCMP"}
						rs_conn = @wifi.add_new_connection(ssid_hash, @tc_ssid_name, @tc_ssid1_pw)
						refute(rs_conn, "无线开关关闭后静态添加无线连接应会连接失败!")
				}

				operate("4、设置无线开关为开；") {
						@wifi_page.open_2g_sw(@browser.url)
						@wifi_page.save_wifi_config
						@systatus_page.open_systatus_page(@browser.url)
						systatus = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_status_on, systatus, "无线开关打开失败！")
				}

				operate("5、使用无线网卡扫描该SSID，是否可以扫描成功，且能连接成功；") {
						p "无线客户端连接SSID1".to_gbk
						rs = @wifi.connect(@tc_ssid_name, @ts_wifi_flag, @tc_ssid1_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi连接失败".to_gbk)
						pc_info = @wifi.ipconfig
						puts "IP地址为#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk
						p "无线客户端访问#{@ts_default_ip}".to_gbk
						ping_rs = @wifi.ping(@ts_default_ip)
						assert(ping_rs, "无线客户端无法访问#{@ts_default_ip}")
				}

		end

		def clearup

				operate("1 恢复无线默认配置") {
						#断开无线连接
						@wifi.netsh_disc_all
						#打开无线开关
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
						unless @wifi_page.wifi_sw_element.class_name==@tc_wifi_on
								@wifi_page.wifi_sw
								@wifi_page.save_wifi_config
						end
						#错误的密码格式也能保存的话，这里要等待其保存完成
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#修改第一个SSID密码
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.save_wifi_config
				}

		end

}
