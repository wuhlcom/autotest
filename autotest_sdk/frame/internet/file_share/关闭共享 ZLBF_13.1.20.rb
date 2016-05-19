#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_13.1.20", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time            = 2
				@tc_gap_time             = 5
				@tc_close_share          = 5
				@tc_relogin_time         = 60
				@tc_reboot_time          = 120
				@tc_tag_systemset        = "syssetting"
				@tc_tag_system_state     = "selected"
				@tc_tag_file_share       = "USB-titile"
				@tc_tag_button           = "button"
				@tc_tag_file_share_state = "active"
				@tc_share_switch_off     = "off"
				@tc_share_switch_on      = "on"
				@tc_file_share_dir       = "Folder_structure.asp"
				@tc_storage_usb          = "U盘"
				@tc_storage_sd           = "SD卡"
				@tc_share_dir            = "一级目录"
				@tc_test_file            = "二级测试文件_TEST.txt"
				@tc_tag_close_share      = "关闭共享"
				@tc_tag_back             = "返回上一级"
		end

		def process

				operate("1 打开高级设置") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe
						assert_match /#{@ts_tag_advance_src}/i, @advance_iframe.src, "打开高级设置失败!"
				}

				operate("2 打开系统设置开启文件共享") {
						#选择‘系统设置’
						sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
						unless sysset == @tc_tag_system_state
								@advance_iframe.link(id: @tc_tag_systemset).click
								sleep @tc_gap_time
						end

						#选择 "文件共享"
						file_share_label       = @advance_iframe.link(id: @tc_tag_file_share)
						file_share_label_state = file_share_label.parent.class_name
						file_share_label.click unless file_share_label_state==@tc_tag_file_share_state
						sleep @tc_gap_time
						file_share = @browser.iframe(src: @tc_file_share_dir)
						rs         = file_share.exists?
						#如果rs为true,说明文件共享已被打开，这不符合默认设置
						assert_equal(false, rs, "文件共享已经开启")

						#打开"文件共享"开关
						file_share_switch = @advance_iframe.button(type: @tc_tag_button)
						switch_state      = file_share_switch.class_name
						if switch_state == @tc_share_switch_off
								puts "打开'文件共享'开关".to_gbk
								file_share_switch.click
						end
				}

				operate("3 查看共享目录U盘中的文件") {
						rs = @browser.iframe(src: @tc_file_share_dir).wait_until_present(@tc_gap_time)
						assert(rs, "未打开文件共享目录界面")
						@file_share_iframe      = @browser.iframe(src: @tc_file_share_dir)
						usb_dir                 = @file_share_iframe.link(text: @tc_storage_usb)
						@back_to_previous_level = @file_share_iframe.link(text: @tc_tag_back)
						puts "查看#{@tc_storage_usb}中的文件".to_gbk
						assert(usb_dir.exists?, "未显示U盘")
						usb_dir.click

						#查看U盘中的文件夹
						sub_dir    =@file_share_iframe.link(text: @tc_share_dir)
						rs_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_sub_dir, "找不到U盘中的文件夹")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk
						sub_dir.click

						#查看U盘中的文件
						file    = @file_share_iframe.link(text: @tc_test_file)
						rs_file = file.wait_until_present(@tc_gap_time)
						assert(rs_file, "未找到测试文件")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "测试文件名：#{file_name}------------文件大小：#{file_size}".to_gbk

						#返回到根目录
						@back_to_previous_level.click
						rs_back_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_sub_dir, "返回到上一级目录失败")
						@back_to_previous_level.click
						rs_back_usb_dir = usb_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_usb_dir, "返回到U盘根目录失败")
				}

				operate("4 查看SD卡中的文件") {
						sd_dir                  = @file_share_iframe.link(text: @tc_storage_sd)
						@back_to_previous_level = @file_share_iframe.link(text: @tc_tag_back)
						puts "查看#{@tc_storage_sd}中的文件".to_gbk
						assert(sd_dir.exists?, "未显示SD卡")
						sd_dir.click
						sub_dir    =@file_share_iframe.link(text: @tc_share_dir)
						rs_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_sub_dir, "找不到SD卡中的文件")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk

						sub_dir.click
						sleep @tc_gap_time
						file    = @file_share_iframe.link(text: @tc_test_file)
						rs_file = file.wait_until_present(@tc_gap_time)
						assert(rs_file, "未找到测试文件")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "测试文件名：#{file_name}------------文件大小：#{file_size}".to_gbk

						#返回到根目录
						@back_to_previous_level.click
						rs_back_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_sub_dir, "返回到上一级目录失败")
						@back_to_previous_level.click
						rs_back_usb_dir = sd_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_usb_dir, "返回到U盘根目录失败")
				}

				operate("5 关闭文件共享") {
						@file_share_iframe.link(text: @tc_tag_close_share).click
						sleep(@tc_close_share)
						rs = @file_share_iframe.iframe(src: @tc_file_share_dir).wait_while_present(@tc_close_share)
						assert_nil(rs, "文件共享关闭失败")
				}

				operate("6 重启路由器") {
						#重启路由器
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
						assert rs, "跳转到登录页面失败!"
				}

				operate("7 重启路由器后,重新登录路由器，打开高级设置") {
						login_no_default_ip(@browser)
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe
						assert_match /#{@ts_tag_advance_src}/i, @advance_iframe.src, "打开高级设置失败!"
				}

				operate("8 重启路由器后，打开系统设置查看文件共享") {
						#选择‘系统设置’
						sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
						unless sysset == @tc_tag_system_state
								@advance_iframe.link(id: @tc_tag_systemset).click
								sleep @tc_gap_time
						end

						#选择 "文件共享"
						file_share_label       = @advance_iframe.link(id: @tc_tag_file_share)
						file_share_label_state = file_share_label.parent.class_name
						file_share_label.click unless file_share_label_state==@tc_tag_file_share_state

						#打开"文件共享"开关
						file_share_switch = @advance_iframe.button(type: @tc_tag_button)
						switch_state      = file_share_switch.class_name
						assert_equal(switch_state, @tc_share_switch_off, "文件共享关闭失败")
				}

		end

		def clearup

				operate("恢复环境，关闭文件共享") {
						rs = @browser.iframe(src: @tc_file_share_dir).exists?
						if rs
								#如果当前WEB为文件共享目录，直接关闭共享
								@file_share_iframe = @browser.iframe(src: @tc_file_share_dir)
								@file_share_iframe.link(text: @tc_tag_close_share).click
								file_share = @browser.iframe(src: @tc_file_share_dir)
								if file_share.exists?
										sleep 2
										# file_share.wait_while_present(@tc_close_share)
								end
						elsif @browser.iframe(src: @ts_tag_advance_src).exists? #如果当前页面是高级设置页面
								@advance_iframe        = @browser.iframe(src: @ts_tag_advance_src)
								file_share_label       = @advance_iframe.link(id: @tc_tag_file_share)
								file_share_label_state = file_share_label.parent.class_name
								#如果当前页面是文件共享页面
								if file_share_label_state==@tc_tag_file_share_state
										#打开"文件共享"开关
										file_share_switch = @advance_iframe.button(type: @tc_tag_button)
										switch_state      = file_share_switch.class_name
										if switch_state == @tc_share_switch_off
												puts "文件共享已经关闭".to_gbk
										end
								else
										#如果当面页面不是文件共享页面则打开文件共享
										file_share_label.click
										#选择‘系统设置’
										sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
										unless sysset ==@tc_tag_systemset
												@advance_iframe.link(id: @tc_tag_systemset).click
												sleep @tc_gap_time
										end
										#选择 "文件共享"
										file_share_label       = @advance_iframe.link(id: @tc_tag_file_share)
										file_share_label_state = file_share_label.parent.class_name
										file_share_label.click unless file_share_label_state==@tc_tag_file_share_state
										sleep @tc_gap_time
										file_share=@browser.iframe(src: @tc_file_share_dir)
										if file_share.exists?
												#重新打开后，如果当前WEB为文件共享目录，直接关闭共享
												@file_share_iframe = @browser.iframe(src: @tc_file_share_dir)
												@file_share_iframe.link(text: @tc_tag_close_share).click
												if file_share.exists?
														file_share.wait_while_present(@tc_close_share)
												end
										end
								end
						else
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe

								#选择‘系统设置’
								sysset          = @advance_iframe.link(id: @tc_tag_systemset).class_name
								unless sysset == @tc_tag_system_state
										@advance_iframe.link(id: @tc_tag_systemset).click
										sleep @tc_gap_time
								end
								#选择 "文件共享"
								file_share_label       = @advance_iframe.link(id: @tc_tag_file_share)
								file_share_label_state = file_share_label.parent.class_name
								file_share_label.click unless file_share_label_state==@tc_tag_file_share_state
								sleep @tc_gap_time
								file_share=@browser.iframe(src: @tc_file_share_dir)
								if file_share.exists?
										#重新打开后，如果当前WEB为文件共享目录，直接关闭共享
										@file_share_iframe = @browser.iframe(src: @tc_file_share_dir)
										@file_share_iframe.link(text: @tc_tag_close_share).click
										if file_share.exists?
												file_share.wait_while_present(@tc_close_share)
										end
								end
						end
				}
		end

}
