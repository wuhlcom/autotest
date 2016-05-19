#
#description:
# ����̫�����ӣ�������������ʵ��
# ���������ά���ɱ�
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.21", "level" => "P1", "auto" => "n"}

    def prepare
        @ts_download_directory.gsub!("\\", "\/")
        @tc_file_name          = "config.tgz"
    end

    def process
        operate("1 �򿪸߼����ã�ѡ��ϵͳ����->�ָ���������") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @wan_page     = RouterPageObject::WanPage.new(@browser)
            @status_page  = RouterPageObject::SystatusPage.new(@browser)
        }

        operate("2 ����ָ���������") {
            @options_page.recover_factory(@browser.url)
            rs = @options_page.login_with_exists(@browser.url)
            assert(rs, "�ָ��������ú�δ��ת��·������¼ҳ��!")
        }

        operate("5 ��������������") {
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
        }

        operate("6 ����PPPOE����") {
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("7 �鿴PPPOE WAN״̬") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.refresh
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns

            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�'
        }

        operate("8 ��֤PPPOEҵ��") {
            rs = ping(@ts_web)
            assert(rs, '�޷���������')
        }

        operate("9 ���´򿪸߼����ã�ѡ��ϵͳ����->�ָ���������") {
            #�жϵ�ǰ����Ŀ¼�Ƿ��������ļ������������������
            config_file_old = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
            unless config_file_old.nil?
                puts config_file_old
                timestamp       = Time.now().strftime("%Y%m%d%H%M%S")
                config_file_new = config_file_old.sub(/\./, "_#{timestamp}\.")
                File.rename(config_file_old, config_file_new)
            end
            #ɾ���ɵ�Ĭ�������ļ�
            Dir.glob(@ts_download_directory+"/*").delete_if { |file|
                if file=~/default/
                    FileUtils.rm(file, force: true)
                    true
                end
            }
            #����������в���"default"����@tc_file_nameƥ��Ľ����޸�Ϊdefault����
            config_file_old = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
            unless config_file_old.nil?
                config_file_default = config_file_old.sub(/\./, "_default\.")
                File.rename(config_file_old, config_file_default)
            end
        }

        operate("10 ����PPPOE�����ļ�") {
            #����Ĭ�����ú��ٵ���pppoe����
            @options_page.export_file_step(@browser, @browser.url)
            config_download = Dir.glob(@ts_download_directory+"/*").any? { |file| file=~/#{@tc_file_name}$/ }
            assert(config_download, "PPPOE�����ļ�����ʧ�ܣ�")
        }

        operate("11 ����PPPOE�����ļ���ָ�·����Ϊ��������") {
            @options_page.recover_btn
            rs = @options_page.login_with_exists(@browser.url)
            assert(rs, "�ָ��������ú�δ��ת��·������¼ҳ��!")
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
        }

        operate("12 �ָ��������ú���鿴WAN״̬,PPPOE�Ƿ񱻻ָ�") {
            @status_page.open_systatus_page(@browser.url)
            wan_type = @status_page.get_wan_type
            assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '��������δ�ָ�ΪĬ��ֵ��'
        }

        operate("13 ����PPPOE�����ļ�") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            pppoe_config_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
            #����Ҳ��������ļ�
            refute(pppoe_config_file.nil?, "�����ļ�����")
            #���������ļ�
            @options_page.import_file_step(@browser.url, pppoe_config_file)
            rs = @options_page.login_with_exists(@browser.url)
            assert(rs, "���������ļ���δ��ת��·������¼ҳ��!")
            #���µ�¼·����
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
        }

        operate("14 ����PPPOE�����ļ���鿴PPPOE������Ϣ") {
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�'
        }

        operate("15 ���µ������鿴PPPOEҵ��") {
            rs = ping(@ts_web)
            assert(rs, '�޷���������')
        }

    end

    def clearup

        operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end

            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
