#
# description:
#bug
# 无法返回到SD卡根目录
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.16", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time        = 2
				@tc_share_dir        = "一级目录"
				@tc_second_dir       = "二级目录"
				@tc_file_name        = "三级安卓软件.apk"
		end

		def process

				operate("1、登陆路由器进入文件共享") {
						@options_page   = RouterPageObject::OptionsPage.new(@browser)
						@fileshare_page = RouterPageObject::FilesharePage.new(@browser)
				}

				operate("2、进入多级文件目录") {
						@options_page.open_fileshare_page(@browser.url)
						rs = @fileshare_page.current_path?
						assert(rs, "文件共享打开失败")
						udisk_status = @fileshare_page.udisk?
						assert(udisk_status, "文件共享未显示SD卡")

						@fileshare_page.udisk #打开SD卡目录
						sleep @tc_wait_time

						puts "#{@fileshare_page.first_catalog_element.text}".to_gbk
						first_dir_status = @fileshare_page.first_catalog? #查看SD卡中"一级目录"是否存在
						assert(first_dir_status, "文件共享中未显示一级目录")

						@fileshare_page.first_catalog #打开一级目录
						sleep @tc_wait_time

						puts "#{@fileshare_page.udisk_second_dir_element.text}".to_gbk
						second_dir_status = @fileshare_page.udisk_second_dir? #查看SD卡中"二级目录"是否存在
						assert(second_dir_status, "文件共享中未显示二级目录")

						@fileshare_page.udisk_second_dir #打开二级目录
						sleep @tc_wait_time

						puts "#{@fileshare_page.third_testfile_element.text}".to_gbk
						third_testfile_status = @fileshare_page.third_testfile? #查看SD卡中"二级目录"下的文件是否存在
						assert(third_testfile_status, "文件共享中未显示二级目录下的文件")
				}

				operate("3、点击返回，点击多次返回，是否可以返回到文件首页") {
						@fileshare_page.return #返回到二级目录
						second_dir_status = @fileshare_page.udisk_second_dir? #查看SD卡中"二级目录"是否存在
						assert(second_dir_status, "文件共享中未显示二级目录")

						@fileshare_page.return #返回到一级目录
						first_dir_status = @fileshare_page.first_catalog? #查看SD卡中"一级目录"是否存在
						assert(first_dir_status, "文件共享中未显示一级目录")

						@fileshare_page.return #返回到SD卡根目录
						udisk_status = @fileshare_page.udisk?
						assert(udisk_status, "文件共享未显示SD卡")
				}
		end

		def clearup

				operate("1 恢复环境，关闭文件共享") {
						fileshare_page = RouterPageObject::FilesharePage.new(@browser)
						fileshare_page.close_fileshare(@browser.url)
				}

		end

}
