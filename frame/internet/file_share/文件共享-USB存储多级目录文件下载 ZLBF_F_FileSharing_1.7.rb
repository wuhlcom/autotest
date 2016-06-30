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
				@tc_download_file    = "������׿���.apk"
				@tc_download_path    = @ts_download_directory+"/#{@tc_download_file}"
		end

		def process

				operate("1��U�̽����༶Ŀ¼��") {
						@options_page   = RouterPageObject::OptionsPage.new(@browser)
						@fileshare_page = RouterPageObject::FilesharePage.new(@browser)
				}

				operate("2����½·���������ļ�����") {
						@options_page.open_fileshare_page(@browser.url)
						rs = @fileshare_page.current_path?
						assert(rs, "�ļ������ʧ��")
						udisk_status = @fileshare_page.udisk?
						assert(udisk_status, "�ļ�����δ��ʾU��")
				}

				operate("3�����ļ�����") {
						#��һ���Ѿ�ʵ��
				}

				operate("4���򿪶���ļ��У������ļ�����") {
						@fileshare_page.udisk #��U��Ŀ¼
						sleep @tc_wait_time

						puts "#{@fileshare_page.first_catalog_element.text}".to_gbk
						first_dir_status = @fileshare_page.first_catalog? #�鿴U����"һ��Ŀ¼"�Ƿ����
						assert(first_dir_status, "�ļ�������δ��ʾһ��Ŀ¼")

						@fileshare_page.first_catalog #��һ��Ŀ¼
						sleep @tc_wait_time

						puts "#{@fileshare_page.udisk_second_dir_element.text}".to_gbk
						second_dir_status = @fileshare_page.udisk_second_dir? #�鿴U����"����Ŀ¼"�Ƿ����
						assert(second_dir_status, "�ļ�������δ��ʾ����Ŀ¼")

						@fileshare_page.udisk_second_dir #�򿪶���Ŀ¼
						sleep @tc_wait_time

						puts "#{@fileshare_page.third_testfile_element.text}".to_gbk
						third_testfile_status = @fileshare_page.third_testfile? #�鿴U����"����Ŀ¼"�µ��ļ��Ƿ����
						assert(third_testfile_status, "�ļ�������δ��ʾ����Ŀ¼�µ��ļ�")
						file_size = @fileshare_page.get_third_testfile_size
						puts "�����ļ�����#{@tc_download_file}------------�ļ���С��#{file_size}".to_gbk

						#����U���е���Ŀ¼�µ��ļ�
						dl_file_path = Dir.glob(@ts_download_directory+"/*").find { |file|
								file=~/#{@tc_download_file}$/
						}
						unless dl_file_path.nil?
								puts "ɾ������Ŀ¼�еľ��ļ�:#{dl_file_path}".encode("GBK")
								File.delete(dl_file_path)
						end

						@fileshare_page.third_testfile #�����ļ�
						sleep @tc_download_time

						dl_file= File.exists?(@tc_download_path)
						assert(dl_file, "�ļ�:#{@tc_download_file}δ���سɹ�")
						dl_filebyte = File.size(@tc_download_path)
						dl_filemb   = (dl_filebyte.to_f/1024/1024).roundf(2)
						dl_fileMB   = "#{dl_filemb}MB"
						puts "����Ŀ¼�е��������ļ���С:#{dl_fileMB}".to_gbk
						assert_equal(file_size, dl_fileMB, "���ص��ļ���С����ʾ�ļ���С����")
				}


		end

		def clearup
				operate("1 �ָ��������ر��ļ�����") {
						fileshare_page = RouterPageObject::FilesharePage.new(@browser)
						fileshare_page.close_fileshare(@browser.url)
				}
		end

}
