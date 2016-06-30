#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_13.1.20", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_storage_usb = "U��"
				@tc_cur_path    = "/usbshare"
		end

		def process

				operate("1 �򿪸߼�����") {
						@options_page   = RouterPageObject::OptionsPage.new(@browser)
						@fileshare_page = RouterPageObject::FilesharePage.new(@browser)
				}

				operate("2 ��ϵͳ���ÿ����ļ�����") {
						@options_page.open_fileshare_page(@browser.url)
				}

				operate("3 �鿴����Ŀ¼U���е��ļ�") {
						rs = @fileshare_page.current_path_element.exists?
						assert(rs, "δ���ļ�����Ŀ¼����")
						puts "�鿴#{@tc_storage_usb}�е��ļ�".to_gbk
						#��U��
						@fileshare_page.udisk

						#�鿴U���е��ļ���
						dir_name = @fileshare_page.first_catalog_element.text
						dir_size = @fileshare_page.get_first_catalog_size
						puts "�ļ�������#{dir_name}----�ļ���С:#{dir_size}".to_gbk
						#����Ŀ¼
						@fileshare_page.first_catalog

						#�鿴U���е��ļ�
						file_name = @fileshare_page.second_testfile_element.text
						file_size = @fileshare_page.get_second_testfile_size
						puts "�����ļ�����#{file_name}------------�ļ���С��#{file_size}".to_gbk

						#���ص���Ŀ¼
						@fileshare_page.return
						@fileshare_page.return
						rs_back_usb_dir = @fileshare_page.current_path
						assert_equal(@tc_cur_path, rs_back_usb_dir, "���ص�U�̸�Ŀ¼ʧ��")
				}

				operate("4 �ر��ļ�����") {
						@fileshare_page.close_share
				}

				operate("5 ����·����") {
						@browser.refresh
						@options_page.reboot
						rs = @options_page.login_with_exists(@browser.url)
						assert(rs, "������δ��ת����¼���棡")
				}

				operate("7 ����·������,���µ�¼·�������򿪸߼�����") {
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
				}

				operate("8 ����·�����󣬴�ϵͳ���ò鿴�ļ�����") {
						@options_page.open_options_page(@browser.url)
						@options_page.select_fileshare
						switch_state = @options_page.file_share_btn_element.exists?
						assert(switch_state, "�ļ�����ر�ʧ��")
				}

		end

		def clearup

				operate("�ָ��������ر��ļ�����") {
						fileshare_page = RouterPageObject::FilesharePage.new(@browser)
						fileshare_page.close_fileshare(@browser.url)
				}
		end

}
