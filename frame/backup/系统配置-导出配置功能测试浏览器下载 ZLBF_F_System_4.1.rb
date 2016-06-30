#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.37", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dmz_ip       = "192.168.200.200"
        @tc_network_file = "network"
        @tc_zhilu_file   = "zhilu"
        @tc_wifi_file    = "wireless"
    end

    def process

        operate("1 �Ȼָ�·������������") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.recover_factory(@browser.url)
            login_ui    = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "�ָ��������ú�ϵͳδ��ת����¼���棡")
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
        }

        operate("2������WAN����ΪPPPoE��ʽ��������ȷ�û��������룬���棬�����Ƿ�ɹ���PC����ҵ���Ƿ�������") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

            rs = ping(@ts_web)
            assert(rs, "PPPOE����ʧ��")
        }

        operate("3���޸�LAN��IP��ַ���޸ĵ�ַ�ط�Χ���޸�����SSID���޸����߰�ȫ���޸����߸߼���������Ӷ˿�ת�����򡢶˿ڴ����������URL���˹���IP��˿ڹ��˹��򡢿���UPNP���ܡ�����DMZ���ܡ�����DDNS���ܡ��޸ĵ�¼����ȣ�") {
            @lan_page = RouterPageObject::LanPage.new(@browser)
            @lan_page.lan_ip_config(@ts_dhcp_server_ip, @browser.url)
            login_ui = @lan_page.login_with_exists(@browser.url)
            assert(login_ui, "�޸�LAN��IP��ַ��ϵͳδ��ת����¼���棡")
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
            @lan_page.open_lan_page(@browser.url)
            @lan_ip = @lan_page.lan_ip
            p "������ipΪ��#{@lan_ip}".to_gbk
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi    = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @ssid      = rs_wifi[:ssid]
            @pwd       = rs_wifi[:pwd]
            p "�޸�ssidΪ��#{@ssid}������Ϊ��#{@pwd}".to_gbk
            @options_page.set_dmz(@tc_dmz_ip, @browser.url)
            p "�޸�dmz����ipΪ��#{@tc_dmz_ip}".to_gbk
        }

        operate("4��������ݣ��鿴�����ļ������Ƿ�ɹ���") {
            #ȡ������Ŀ¼�µ������ļ�����·����������
            old_backup_files = Dir.glob(@ts_backup_directory+"/*")
            #ɾ��Ŀ¼�����������ļ�
            old_backup_files.each do |file|
                FileUtils.rm_rf(file) if file=~/#{@ts_default_config_name}$/
            end
            old_config = Dir.glob(@ts_backup_directory+"/*").any? { |file| file=~/#{@ts_default_config_name}$/ }
            refute(old_config, "�ɵ������ļ�δɾ��")
            @options_page.export_file_step(@browser, @browser.url) #���������ļ�

            #�鿴�ļ��Ƿ����سɹ�
            config_flag = false
            Dir.glob(@ts_backup_directory+"/*").each { |file|
                if file=~/#{@ts_default_config_name}$/
                    config_flag=true
                    break
                end
            }
            assert(config_flag, "ϵͳ�����ļ�����ʧ�ܣ�")

            archive_path = @ts_backup_directory + "/" + @ts_default_config_name
            network_file = get_tgz_content(archive_path, /#{@tc_network_file}/) #��ȡnetwork�����ļ�
            wifi_file    = get_tgz_content(archive_path, /#{@tc_wifi_file}/) #��ȡwireless�����ļ�
            zhilu_file   = get_tgz_content(archive_path, /#{@tc_zhilu_file}/) #��ȡzhilu�����ļ�
            puts "�����ļ�ƥ����".encode("GBK")
            matchs = network_file =~ /option proto '#{@ts_wan_mode_pppoe}'/i &&
                network_file =~ /option username '#{@ts_pppoe_usr}'/i &&
                network_file =~ /option password '#{@ts_pppoe_pw}'/i &&
                network_file =~ /option ipaddr '#{@lan_ip}'/i &&
                wifi_file =~ /option ssid '#{@ssid}'/i &&
                wifi_file =~ /option key '#{@pwd}'/i &&
                zhilu_file =~ /option dmzEnable '1'/i &&
                zhilu_file =~ /option dmzAddress '#{@tc_dmz_ip}'/i
            assert(false, "�����������ļ������쳣") unless matchs
        }
    end

    def clearup

        operate("1 �ָ����������Իָ�Ĭ������") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.recover_factory(@browser.url)
            # ## �������ʽ�ظ��������ã���ֹ·������¼ʧ�������޷��ָ�Ĭ������
            # lan_ip = ipconfig[@ts_nicname][:gateway][0]
            # telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
            # exp_ralink_init
        }

    end

}
