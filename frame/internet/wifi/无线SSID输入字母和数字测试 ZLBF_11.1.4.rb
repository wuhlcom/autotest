#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.4", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi          = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_ssid_name1 = "abczfh123"
				@tc_ssid_name2 = "abczfh1234"
				@tc_wifi_on    = "ON"
				@tc_wifi_off   = "OFF"
		end

		def process

				operate("1、无线SSID输入test123，查看是否设置成功，STA是否连接成功；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)

						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#ssid1
						@wifi_page.modify_ssid1(@tc_ssid_name1)
						puts "修改SSID1名字为#{@tc_ssid_name1}".to_gbk
						ssid_mode = @wifi_page.ssid1_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID1密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
						end
						ssid1_pw = @wifi_page.ssid1_pw
						if @wifi_page.ssid1_sw == @tc_wifi_off
								@wifi_page.ssid1_sw = @tc_wifi_on
						end

						#ssid2
						@wifi_page.modify_ssid2(@tc_ssid_name2)
						puts "修改SSID2名字为#{@tc_ssid_name2}".to_gbk
						ssid_mode = @wifi_page.ssid2_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID2密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						end
						ssid2_pw = @wifi_page.ssid2_pw
						if @wifi_page.ssid2_sw == @tc_wifi_off
								@wifi_page.ssid2_sw = @tc_wifi_on
						end
						@wifi_page.save_wifi_config

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询SSID详细信息".to_gbk
						ssid1 = @wifi_detail.ssid1_name
						ssid2 = @wifi_detail.ssid2_name
						assert_equal(@tc_ssid_name1, ssid1, "SSID1配置失败")
						assert_equal(@tc_ssid_name2, ssid2, "SSID2配置失败")

						p "无线客户端连接SSID1".to_gbk
						flag ="1"

						rs = @wifi.connect(@tc_ssid_name1, flag, ssid1_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi连接失败".to_gbk)
						pc_info = @wifi.ipconfig
						puts "IP地址为#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk

						p "无线客户端访问外网#{@ts_web}".to_gbk
						ping_rs = @wifi.ping(@ts_web)
						assert(ping_rs, "无线客户端无法访问外网#{@ts_web}")

						@wifi.netsh_disc_all #断开wifi连接

						p "无线连接SSID2".to_gbk
						rs = @wifi.connect(@tc_ssid_name2, flag, ssid2_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi连接失败")

						pc_info = @wifi.ipconfig
						puts "IP地址为#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk

						p "无线客户端访问外网#{@ts_web}".to_gbk
						ping_rs = @wifi.ping(@ts_web)
						assert(ping_rs, "无线客户端无法访问外网#{@ts_web}")
				}

		end

		def clearup

				operate("1 恢复无线默认配置") {
						#断开无线连接
						@wifi.netsh_disc_all
						#错误的密码格式也能保存的话，这里要等待其保存完成
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#修改SSID
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						if @wifi_page.ssid2_sw == @tc_wifi_on
								@wifi_page.ssid2_sw = @tc_wifi_off
						end
						@wifi_page.save_wifi_config
				}
		end

}
