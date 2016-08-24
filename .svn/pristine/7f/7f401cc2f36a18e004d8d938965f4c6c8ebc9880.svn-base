#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.31", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time      = 2
				@tc_net_time       = 50
				@tc_relogin_time   = 60
				@tc_reboot_time    = 120
				@tc_test_ssid      = "wifitest_whl"
				@tc_pub_tcp_port   = 5001
				@tc_vir_tcpsrv_port= 5002
		end

		def process

				operate("1、登录DUT管理页面；") {
						puts "恢复路由器为出厂设置".encode("GBK")
						#先将路由器恢复出厂设置
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择‘系统设置’
						sysset      = @advance_iframe.link(id: @ts_tag_op_system)
						sysset_name = sysset.class_name
						unless sysset_name == @ts_tag_select_state
								sysset.click
								sleep @tc_wait_time
						end

						#选择“恢复出厂设置”标签
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time
						#点击”恢复出厂设置“按钮
						@advance_iframe.button(id: @ts_tag_reset_factory).click
						sleep @tc_wait_time
						reset_confirm_tip = @advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reset_text)
						assert reset_confirm_tip.visible?, "未弹出恢复出厂提示!"
						#确认恢复出厂值
						reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						reset_confirm.click
						puts "waiting for system reboot......"
						sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
						login_no_default_ip(@browser) #重新登录
				}

				operate("2、配置WAN连接为PPTP方式，修改LAN口IP地址，修改地址池范围，修改无线SSID，修改无线安全，修改无线高级参数，添加端口转发规则、端口触发规则、添加URL过滤规则、IP与端口过滤规则、开启UPNP功能、开启DMZ功能、开启DDNS功能、修改登录密码等页面所有可配置的选项；") {
						#恢复出厂值后，先查询默认配置，
						#再增加配置
						#修改SSID，修改接入方式为PPTP
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_dhcp})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk
						assert_match(/#{@ts_wan_mode_dhcp }/, wan_type, "默认接入接入类型不是#{@ts_wan_mode_dhcp}！")
						ssid_name = @status_iframe.b(:id => @ts_dut_ssid).parent.text
						/\n(?<ssid>.+)/m=~ssid_name
						@tc_default_ssid = ssid
						puts "默认SSID为：#{@tc_default_ssid}".encode("GBK")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						#修改SSID
						@lan_iframe.text_field(id: @ts_tag_ssid).set(@tc_test_ssid) #输入ssid
						@lan_iframe.button(id: @ts_tag_sbm).click #保存
						sleep @tc_net_time

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#修改为PPTP接入
						@browser.link(:id => @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择网络连接
						network = @advance_iframe.link(:id, @ts_tag_op_network)
						unless network.class_name =~ /#{@ts_tag_select_state}/
								network.click
								sleep @tc_wait_time
						end
						@advance_iframe.link(:id, @ts_tag_op_pptp).click
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).wait_until_present(@tc_pptpset_time)

						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip)
						@advance_iframe.text_field(:id, @ts_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_iframe.text_field(:id, @ts_tag_pptp_pw).set(@ts_pptp_pw)
						@advance_iframe.button(:id, @ts_tag_sbm).click
						puts "Waiting for pptp connection..."
						sleep @tc_net_time

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						#查看虚拟服务器开关状态
						virtualsrv_btn = @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_off).exists?
						assert(virtualsrv_btn, "虚拟服务器开关默认被打开了")
						virtualsrv_item = @advance_iframe.td(text: "1").exists?
						refute(virtualsrv_item, "默认配置了虚拟服务器")

						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "Virtual Server IP #{@tc_pc_ip}"

						#打开虚拟服务器开关
						@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
						#添加一条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip1).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip1).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_tcp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_vir_tcpsrv_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time

						virtualsrv_btn = @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
						assert(virtualsrv_btn, "虚拟服务器开关打开失败")
						virtualsrv_item = @advance_iframe.td(text: "1").exists?
						assert(virtualsrv_item, "配置虚拟服务器失败")

						#高级设置页面背景DIV
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#找到背景根DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#隐藏高级设置背景DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#隐藏背景根DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#查看PPTP和SSID的配置是否生效
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_pptp})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk
						assert_match(/#{@ts_wan_mode_pptp}/, wan_type, "接入类型不是#{@ts_wan_mode_pptp}！")
						ssid_name = @status_iframe.b(:id => @ts_dut_ssid).parent.text
						/\n(?<ssid>.+)/m=~ssid_name
						tc_ssid = ssid
						puts "修改后SSID为:#{tc_ssid}".encode("GBK")
						assert_match(/#{@tc_test_ssid }/, tc_ssid, "SSID不是#{@tc_test_ssid}！")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("3、在页面进行复位，查看设置的参数是否全部复位成出厂默认状态；") {
						#先将路由器恢复出厂设置
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择‘系统设置’
						sysset      = @advance_iframe.link(id: @ts_tag_op_system)
						sysset_name = sysset.class_name
						unless sysset_name == @ts_tag_select_state
								sysset.click
								sleep @tc_wait_time
						end

						#选择“恢复出厂设置”标签
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time
						#点击”恢复出厂设置“按钮
						@advance_iframe.button(id: @ts_tag_reset_factory).click
						sleep @tc_wait_time
						reset_confirm_tip = @advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reset_text)
						assert reset_confirm_tip.visible?, "未弹出恢复出厂提示!"
						#确认恢复出厂值
						reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						reset_confirm.click

						puts "waiting for system reboot...."
						sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
						login_no_default_ip(@browser) #重新登录

						puts "恢复出厂设置后查看默认值是否恢复成功！".encode("GBK")
						#查看PPTP和SSID的配置是否生效
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_dhcp})/
						puts "恢复出厂设置后WAN接入类型为：#{Regexp.last_match(1)}".to_gbk
						assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, "接入类型不是#{@ts_wan_mode_dhcp}！")

						ssid_name = @status_iframe.b(:id => @ts_dut_ssid).parent.text
						/\n(?<ssid>.+)/m=~ssid_name
						tc_ssid = ssid
						puts "恢复出厂设置后SSID为:#{tc_ssid}".encode("GBK")
						assert_match(/#{@tc_default_ssid}/, tc_ssid, "SSID不是#{@tc_default_ssid}！")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#查看虚拟服务器配置是否恢复为默认值
						@browser.link(:id => @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time

						#查看虚拟服务器开关状态
						virtualsrv_btn = @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_off).exists?
						assert(virtualsrv_btn, "恢复出厂设置后虚拟服务器开关是打开的")
						virtualsrv_item = @advance_iframe.td(text: "1").exists?
						refute(virtualsrv_item, "恢复出厂设置后虚拟服务器配置未删除")
				}


		end

		def clearup

				operate("1 恢复默认设置") {
						if @browser.span(id: @ts_tag_status).exists?
								@browser.span(id: @ts_tag_status).click
								sleep @tc_wait_time
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
								wan_type =~/\n(\w+)/m
								puts "当前路由器接入类型为：#{Regexp.last_match(1)}".to_gbk
								ssid_name      = @status_iframe.b(:id => @ts_dut_ssid).parent.text
								/\n(?<ssid>.+)/m =~ ssid_name
								tc_ssid = ssid
								puts "当前路由器SSID为:#{tc_ssid}".encode("GBK")
								#恢复默认接入方式
								unless wan_type =~/(#{@ts_wan_mode_dhcp})/
										#打开外网设置
										@browser.span(:id => @ts_tag_netset).click
										#选择有线连接
										@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
										@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
										#设置为dhcp接入
										dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
										dhcp_radio_state = dhcp_radio.checked?
										unless dhcp_radio_state
												dhcp_radio.click
												@wan_iframe.button(:id, @ts_tag_sbm).click
												sleep @tc_net_time
										end
								end
								#恢复默认SSID
								unless tc_ssid =~/(#{@tc_default_ssid})/ && !@tc_default_ssid.nil?
										@lan_iframe.text_field(id: @ts_tag_ssid).set(@tc_default_ssid) #输入ssid
										@lan_iframe.button(id: @ts_tag_sbm).click #保存
										sleep @tc_net_time
								end

								#恢复虚拟服务器默认配置
								@browser.link(id: @ts_tag_options).click
								@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

								#选择‘应用设置’
								application      = @advance_iframe.link(id: @ts_tag_application)
								application_name = application.class_name
								unless application_name == @ts_tag_select_state
										application.click
										sleep @tc_wait_time
								end

								#选择“虚拟服务器”标签
								virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
								virtualsrv_state = virtualsrv.parent.class_name
								virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
								sleep @tc_wait_time

								if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
										#关闭虚拟服务器开关
										@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
										flag=true
								end
								if @advance_iframe.td(text: "1").exists?
										#删除端口映射
										@advance_iframe.button(id: @ts_tag_delvir).click
										flag=true
								end
								if flag
										#保存
										@advance_iframe.button(id: @ts_tag_save_btn).click
										sleep @tc_wait_time
								end
						end

						if @browser.text_field(:name, @ts_tag_usr).exists?
								puts "如果出现登录界面，先登录路由器".encode("GBK")
								login_no_default_ip(@browser) #重新登录
								@browser.span(id: @ts_tag_status).click
								sleep @tc_wait_time
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
								wan_type =~/\n(\w+)/m
								puts "当前路由器接入类型为：#{Regexp.last_match(1)}".to_gbk
								ssid_name = @status_iframe.b(:id => @ts_dut_ssid).parent.text
								/\n(?<ssid>.+)/m =~ ssid_name
								tc_ssid = ssid
								puts "当前路由器SSID为:#{tc_ssid}".encode("GBK")
								#恢复默认接入方式
								unless wan_type =~/(#{@ts_wan_mode_dhcp})/
										#打开外网设置
										@browser.span(:id => @ts_tag_netset).click
										#选择有线连接
										@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
										@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
										#设置为dhcp接入
										dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
										dhcp_radio_state = dhcp_radio.checked?
										unless dhcp_radio_state
												dhcp_radio.click
												@wan_iframe.button(:id, @ts_tag_sbm).click
												sleep @tc_net_time
										end
								end
								#恢复默认SSID
								unless tc_ssid =~/(#{@tc_default_ssid})/ && !@tc_default_ssid.nil?
										@browser.span(:id => @ts_tag_lan).click
										@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
										@lan_iframe.text_field(id: @ts_tag_ssid).set(@tc_default_ssid) #输入ssid
										@lan_iframe.button(id: @ts_tag_sbm).click #保存
										sleep @tc_net_time
								end

								#恢复虚拟服务器默认配置
								@browser.link(id: @ts_tag_options).click
								@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

								#选择‘应用设置’
								application      = @advance_iframe.link(id: @ts_tag_application)
								application_name = application.class_name
								unless application_name == @ts_tag_select_state
										application.click
										sleep @tc_wait_time
								end

								#选择“虚拟服务器”标签
								virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
								virtualsrv_state = virtualsrv.parent.class_name
								virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
								sleep @tc_wait_time

								if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
										#关闭虚拟服务器开关
										@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
										flag=true
								end
								if @advance_iframe.td(text: "1").exists?
										#删除端口映射
										@advance_iframe.button(id: @ts_tag_delvir).click
										flag=true
								end
								if flag
										#保存
										@advance_iframe.button(id: @ts_tag_save_btn).click
										sleep @tc_wait_time
								end
						end
				}
		end
}
