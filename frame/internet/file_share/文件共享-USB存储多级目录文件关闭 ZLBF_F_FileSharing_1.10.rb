#
# description:
# bug
# �������޷�����
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

				operate("1���ֱ����USB�豸��TF����SD������¼webҳ�棬����༶Ŀ¼�ĵ�����ҳ��") {
						@options_page   = RouterPageObject::OptionsPage.new(@browser)
						@fileshare_page = RouterPageObject::FilesharePage.new(@browser)
				}

				operate("2���رյ�ǰ���ļ������ܡ��رպ�ҳ���Ƿ���ʾ��ǰ�����豸���ļ�����") {
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

						@fileshare_page.close_fileshare(@browser.url) #�رչ���

						@fileshare_page.open_options_page(@browser.url)
						@fileshare_page.select_fileshare #�����ļ�����ҳ��
						sleep @tc_wait_time
						rs = @fileshare_page.file_share_btn? #����ļ�����򿪰�ť����˵���ļ������Ѿ��ر�
						sleep @tc_wait_time
						assert(rs, "�ļ�����ر�ʧ��!")
				}

				operate("3�������豸�����µ�¼ҳ�棬�鿴�Ƿ���Ϊ�ر�״̬") {
						@browser.refresh
						@fileshare_page.reboot
						rs = @browser.text_field(name: @ts_tag_usr).exists?
						assert rs, "����·����ʧ��δ��ת����¼ҳ��!"
						#���µ�¼·����
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")

						@fileshare_page.open_options_page(@browser.url)
						@fileshare_page.select_fileshare #�����ļ�����ҳ��
						sleep @tc_wait_time
						rs = @fileshare_page.file_share_btn? #����ļ�����򿪰�ť����˵���ļ������Ѿ��ر�
						sleep @tc_wait_time
						assert(rs, "�������ļ�����δ�ر�!")
				}


		end

		def clearup

				operate("1 �ָ��������ر��ļ�����") {
						fileshare_page = RouterPageObject::FilesharePage.new(@browser)
						fileshare_page.close_fileshare(@browser.url)
				}

		end

}
