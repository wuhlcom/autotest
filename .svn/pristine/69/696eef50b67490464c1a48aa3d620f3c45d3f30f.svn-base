#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.6", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time        = 2
				@tc_shareopen_time   = 5
				@tc_gap_time         = 3
				@tc_close_share_time = 5
				@tc_test_file        = "一级测试文件_TEST.txt"
				@tc_content_cn       = "知路文件共享测试"
				@tc_content_en       = "zhilu sharing file test"
		end

		def process

				operate("1、拷贝wod、exce、文本文档到U盘") {
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

				operate("3、打开文件共享，进入文件夹打开wod、exce、文本文档") {
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
						#查看U盘中的内容
						@file_share_iframe.link(text: @ts_storage_usb).click
						sleep @tc_wait_time
						#查看U盘中的文件
						file = @file_share_iframe.link(text: @tc_test_file)
						assert(file.exists?, "路由器未显示测试文件:#{@tc_test_file}")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "测试文件名：#{file_name}------------文件大小：#{file_size}".to_gbk
						#打开文件
						file.click
						sleep @tc_wait_time
						#获取@browser对象下各个窗口对象的句柄对象
						@tc_handles = @browser.driver.window_handles
						assert(@tc_handles.size==2, "打开新窗口")
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[1])
						content = @browser.pre.text
						print "===================File content=============\n"
						print content.encode("GBK")
						print "\n===================File content============="
						assert_match(/#{@tc_content_cn}/, content, "未显示中文内容")
						assert_match(/#{@tc_content_en}/, content, "未显示英文内容")
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
