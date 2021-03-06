#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.5", "level" => "P2", "auto" => "n"}

		def prepare
				@ts_download_directory.gsub!("\\", "\/")
				@tc_download_time = 50
				@tc_wait_time     = 2
				@tc_download_file = "一级安卓软件_TEST.apk"
				@tc_download_path = @ts_download_directory+"/#{@tc_download_file}"
		end

		def process

				operate("1、拷贝混合名称文件夹和文件到U盘") {
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

				operate("3、打开文件共享，进入文件夹下载混合文件") {
						#判断当前下载目录是否已有文件
						dl_file_path = Dir.glob(@ts_download_directory+"/*").find { |file|
								file=~/#{@tc_download_file}$/
						}
						unless dl_file_path.nil?
								puts "删除下载目录中的旧文件:#{dl_file_path}".encode("GBK")
								File.delete(dl_file_path)
						end
						file_state = File.exists?(@tc_download_path)
						refute(file_state, "下载目录中旧文件:#{@tc_download_file}未删除")

						@fileshare_page.udisk #打开U盘目录
						sleep @tc_wait_time

						puts "查看文件:#{@tc_download_file}是否存在".to_gbk
						udisk_file_status = @fileshare_page.udisk_first_file2?
						assert(udisk_file_status, "路由器未显示测试文件:#{@tc_download_file}")
						file_size = @fileshare_page.get_udisk_first_file2_size
						puts "测试文件名：#{@tc_download_file}------------文件大小：#{file_size}".to_gbk

						@fileshare_page.udisk_first_file2 #下载文件
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
