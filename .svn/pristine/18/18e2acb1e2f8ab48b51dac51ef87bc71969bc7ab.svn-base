#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.4", "level" => "P2", "auto" => "n"}

		def prepare
				@ts_download_directory.gsub!("\\", "\/")
				@tc_download_time    = 20
				@tc_wait_time        = 2
				@tc_shareopen_time   = 5
				@tc_gap_time         = 3
				@tc_close_share_time = 5
				@tc_share_dir        = "first_dir"
				@tc_test_file        = "first_file_TEST.txt"
				@tc_download_file    = "first_anzuo.apk"
				@tc_download_path    = @ts_download_directory+"/#{@tc_download_file}"
		end

		def process

				operate("1、拷贝英文名称文件夹和文件到U盘") {
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级失败!")
				}

				operate("2、登陆路由器进入文件共享") {
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name == @ts_tag_select_state
								system_set.click
						end
						fileshare = @advance_iframe.link(id: @ts_tag_fileshare)
						fileshare.parent.class_name
						fileshare.click unless fileshare.parent.class_name==@ts_tag_liclass
				}

				operate("3、打开文件共享，进入英文文件夹下载英文文件") {
						fileshare_btn = @advance_iframe.button(class_name: @ts_tag_filebtn_off)
						assert(fileshare_btn.exists?, "文件共享已经被打开")
						fileshare_btn.click
						sleep @tc_shareopen_time
						rs = @browser.iframe(src: @ts_file_share_dir).wait_until_present(@tc_wait_time)
						assert(rs, "未打开文件共享目录界面")
						@file_share_iframe      = @browser.iframe(src: @ts_file_share_dir)
						usb_dir                 = @file_share_iframe.link(text: @ts_storage_usb)
						@back_to_previous_level = @file_share_iframe.link(text: @ts_tag_back)
						puts "查看#{@ts_storage_usb}中的文件".to_gbk
						assert(usb_dir.exists?, "未显示U盘")

						#查看U盘中的文件夹
						@file_share_iframe.link(text: @ts_storage_usb).click
						sleep @tc_wait_time
						sub_dir =@file_share_iframe.link(text: @tc_share_dir)
						assert(sub_dir.exists?, "找不到U盘中的文件夹")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "文件夹名：#{dir_name}----文件夹大小:#{dir_size}".to_gbk

						#查看U盘中的文件
						file = @file_share_iframe.link(text: @tc_test_file)
						assert(file.exists?, "路由器未显示测试文件:#{@tc_test_file}")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "测试文件名：#{file_name}------------文件大小：#{file_size}".to_gbk

						#下载U盘中的文件
						#判断当前下载目录是否有配置文件，如果有则将其重命名
						dl_file_path = Dir.glob(@ts_download_directory+"/*").find { |file|
								file=~/#{@tc_download_file}$/
						}
						unless dl_file_path.nil?
								puts "删除下载目录中的旧文件:#{dl_file_path}".encode("GBK")
								File.delete(dl_file_path)
						end

						file_state = File.exists?(@tc_download_path)
						refute(file_state, "下载目录中旧文件:#{@tc_download_file}未删除")
						file_download = @file_share_iframe.link(text: @tc_download_file)
						assert(file_download.exists?, "路由器上未显示要下载的文件#{@tc_download_file}")
						dl_file_name = file_download.parent.parent[0].text
						dl_file_size = file_download.parent.parent[1].text
						puts "要下载的文件名：#{dl_file_name}------------文件大小：#{dl_file_size}".to_gbk
						file_download.click
						sleep @tc_download_time
						dl_file= File.exists?(@tc_download_path)
						assert(dl_file, "文件:#{@tc_download_file}未下载成功")
						dl_filebyte = File.size(@tc_download_path)
						dl_filemb   = (dl_filebyte.to_f/1024/1024).roundf(2)
						dl_fileMB   = "#{dl_filemb}MB"
						puts "下载目录中的已下载文件大小:#{dl_fileMB}".to_gbk
						assert_equal(dl_file_size, dl_fileMB, "下载的文件大小与显示文件大小不符")
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
