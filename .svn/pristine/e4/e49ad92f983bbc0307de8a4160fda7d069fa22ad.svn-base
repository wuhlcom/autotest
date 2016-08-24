#
# description:
# bug
# 重启后无法共享
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.21", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time        = 2
				@tc_shareopen_time   = 5
				@tc_gap_time         = 3
				@tc_close_share_time = 5
				@tc_reboot_time      = 120
				@tc_relogin_time     = 80
				@tc_share_dir        = "一级目录"
				@tc_second_dir       = "二级目录"
				@tc_file_name        = "三级安卓软件.apk"
		end

		def process

				operate("1、分别插入USB设备、TF卡、SD卡，登录web页面，进入多级目录文档共享页面") {
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级失败!")
				}

				operate("2、关闭当前的文件共享功能。关闭后页面是否不显示当前所接设备的文件内容") {
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name == @ts_tag_select_state
								system_set.click
						end
						fileshare = @advance_iframe.link(id: @ts_tag_fileshare)
						fileshare.parent.class_name
						fileshare.click unless fileshare.parent.class_name==@ts_tag_liclass

						fileshare_btn = @advance_iframe.button(class_name: @ts_tag_filebtn_off)
						assert(fileshare_btn.exists?, "文件共享已经被打开")
						fileshare_btn.click
						sleep @tc_shareopen_time
						rs = @browser.iframe(src: @ts_file_share_dir).wait_until_present(@tc_wait_time)
						assert(rs, "未打开文件共享目录界面")
						@file_share_iframe = @browser.iframe(src: @ts_file_share_dir)
						usb_dir            = @file_share_iframe.link(text: @ts_storage_usb)

						puts "查看#{@ts_storage_usb}中的文件".to_gbk
						assert(usb_dir.exists?, "未显示U盘")

						#查看U盘中的文件夹
						@file_share_iframe.link(text: @ts_storage_usb).click
						sleep @tc_wait_time

						sub_dir =@file_share_iframe.link(text: @tc_share_dir)
						assert(sub_dir.exists?, "未显示U盘中的文件夹:#{@tc_share_dir}")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "文件夹名：#{dir_name}----文件夹大小:#{dir_size}".to_gbk

						#打开下一级目录("一级目录"目录)
						sub_dir.click
						sleep @tc_wait_time

						second_dir =@file_share_iframe.link(text: @tc_second_dir)
						assert(second_dir.exists?, "未显示U盘中的文件夹:#{@tc_second_dir}")
						second_dir_name = second_dir.parent.parent[0].text
						second_dir_size = second_dir.parent.parent[1].text
						puts "文件夹名：#{second_dir_name}----文件夹大小:#{second_dir_size}".to_gbk

						#打开下二级目录("二级目录"目录)
						second_dir.click
						sleep @tc_wait_time

						second_dir_file =@file_share_iframe.link(text: @tc_file_name)
						assert(second_dir_file.exists?, "未显示U盘中的文件:#{@tc_file_name}")
						second_dir_file_name  = second_dir_file.parent.parent[0].text
						dsecond_dir_file_size = second_dir_file.parent.parent[1].text
						puts "文件名：#{second_dir_file_name}----文件大小:#{dsecond_dir_file_size}".to_gbk
						#关闭共享
						@file_share_iframe.link(id: @ts_tag_disshare).click
						sleep @tc_wait_time
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name == @ts_tag_select_state
								system_set.click
						end
						fileshare = @advance_iframe.link(id: @ts_tag_fileshare)
						fileshare.parent.class_name
						fileshare.click unless fileshare.parent.class_name==@ts_tag_liclass

						fileshare_btn = @advance_iframe.button(class_name: @ts_tag_filebtn_off)
						assert(fileshare_btn.exists?, "文件共享关闭失败!")
				}

				operate("3、重启设备后，重新登录页面，查看是否仍为关闭状态") {
						@browser.span(id: @ts_tag_reboot).click
						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "未提示重启路由器要确认!"
						reboot_confirm.click
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "重启路由器失败未跳转到登录页面!"
						#重新登录路由器
						rs = login_no_default_ip(@browser)
						assert(rs, "重新登录路由器失败!")
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name == @ts_tag_select_state
								system_set.click
						end
						fileshare = @advance_iframe.link(id: @ts_tag_fileshare)
						fileshare.parent.class_name
						fileshare.click unless fileshare.parent.class_name==@ts_tag_liclass

						fileshare_btn = @advance_iframe.button(class_name: @ts_tag_filebtn_off)
						assert(fileshare_btn.exists?, "重启后文件共享未关闭!")
				}


		end

		def clearup
				operate("恢复环境，关闭文件共享") {
						rs = @browser.iframe(src: @ts_file_share_dir).exists?
						if rs
								#如果当前WEB为文件共享目录，直接关闭共享
								@file_share_iframe = @browser.iframe(src: @ts_file_share_dir)
								@file_share_iframe.link(text: @ts_tag_close_share).click
								file_share = @browser.iframe(src: @ts_file_share_dir)
								if file_share.exists?
										sleep @tc_wait_time
								end
						else
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								#如果当前不为文件共享，重新打开高级设置
								if @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe

								#选择‘系统设置’
								sysset          = @advance_iframe.link(id: @ts_tag_op_system).class_name
								unless sysset == @ts_tag_select_state
										@advance_iframe.link(id: @ts_tag_op_system).click
										sleep @tc_gap_time
								end
								#选择 "文件共享"
								file_share_label       = @advance_iframe.link(id: @ts_tag_fileshare)
								file_share_label_state = file_share_label.parent.class_name
								file_share_label.click unless file_share_label_state==@ts_tag_liclass
								sleep @tc_gap_time
								file_share=@browser.iframe(src: @ts_file_share_dir)
								if file_share.exists?
										#重新打开后，如果当前WEB为文件共享目录，直接关闭共享
										@file_share_iframe = @browser.iframe(src: @ts_file_share_dir)
										@file_share_iframe.link(text: @ts_tag_close_share).click
										if file_share.exists?
												file_share.wait_while_present(@tc_close_share_time)
										end
								end
						end
				}
		end

}
