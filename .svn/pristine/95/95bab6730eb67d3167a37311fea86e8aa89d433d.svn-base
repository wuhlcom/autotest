#
#description:
# 用例太过复杂，整改用例后再实现
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.29", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_wait_time         = 3
				@tc_relogin_time      = 60
				@tc_reboot_time       = 120
				@tc_tag_systemset     = "syssetting"
				@tc_tag_system_state  = "selected"
				@tc_tag_reboot_state  = "active"
				@tc_tag_adreboot      = "reboot-titile"
				@tc_tag_reboot_btn    = "reboot_submit_btn"
				@tc_tag_reboot_confirm= "aui_state_highlight"
		end

		def process

				operate("1 在快捷操作页面重启路由器") {
						@browser.span(id: @ts_tag_reboot).click
						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "未提示重启路由器要确认!"
						reboot_confirm.click

						#<div class="aui_content" style="padding: 20px 25px;">正在重启中，请稍等...</div>
						Watir::Wait.until(@tc_wait_time, "重启路由器正在重启提示未出现") {
								@browser.div(:class_name, @ts_tag_rebooting).visible?
						}
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "重启路由器失败未跳转到登录页面!"
				}

				operate("2 使用高级设置界面的重启功能") {
						login_no_default_ip(@browser)
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择‘系统设置’
						sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
						unless sysset == @tc_tag_system_state
								@advance_iframe.link(id: @tc_tag_systemset).click
								sleep @tc_wait_time
						end

						#选择“重启路由器”
						system_reboot = @advance_iframe.link(id: @tc_tag_adreboot)
						reboot_state  = system_reboot.parent.class_name
						system_reboot.click unless reboot_state==@tc_tag_reboot_state

						#重启路由器
						@advance_iframe.button(id: @tc_tag_reboot_btn).click

						reboot_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "未提示重启路由器要确认!"
						#确认重启
						reboot_confirm.click

						#<div class="aui_content" style="padding: 20px 25px;">正在重启中，请稍等...</div>
						# Watir::Wait.until(@tc_wait_time, "重启路由器正在重启提示未出现") {
						# 	@advance_iframe.div(:class_name, @ts_tag_rebooting).visible?
						# }
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "重启路由器后未跳转到登录页面!"
				}
		end

		def clearup

		end

}
