#
# description:
#bug
# �޷����ص�U�̸�Ŀ¼
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.8", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time = 2
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
						assert(udisk_status, "�ļ�����δ��ʾU��")

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
				}

				operate("3��������أ������η��أ��Ƿ���Է��ص��ļ���ҳ") {
						@fileshare_page.return #���ص�����Ŀ¼
						second_dir_status = @fileshare_page.udisk_second_dir? #�鿴U����"����Ŀ¼"�Ƿ����
						assert(second_dir_status, "�ļ�������δ��ʾ����Ŀ¼")

						@fileshare_page.return #���ص�һ��Ŀ¼
						first_dir_status = @fileshare_page.first_catalog? #�鿴U����"һ��Ŀ¼"�Ƿ����
						assert(first_dir_status, "�ļ�������δ��ʾһ��Ŀ¼")

						@fileshare_page.return #���ص�U�̸�Ŀ¼
						udisk_status = @fileshare_page.udisk?
						assert(udisk_status, "�ļ�����δ��ʾU��")
				}

		end

		def clearup

				operate("1 �ָ��������ر��ļ�����") {
						fileshare_page = RouterPageObject::FilesharePage.new(@browser)
						fileshare_page.close_fileshare(@browser.url)
				}

		end

}
