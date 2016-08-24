#
# description:
#下载过程中关闭共享，关闭共享后，还能操作路由器，并查看到共享界面是关闭
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.23", "level" => "P4", "auto" => "n"}

		def prepare
				@ts_download_directory.gsub!("\\", "\/")
				@tc_download_time    = 5
				@tc_wait_time        = 2
				@tc_shareopen_time   = 5
				@tc_gap_time         = 3
				@tc_close_share_time = 5
				@tc_share_dir        = "一级目录"
				@tc_download_file    = "二级Pycharm_TEST.exe"
				@tc_download_path    = @ts_download_directory+"/#{@tc_download_file}"
		end

		def process

				operate("1、分别插入USB设备、TF卡、SD卡，登录web页面，进入到文档共享页面，") {
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级失败!")
						#打开系统设置
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name == @ts_tag_select_state
								system_set.click
						end
						#打开文件共享界面
						fileshare = @advance_iframe.link(id: @ts_tag_fileshare)
						fileshare.parent.class_name
						fileshare.click unless fileshare.parent.class_name==@ts_tag_liclass
				}

				operate("2、开启当前的文件共享功能。开启后页面是否显示当前所接设备的文件内容") {
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

						#打开子目录
						sub_dir.click
						sleep @tc_wait_time
				}

				operate("3、点击其中的文件进行下载，下载过程中在页面上把文件共享功能关闭，查看AP是否异常") {
						#下载U盘中的子目录下的文件
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
						thr = Thread.new do
								#点击文件开始下载
								file_download.click
								sleep @tc_download_time
						end
						sleep @tc_wait_time
						#下载过程中，关闭共享
						puts "下载过程中关闭共享".encode("GBK")
						@file_share_iframe.link(id: @ts_tag_disshare).click
						sleep @tc_close_share_time
						puts "关闭共享后打开共享界面检查共享是否被关闭".encode("GBK")

							@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级失败!")
						#打开系统设置
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name == @ts_tag_select_state
								system_set.click
						end
						#打开文件共享界面
						fileshare = @advance_iframe.link(id: @ts_tag_fileshare)
						fileshare.parent.class_name
						fileshare.click unless fileshare.parent.class_name==@ts_tag_liclass
						fileshare_btn = @advance_iframe.button(class_name: @ts_tag_filebtn_off)
						assert(fileshare_btn.exists?, "下载过程中关闭文件共享失败")
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
