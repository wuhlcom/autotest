#
# description:
#���ع����йرչ����رչ���󣬻��ܲ���·���������鿴����������ǹر�
#ͳһƽ̨�汾�����ع������޷��رչ���������ʾ��"�豸����ʹ����,�ر�ʧ��" 2016/04/06
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_13.1.23", "level" => "P4", "auto" => "n"}

    def prepare
        @ts_download_directory.gsub!("\\", "\/")
        @tc_download_time    = 5
        @tc_wait_time        = 3
        @tc_close_share_time = 5
        @tc_download_file    = "����Pycharm_TEST.exe"
        @tc_download_path    = @ts_download_directory+"/#{@tc_download_file}"
        @tc_hint_msg         = "�豸����ʹ����,�ر�ʧ��"
    end

    def process

        operate("1���ֱ����USB�豸��TF����SD������¼webҳ�棬���뵽�ĵ�����ҳ�棬") {
            @options_page   = RouterPageObject::OptionsPage.new(@browser)
            @fileshare_page = RouterPageObject::FilesharePage.new(@browser)
        }

        operate("2��������ǰ���ļ������ܡ�������ҳ���Ƿ���ʾ��ǰ�����豸���ļ�����") {
            @options_page.open_fileshare_page(@browser.url)
            rs = @fileshare_page.current_path?
            assert(rs, "�ļ������ʧ��")
            udisk_status = @fileshare_page.udisk?
            assert(udisk_status, "�ļ�����δ��ʾU��")

            #�鿴U���е��ļ���
            @fileshare_page.udisk #��U��Ŀ¼
            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "�ļ�������#{dir_name}----�ļ���С:#{dir_size}".to_gbk

            #����Ŀ¼
            @fileshare_page.first_catalog
        }

        operate("3��������е��ļ��������أ����ع�������ҳ���ϰ��ļ������ܹرգ��鿴AP�Ƿ��쳣") {
            #����U���е���Ŀ¼�µ��ļ�
            #�жϵ�ǰ����Ŀ¼�Ƿ��������ļ������������������
            dl_file_path = Dir.glob(@ts_download_directory+"/*").find { |file|
                file=~/#{@tc_download_file}$/
            }
            unless dl_file_path.nil?
                puts "ɾ������Ŀ¼�еľ��ļ�:#{dl_file_path}".encode("GBK")
                File.delete(dl_file_path)
            end

            file_state = File.exists?(@tc_download_path)
            refute(file_state, "����Ŀ¼�о��ļ�:#{@tc_download_file}δɾ��")

            dl_file_name = @fileshare_page.second_pycharm_testfile_element.text
            dl_file_size = @fileshare_page.get_second_py_size
            puts "Ҫ���ص��ļ�����#{dl_file_name}------------�ļ���С��#{dl_file_size}".to_gbk
            thr = Thread.new do
                #����ļ���ʼ����
                @fileshare_page.second_pycharm_testfile #�����ļ�
                sleep @tc_download_time
            end
            sleep @tc_wait_time
            #���ع����У��رչ���
            puts "���ع����йرչ���".encode("GBK")
            @fileshare_page.close_share
            sleep 2
            p "�鿴�Ƿ������ر�".to_gbk
            @options_page.open_options_page(@browser.url)
            @options_page.select_fileshare #�����ļ�����ҳ��
            sleep 2
            rs = @fileshare_page.current_path?
            refute(rs, "�ļ������ʧ��")
        }


    end

    def clearup
        operate("1 �ָ��������ر��ļ�����") {
            fileshare_page = RouterPageObject::FilesharePage.new(@browser)
            fileshare_page.close_fileshare(@browser.url)
        }
    end

}
