#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
	attr = {"id" => "ZLBF_21.1.12", "level" => "P1", "auto" => "n"}

	def prepare
		@tc_upload_file_current = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_current/i }
		puts "Current version file:#{@tc_upload_file_current}"

		@tc_upload_file_new = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_new/i }
		puts "New version file:#{@tc_upload_file_new}"

		@tc_upload_file_old = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_old/i }
		puts "Old version file:#{@tc_upload_file_old}"
		puts "Before uploading the version name is: #{@ts_current_ver}"

		@tc_wait_time       = 2
		@tc_gap_time        = 5
		@tc_net_wait_time   = 60
		@tc_wait_for_reboot = 120
		@tc_wait_for_login  = 80

		@tc_tag_systemset    = "syssetting"
		@tc_tag_system_state = "selected"
		@tc_tag_button       = "button"
		@tc_tag_update_state = "active"
		@tc_tag_update_src   = "update.asp"
		@tc_tag_update       = "update-titile"

		@tc_tag_verion          = "version"
		@tc_tag_update_filename = "filename"

		@tc_tag_file_div   = "aui_state_lock aui_state_focus" #共享目录的根DIV，focus在后表示选中了当前div
		@tc_tag_update_btn = "update_submit_btn"

		@tc_tag_update_tip_div = "aui_state_noTitle aui_state_focus aui_state_lock"
		@tc_tag_update_tip     = "aui_content"
		@tc_tag_updating       = "固件升级进行中"
		@tc_tag_updated        = "固件升级完成"
		@tc_tag_confirm_btn    = "aui_state_highlight"
		@tc_tag_same_ver       = "很抱歉，请重新选择升级包再执行升级操作！"

	end

	def process

		operate("1 从当前版本升到高级版本") {

			@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
			@browser.link(id: @ts_tag_options).click
			@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
			assert(@advance_iframe.exists?, "打开高级设置失败!")

			#选择‘系统设置’
			sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
			unless sysset == @tc_tag_system_state
				@advance_iframe.link(id: @tc_tag_systemset).click
				sleep @tc_gap_time
			end

			#选择 "固件升级"
			update_label       = @advance_iframe.link(id: @tc_tag_update)
			update_label_state = update_label.parent.class_name
			update_label.click unless update_label_state==@tc_tag_update_state
			sleep @tc_gap_time

			#设置升级文件
			@advance_iframe.file_field(id: @tc_tag_update_filename).set(@tc_upload_file_new)
			sleep @tc_wait_time
			@advance_iframe.button(id: @tc_tag_update_btn).click

			#等待升级完成
			puts "Waitfing for system reboot...."
			sleep(@tc_wait_for_reboot) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
			#degbug:重启过程中客户端可能会获得WAN IP地址
			# ip_release
			# ip_renew
			rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_wait_for_login)
			assert rs, "跳转到登录页面失败!"

			#重新登录路由器
			login_no_default_ip(@browser)

		}

		operate("2 当前版本升到高级版本后检查版本信息") {
			#"\u7CFB\u7EDF\u7248\u672C\uFF1AV100R003SPC010 MAC\uFF1A00:0C:43:76:20:66"
			version_info = @browser.p(text: /#{@ts_tag_sys_ver}/).text
			version_info =~/(V\d+R\d+SPC\d+)\s+MAC/
			tc_new_version = Regexp.last_match(1)
			puts "Updated new version name: #{tc_new_version}"
			refute_equal(tc_new_version, @ts_current_ver, "升级到高版本失败！")
		}

		operate("3 从高版本降级到当前版本") {
			@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
			@browser.link(id: @ts_tag_options).click
			@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
			assert(@advance_iframe.exists?, "打开高级设置失败!")

			#选择‘系统设置’
			sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
			unless sysset == @tc_tag_system_state
				@advance_iframe.link(id: @tc_tag_systemset).click
				sleep @tc_gap_time
			end

			#选择 "固件升级"
			update_label       = @advance_iframe.link(id: @tc_tag_update)
			update_label_state = update_label.parent.class_name
			update_label.click unless update_label_state==@tc_tag_update_state
			sleep @tc_gap_time

			#设置升级文件
			@advance_iframe.file_field(id: @tc_tag_update_filename).set(@tc_upload_file_current)
			@advance_iframe.button(id: @tc_tag_update_btn).click
			sleep @tc_gap_time
			#由于高版本升低版本会弹出升级提示框
			update_confirm = @advance_iframe.button(class_name: @tc_tag_confirm_btn)
			update_confirm.wait_until_present(@tc_wait_time)
			assert(update_confirm.exists?, "高版本降级到当前版本无提示！")
			@advance_iframe.button(class_name: @tc_tag_confirm_btn).click

			#等待升级完成
			puts "Waitfing for system reboot...."
			sleep(@tc_wait_for_reboot) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
			#degbug:重启过程中客户端可能会获得WAN IP地址
			ip_release
			ip_renew
			rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_wait_for_login)
			assert rs, "跳转到登录页面失败!"

			#重新登录路由器
			login_no_default_ip(@browser)
		}

		operate("4 从高版本降级到当前版本后检查版本信息") {
			#"\u7CFB\u7EDF\u7248\u672C\uFF1AV100R003SPC010 MAC\uFF1A00:0C:43:76:20:66"
			version_info = @browser.p(text: /#{@ts_tag_sys_ver}/).text
			version_info =~/(V\d+R\d+SPC\d+)\s+MAC/
			tc_currnet_ver = Regexp.last_match(1)
			puts "After updated,the version name is: #{tc_currnet_ver}"
			assert_equal(tc_currnet_ver, @ts_current_ver, "高版本降级到当前版本失败！")
		}

		operate("5 从当前版本降级到低版本") {
			@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
			@browser.link(id: @ts_tag_options).click
			@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
			assert(@advance_iframe.exists?, "打开高级设置失败!")

			#选择‘系统设置’
			sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
			unless sysset == @tc_tag_system_state
				@advance_iframe.link(id: @tc_tag_systemset).click
				sleep @tc_gap_time
			end

			#选择 "固件升级"
			update_label       = @advance_iframe.link(id: @tc_tag_update)
			update_label_state = update_label.parent.class_name
			update_label.click unless update_label_state==@tc_tag_update_state
			sleep @tc_gap_time

			#设置升级文件
			@advance_iframe.file_field(id: @tc_tag_update_filename).set(@tc_upload_file_old)
			@advance_iframe.button(id: @tc_tag_update_btn).click
			sleep @tc_gap_time
			#由于高版本升低版本会弹出升级提示框
			update_confirm = @advance_iframe.button(class_name: @tc_tag_confirm_btn)
			update_confirm.wait_until_present(@tc_wait_time)
			assert(update_confirm.exists?, "当前版本降级到低版本无提示！")
			@advance_iframe.button(class_name: @tc_tag_confirm_btn).click

			#等待升级完成
			puts "Waitfing for system reboot...."
			sleep(@tc_wait_for_reboot) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
			rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_wait_for_login)
			assert rs, "跳转到登录页面失败!"

			#重新登录路由器
			login_no_default_ip(@browser)
		}

		operate("6 当前版本降级到低版后检查版本信息") {
			#"\u7CFB\u7EDF\u7248\u672C\uFF1AV100R003SPC010 MAC\uFF1A00:0C:43:76:20:66"
			version_info = @browser.p(text: /#{@ts_tag_sys_ver}/).text
			version_info =~/(V\d+R\d+SPC\d+)\s+MAC/
			tc_current_ver = Regexp.last_match(1)
			puts "After updated,the version name is #{tc_current_ver}"
			refute_equal(tc_current_ver, @ts_current_ver, "当前版本降级到低版本时降级失败！")
		}

	end

	def clearup

		operate("1 恢复默认版本") {
			#"\u7CFB\u7EDF\u7248\u672C\uFF1AV100R003SPC010 MAC\uFF1A00:0C:43:76:20:66"
			version_info = @browser.p(text: /#{@ts_tag_sys_ver}/).text
			version_info =~/(V\d+R\d+SPC\d+)\s+MAC/
			tc_current_ver = Regexp.last_match(1)
			puts "The cunrretn version name is #{tc_current_ver}"
			unless tc_current_ver==@ts_current_ver
				@browser.link(id: @ts_tag_options).click
				@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

				#选择‘系统设置’
				sysset          = @advance_iframe.link(id: @tc_tag_systemset).class_name
				unless sysset == @tc_tag_system_state
					@advance_iframe.link(id: @tc_tag_systemset).click
					sleep @tc_gap_time
				end

				#选择 "固件升级"
				update_label       = @advance_iframe.link(id: @tc_tag_update)
				update_label_state = update_label.parent.class_name
				update_label.click unless update_label_state==@tc_tag_update_state
				sleep @tc_gap_time

				#设置升级文件
				@advance_iframe.file_field(id: @tc_tag_update_filename).set(@tc_upload_file_current)
				@advance_iframe.button(id: @tc_tag_update_btn).click

				#由于高版本升低版本会弹出升级提示框
				update_confirm = @advance_iframe.button(class_name: @tc_tag_confirm_btn)
				rs             = update_confirm.wait_until_present(@tc_wait_time)
				if rs
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

	end

}
