#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.24", "level" => "P2", "auto" => "n"}

		def prepare

				@tc_default_ip      = "192.168.100.1"
				@tc_default_startip = "192.168.100.100"
				@tc_default_endip   = "192.168.100.200"
				@tc_lan_ip          = "192.168.30.1"
				@tc_lan_startip     = "192.168.30.50"
				@tc_lan_endip       = "192.168.30.100"
				@tc_wait_time       = 2
				@tc_netreset_time   = 50
				@tc_net_time        = 10
				@tc_pool_time       = 30
				@tc_reset_time      = 150
				@tc_tag_account     = "login-accout"

		end

		def process

				operate("1、进入LAN设置页面；") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")
				}

				operate("2、更改LAN IP与子网掩码，更改地址池范围") {
						tc_lan_field = @lan_iframe.text_field(id: @ts_tag_lanip)
						@lan_ip      = tc_lan_field.value
						puts "当前LAN IP为#{@lan_ip}".encode("GBK")
						puts "修改为#{@tc_lan_ip}".encode("GBK")
						tc_lan_field.set(@tc_lan_ip)

						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						@current_startip = tc_startip_field.value
						puts "当前LAN起始地址池IP为#{@current_startip}".encode("GBK")
						puts "修改为#{@tc_lan_startip}".encode("GBK")
						tc_startip_field.set(@tc_lan_startip)

						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						@current_endip = tc_endip_field.value
						puts "当前LAN结束地址池IP为#{@current_endip}".encode("GBK")
						puts "修改为#{@tc_lan_endip}".encode("GBK")
						tc_endip_field.set(@tc_lan_endip)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_reset_time
						rs = @browser.span(:id, @tc_tag_account).wait_until_present(@tc_net_time)
						assert rs, '跳转到登录页面失败！'
						#重新登录路由器
						login_no_default_ip(@browser)
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe  = @browser.iframe(src: @ts_tag_lan_src)

						#查看修改是否成功
						tc_lan_field = @lan_iframe.text_field(id: @ts_tag_lanip)
						new_lan_ip   = tc_lan_field.value
						assert_equal(@tc_lan_ip, new_lan_ip, "修改LAN IP失败")

						tc_startip_field    = @lan_iframe.text_field(id: @ts_tag_lanstart)
						new_current_startip = tc_startip_field.value
						assert_equal(@tc_lan_startip, new_current_startip, "修改LAN地址池起始IP失败")

						tc_endip_field    = @lan_iframe.text_field(id: @ts_tag_lanend)
						new_current_endip = tc_endip_field.value
						assert_equal(@tc_lan_endip, new_current_endip, "修改LAN地址池结束IP失败")
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("3、恢复DUT为出厂默认状态，查看LAN设置页面的参数是否被复位成默认状态。") {
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
						system_reset.click unless system_reset_state==@ts_tag_select_state
						sleep @tc_wait_time

						#点击”恢复出厂设置“按钮
						@advance_iframe.button(id: @ts_tag_reset_factory).click
						sleep @tc_wait_time

						reset_confirm_tip = @advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reset_text)
						assert reset_confirm_tip.visible?, "未弹出恢复出厂提示!"

						#确认恢复出厂值
						reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						reset_confirm.click
						puts "Waitfing for system reboot...."
						sleep @tc_reset_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.span(:id, @tc_tag_account).wait_until_present(@tc_net_time)
						assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
						login_no_default_ip(@browser) #重新登录

						#恢复出厂设置后，查看是否恢复默认值
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe  = @browser.iframe(src: @ts_tag_lan_src)
						tc_lan_field = @lan_iframe.text_field(id: @ts_tag_lanip)
						new_lan_ip   = tc_lan_field.value
						puts "#{new_lan_ip}"
						assert_equal(@tc_default_ip, new_lan_ip, "恢复为默认LAN IP失败")

						tc_startip_field    = @lan_iframe.text_field(id: @ts_tag_lanstart)
						new_current_startip = tc_startip_field.value
						puts "#{new_current_startip}"
						assert_equal(@tc_default_startip, new_current_startip, "恢复为默认LAN地址池起始IP失败")

						tc_endip_field    = @lan_iframe.text_field(id: @ts_tag_lanend)
						new_current_endip = tc_endip_field.value
						puts "#{new_current_endip}"
						assert_equal(@tc_default_endip, new_current_endip, "恢复为默认LAN地址池结束IP失败")
				}


		end

		def clearup
				operate("恢复LAN设置为默认配置") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @lan_iframe.nil? && @lan_iframe.exists?
								login_recover(@browser, @ts_default_ip)
								@browser.span(id: @ts_tag_lan).click
								@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						end

						tc_lan_field = @lan_iframe.text_field(id: @ts_tag_lanip)
						lan_ip       = tc_lan_field.value

						flag_lan  = false
						flag_pool =false
						unless lan_ip == @tc_default_ip
								tc_lan_field.set(@tc_default_ip)
								flag_lan=true
						end

						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						current_startip  = tc_startip_field.value

						unless current_startip==@tc_default_startip
								tc_startip_field.set(@tc_lan_startip)
								flag_pool=true
						end

						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						current_endip  = tc_endip_field.value
						unless current_endip==@tc_default_endip
								tc_endip_field.set(@tc_default_endip)
								flag_pool=true
						end

						if flag_lan
								@lan_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_netreset_time
						elsif flag_pool
								@lan_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_pool_time
						end
				}

		end

}
