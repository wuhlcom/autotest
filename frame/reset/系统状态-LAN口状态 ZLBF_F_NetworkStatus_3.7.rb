#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.23", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_lan_ip = "192.168.121.1"
    end

    def process

        operate("1 ��״̬����") {
            @status_page = RouterPageObject::SystatusPage.new(@browser)
        }

        operate("2 �鿴lan״̬") {
            @status_page.open_systatus_page(@browser.url)
            rs_mac  = @status_page.get_lan_mac
            rs_ip   = @status_page.get_lan_ip
            rs_mask = @status_page.get_lan_mask

            assert_match(@ts_wan_mac_pattern1, rs_mac, "��ʾmac��ַ����!")
            assert_match(/#{@ts_default_ip}/, rs_ip, "��ʾip��ַ����!")
            assert_match(/#{@ts_lan_mask}/, rs_mask, "��ʾmask��ַ����!")
        }

        operate("3 �޸�LAN IP��ַ") {
            @lan_page = RouterPageObject::LanPage.new(@browser)
            @lan_page.lan_ip_config(@tc_lan_ip, @browser.url)

            @login_page = RouterPageObject::LoginPage.new(@browser)
            rs          = @login_page.login_with_exists(@browser.url)
            assert rs, '��ת����¼ҳ��ʧ�ܣ�'
            #���µ�¼·����
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
        }

        operate("4 �޸�LAN IP�����²鿴LAN״̬") {
            @status_page.open_systatus_page(@browser.url)
            rs_mac = @status_page.get_lan_mac
            rs_ip  = @status_page.get_lan_ip
            rs_mask = @status_page.get_lan_mask

            assert_match(@ts_wan_mac_pattern1, rs_mac, "�޸�������ʾmac��ַ����!")
            assert_match(/#{@tc_lan_ip}/, rs_ip, "�޸�������ʾip��ַ����!")
            assert_match(/#{@ts_lan_mask}/, rs_mask, "�޸�������ʾmask��ַ����!")
        }

    end

    def clearup
        operate("1 �ָ�LanĬ������") {
            rs1 = ping(@ts_default_ip)
            if rs1 == true
                puts "·��������Ĭ������".to_gbk
            else
                options_page = RouterPageObject::OptionsPage.new(@browser)
                options_page.recover_factory(@browser.url)

                ##�������ʽ�ظ��������ã���ֹ·������¼ʧ�������޷��ָ�Ĭ������
                # lan_ip = ipconfig[@ts_nicname][:gateway][0]
                # telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
                # exp_ralink_init
            end
        }
    end

}
