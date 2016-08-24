#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.30", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time      = 3
				@tc_net_time       = 60
				@tc_ralink_time    = 120
				@tc_static_ip      = "10.10.10.54"
				@tc_static_mask    = "255.255.255.0"
				@tc_static_gateway = "10.10.10.1"
				@tc_static_dns     = "10.10.10.1"
				@tc_lan_ip         = "192.168.90.1"
				@tc_lan_start      = "192.168.90.50"
				@tc_lan_end        = "192.168.90.100"
				@tc_static_backdns = "8.8.8.8"
				@tc_wifi_ssid      = "wifi_llp"
				@tc_wifi_safe      = "None"
				@tc_clear_config   = "ralink_init clear 2860;\nralink_init renew 2860 /etc_ro/Wireless/RT2860AP/RT2860_default_vlan\n"
				# @tc_init_config    = "ralink_init renew 2860 /etc_ro/Wireless/RT2860AP/RT2860_default_vlan"
				@flag              = false
				# @lanip_changeflag  = false
				@dut_ip            = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
		end

		def process

				operate("1、登录DUT管理页面；") {
						#先恢复出厂设置，查看默认值
						telnet_init(@default_url, @ts_default_usr, @ts_default_pw)
						exp_ralink_init(@tc_clear_config)
						sleep @tc_ralink_time
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_default(@browser) #重新登录
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe    = @browser.iframe(src: @ts_tag_status_iframe_src)
						@wan_default_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text #默认接入方式
						p "默认接入方式是：#{@wan_default_type}".to_gbk
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "打开内网设置失败！")
						@lan_ip_default    = @lan_iframe.text_field(id: @ts_tag_lanip).value
						@lan_start_default = @lan_iframe.text_field(id: @ts_tag_lanstart).value
						@lan_end_default   = @lan_iframe.text_field(id: @ts_tag_lanend).value
						@lan_ssid_default  = @lan_iframe.text_field(id: @ts_tag_ssid).value
						p "默认内网IP：#{@lan_ip_default}".to_gbk
						p "默认开始地址池：#{@lan_start_default}".to_gbk
						p "默认结束地址池：#{@lan_end_default}".to_gbk
						p "默认ssid：#{@lan_ssid_default}".to_gbk
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						@fire_wall_default = @option_iframe.button(id: @ts_tag_security_sw).class_name
						@ip_btn_default    = @option_iframe.button(id: @ts_tag_security_ip).class_name
						p "默认防火墙开关状态：#{@fire_wall_default}".to_gbk
						p "默认IP过滤开关状态：#{@ip_btn_default}".to_gbk
						@option_iframe.link(id: @ts_tag_application).click #应用设置
						vir_btn = @option_iframe.button(id: @ts_tag_virtualsrv_sw) #虚拟服务器
						vir_btn.wait_until_present(@tc_wait_time)
						@vir_btn_default = vir_btn.class_name
						p "默认虚拟服务器开关状态：#{@ip_btn_default}".to_gbk
						@option_iframe.link(id: @ts_tag_dmz).click #DMZ
						dmz_btn = @option_iframe.button(id: @ts_tag_dmzsw)
						dmz_btn.wait_until_present(@tc_wait_time)
						@dmz_btn_default = dmz_btn.class_name
						p "默认DMZ开关状态：#{@ip_btn_default}".to_gbk
						@option_iframe.link(id: @ts_tag_ddns).click #ddns
						ddns_btn = @option_iframe.button(id: @ts_tag_ddns_sw)
						ddns_btn.wait_until_present(@tc_wait_time)
						@ddns_btn_default = ddns_btn.class_name
						p "默认DDNS开关状态：#{@ip_btn_default}".to_gbk
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、配置WAN连接为静态IP地址方式，修改LAN口IP地址，修改地址池范围，修改无线SSID，修改无线安全，修改无线高级参数，添加端口转发规则、端口触发规则、添加URL过滤规则、IP与端口过滤规则、开启UPNP功能、开启DMZ功能、开启DDNS功能、修改登录密码等页面所有可配置的选项；") {
						p "配置WAN连接为静态IP地址方式".to_gbk
						@browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开外网失败！")
						rs1 = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						rs1.wait_until_present(@tc_wait_time)
						unless rs1.class_name =~/ #{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						static_radio       = @wan_iframe.radio(id: @ts_tag_wired_static) #选择手动方式连接
						static_radio_state = static_radio.checked?
						unless static_radio_state
								static_radio.click
						end
						@wan_iframe.text_field(id: @ts_tag_staticIp).wait_until_present(@tc_wait_time)
						@wan_iframe.text_field(id: @ts_tag_staticIp).set(@tc_static_ip)
						@wan_iframe.text_field(id: @ts_tag_staticNetmask).set(@tc_static_mask)
						@wan_iframe.text_field(id: @ts_tag_staticGateway).set(@tc_static_gateway)
						@wan_iframe.text_field(id: @ts_tag_staticPriDns).set(@tc_static_dns)
						if @wan_iframe.text_field(id: @ts_tag_backupDns).exists?
								@wan_iframe.text_field(id: @ts_tag_backupDns).set(@tc_static_backdns)
						end
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						p "修改LAN口IP地址，修改地址池范围，修改无线SSID".to_gbk
						@browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "打开内网设置失败！")
						# @lan_iframe.text_field(id: @ts_tag_lanip).set(@tc_lan_ip)
						# @lan_iframe.text_field(id: @ts_tag_lanstart).set(@tc_lan_start)
						# @lan_iframe.text_field(id: @ts_tag_lanend).set(@tc_lan_end)
						@lan_iframe.text_field(id: @ts_tag_ssid).set(@tc_wifi_ssid)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
						# @lanip_changeflag = true
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_default(@browser, @tc_lan_ip) #重新登录
						end
						p "修改其他配置项".to_gbk
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						#安全设置
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						#打开防火墙总开关
						fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
						fire_wall_btn.click
						#打开IP过滤
						ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
						ip_btn.click
						@option_iframe.button(id: @ts_tag_security_save).click #保存
						sleep @tc_wait_time

						#打开应用设置
						@option_iframe.link(id: @ts_tag_application).click #应用设置
						vir_btn = @option_iframe.button(id: @ts_tag_virtualsrv_sw)
						vir_btn.wait_until_present(@tc_wait_time)
						vir_btn.click
						@option_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time
						#配置DMZ
						@option_iframe.link(id: @ts_tag_dmz).click #DMZ
						dmz_btn = @option_iframe.button(id: @ts_tag_dmzsw)
						dmz_btn.wait_until_present(@tc_wait_time)
						dmz_btn.click
						@option_iframe.text_field(id: @ts_tag_dmzip).set(@dut_ip)
						@option_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						#配置DDNS
						@option_iframe.link(id: @ts_tag_ddns).click #ddns
						ddns_btn = @option_iframe.button(id: @ts_tag_ddns_sw)
						ddns_btn.wait_until_present(@tc_wait_time)
						ddns_btn.click
						@option_iframe.text_field(id: @ts_tag_ddns_host).set(@dut_ip)
						@option_iframe.text_field(id: @ts_tag_ddns_user).set(@ts_default_usr)
						@option_iframe.text_field(id: @ts_tag_ddns_pwd).set(@ts_default_pw)
						@option_iframe.button(id: @ts_tag_ddns_save).click
						sleep @tc_wait_time
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("3、使用命令进行复位，查看设置的参数是否全部复位成出厂默认状态；") {
						telnet_init(@default_url, @ts_default_usr, @ts_default_pw)
						exp_ralink_init(@tc_clear_config)
						sleep @tc_ralink_time
						#做一个标志位，当代码执行到此时，表示脚本已进行了恢复出厂设置，这时不在clearup中恢复出厂设置了，否则就执行clearup代码块
						@flag = true
						p "查看配置是否恢复".to_gbk
						login_default(@browser) #重新登录
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						@status_iframe.b(id: @ts_tag_wan_type).wait_until_present(@tc_wait_time)
						wan_type = @status_iframe.b(id: @ts_tag_wan_type).parent.text
						assert_equal(@wan_default_type, wan_type, '接入类型错误，未恢复默认接入！')
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "打开内网设置失败！")
						# lan_ip    = @lan_iframe.text_field(id: @ts_tag_lanip).value
						# lan_start = @lan_iframe.text_field(id: @ts_tag_lanstart).value
						# lan_end   = @lan_iframe.text_field(id: @ts_tag_lanend).value
						lan_ssid = @lan_iframe.text_field(id: @ts_tag_ssid).value
						# assert_equal(@lan_ip_default, lan_ip, "内网IP未恢复成默认配置")
						# assert_equal(@lan_start_default, lan_start, "内网IP未恢复成默认配置")
						# assert_equal(@lan_end_default, lan_end, "内网IP未恢复成默认配置")
						assert_equal(@lan_ssid_default, lan_ssid, "内网IP未恢复成默认配置")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).click
						@option_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@option_iframe.exists?, "打开高级设置失败！")
						@option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
						@option_iframe.link(id: @ts_tag_security).click
						fire_wall = @option_iframe.link(id: @ts_tag_fwset)
						fire_wall.wait_until_present(@tc_wait_time)
						unless @option_iframe.button(id: @ts_tag_security_sw).exists?
								fire_wall.click
						end
						fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw).class_name
						ip_btn        = @option_iframe.button(id: @ts_tag_security_ip).class_name
						@option_iframe.link(id: @ts_tag_application).click #应用设置
						vir_btn = @option_iframe.button(id: @ts_tag_virtualsrv_sw) #虚拟服务器
						vir_btn.wait_until_present(@tc_wait_time)
						vir_btn_value = vir_btn.class_name
						@option_iframe.link(id: @ts_tag_dmz).click #DMZ
						dmz_btn = @option_iframe.button(id: @ts_tag_dmzsw)
						dmz_btn.wait_until_present(@tc_wait_time)
						dmz_btn_value = dmz_btn.class_name
						@option_iframe.link(id: @ts_tag_ddns).click #ddns
						ddns_btn = @option_iframe.button(id: @ts_tag_ddns_sw)
						ddns_btn.wait_until_present(@tc_wait_time)
						ddns_btn_value = ddns_btn.class_name

						assert_equal(@fire_wall_default, fire_wall_btn, "防火墙开关未恢复成默认值")
						assert_equal(@ip_btn_default, ip_btn, "IP过滤开关未恢复成默认值")
						assert_equal(@vir_btn_default, vir_btn_value, "虚拟服务器开关未恢复成默认值")
						assert_equal(@dmz_btn_default, dmz_btn_value, "DMZ开关未恢复成默认值")
						assert_equal(@ddns_btn_default, ddns_btn_value, "DDNS开关未恢复成默认值")

				}


		end

		def clearup
				operate("恢复默认出厂设置") {
						unless @flag
								# if @lanip_changeflag
								# 		lan_ip = @tc_lan_ip
								# else
								lan_ip = @default_url
								# end
								telnet_init(lan_ip, @ts_default_usr, @ts_default_pw)
								exp_ralink_init(@tc_clear_config)
								sleep @tc_ralink_time
						end
				}
		end

}
