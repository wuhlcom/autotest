#encoding:utf-8
#
# 路由器文件共享
# author:liluping
# date:2016-03-17
# modify:
#

module RouterPageObject
		module Fileshare_Page
				include PageObject
				in_iframe(:src => @@ts_file_share_dir) do |frame|
						link(:close_share, id: @@ts_tag_disshare, frame: frame) #关闭共享
						link(:return, id: @@ts_tag_return, frame: frame) #返回上一级目录
						link(:sdcard, text: @@ts_storage_sd, frame: frame) #SD卡
						link(:udisk, text: @@ts_storage_usb, frame: frame) #U盘
						link(:first_catalog, text: @@ts_tag_catalog_first, frame: frame) #一级目录
						link(:udisk_second_dir, text: @@ts_tag_udisk_seconddir, frame: frame) #二级目录
						link(:udisk_first_dir_en, text: @@ts_tag_udisk_dir_en, frame: frame) #first_dir
						link(:udisk_first_file1, text: @@ts_tag_udisk_file1, frame: frame) #一级测试文件_TEST.txt
						link(:udisk_first_file2, text: @@ts_tag_udisk_file2, frame: frame) #一级安卓软件_TEST.apk
						link(:udisk_first_file3, text: @@ts_tag_udisk_file3, frame: frame) #一级安卓软件.apk
						link(:udisk_first_file4, text: @@ts_tag_udisk_file4, frame: frame) #first_anzuo.apk
						link(:second_testfile, text: @@ts_tag_second_testfile, frame: frame) #二级测试文件
						link(:third_testfile, text: @@ts_tag_udisk_thr_file, frame: frame) #三级测试文件
						span(:current_path, id: @@ts_tag_cur_path, frame: frame) #当前位置
						link(:second_pycharm_testfile, text: @@ts_tag_sec_py_testfile, frame: frame) #二级Pycharm_TEST.exe
						link(:second_ruby_testfile, text: @@ts_tag_sec_ruby_testfile, frame: frame) #二级RubyMine_TEST.exe
						div(:fileshare_hint, class_name: @@ts_tag_aui_content, frame: frame) #页面提示
				end
		end

		class FilesharePage < OptionsPage
				include Fileshare_Page

				#获取一级目录大小
				def get_first_catalog_size
						first_catalog_element.parent.parent[1].text
				end

				#获取二级测试文件大小
				def get_second_testfile_size
						second_testfile_element.parent.parent[1].text
				end

				#获取二级Pycharm_TEST.exe文件大小
				def get_second_py_size
						second_pycharm_testfile_element.parent.parent[1].text
				end

				#获取二级RubyMine_TEST.exe文件大小
				def get_second_ruby_size
						second_ruby_testfile_element.parent.parent[1].text
				end

				#获取U盘中指定文件大小
				def get_udisk_first_file1_size
						udisk_first_file1_element.parent.parent[1].text
				end

				#获取U盘中指定文件大小
				def get_udisk_first_file2_size
						udisk_first_file2_element.parent.parent[1].text
				end

				#获取U盘中指定文件大小
				def get_udisk_first_file3_size
						udisk_first_file3_element.parent.parent[1].text
				end

				#获取U盘中指定文件大小
				def get_third_testfile_size
						third_testfile_element.parent.parent[1].text
				end

				#获取U盘中指定文件大小
				def get_udisk_first_file4_size
						udisk_first_file4_element.parent.parent[1].text
				end

				#关闭共享
				def close_fileshare(url)
						open_options_page(url)
						select_fileshare #进入文件共享页面
						sleep 3
						unless file_share_btn? #按钮存在即关闭
								close_share
								sleep 3
						end
				end
		end
end