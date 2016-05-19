#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.23", "level" => "P2", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_server_obj = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_pppoe_chap = "chap"
        @tc_net_time   = 50
        @tc_wait_time  = 2
    end

    def process

        operate("1��BAS����ץ����") {
            #����pppoe����ļ���Ϊchap
            @tc_server_obj.init_routeros_obj(@ts_routeros_ip)
            @tc_server_obj.routeros_send_cmd(@ts_pppoe_chap_set)
            rs = @tc_server_obj.pppoe_srv_pri(@ts_pppoe_srv_pri)
            puts "�޸ķ�����PPPOE��֤Ϊ:#{rs["authentication"]}".encode("GBK")
            assert_equal(@tc_pppoe_chap, rs["authentication"], "�޸���֤��ʽʧ��")
        }

        operate("2������DUT��WAN���ŷ�ʽΪPPPoE��DNSΪ�Զ���ȡ��ʽ��BAS��֤ǿ������ΪCHAP-MD5������д��ȷ�Ĳ����û��������룬�ύ��") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("3��ץ��ȷ����PPP LCP�����У�BAS��DUTЭ���Ƿ����CHAP-MD5��֤�������Ƿ�ɹ����鿴WAN���ӣ�IP��·�ɣ�DNS����Ϣͳ��ҳ����ʾ��Ϣ�Ƿ���ȷ��") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page = RouterPageObject::SystatusPage.new(@browser)
            @sys_page.open_systatus_page(@browser.url)
            p wan_addr     = @sys_page.get_wan_ip
            p wan_type     = @sys_page.get_wan_type
            p mask         = @sys_page.get_wan_mask
            p gateway_addr = @sys_page.get_wan_gw
            p dns_addr     = @sys_page.get_wan_dns
            assert_match @ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
            assert_match @ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�'
            assert_match @ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�'
            assert_match @ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�'
        }

        operate("4��LAN PC��STA PC����ҵ���Ƿ�������") {
            rs = ping(@ts_web)
            assert(rs, "PPPOE���ųɹ���ҵ���쳣")
        }


    end

    def clearup

        operate("1 �ָ�������Ĭ������") {
            @tc_server_obj.routeros_send_cmd(@ts_pppoe_default_set)
            rs = @tc_server_obj.pppoe_srv_pri(@ts_pppoe_srv_pri)
            puts "�ָ���������֤��ʽΪ:#{rs["authentication"]}".encode("GBK")
            @tc_server_obj.logout_routeros
        }

        operate("2 �ָ�Ĭ��DHCP����") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
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
