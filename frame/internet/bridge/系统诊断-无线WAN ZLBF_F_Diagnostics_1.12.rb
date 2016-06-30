#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.29", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_error_pw            = "errorpasswd"
        @tc_tag_diag_fini_fail2 = "�����ɣ����粻ͨ��"
        @tc_handle_num0         = 0
        @tc_handle_num1         = 1
        @tc_diag_time           = 30
    end

    def process

        operate("1��������������Ϊ����WAN��ɨ��һ����������������AP�������ӣ�������ȷ���������ӳɹ���") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_bridge_pattern(@browser.url, @ts_upssid_name, @ts_ap_pw)
            #�鿴WAN״̬
            @systatus_page = RouterPageObject::SystatusPage.new(@browser)
            @systatus_page.open_systatus_page(@browser.url)
            wan_type = @systatus_page.get_wan_type
            wan_ip   = @systatus_page.get_wan_ip
            wan_gw   = @systatus_page.get_wan_gw
            puts "WAN���뷽ʽΪ:#{wan_type}".to_gbk
            assert_match(/#{@ts_tag_wifiwan}/, wan_type, "�������ʹ���")
            puts "WAN IP��ַ:#{wan_ip}".to_gbk
            assert_match(@ts_tag_ip_regxp, wan_ip, "����WAN��ȡIP��ַʧ��")
            puts "WAN ����Ϊ:#{wan_gw}".to_gbk
            assert_match(@ts_tag_ip_regxp, wan_gw, "����WAN��ȡ���ص�ַʧ��")
            rs = ping(@ts_web)
            assert(rs, "��������ʧ��!")
        }

        operate("2�����ϵͳ��ϣ��鿴��Ͻ����") {
            @diagnose_page = RouterPageObject::DiagnosePage.new(@browser)
            @diagnose_page.initialize_diag(@browser)
            rs = @diagnose_page.detect_rs
            puts "��Ͻ��:#{rs}".to_gbk
            assert_equal(@ts_tag_diag_fini_success, rs, "��Ͻ������!")

            net_status = @diagnose_page.net_status
            puts "��������״̬:#{net_status}".to_gbk
            assert_equal(@ts_tag_diag_success, net_status, "�������ӽ����ʾ����")

            wan_conn = @diagnose_page.wan_conn
            puts "WAN������״̬:#{wan_conn}".to_gbk
            assert_equal(@ts_tag_diag_success, wan_conn, "WAN������״̬��ʾ����")

            net_speed = @diagnose_page.net_speed
            puts "��������״̬:#{net_speed}".to_gbk
            assert_equal(@ts_tag_diag_success, net_speed, "WAN������������ʾ����")
        }

        operate("3��ɨ��һ������AP�������ӣ�������������������ӣ�ʹ���Ӳ��ɹ���") {
            @diagnose_page.switch_page(@tc_handle_num0)
            @wan_page.set_bridge_pattern(@browser.url, @ts_upssid_name, @tc_error_pw)
            rs = ping(@ts_web)
            refute(rs, "��������Ӧ����ʧ�ܵ�!")
        }

        operate("4�����ϵͳ��ϣ��鿴��Ͻ����") {
            @diagnose_page.switch_page(@tc_handle_num1)
            @diagnose_page.rediag #�������
            sleep @tc_diag_time
            rs = @diagnose_page.detect_rs
            puts "��Ͻ��:#{rs}".to_gbk
            assert_equal(@tc_tag_diag_fini_fail2, rs, "��Ͻ������!")

            net_status = @diagnose_page.net_status
            puts "��������״̬:#{net_status}".to_gbk
            assert_equal(@ts_tag_diag_fail, net_status, "�������ӽ����ʾ����")

            wan_conn = @diagnose_page.wan_conn
            puts "WAN������״̬:#{wan_conn}".to_gbk

            net_speed = @diagnose_page.net_speed
            puts "��������״̬:#{net_speed}".to_gbk
            assert_equal(@ts_tag_diag_fail, net_speed, "WAN������������ʾ����")
        }

        # operate("5��ɨ�貢����һ������������AP�����ӳɹ������ϵͳ��ϣ��鿴��Ͻ����") {
        #
        # }

    end

    def clearup

        operate("1���ָ�Ĭ�Ͻ��뷽ʽDHCP") {
            @diagnose_page.switch_page(@tc_handle_num0)
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }

    end

}
