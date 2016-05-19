#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.37", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time          = 2
				@tc_download_conf_time = 10
				@tc_net_time           = 60
				@tc_reboot_time        = 120
				@tc_relogin_time       = 80
				tc_time                = Time.now.strftime("%Y%m%d%H%M%S")
				@tc_newssid            = @ts_ssid_test_pre+tc_time
				puts "new ssid:#{@tc_newssid}" #ssid是动态获取时间生成的,每次执行都不一样
				@tc_passwd = "zhilutest123"
				@tc_dmz_ip = "192.168.200.200"
		end

		def process

				operate("1 先恢复路由器出厂设置") {
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
						Watir::Wait.until(@tc_wait_time, "开始恢复出厂设置") {
								@advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reseting_text)
						}
						puts "Waitfing for system reboot...."
						sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
						login_no_default_ip(@browser) #重新登录

				}

				operate("2、配置WAN连接为PPPoE方式，输入正确用户名与密码，保存，拨号是否成功，PC上网业务是否正常；") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')

						#设置为有线连接
						rs1= @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						#设置PPPOE拨号
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end

						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						Watir::Wait.until(@tc_wait_time+5, "等待网络重启提示出现".to_gbk) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
						}
						Watir::Wait.while(@tc_net_time, "正在重启网络配置".to_gbk) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present?
						}
						rs = ping(@ts_web)
						assert(rs, "PPPOE上网失败")
				}

				operate("3、修改LAN口IP地址，修改地址池范围，修改无线SSID，修改无线安全，修改无线高级参数，添加端口转发规则、端口触发规则、添加URL过滤规则、IP与端口过滤规则、开启UPNP功能、开启DMZ功能、开启DDNS功能、修改登录密码等，") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						#修改lan ip
						@lan_iframe.text_field(id: @ts_tag_lanip).set(@ts_dhcp_server_ip)
						#修改ssid
						@lan_iframe.text_field(id: @ts_tag_ssid).set(@tc_newssid)
						#修改密码
						@lan_iframe.text_field(id: @ts_tag_input_pw).set(@tc_passwd)
						@lan_iframe.button(id: @ts_tag_sbm).click
						# Watir::Wait.until(@tc_wait_time, "等待重启网络提示出现失败") {
						# 	lan_reseting = @lan_iframe.div(class_name: @ts_tag_rebooting, text: @ts_tag_lan_reset_text)
						# 	lan_reseting.present?
						# }
						sleep @tc_reboot_time
						rs = @browser.text_field(:name, @ts_tag_login_usr).wait_until_present(@tc_relogin_time)
						assert rs, '跳转到登录页面失败！'
						#重新登录路由器
						login_no_default_ip(@browser)

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“DMZ设置”标签
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开dmz开关
						@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_off).exists?
						#输出dmz服务地址
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
				}

				operate("4、点击备份，查看备份文件操作是否成功；") {
						#取出下载目录下的所有文件绝对路径存入数组
						old_backup_files = Dir.glob(@ts_backup_directory+"/*")
						#删除目录下所有配置文件
						old_backup_files.each do |file|
								FileUtils.rm_rf(file) if file=~/#{@ts_default_config_name}$/
						end
						old_config = Dir.glob(@ts_backup_directory+"/*").any? { |file| file=~/#{@ts_default_config_name}$/ }
						refute(old_config, "旧的配置文件未删除")
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						#选择‘系统设置’
						sysset          = @advance_iframe.link(id: @ts_tag_op_system)
						sysset_name     = sysset.class_name
						unless sysset_name == @ts_tag_select_state
								sysset.click
								sleep @tc_wait_time
						end

						#选择“恢复出厂设置”标签
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time
						#选择备份
						@advance_iframe.button(id: @ts_tag_export).click
						sleep @tc_download_conf_time
						#查看文件是否下载成功
						config_file = ""
						config_flag = false
						Dir.glob(@ts_backup_directory+"/*").each { |file|
								if file=~/#{@ts_default_config_name}$/
										config_file=file
										config_flag=true
										break
								end
						}
						assert(config_flag, "PPPOE配置文件下载失败！")
						#读取配置文件
						content = ""
						open(config_file, "r") { |f|
								puts "输出配置文件内容:".encode("GBK")
								content = f.read
								content = content.encode("UTF-8", {:invalid => :replace, :undef => :replace, :replace => "?"})
						}
						#查看配置内容是否正确
						#pppoe配置

						puts "配置文件匹配结果".encode("GBK")
						puts "PPPOE CONIFG"
						content =~ /wanConnectionMode=#{@ts_wan_mode_pppoe}/
						content =~ /wan_pppoe_user=#{@ts_pppoe_usr}/
						content =~ /wan_pppoe_pass=#{@ts_pppoe_pw}/
						content =~ /wan_pppoe_opmode=KeepAlive/
						content =~ /wan_pppoe_optime=60/
						#lan配置
						puts "LAN CONIFG"
						content =~ /lan_ipaddr=#{@ts_dhcp_server_ip}/
						content =~ /SSID1=#{@tc_newssid}/ #ssid是动态获取时间生成的,每次执行都不一样
						content =~ /WPAPSK1=#{@tc_passwd}/
						#dmz
						puts "DMZ CONIFG"
						content =~ /DMZEnable=1/
						content =~ /DMZAddress=#{@tc_dmz_ip}/

						matchs = content =~ /wanConnectionMode=#{@ts_wan_mode_pppoe}/ &&
								content =~ /wan_pppoe_user=#{@ts_pppoe_usr}/ &&
								content =~ /wan_pppoe_pass=#{@ts_pppoe_pw}/ &&
								content =~ /wan_pppoe_opmode=KeepAlive/ &&
								content =~ /wan_pppoe_optime=60/ &&
								#lan配置
								content =~ /lan_ipaddr=#{@ts_dhcp_server_ip}/ &&
								content =~ /SSID1=#{@tc_newssid}/ &&
								content =~ /WPAPSK1=#{@tc_passwd}/ &&
								#dmz
								content =~ /DMZEnable=1/ &&
								content =~ /DMZAddress=#{@tc_dmz_ip}/
						if matchs
								assert(true, "导出配置文件正常")
						else
								assert(false, "导出的配置文件内容异常")
						end
				}


		end

		def clearup

				operate("1 恢复出厂设置以恢复默认配置") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

						#选择‘系统设置’
						sysset          = @advance_iframe.link(id: @ts_tag_op_system)
						sysset_name     = sysset.class_name
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
						#确认恢复出厂值
						reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						reset_confirm.click
						puts "Waitfing for system reboot...."
						sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待

				}

		end

}
