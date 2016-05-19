#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.4", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time    = 3
				@tc_reboot_time  = 150
				@tc_relogin_time = 60

		end

		def process

				operate("1、进入DMZ配置页面，配置相关项；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						sleep @tc_wait_time
						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@pc_ip_addr = ip_info[:ip][0]
						puts "DMZ Server IP #{@pc_ip_addr}"
						#选择“DMZ设置”标签
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开dmz开关
						@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_off).exists?
						#配置dmz 服务器ip
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@pc_ip_addr)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
				}

				operate("2、把DUT复位到出厂默认状态，查看设置页面参数是否恢复成功。") {
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
						puts "Waitfing for system reboot...."
						sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "恢复出厂设置后未跳转到路由器登录页面!"

						#重新登录路由器
						rs_relogin = login_no_default_ip(@browser)
						assert(rs_relogin, "重新登录路由器失败!")

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						sleep @tc_wait_time
						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@pc_ip_addr = ip_info[:ip][0]
						puts "DMZ Server IP #{@pc_ip_addr}"
						#选择“DMZ设置”标签
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time
						#查看dmz开关
						rs = @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_off).exist?
						assert(rs, "恢复出厂设置后DMZ开关未关闭")
				}


		end

		def clearup
				operate("1 取消DMZ") {
						if @browser.link(id: @ts_tag_options).exists?
								if @advance_iframe.nil? || !@advance_iframe.exists?
										@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
										@browser.link(id: @ts_tag_options).click
										@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
								end
						else
								login_recover(@browser, @ts_default_ip)
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end

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

						if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_on).exists?
								#关闭dmz开关
								@advance_iframe.button(id: @ts_tag_dmzsw).click
								#提交
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
						end
				}
		end

}
