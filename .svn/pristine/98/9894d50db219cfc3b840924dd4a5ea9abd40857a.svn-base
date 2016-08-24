#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_current_software = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*current/ }
				@tc_upload_file      = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*new/ }
				@tc_upload_file =~ /(V\d+R\d+SPC\d+)/
				@tc_upload_vername = Regexp.last_match(1)
				puts "New version file:#{@tc_upload_file}"
				puts "New version name:#{@tc_upload_vername}"

				#默认SSID
				@tc_default_ssid = "WIFI_"+@ts_sub_mac
				puts "Default SSID:#{@tc_default_ssid}"

				#将要设置的SSID
				@tc_ssid = "zhilutest_#{@ts_sub_mac}"
				DRb.start_service
				@wifi               = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wifi_flag       = "1"
				@tc_wait_time       = 2
				@tc_gap_time        = 3
				@tc_net_time        = 50
				@tc_net_reset       = 30
				@tc_update_confirm  = 10
				@tc_status_iframe   = 10
				@tc_wait_for_reboot = 150
				@tc_wait_for_login  = 20

				@tc_tag_wan_mode_label = "wire-pppoe"
				@tc_tag_on             = "On"

				@tc_tag_button       = "button"
				@tc_tag_update_state = "active"
				@tc_tag_update_src   = "update.asp"
				@tc_tag_update       = "update-titile"

				@tc_tag_verion          = "version"
				@tc_tag_update_filename = "filename"
				@tc_tag_update_btn      = "update_submit_btn"

				@tc_tag_update_tip_div = "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_update_tip     = "aui_content"
				@tc_tag_updating       = "固件升级进行中"
				@tc_tag_updated        = "固件升级完成"
				@tc_tag_confirm_btn    = "aui_state_highlight"

		end

		def process

				operate("1 打开路由器WAN设置,设置PPPOE模式") {
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
						pppoe_radio_state = pppoe_radio.attribute_value(:checked)
						unless pppoe_radio_state == "true"
								pppoe_radio.click
						end

						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
				}

				operate("2 修改路由器SSID") {
						if @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "打开内网设置失败!")

						puts "修改SSID为：#{@tc_ssid}".to_gbk
						ssid_obj = @lan_iframe.text_field(:id, @ts_tag_ssid)
						ssid_obj.set(@tc_ssid)
						@lan_iframe.button(:id, @ts_tag_sbm).click
						puts "修改SSID后,等待网络重启。。。".to_gbk
						sleep @tc_net_reset
				}

				operate("3 无线客户端连接路由器") {
						rs = @wifi.connect(@tc_ssid, @tc_wifi_flag)
						assert rs, "WIFI连接失败"
						sleep @tc_wait_time #等待无线连接稳定
				}

				operate("4 查看路由器配置信息") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_wait_time+8 #等待页面显示
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						Watir::Wait.until(@tc_net_time, "等待PPPOE拨号成功".to_gbk) {
								wan_addr     = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
								wan_type     = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
								mask         = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
								gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
								dns_addr     = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
								wifi_on_off  = @status_iframe.b(:id => @ts_wifi_status).parent.text
								wifi_ssid    = @status_iframe.b(:id => @ts_dut_ssid).parent.text

								assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
								assert_match /#{@tc_wire_mode}/, wan_type, '接入类型错误！'
								assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
								assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
								assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
								assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI状态不正确!")
								assert_match(/#{@tc_ssid}$/, wifi_ssid, "SSID显示不正确")
						}
				}

				operate("5 验证客户端网络业务") {
						rs1 = @wifi.ping(@ts_web)
						rs2 = ping(@ts_web)
						assert(rs1, "无线客户端无法连接网络")
						assert(rs2, "有线客户端无法连接网络")
				}

				operate("6 升级路由器软件") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe
						assert_match /#{@ts_tag_advance_src}/i, @advance_iframe.src, "打开高级设置失败!"

						#选择‘系统设置’
						sysset = @advance_iframe.link(id: @ts_tag_op_system).class_name
						unless sysset == @ts_tag_select_state
								@advance_iframe.link(id: @ts_tag_op_system).click
								sleep @tc_gap_time
						end

						#选择 "固件升级"
						update_label       = @advance_iframe.link(id: @tc_tag_update)
						update_label_state = update_label.parent.class_name
						update_label.click unless update_label_state==@tc_tag_update_state
						sleep @tc_gap_time

						#设置升级文件
						@advance_iframe.file_field(id: @tc_tag_update_filename).set(@tc_upload_file)
						sleep @tc_wait_time
						@advance_iframe.button(id: @tc_tag_update_btn).click
						sleep @tc_update_confirm
						#由于低版本升高版本会弹出升级提示框
						# if @advance_iframe.button(class_name: @tc_tag_confirm_btn).exists?
						# 	puts "确认升级".to_gbk
						# 	@advance_iframe.button(class_name: @tc_tag_confirm_btn).click
						# end

						#等待升级完成
						puts "Waiting for system reboot...."
						sleep(@tc_wait_for_reboot) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_wait_for_login)
						assert rs, "跳转到登录页面失败!"

						#重新登录路由器
						login_no_default_ip(@browser)
				}

				operate("7 升级后检查版本信息") {
						#"\u7CFB\u7EDF\u7248\u672C\uFF1A V100R003SPC010 MAC\uFF1A00:0C:43:76:20:66"
						version_info = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						version_info =~/(V\d+R\d+SPC\d+)\s+MAC/
						@tc_vername_after = Regexp.last_match(1)
						puts "After updated, the version name is: #{@tc_vername_after}"
						refute_equal(@ts_current_ver, @tc_vername_after, "升级失败！")
				}

				operate("8 升级后检查配置信息") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_iframe #等待页面显示
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						Watir::Wait.until(@tc_status_iframe, "等待PPPOE拨号成功".to_gbk) {
								wan_addr     = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
								wan_type     = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
								mask         = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
								gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
								dns_addr     = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
								wifi_on_off  = @status_iframe.b(:id => @ts_wifi_status).parent.text
								wifi_ssid    = @status_iframe.b(:id => @ts_dut_ssid).parent.text

								assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
								assert_match /#{@tc_wire_mode}/, wan_type, '接入类型错误！'
								assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
								assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
								assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
								assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI状态不正确!")
								assert_match(/#{@tc_ssid}$/, wifi_ssid, "SSID显示不正确")
						}
				}

				operate("9 升级后检查验证客户端业务功能") {
						rs1 = @wifi.ping(@ts_web)
						rs2 = ping(@ts_web)
						assert(rs1, "无线客户端无法连接网络")
						assert(rs2, "有线客户端无法连接网络")
				}

		end

		def clearup

				operate("1 恢复默认版本") {
						@wifi.netsh_disc_all #断开wifi连接
						#"\u7CFB\u7EDF\u7248\u672C\uFF1AV100R003SPC010 MAC\uFF1A00:0C:43:76:20:66"
						version_info = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						version_info =~/(V\d+R\d+SPC\d+)\s+MAC/
						tc_current_ver = Regexp.last_match(1)
						puts "The Testing Version #{@ts_current_ver}"
						puts "The cunrret version name is #{tc_current_ver}"
						unless tc_current_ver==@ts_current_ver
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

								#选择‘系统设置’
								sysset          = @advance_iframe.link(id: @ts_tag_op_system).class_name
								unless sysset == @ts_tag_select_state
										@advance_iframe.link(id: @ts_tag_op_system).click
										sleep @tc_gap_time
								end

								#选择 "固件升级"
								update_label       = @advance_iframe.link(id: @tc_tag_update)
								update_label_state = update_label.parent.class_name
								update_label.click unless update_label_state==@tc_tag_update_state
								sleep @tc_gap_time

								#设置升级文件
								@advance_iframe.file_field(id: @tc_tag_update_filename).set(@tc_current_software)
								@advance_iframe.button(id: @tc_tag_update_btn).click
								sleep @tc_update_confirm
								#由于低版本升高版本会弹出升级提示框
								if @advance_iframe.button(class_name: @tc_tag_confirm_btn).exists?
										puts "确认升级".to_gbk
										@advance_iframe.button(class_name: @tc_tag_confirm_btn).click
								end

								#等待升级完成
								puts "Waitfing for system reboot...."
								sleep(@tc_wait_for_reboot) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
								rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_wait_for_login)

								if rs
										#重新登录路由器
										login_no_default_ip(@browser)
										version_info = @browser.p(text: /#{@ts_tag_sys_ver}/).text
										version_info =~/(V\d+R\d+SPC\d+)\s+MAC/
										tc_current_ver = Regexp.last_match(1)
										puts "After recover,the version name is #{tc_current_ver}"
								end
						end
				}

				operate("2 路由器配置恢复为默认配置") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式为网线连接
						rs1         =@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        =false
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag=true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.attribute_value(:checked)

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state == "true"
								dhcp_radio.click
								flag=true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end

				}

				operate("3 恢复默认SSID") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)

						puts "恢复SSID为默认SSID：#{@tc_default_ssid}".to_gbk
						ssid_obj = @lan_iframe.text_field(:id, @ts_tag_ssid)
						ssid_obj.set(@tc_default_ssid)

						@lan_iframe.button(:id, @ts_tag_sbm).click
						puts "修改SSID后,等待网络重启。。。".to_gbk
						sleep @tc_net_reset
				}

		end

}
