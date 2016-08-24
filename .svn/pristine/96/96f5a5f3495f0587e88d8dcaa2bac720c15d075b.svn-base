#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.7", "level" => "P2", "auto" => "n"}

		def prepare
				@ts_download_directory.gsub!("\\", "\/")
				@tc_download_time    = 50
				@tc_wait_time        = 2
				@tc_download_file    = "三级安卓软件.apk"
				@tc_download_path    = @ts_download_directory+"/#{@tc_download_file}"
		end

		def process

				operate("1、U盘建立多级目录，") {
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

				operate("3、打开文件共享，") {
						#上一步已经实现
				}

				operate("4、打开多个文件夹，进入文件下载") {
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
						file_size = @fileshare_page.get_third_testfile_size
						puts "测试文件名：#{@tc_download_file}------------文件大小：#{file_size}".to_gbk

						#下载U盘中的子目录下的文件
						dl_file_path = Dir.glob(@ts_download_directory+"/*").find { |file|
								file=~/#{@tc_download_file}$/
						}
						unless dl_file_path.nil?
								puts "删除下载目录中的旧文件:#{dl_file_path}".encode("GBK")
								File.delete(dl_file_path)
						end

						@fileshare_page.third_testfile #下载文件
						sleep @tc_download_time

						dl_file= File.exists?(@tc_download_path)
						assert(dl_file, "文件:#{@tc_download_file}未下载成功")
						dl_filebyte = File.size(@tc_download_path)
						dl_filemb   = (dl_filebyte.to_f/1024/1024).roundf(2)
						dl_fileMB   = "#{dl_filemb}MB"
						puts "下载目录中的已下载文件大小:#{dl_fileMB}".to_gbk
						assert_equal(file_size, dl_fileMB, "下载的文件大小与显示文件大小不符")
				}


		end

		def clearup
				operate("1 恢复环境，关闭文件共享") {
						fileshare_page = RouterPageObject::FilesharePage.new(@browser)
						fileshare_page.close_fileshare(@browser.url)
				}
		end

}
