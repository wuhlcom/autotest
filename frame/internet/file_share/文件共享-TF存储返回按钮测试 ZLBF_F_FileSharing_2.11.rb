#
# description:
#bug
# �޷����ص�SD����Ŀ¼
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.16", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time        = 2
				@tc_share_dir        = "һ��Ŀ¼"
				@tc_second_dir       = "����Ŀ¼"
				@tc_file_name        = "������׿���.apk"
		end

		def process

				operate("1����½·���������ļ�����") {
						@options_page   = RouterPageObject::OptionsPage.new(@browser)
						@fileshare_page = RouterPageObject::FilesharePage.new(@browser)
				}

				operate("2������༶�ļ�Ŀ¼") {
						@options_page.open_fileshare_page(@browser.url)
						rs = @fileshare_page.current_path?
						assert(rs, "�ļ������ʧ��")
						udisk_status = @fileshare_page.udisk?
						assert(udisk_status, "�ļ�����δ��ʾSD��")

						@fileshare_page.sdcard #��SD��Ŀ¼
						sleep @tc_wait_time

						puts "#{@fileshare_page.first_catalog_element.text}".to_gbk
						first_dir_status = @fileshare_page.first_catalog? #�鿴SD����"һ��Ŀ¼"�Ƿ����
						assert(first_dir_status, "�ļ�������δ��ʾһ��Ŀ¼")

						@fileshare_page.first_catalog #��һ��Ŀ¼
						sleep @tc_wait_time

						puts "#{@fileshare_page.udisk_second_dir_element.text}".to_gbk
						second_dir_status = @fileshare_page.udisk_second_dir? #�鿴SD����"����Ŀ¼"�Ƿ����
						assert(second_dir_status, "�ļ�������δ��ʾ����Ŀ¼")

						@fileshare_page.udisk_second_dir #�򿪶���Ŀ¼
						sleep @tc_wait_time

						puts "#{@fileshare_page.third_testfile_element.text}".to_gbk
						third_testfile_status = @fileshare_page.third_testfile? #�鿴SD����"����Ŀ¼"�µ��ļ��Ƿ����
						assert(third_testfile_status, "�ļ�������δ��ʾ����Ŀ¼�µ��ļ�")
				}

				operate("3��������أ������η��أ��Ƿ���Է��ص��ļ���ҳ") {
						@fileshare_page.return #���ص�����Ŀ¼
						second_dir_status = @fileshare_page.udisk_second_dir? #�鿴SD����"����Ŀ¼"�Ƿ����
						assert(second_dir_status, "�ļ�������δ��ʾ����Ŀ¼")

						@fileshare_page.return #���ص�һ��Ŀ¼
						first_dir_status = @fileshare_page.first_catalog? #�鿴SD����"һ��Ŀ¼"�Ƿ����
						assert(first_dir_status, "�ļ�������δ��ʾһ��Ŀ¼")

						@fileshare_page.return #���ص�SD����Ŀ¼
						udisk_status = @fileshare_page.udisk?
						assert(udisk_status, "�ļ�����δ��ʾSD��")
				}
		end

		def clearup

				operate("1 �ָ��������ر��ļ�����") {
						fileshare_page = RouterPageObject::FilesharePage.new(@browser)
						fileshare_page.close_fileshare(@browser.url)
				}

		end

}
