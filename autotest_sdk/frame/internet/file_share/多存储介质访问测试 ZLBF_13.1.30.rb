#
#description:
# 无法判断一个正在进行时，另一个下载也在进行
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.30", "level" => "P1", "auto" => "n"}

		def prepare

				@ts_download_directory.gsub!("\\", "/")
				if File.exists? @ts_download_directory
						puts("下载文件保存路径：#{@ts_download_directory}".to_gbk)
						files = Dir.glob("#{@ts_download_directory}/**/*")
						unless files.empty?
								puts "=="*40
								puts "删除已存在的文件夹与文件:".to_gbk
								#不删除路由器的配置文件
								files.delete_if { |file|
										file=~/RT2880_Settings/i
								}
								print files.join("\n").to_gbk
								print "\n"
								puts "=="*40
								FileUtils.rm_rf(files)
						end
				end

				@tc_wait_time           = 3
				@tc_close_share         = 5
				@tc_wait_for_reboot     = 30
				@tc_wait_system         = 180
				@tc_download_time       = 140
				@tc_tag_class           = "selected"
				@tc_tag_button          = "button"
				@ts_tag_fileshare_state = "active"
				@tc_share_switch_off    = "off"
				@tc_share_switch_on     = "on"
				@tc_storage_usb         = "U盘"
				@tc_storage_sd          = "SD卡"
				@tc_share_dir           = "一级目录"
				@tc_usb_dl_name         = "二级Pycharm_TEST.exe"
				@tc_sd_dl_name          = "二级RubyMine_TEST.exe"
				@tc_tag_close_share     = "关闭共享"
				@tc_tag_back            = "返回上一级"
				@tc_tag_file_div        = "aui_state_lock aui_state_focus" #共享目录的根DIV，focus在后表示选中了当前div
				@tc_tag_style_zindex    = "z-index"
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
						sysset = @advance_iframe.link(id: @ts_tag_op_system).class_name
						unless sysset == @ts_tag_op_system
								@advance_iframe.link(id: @ts_tag_op_system).click
								sleep @tc_wait_time
						end

						#选择 "文件共享"
						file_share_label       = @advance_iframe.link(id: @ts_tag_fileshare)
						file_share_label_state = file_share_label.parent.class_name
						file_share_label.click unless file_share_label_state==@ts_tag_fileshare_state
						sleep @tc_wait_time
						file_share = @browser.iframe(src: @ts_file_share_dir)
						rs         = file_share.exists?
						#如果rs为true,说明文件共享已被打开，这不符合默认设置
						assert_equal(false, rs, "文件共享已经开启")

						#打开"文件共享"开关
						file_share_switch = @advance_iframe.button(type: @tc_tag_button)
						switch_state      = file_share_switch.class_name
						if switch_state == @tc_share_switch_off
								file_share_switch.click
								sleep @tc_wait_time
						end
				}

				operate("3 查看U盘中的文件是否存在") {
						rs = @browser.iframe(src: @ts_file_share_dir).wait_until_present(@tc_wait_time)
						assert(rs, "未打开文件共享目录界面")
						@file_share_iframe      = @browser.iframe(src: @ts_file_share_dir)
						usb_dir                 = @file_share_iframe.link(text: @tc_storage_usb)
						@back_to_previous_level = @file_share_iframe.link(text: @tc_tag_back)
						puts "查看#{@tc_storage_usb}中的内容".to_gbk
						assert(usb_dir.exists?, "未显示U盘")
						usb_dir.click

						#查看U盘中的文件夹
						sub_dir    =@file_share_iframe.link(text: @tc_share_dir)
						rs_sub_dir = sub_dir.wait_until_present(@tc_wait_time)
						assert(rs_sub_dir, "找不到U盘中的文件夹")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk
						sub_dir.click

						#查看U盘中的要下载的文件是否存在
						@tc_usb_download_file = @file_share_iframe.link(text: @tc_usb_dl_name)
						rs_file               = @tc_usb_download_file.wait_until_present(@tc_wait_time)
						assert(rs_file, "未找到要下载的测试文件")
						@tc_usb_download_file_name = @tc_usb_download_file.parent.parent[0].text
						@tc_usb_download_file_size = @tc_usb_download_file.parent.parent[1].text
						puts "测试文件名：#{@tc_usb_download_file_name}------------文件大小：#{@tc_usb_download_file_size}".to_gbk
						@tc_usb_download_file_size=~/^(\d+\.*\d+)/
						@tc_usb_file_size=Regexp.last_match(1)
				}

				operate("4 打开第二个浏览器窗口用于进行SD卡下载测试") {
						@browser.execute_script("window.open('http://#{@ts_default_ip}')")
						#得个@browser对象下各个窗口对象的句柄对象
						@tc_handles = @browser.driver.window_handles
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[1])
						login_no_default_ip(@browser)

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe_sd = @browser.iframe
						assert_match /#{@ts_tag_advance_src}/i, @advance_iframe_sd.src, "打开高级设置失败!"
				}

				operate("5 在第二个浏览器窗口查看SD卡中的文件是否存在") {
						#选择‘系统设置’
						sysset = @advance_iframe_sd.link(id: @ts_tag_op_system).class_name
						unless sysset == @ts_tag_op_system
								@advance_iframe_sd.link(id: @ts_tag_op_system).click
								sleep @tc_wait_time
						end

						#选择 "文件共享"
						file_share_label       = @advance_iframe_sd.link(id: @ts_tag_fileshare)
						file_share_label_state = file_share_label.parent.class_name
						file_share_label.click unless file_share_label_state==@ts_tag_fileshare_state
						sleep @tc_wait_time
						file_share = @browser.iframe(src: @ts_file_share_dir)
						rs         = file_share.exists?
						assert(rs, "第二个窗口文件共享未开启")

						@file_share_iframe_sd = @browser.iframe(src: @ts_file_share_dir)
						sd_dir                = @file_share_iframe_sd.link(text: @tc_storage_sd)
						puts "查看#{@tc_storage_sd}中的文件".to_gbk
						assert(sd_dir.exists?, "第二个窗口未显示SD卡")
						#打开SD卡目录
						sd_dir.click
						sub_dir    = @file_share_iframe.link(text: @tc_share_dir)
						rs_sub_dir = sub_dir.wait_until_present(@tc_wait_time)
						assert(rs_sub_dir, "第二个窗口找不到SD卡中的文件夹")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk
						#打开SD卡一级目录
						sub_dir.click

						@tc_sd_download_file = @file_share_iframe_sd.link(text: @tc_sd_dl_name)
						rs_file              = @tc_sd_download_file.wait_until_present(@tc_wait_time)
						assert(rs_file, "第二个窗口未找到SD卡中要下载的文件")
						@tc_sd_download_file_name = @tc_sd_download_file.parent.parent[0].text
						@tc_sd_download_file_size = @tc_sd_download_file.parent.parent[1].text
						puts "测试文件名：#{@tc_sd_download_file_name}------------文件大小：#{@tc_sd_download_file_size}".to_gbk
						@tc_sd_download_file_size=~/^(\d+\.*\d+)/
						@tc_sd_file_size=Regexp.last_match(1)
				}

				operate("6 U盘在下载的同时SD卡也在下载") {
						#下载SD卡的文件
						puts "下载SD卡的文件".to_gbk
						@tc_sd_download_file.click
						#下载U盘中的文件
						puts "下载U盘中的文件".to_gbk
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[0])
						@tc_usb_download_file.click
						puts "Waiting for Download Files....."
						sleep @tc_download_time
				}

				operate("7 查看文件是否下载成功") {
						if File.exist?(@ts_download_directory)
								files = Dir.glob("#{@ts_download_directory}/**/*")
								if files.empty?
										assert(false, "文件下载失败，未到下载的文件")
								else
										puts "=="*50
										puts "已经下载的文件:".to_gbk
										#配置文件排除在外
										files.delete_if { |file|
												file=~/RT2880_Settings/i
										}
										print files.join("\n").to_gbk
										print "\n"
										puts "=="*50
										dl_usb_file_size = 0
										dl_sd_file_size  = 0
										files.each do |file|
												next if file !~ /#{@tc_usb_dl_name}|#{@tc_sd_dl_name}/
												if file=~/#{@tc_usb_dl_name}/
														usb_file_size    = File.size(file)
														#计算文件大小
														dl_usb_file_size = usb_file_size.to_f/1024.00/1024.00
														dl_usb_file_size = dl_usb_file_size.roundf(2)
														puts "读取从U盘中下载的文件#{@tc_usb_dl_name}，大小为#{dl_usb_file_size}".to_gbk
												elsif file=~/#{@tc_sd_dl_name}/
														sd_file_size    = File.size(file)
														dl_sd_file_size = sd_file_size.to_f/1024/1024
														dl_sd_file_size = dl_sd_file_size.roundf(2)
														puts "读取从SD卡中下载的文件#{@tc_sd_dl_name}，大小为#{dl_sd_file_size}".to_gbk
												end
										end
										#浮点数使用字符串的形式来比较
										flag_usb     = (@tc_usb_file_size == dl_usb_file_size.to_s) && (dl_usb_file_size > 0)
										flag_sd      = (@tc_sd_file_size == dl_sd_file_size.to_s) && (dl_sd_file_size > 0)
										usb_download = files.any? { |file| file=~/#{@tc_usb_dl_name}/ }
										sd_download  = files.any? { |file| file=~/#{@tc_sd_dl_name}/ }
										assert(usb_download, "U盘中文件未下载")
										assert(flag_usb, "U盘中文件下载异常")
										assert(sd_download, "SD卡中文件未下载")
										assert(flag_sd, "SD卡中文件下载异常")
								end
						else
								assert(false, "下载文件保存目录不存在")
						end
				}
		end

		def clearup

				operate("恢复环境，关闭文件共享") {
						tc_handles = @browser.driver.window_handles
						@browser.driver.switch_to.window(tc_handles[0])
						rs = @browser.iframe(src: @ts_file_share_dir).exists?
						if rs
								#如果当前WEB为文件共享目录，直接关闭共享
								@file_share_iframe = @browser.iframe(src: @ts_file_share_dir)
								@file_share_iframe.link(text: @tc_tag_close_share).click
								file_share = @browser.iframe(src: @ts_file_share_dir)
								if file_share.exists?
										sleep 5
								end
						elsif @browser.iframe(src: @ts_tag_advance_src).exists? #如果当前页面是高级设置页面
								@advance_iframe        =@browser.iframe(src: @ts_tag_advance_src)
								file_share_label       = @advance_iframe.link(id: @ts_tag_fileshare)
								file_share_label_state = file_share_label.parent.class_name
								#如果当前页面是文件共享页面
								if file_share_label_state==@ts_tag_fileshare_state
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
										sysset = @advance_iframe.link(id: @ts_tag_op_system).class_name
										unless sysset ==@ts_tag_op_system
												@advance_iframe.link(id: @ts_tag_op_system).click
												sleep @tc_wait_time
										end
										#选择 "文件共享"
										file_share_label       = @advance_iframe.link(id: @ts_tag_fileshare)
										file_share_label_state = file_share_label.parent.class_name
										file_share_label.click unless file_share_label_state==@ts_tag_fileshare_state
										sleep @tc_wait_time
										file_share=@browser.iframe(src: @ts_file_share_dir)
										if file_share.exists?
												#重新打开后，如果当前WEB为文件共享目录，直接关闭共享
												@file_share_iframe = @browser.iframe(src: @ts_file_share_dir)
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
								#如果高级设置已经关闭则重新开高级设置
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe

								#选择‘系统设置’
								sysset          = @advance_iframe.link(id: @ts_tag_op_system).class_name
								unless sysset ==@ts_tag_op_system
										@advance_iframe.link(id: @ts_tag_op_system).click
										sleep @tc_wait_time
								end
								#选择 "文件共享"
								file_share_label       = @advance_iframe.link(id: @ts_tag_fileshare)
								file_share_label_state = file_share_label.parent.class_name
								file_share_label.click unless file_share_label_state==@ts_tag_fileshare_state
								sleep @tc_wait_time
								file_share=@browser.iframe(src: @ts_file_share_dir)
								if file_share.exists?
										#重新打开后，如果当前WEB为文件共享目录，直接关闭共享
										@file_share_iframe = @browser.iframe(src: @ts_file_share_dir)
										@file_share_iframe.link(text: @tc_tag_close_share).click
										if file_share.exists?
												file_share.wait_while_present(@tc_close_share)
										end
								end
						end
				}
		end

}
