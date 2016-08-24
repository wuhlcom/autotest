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
				@tc_wait_time     = 2
		end

		def process

				operate("1、分别插入USB设备、TF卡、SD卡，登录web页面，进入多级目录文档共享页面") {
						@options_page   = RouterPageObject::OptionsPage.new(@browser)
						@fileshare_page = RouterPageObject::FilesharePage.new(@browser)
				}

				operate("2、关闭当前的文件共享功能。关闭后页面是否不显示当前所接设备的文件内容") {
						@options_page.open_fileshare_page(@browser.url)
						rs = @fileshare_page.current_path?
						assert(rs, "文件共享打开失败")
						udisk_status = @fileshare_page.udisk?
						assert(udisk_status, "文件共享未显示U盘")

						@fileshare_page.udisk #打开U盘目录
						sleep @tc_wait_time

						puts "#{@fileshare_page.first_catalog_element.text}".to_gbk
						first_dir_status = @fileshare_page.first_catalog? #查看U盘中"一级目录"是否存在
						assert(first_dir_status, "文件共享中未显示一级目录")

						@fileshare_page.first_catalog #打开一级目录
						sleep @tc_wait_time

						puts "#{@fileshare_page.udisk_second_dir_element.text}".to_gbk
						second_dir_status = @fileshare_page.udisk_second_dir? #查看U盘中"二级目录"是否存在
						assert(second_dir_status, "文件共享中未显示二级目录")

						@fileshare_page.udisk_second_dir #打开二级目录
						sleep @tc_wait_time

						puts "#{@fileshare_page.third_testfile_element.text}".to_gbk
						third_testfile_status = @fileshare_page.third_testfile? #查看U盘中"二级目录"下的文件是否存在
						assert(third_testfile_status, "文件共享中未显示二级目录下的文件")

						@fileshare_page.close_fileshare(@browser.url) #关闭共享

						@fileshare_page.open_options_page(@browser.url)
						@fileshare_page.select_fileshare #进入文件共享页面
						sleep @tc_wait_time
						rs = @fileshare_page.file_share_btn? #如果文件共享打开按钮存在说明文件共享已经关闭
						sleep @tc_wait_time
						assert(rs, "文件共享关闭失败!")
				}

				operate("3、重启设备后，重新登录页面，查看是否仍为关闭状态") {
						@browser.refresh
						@fileshare_page.reboot
						rs = @browser.text_field(name: @ts_tag_usr).exists?
						assert rs, "重启路由器失败未跳转到登录页面!"
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

						@fileshare_page.open_options_page(@browser.url)
						@fileshare_page.select_fileshare #进入文件共享页面
						sleep @tc_wait_time
						rs = @fileshare_page.file_share_btn? #如果文件共享打开按钮存在说明文件共享已经关闭
						sleep @tc_wait_time
						assert(rs, "重启后文件共享未关闭!")
				}


		end

		def clearup

				operate("1 恢复环境，关闭文件共享") {
						fileshare_page = RouterPageObject::FilesharePage.new(@browser)
						fileshare_page.close_fileshare(@browser.url)
				}

		end

}
