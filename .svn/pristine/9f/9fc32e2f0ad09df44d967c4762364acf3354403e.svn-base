#
# description:
# author:wuhongliang
# 远程控制来恢复出厂设置
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.8", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj   = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_wait_time    = 5
				@tc_mac          = "00:11:00:00:00:FF"
				@tc_desc         = "remotetest"
				@tc_switch_on    = "on"
				@tc_switch_off   = "off"
				@tc_wifi_off     = "OFF"
				@tc_wifi_on      = "ON"
		end

		def process

				operate("1、PC1登录DUT页面修改当前配置(WAN 连接配置为PPPOE)；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						# 测试前先将路由器恢复出厂设置
						@options_page.recover_factory(@browser.url)
						# 重新登录
						@options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)

						#打开外网访问WEB
						@options_page.open_web_access_btn(@browser.url)
						@tc_web_acc_port = @options_page.web_access_port
						@options_page.save_web_access

						#设置MAC过滤
						@options_page.security_settings
						sleep @tc_wait_time
						@options_page.open_switch(@tc_switch_on, @tc_switch_off, @tc_switch_on, @tc_switch_off)
						@options_page.macfilter_click #打开mac过滤页面
						@options_page.mac_filter_add #添加过滤规则
						@options_page.mac_filter_input(@tc_mac, @tc_desc)
						@options_page.mac_filter_save
						rs = @browser.iframe(src: @ts_tag_advance_src).td(:text, @tc_mac).exists?
						assert(rs, "MAC过滤添加失败!")

						#关闭无线开关
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.close_2g_sw(@browser.url)
						@wifi_page.save_wifi_config(60)

						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为PPPOE".to_gbk
						#修改服务器租约后，WAN要重新获取一次IP地址，这里直接设置DHCP模式并保存
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type  = @systatus_page.get_wan_type
						@wan_addr = @systatus_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{@wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, @wan_addr, 'PPPOE获取IP地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
						#查看无线开关状态
						rs_wifisw = @systatus_page.get_wifi_switch
						assert_equal(@tc_wifi_off, rs_wifisw, "WIFI开关未关闭")
				}

				operate("2、PC2远程登录DUT页面，恢复出厂默认设置；") {
						@tc_remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{@tc_remote_url}"
						rs=@tc_server_obj.restore_router(@tc_remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "外网访问控制路由器恢复出厂设置失败")
						@browser.refresh
						sleep 1
						@browser.refresh
						sleep @tc_wait_time
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
						rs_wifisw = @systatus_page.get_wifi_switch
						puts "查询到WIFI开关状态:#{rs_wifisw}".to_gbk
						assert_equal(@tc_wifi_on, rs_wifisw, "WIFI开关未关闭")

						puts "查询到防火墙开关状态".to_gbk
						@options_page.open_security_page_step(@browser.url)
						fw_sw = @options_page.firewall_switch_element.class_name
						mac_sw= @options_page.mac_filter_switch_element.class_name
						assert_equal(@tc_switch_off, fw_sw, "外网连接恢复出厂值后防火墙总开关未关闭")
						assert_equal(@tc_switch_off, mac_sw, "外网连接恢复出厂值后MAC过滤开关未关闭")
				}

		end

		def clearup

				operate("1 恢复默认DHCP接入") {
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2.恢复wifi开关状态") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
						unless @wifi_page.wifi_sw_element.class_name==@tc_switch_on
								@wifi_page.turn_on_2g_sw
								@wifi_page.save_wifi_config
						end
				}

				operate("3 关闭防火墙开关并删除规则") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.close_web_access(@browser.url)
				}

				operate("4 关闭外网访问开关") {
						@options_page.close_web_access(@browser.url)
				}
		end

}
