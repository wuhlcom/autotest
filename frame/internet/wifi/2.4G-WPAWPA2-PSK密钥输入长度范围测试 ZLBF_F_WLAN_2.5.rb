#
# description:
# 测试最短和最长密码
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.14", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi          = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wifi_ssid1 = "Wireless0"
				@tc_wifi_ssid2 = "Wireless1"
				@tc_wifi_ssid3 = "Wireless2"
				@tc_wifi_ssid4 = "Wireless3"
				@tc_wifi_on    = "ON"
				@tc_wifi_off   = "OFF"
				@tc_wifi_pw1   = "01234567"
				@tc_wifi_pw2   = "qwertyuioplkjhgfdsazxcvbnm896543210krtghjuiopasdfghjklmnbvcx123"
		end

		def process

				operate("1、秘钥输入#{@tc_wifi_pw1}，#{@tc_wifi_pw1.size}个字符，是否可以设置成功； STA是否连接成功；") {
						@wifi_page   = RouterPageObject::WIFIPage.new(@browser)
						@tc_mac_last = @wifi_page.get_mac_last
						@wifi_page.select_2g_basic(@browser.url)
						###############################ssid1#######################
						ssid1_name = @wifi_page.ssid1
						puts "当前SSID1名为#{ssid1_name}".to_gbk
						new_ssid1 = "wirless1_#{@tc_mac_last}"
						puts "新SSID1名为#{new_ssid1}".to_gbk
						@wifi_page.modify_ssid1(new_ssid1)
						puts "修改SSID1密码为#{@tc_wifi_pw1}".to_gbk
						@wifi_page.modify_ssid1_pw(@tc_wifi_pw1)
						@wifi_page.save_wifi_config

						rs1_ssid1 = @wifi.connect(new_ssid1, @ts_wifi_flag, @tc_wifi_pw1)
						assert rs1_ssid1, 'WIFI连接失败'
						rs2_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid1, 'WIFI客户端无法ping通路由器'

						puts "修改SSID1密码为#{@tc_wifi_pw2}".to_gbk
						@wifi_page.modify_ssid1_pw(@tc_wifi_pw2)
						@wifi_page.save_wifi_config

						rs3_ssid1 = @wifi.connect(new_ssid1, @ts_wifi_flag, @tc_wifi_pw2)
						assert rs3_ssid1, 'WIFI连接失败'
						rs4_ssid1 = @wifi.ping(@ts_default_ip)
						assert rs4_ssid1, 'WIFI客户端无法ping通路由器'
						##############################SSID2#################################################
						ssid2_name = @wifi_page.ssid2
						puts "当前SSID2名为#{ssid2_name}".to_gbk
						new_ssid2 = "wirless2_#{@tc_mac_last}"
						puts "新SSID2名为#{new_ssid2}".to_gbk
						@wifi_page.modify_ssid2(new_ssid2)
						puts "修改SSID2密码为#{@tc_wifi_pw1}".to_gbk
						@wifi_page.modify_ssid2_pw(@tc_wifi_pw1)
						if @wifi_page.ssid2_sw == @tc_wifi_off
								@wifi_page.ssid2_sw = @tc_wifi_on
						end
						##############################SSID3#################################################
						ssid3_name = @wifi_page.ssid3
						puts "当前SSID3名为#{ssid3_name}".to_gbk
						new_ssid3 = "wirless3_#{@tc_mac_last}"
						puts "新SSID3名为#{new_ssid3}".to_gbk
						@wifi_page.modify_ssid3(new_ssid3)
						if @wifi_page.ssid3_sw == @tc_wifi_off
								@wifi_page.ssid3_sw = @tc_wifi_on
						end
						puts "修改SSID3密码为#{@tc_wifi_pw2}".to_gbk
						@wifi_page.modify_ssid3_pw(@tc_wifi_pw2)
						##############################SSID4#################################################
						ssid4_name = @wifi_page.ssid4
						puts "当前SSID4名为#{ssid4_name}".to_gbk
						new_ssid4 = "wirless4_#{@tc_mac_last}"
						puts "新SSID4名为#{new_ssid4}".to_gbk
						@wifi_page.modify_ssid4(new_ssid4)
						puts "修改SSID4密码为#{@tc_wifi_pw1}".to_gbk
						@wifi_page.modify_ssid4_pw(@tc_wifi_pw1)
						if @wifi_page.ssid4_sw == @tc_wifi_off
								@wifi_page.ssid4_sw = @tc_wifi_on
						end

						@wifi_page.save_wifi_config
						##############################connect SSID2#################################################
						puts "conneting  ssid :#{new_ssid2}"
						rs1_ssid2 = @wifi.connect(new_ssid2, @ts_wifi_flag, @tc_wifi_pw1)
						assert rs1_ssid2, 'WIFI连接失败'
						rs2_ssid2 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid2, 'WIFI客户端无法ping通路由器'
						##############################connect SSID3#################################################
						puts "conneting  ssid :#{new_ssid3}"
						rs3_ssid3 = @wifi.connect(new_ssid3, @ts_wifi_flag, @tc_wifi_pw2)
						assert rs3_ssid3, 'WIFI连接失败'
						rs4_ssid3 = @wifi.ping(@ts_default_ip)
						assert rs4_ssid3, 'WIFI客户端无法ping通路由器'
						##############################connect SSID4#################################################
						puts "conneting  ssid :#{new_ssid4}"
						rs1_ssid4 = @wifi.connect(new_ssid4, @ts_wifi_flag, @tc_wifi_pw1)
						assert rs1_ssid4, 'WIFI连接失败'
						rs2_ssid4 = @wifi.ping(@ts_default_ip)
						assert rs2_ssid4, 'WIFI客户端无法ping通路由器'
				}

				# operate("2、秘钥输入#{@tc_wifi_pw2},#{@tc_wifi_pw2.size}个16进制，是否可以设置成功；STA是否连接成功；") {
				# 		#上一步已经实现
				# }

		end

		def clearup
				operate("1 恢复默认ssid和密码") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#修改第一个SSID密码
						@wifi_page.modify_ssid1(@ts_wifi_ssid1)
						if @wifi_page.ssid1_sw == @tc_wifi_off
								@wifi_page.ssid1_sw = @tc_wifi_on
						end
						@wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)

						@wifi_page.modify_ssid2(@ts_wifi_ssid2)
						if @wifi_page.ssid2_sw == @tc_wifi_on
								@wifi_page.ssid2_sw = @tc_wifi_off
						end
						@wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)

						@wifi_page.modify_ssid3(@ts_wifi_ssid3)
						if @wifi_page.ssid3_sw == @tc_wifi_on
								@wifi_page.ssid3_sw = @tc_wifi_off
						end
						@wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)

						@wifi_page.modify_ssid4(@ts_wifi_ssid4)
						if @wifi_page.ssid4_sw == @tc_wifi_on
								@wifi_page.ssid4_sw = @tc_wifi_off
						end
						@wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
						@wifi_page.save_wifi_config
				}
		end

}
