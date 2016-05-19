#
#description:
# �޷��ж�һ�����ڽ���ʱ����һ������Ҳ�ڽ���
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_13.1.30", "level" => "P1", "auto" => "n"}

    def prepare

        @ts_download_directory.gsub!("\\", "/")
        @tc_download_time = 200
        @tc_storage_usb   = "U��"
        @tc_storage_sd    = "SD��"
        @tc_share_dir     = "һ��Ŀ¼"
        @tc_usb_dl_name   = "����Pycharm_TEST.exe"
        @tc_sd_dl_name    = "����RubyMine_TEST.exe"
    end

    def process

        operate("1 �򿪸߼�����") {
            @options_page   = RouterPageObject::OptionsPage.new(@browser)
            @fileshare_page = RouterPageObject::FilesharePage.new(@browser)

            if File.exists? @ts_download_directory
                puts("�����ļ�����·����#{@ts_download_directory}".to_gbk)
                files = Dir.glob("#{@ts_download_directory}/**/*")
                unless files.empty?
                    puts "=="*40
                    puts "ɾ���Ѵ��ڵ��ļ������ļ�:".to_gbk
                    #��ɾ��·�����������ļ�
                    files.delete_if { |file|
                        file=~/config/i
                    }
                    print files.join("\n").to_gbk
                    print "\n"
                    puts "=="*40
                    FileUtils.rm_rf(files)
                end
            end
        }

        operate("2 ��ϵͳ���ÿ����ļ�����") {
            @options_page.open_fileshare_page(@browser.url)
        }

        operate("3 �鿴U���е��ļ��Ƿ����") {
            rs = @fileshare_page.current_path_element.exists?
            assert(rs, "δ���ļ�����Ŀ¼����")

            usb_dir = @fileshare_page.udisk_element
            assert(usb_dir.exists?, "δ��ʾU��")
            puts "�鿴#{@tc_storage_usb}�е�����".to_gbk
            @fileshare_page.udisk

            #�鿴U���е��ļ���
            rs_sub_dir = @fileshare_page.first_catalog_element.exists?
            assert(rs_sub_dir, "�Ҳ���U���е��ļ���")
            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "�ļ�������#{dir_name}----�ļ���С:#{dir_size}".to_gbk
            @fileshare_page.first_catalog #��һ��Ŀ¼

            #�鿴U���е�Ҫ���ص��ļ��Ƿ����
            rs_file = @fileshare_page.second_pycharm_testfile_element.exists?
            assert(rs_file, "δ�ҵ�Ҫ���صĲ����ļ�")
            @tc_usb_download_file_name = @fileshare_page.second_pycharm_testfile_element.text
            @tc_usb_download_file_size = @fileshare_page.get_second_py_size
            puts "�����ļ�����#{@tc_usb_download_file_name}------------�ļ���С��#{@tc_usb_download_file_size}".to_gbk
            @tc_usb_download_file_size=~/^(\d+\.*\d+)/
            @tc_usb_file_size=Regexp.last_match(1)
        }

        operate("4 �򿪵ڶ���������������ڽ���SD�����ز���") {
            @browser.execute_script("window.open('http://#{@ts_default_ip}')")
            #�ø�@browser�����¸������ڶ���ľ������
            @tc_handles = @browser.driver.window_handles
            #ͨ��������л���ͬ��windows����
            @browser.driver.switch_to.window(@tc_handles[1])
            # rs_login = login_no_default_ip(@browser) #���µ�¼
            # assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
        }

        operate("5 �ڵڶ�����������ڲ鿴SD���е��ļ��Ƿ����") {
            @options_page.open_fileshare_page(@browser.url)
            rs = @fileshare_page.current_path_element.exists?
            assert(rs, "�ڶ��������ļ�����δ����")

            sd_dir = @fileshare_page.sdcard_element
            assert(sd_dir.exists?, "�ڶ�������δ��ʾSD��")
            puts "�鿴#{@tc_storage_sd}�е��ļ�".to_gbk

            #��SD��Ŀ¼
            @fileshare_page.sdcard
            rs_sub_dir = @fileshare_page.first_catalog_element.exists?
            assert(rs_sub_dir, "�ڶ��������Ҳ���SD���е��ļ���")
            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "�ļ�������#{dir_name}----�ļ���С:#{dir_size}".to_gbk
            #��SD��һ��Ŀ¼
            @fileshare_page.first_catalog

            rs_file = @fileshare_page.second_ruby_testfile_element.exists?
            assert(rs_file, "�ڶ�������δ�ҵ�SD����Ҫ���ص��ļ�")
            @tc_sd_download_file_name = @fileshare_page.second_ruby_testfile_element.text
            @tc_sd_download_file_size = @fileshare_page.get_second_ruby_size
            puts "�����ļ�����#{@tc_sd_download_file_name}------------�ļ���С��#{@tc_sd_download_file_size}".to_gbk
            @tc_sd_download_file_size=~/^(\d+\.*\d+)/
            @tc_sd_file_size=Regexp.last_match(1)
        }

        operate("6 U�������ص�ͬʱSD��Ҳ������") {
            #����SD�����ļ�
            puts "����SD�����ļ�".to_gbk
            @fileshare_page.second_ruby_testfile
            #����U���е��ļ�
            puts "����U���е��ļ�".to_gbk
            #ͨ��������л���ͬ��windows����
            @browser.driver.switch_to.window(@tc_handles[0])
            @fileshare_page.second_pycharm_testfile
            puts "Waiting for Download Files....."
            sleep @tc_download_time
        }

        operate("7 �鿴�ļ��Ƿ����سɹ�") {
            if File.exist?(@ts_download_directory)
                files = Dir.glob("#{@ts_download_directory}/**/*")
                if files.empty?
                    assert(false, "�ļ�����ʧ�ܣ�δ�����ص��ļ�")
                else
                    puts "=="*50
                    puts "�Ѿ����ص��ļ�:".to_gbk
                    #�����ļ��ų�����
                    files.delete_if { |file|
                        file=~/config/i
                    }
                    print files.join("\n").to_gbk
                    print "\n"
                    puts "=="*50
                    dl_usb_file_size = 0
                    dl_sd_file_size  = 0
                    files.each do |file|
                        next if file !~ /#{@tc_usb_dl_name}|#{@tc_sd_dl_name}/
                        if file=~/#{@tc_usb_dl_name}/
                            usb_file_size    = File.size(file)
                            #�����ļ���С
                            dl_usb_file_size = usb_file_size.to_f/1024.00/1024.00
                            dl_usb_file_size = dl_usb_file_size.roundf(2)
                            puts "��ȡ��U�������ص��ļ�#{@tc_usb_dl_name}����СΪ#{dl_usb_file_size}".to_gbk
                        elsif file=~/#{@tc_sd_dl_name}/
                            sd_file_size    = File.size(file)
                            dl_sd_file_size = sd_file_size.to_f/1024/1024
                            dl_sd_file_size = dl_sd_file_size.roundf(2)
                            puts "��ȡ��SD�������ص��ļ�#{@tc_sd_dl_name}����СΪ#{dl_sd_file_size}".to_gbk
                        end
                    end
                    #������ʹ���ַ�������ʽ���Ƚ�
                    flag_usb     = (@tc_usb_file_size == dl_usb_file_size.to_s) && (dl_usb_file_size > 0)
                    flag_sd      = (@tc_sd_file_size == dl_sd_file_size.to_s) && (dl_sd_file_size > 0)
                    usb_download = files.any? { |file| file=~/#{@tc_usb_dl_name}/ }
                    sd_download  = files.any? { |file| file=~/#{@tc_sd_dl_name}/ }
                    assert(usb_download, "U�����ļ�δ����")
                    assert(flag_usb, "U�����ļ������쳣")
                    assert(sd_download, "SD�����ļ�δ����")
                    assert(flag_sd, "SD�����ļ������쳣")
                end
            else
                assert(false, "�����ļ�����Ŀ¼������")
            end
        }
    end

    def clearup

        operate("�ָ��������ر��ļ�����") {
            tc_handles = @browser.driver.window_handles
            @browser.driver.switch_to.window(tc_handles[0])
            fileshare_page = RouterPageObject::FilesharePage.new(@browser)
            fileshare_page.close_fileshare(@browser.url)
        }
    end

}
