#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.42", "level" => "P4", "auto" => "n"}

    def prepare
        #�жϵ�ǰ����Ŀ¼�Ƿ��������ļ������������������
        dl_file_path = Dir.glob(@ts_download_directory+"/*").find { |file|
            file=~/\.tgz/i
        }
        unless dl_file_path.nil?
            puts "ɾ������Ŀ¼�еľ��ļ�:#{dl_file_path}".encode("GBK")
            File.delete(dl_file_path)
        end
    end

    def process

        operate("1����ǰΪAPΪPPPOE���ţ����������ļ�") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pppoe, connect_type, "�޸�������������ʧ�ܣ�")
            p "���������ļ�".to_gbk
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.export_file_step(@browser, @browser.url)
        }

        operate("2���޸�WAN����ΪDHCP��Ȼ���벽��1�е������ļ�������ɹ��󣬲鿴AP������ģʽ") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wan_page.set_dhcp(@browser, @browser.url)
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_dhcp, connect_type, "�޸�������������#{@ts_wan_mode_dhcp}ʧ�ܣ�")

            p "���������ļ�".to_gbk
            configuration_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/\.tgz/i }
            puts "�����ļ�����·����#{configuration_file}".encode("GBK")
            @options_page.import_file_step(@browser.url, configuration_file)

            p "�鿴�����Ƿ�ָ���".to_gbk
            @login_page = RouterPageObject::LoginPage.new(@browser)
            login_ui    = @login_page.login_with_exists(@browser.url)
            assert(login_ui, "��������ϵͳ������δ��ת����¼����")
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pppoe, connect_type, "���������ļ���������������δ�ָ�Ϊ#{@ts_wan_mode_pppoe}����")
        }

        operate("3���޸�WAN����Ϊ��̬IP��Ȼ���벽��1�е������ļ�������ɹ��󣬲鿴AP������ģʽ") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #����ΪSTATIC����
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_static, connect_type, "�޸�������������#{@ts_wan_mode_static}ʧ�ܣ�")

            p "���������ļ�".to_gbk
            configuration_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/\.tgz/i }
            puts "�����ļ�����·����#{configuration_file}".encode("GBK")
            @options_page.import_file_step(@browser.url, configuration_file)

            p "�鿴�����Ƿ�ָ���".to_gbk
            login_ui = @login_page.login_with_exists(@browser.url)
            assert(login_ui, "��������ϵͳ������δ��ת����¼����")
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pppoe, connect_type, "���������ļ���������������δ�ָ�Ϊ#{@ts_wan_mode_pppoe}����")
        }

        operate("4���޸�WAN����ΪPPTP���ţ�Ȼ���벽��1�е������ļ�������ɹ��󣬲鿴AP������ģʽ") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #����ΪPPTP����
            @options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pptp, connect_type, "�޸�������������#{@ts_wan_mode_pptp}ʧ�ܣ�")

            p "���������ļ�".to_gbk
            configuration_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/\.tgz/i }
            puts "�����ļ�����·����#{configuration_file}".encode("GBK")
            @options_page.import_file_step(@browser.url, configuration_file)

            p "�鿴�����Ƿ�ָ���".to_gbk
            login_ui = @login_page.login_with_exists(@browser.url)
            assert(login_ui, "��������ϵͳ������δ��ת����¼����")
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pppoe, connect_type, "���������ļ���������������δ�ָ�Ϊ#{@ts_wan_mode_pppoe}����")
        }


    end

    def clearup
        operate("�ָ�Ĭ��DHCP����") {
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
