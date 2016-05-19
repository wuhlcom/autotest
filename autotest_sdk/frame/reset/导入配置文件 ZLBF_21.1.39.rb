#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.39", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time         = 2
				@tc_download_conf_time= 5
				@tc_net_time          = 50
				@tc_relogin_time      = 60
				@tc_reboot_time       = 120
		end

		def process
				operate("1 将路由器恢复出厂设置") {
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

				operate("2、恢复出厂设置后查看默认配置") {
						#恢复出厂值后，先查询默认配置
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/\n(\w+)/m
						puts "恢复出厂设置后WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk
						assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, "默认接入接入类型不是#{@ts_wan_mode_dhcp}！")
				}

				operate("3、配置PPPOE接入方式") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')

						puts "设置外网连接方式".to_gbk
						wire_mode       = @wan_iframe.span(:id => @ts_tag_wired_mode_span)
						wire_mode_state = wire_mode.parent.class_name
						unless wire_mode_state=~/#{@ts_tag_select_state}/
								wire_mode.click
						end

						puts "设置外网PPPOE接入".to_gbk
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end

						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time

						#查看pppoe设置是否生效
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/\n(\w+)/m
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk
						assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, "设置为PPPOE模式后,接入类型不是#{@ts_wan_mode_pppoe}！")

						rs = ping(@ts_web)
						assert(rs, "PPPOE拨号上网正常")
				}

				operate("4、导出配置文件") {
						#取出下载目录下的所有文件绝对路径存入数组
						old_backup_files = Dir.glob(@ts_download_directory+"/*")
						#删除目录下所有配置文件
						old_backup_files.each do |file|
								FileUtils.rm_rf(file) if file=~/#{@ts_default_config_name}$/
						end
						old_config = Dir.glob(@ts_download_directory+"/*").any? { |file| file=~/#{@ts_default_config_name}$/ }
						refute(old_config, "旧的配置文件未删除")
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

						#点击备份按钮
						@advance_iframe.button(id: @ts_tag_export).click
						sleep @tc_download_conf_time
						#查看文件是否下载成功
						@tc_config_file = ""
						config_flag     = false
						Dir.glob(@ts_download_directory+"/*").each { |file|
								if file=~/#{@ts_default_config_name}$/
										@tc_config_file=file
										config_flag    =true
										break
								end
						}
						assert(config_flag, "PPPOE配置文件下载失败！")
				}

				operate("5、点击恢复出厂设置") {
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

				operate("6、恢复完成以后，查看路由器配置是否被恢复") {
						#恢复出厂值后，先查询默认配置
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_dhcp})/m
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk
						assert_match(/#{@ts_wan_mode_dhcp }/, wan_type, "默认接入接入类型不是#{@ts_wan_mode_dhcp}！")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("7、导入配置文件，查看导入是否成功") {
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

						@advance_iframe.file_field(id: @ts_tag_filename).set(@tc_config_file)
						sleep @tc_wait_time
						@advance_iframe.button(id: @ts_tag_inport_btn).click
						#等待配置导入完成
						puts "after import config,waiting for system reboot...."
						sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "跳转到登录页面失败!"
						login_no_default_ip(@browser) #重新登录

						#查看pppoe设置是否生效
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/\n(\w+)/m
						puts "导入配置后显示接入类型为：#{Regexp.last_match(1)}".to_gbk
						assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, "接入类型不是#{@ts_wan_mode_pppoe}！")

						#导入配置后，路由器PPPOE拨号业务验证
						rs_ping = ping(@ts_web)
						assert(rs_ping, "导入配置后PPPOE拨号上网正常")
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
						end
				}
		end

}
