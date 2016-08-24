#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.8", "level" => "P2", "auto" => "n"}

		def prepare

				DRb.start_service
				@wifi          = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_ssid_name1 = "a" #最短SSID
				@tc_ssid_name2 = "autotest_23a23f" #中间值
				@tc_ssid_name3 = "1234567890ASDFGHJKLMqwertyuiop12" #最长SSID
				@tc_wifi_on    = "ON"
				@tc_wifi_off   = "OFF"
		end

		def process

				operate("1、设置无线SSID为1个字符，设置为“#{@tc_ssid_name1}”，无线客户端与之关联，查看是否能连接成功，") {
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
						if @wifi_page.ssid1_sw == @tc_wifi_off
								@wifi_page.ssid1_sw = @tc_wifi_on
						end
						ssid1_pw = @wifi_page.ssid1_pw

						#ssid2
						@wifi_page.modify_ssid2(@tc_ssid_name2)
						puts "修改SSID2名字为#{@tc_ssid_name2}".to_gbk
						ssid_mode = @wifi_page.ssid2_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID2密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid2_sw == @tc_wifi_off
								@wifi_page.ssid2_sw = @tc_wifi_on
						end
						ssid2_pw = @wifi_page.ssid2_pw

						#ssid3
						@wifi_page.modify_ssid3(@tc_ssid_name3)
						puts "修改SSID3名字为#{@tc_ssid_name3}".to_gbk
						ssid_mode = @wifi_page.ssid3_pwmode
						unless ssid_mode==@ts_sec_mode_wpa
								puts "修改SSID3密码为#{@ts_default_wlan_pw}".to_gbk
								@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
						end
						if @wifi_page.ssid3_sw == @tc_wifi_off
								@wifi_page.ssid3_sw = @tc_wifi_on
						end
						ssid3_pw = @wifi_page.ssid3_pw
						@wifi_page.save_wifi_config

						@wifi_detail = RouterPageObject::WIFIDetail.new(@browser)
						@wifi_detail.open_wifidetail_page(@browser.url)
						puts "查询SSID详细信息".to_gbk
						ssid1 = @wifi_detail.ssid1_name
						ssid2 = @wifi_detail.ssid2_name
						ssid3 = @wifi_detail.ssid3_name
						assert_equal(@tc_ssid_name1, ssid1, "SSID1配置失败")
						assert_equal(@tc_ssid_name2, ssid2, "SSID2配置失败")
						assert_equal(@tc_ssid_name3, ssid3, "SSID3配置失败")

						p "无线客户端连接SSID1".to_gbk
						rs = @wifi.connect(@tc_ssid_name1, @ts_wifi_flag, ssid1_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi连接失败".to_gbk)
						pc_info = @wifi.ipconfig
						puts "IP地址为#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk
						p "无线客户端访问#{@ts_default_ip}".to_gbk
						ping_rs = @wifi.ping(@ts_default_ip)
						assert(ping_rs, "无线客户端无法访问外网#{@ts_default_ip}")

						@wifi.netsh_disc_all #断开wifi连接

						p "无线连接SSID2".to_gbk
						rs = @wifi.connect(@tc_ssid_name2, @ts_wifi_flag, ssid2_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi连接失败")
						pc_info = @wifi.ipconfig
						puts "IP地址为#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk
						p "无线客户端访问#{@ts_default_ip}".to_gbk
						ping_rs = @wifi.ping(@ts_default_ip)
						assert(ping_rs, "无线客户端无法访问外网#{@ts_default_ip}")

						p "无线连接SSID3".to_gbk
						rs = @wifi.connect(@tc_ssid_name3, @ts_wifi_flag, ssid3_pw, @ts_wlan_nicname)
						assert(rs, "PC wifi连接失败")
						pc_info = @wifi.ipconfig
						puts "IP地址为#{pc_info[@ts_wlan_nicname][:ip]}".to_gbk
						p "无线客户端访问#{@ts_default_ip}".to_gbk
						ping_rs = @wifi.ping(@ts_default_ip)
						assert(ping_rs, "无线客户端无法访问外网#{@ts_default_ip}")
				}

				operate("2、设置无线SSID为“#{@tc_ssid_name2}”#{@tc_ssid_name2.size}个字符，无线客户端与之关联，查看是否能连接成功；") {
						#上一步已经实现
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
						if @wifi_page.ssid1_sw == @tc_wifi_off
								@wifi_page.ssid1_sw = @tc_wifi_on
						end

						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						if @wifi_page.ssid2_sw == @tc_wifi_on
								@wifi_page.ssid2_sw = @tc_wifi_off
						end

						@wifi_page.modify_ssid3(@ts_wifi_ssid3)
						if @wifi_page.ssid3_sw == @tc_wifi_on
								@wifi_page.ssid3_sw = @tc_wifi_off
						end

						@wifi_page.save_wifi_config
				}
		end

}
