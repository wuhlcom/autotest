#
#description:
# 用例太过复杂，整改用例后再实现
# 会大量增加维护成本
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.21", "level" => "P1", "auto" => "n"}

		def prepare
				@ts_download_directory.gsub!("\\", "\/")
				@tc_file_name          = "RT2880_Settings.dat"
				@tc_wait_time          = 2
				@tc_gap_time           = 2
				@tc_status_time        = 10
				@tc_download_conf_time = 20
				@tc_reboot_time        = 120
				@tc_relogin_time       = 80
				@tc_tag_inport         = "filename"
				@tc_tag_update_btn     = "update_submit_btn"

		end

		def process
				operate("1 打开高级设置，选择系统设置->恢复出厂设置") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择‘系统设置’
						sysset      = @advance_iframe.link(id: @ts_tag_op_system)
						sysset_name = sysset.class_name
						unless sysset_name == @ts_tag_select_state
								sysset.click
								sleep @tc_gap_time
						end

						#选择“恢复出厂设置”标签
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time
				}

				operate("2 点击恢复出厂设置") {
						#点击”恢复出厂设置“按钮
						@advance_iframe.button(id: @ts_tag_reset_factory).click
						sleep @tc_wait_time
						reset_confirm_tip = @advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reset_text)
						assert reset_confirm_tip.visible?, "未弹出恢复出厂提示!"
						#确认恢复出厂值
						reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						reset_confirm.click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_wait_time, "开始恢复出厂设置") {
								@advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reseting_text)
						}
						puts "Waiting for system reboot...."
						sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
				}

				operate("5 打开外网连接设置") {
						login_no_default_ip(@browser) #重新登录
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')
				}

				operate("6 设置PPPOE拨号") {
						#设置为有线连接
						rs1= @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								rs2 = @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						# sleep @tc_wait_time
						Watir::Wait.until(@tc_wait_time+5, "等待网络重启提示出现".to_gbk) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
						}
						Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present?
						}
				}

				operate("7 查看PPPOE WAN状态") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_time #等待页面显示
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						sleep @tc_status_time #等待pppoe拨号成功
						wan_addr     = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type     = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						mask         = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr     = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

						assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
						assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
						assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
						assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
				}

				operate("8 验证PPPOE业务") {
						rs = ping(@ts_web)
						assert(rs, '无法连接网络')
				}

				operate("9 重新打开高级设置，选择系统设置->恢复出厂设置") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择‘系统设置’
						sysset      = @advance_iframe.link(id: @ts_tag_op_system)
						sysset_name = sysset.class_name
						unless sysset_name == @ts_tag_select_state
								sysset.click
								sleep @tc_gap_time
						end

						#选择“恢复出厂设置”标签
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time
				}

				operate("10 导出PPPOE配置文件") {
						#判断当前下载目录是否有配置文件，如果有则将其重命名
						config_file_old = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }

						unless config_file_old.nil?
								puts config_file_old
								timestamp       = Time.now().strftime("%Y%m%d%H%M%S")
								config_file_new = config_file_old.sub(/\./, "_#{timestamp}\.")
								File.rename(config_file_old, config_file_new)
						end

						#删除旧的默认配置文件
						Dir.glob(@ts_download_directory+"/*").delete_if { |file|
								if file=~/default/
										FileUtils.rm(file, force: true)
										true
								end
						}

						#如果有名字中不含"default"且与@tc_file_name匹配的将其修改为default配置
						config_file_old = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
						unless config_file_old.nil?
								config_file_default = config_file_old.sub(/\./, "_default\.")
								File.rename(config_file_old, config_file_default)
						end

						#处理默认配置后再导出pppoe配置
						@advance_iframe.button(id: @ts_tag_export).click
						sleep @tc_download_conf_time
						config_download = Dir.glob(@ts_download_directory+"/*").any? { |file| file=~/#{@tc_file_name}$/ }
						assert(config_download, "PPPOE配置文件下载失败！")
				}

				operate("11 导出PPPOE配置文件后恢复路由器为出厂设置") {
						#点击”恢复出厂设置“按钮
						@advance_iframe.button(id: @ts_tag_reset_factory).click
						sleep @tc_wait_time
						reset_confirm_tip = @advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reset_text)
						assert reset_confirm_tip.visible?, "未弹出恢复出厂提示!"
						#确认恢复出厂值
						reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						reset_confirm.click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_wait_time, "开始恢复出厂设置") {
								@advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reseting_text)
						}
						puts "Waitfing for system reboot...."
						sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
				}

				operate("12 恢复出厂设置后检查查看WAN状态,PPPOE是否被恢复") {
						login_no_default_ip(@browser) #重新登录
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_time #等待页面显示
						@status_iframe = @browser.iframe
						assert_match /#{@ts_tag_status}/i, @status_iframe.src, '打开WAN状态失败！'
						sleep @tc_status_time
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型未恢复为默认值！'
				}

				operate("13 导入PPPOE配置文件") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择‘系统设置’
						sysset = @advance_iframe.link(id: @ts_tag_op_system).class_name
						unless sysset == @ts_tag_select_state
								@advance_iframe.link(id: @ts_tag_op_system).click
								sleep @tc_gap_time
						end

						#选择“恢复出厂设置”标签
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time
						pppoe_config_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
						#如果找不到配置文件
						refute(pppoe_config_file.nil?, "配置文件不存")
						#设置配置文件
						@advance_iframe.file_field(id: @tc_tag_inport).set(pppoe_config_file)
						sleep @tc_wait_time
						@advance_iframe.button(id: @tc_tag_update_btn).click

						#等待配置导入完成
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "跳转到登录页面失败!"

						#重新登录路由器
						login_no_default_ip(@browser)
				}

				operate("14 导入PPPOE配置文件后查看PPPOE配置信息") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_waist_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_time #等待页面显示
						@status_iframe = @browser.iframe
						assert_match /#{@ts_tag_status}/i, @status_iframe.src, '打开WAN状态失败！'
						sleep @tc_status_time #等待pppoe拨号成功
						wan_addr     = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type     = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						mask         = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr     = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

						assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
						assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
						assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
						assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
				}

				operate("15 重新导入配后查看PPPOE业务") {
						rs = ping(@ts_web)
						assert(rs, '无法连接网络')
				}

		end

		def clearup

				operate("1 恢复为默认的接入方式，DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式为网线连接
						rs1         = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        = false
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag=true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag=true
						end
						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_relogin_time
						end
				}
		end

}
