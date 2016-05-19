#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.6", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time  = 2
				@tc_test_file  = "一级测试文件_TEST.txt"
				@tc_content_cn = "知路文件共享测试"
				@tc_content_en = "zhilu sharing file test"
		end

		def process

				operate("1、拷贝wod、exce、文本文档到U盘") {
						@options_page   = RouterPageObject::OptionsPage.new(@browser)
						@fileshare_page = RouterPageObject::FilesharePage.new(@browser)
				}

				operate("2、登陆路由器进入文件共享") {
						@options_page.open_fileshare_page(@browser.url)
						rs = @fileshare_page.current_path?
						assert(rs, "文件共享打开失败")
						udisk_status = @fileshare_page.udisk?
						assert(udisk_status, "文件共享未显示U盘")
				}

				operate("3、打开文件共享，进入文件夹打开wod、exce、文本文档") {
						@fileshare_page.udisk #打开U盘目录
						sleep @tc_wait_time
						puts "查看文件:#{@tc_test_file}是否存在".to_gbk
						udisk_file1_status = @fileshare_page.udisk_first_file1?
						assert(udisk_file1_status, "路由器未显示测试文件:#{@tc_test_file}")
						file_size = @fileshare_page.get_udisk_first_file1_size
						puts "测试文件名：#{@tc_test_file}------------文件大小：#{file_size}".to_gbk

						@fileshare_page.udisk_first_file1 #打开文件读取文件内容
						#获取@browser对象下各个窗口对象的句柄对象
						@tc_handles = @browser.driver.window_handles
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[1])
						content = @browser.pre.text
						print "===================File content begin=============\n"
						print content.encode("GBK")
						print "\n===================File content end============="
						assert_match(/#{@tc_content_cn}/, content, "未显示中文内容")
						assert_match(/#{@tc_content_en}/, content, "未显示英文内容")
				}


		end

		def clearup

				operate("1 恢复环境，关闭文件共享") {
						unless @tc_handles.nil? && @tc_handles.empty?
								@browser.driver.switch_to.window(@tc_handles[0])
						end
						fileshare_page = RouterPageObject::FilesharePage.new(@browser)
						fileshare_page.close_fileshare(@browser.url)
				}

		end

}
