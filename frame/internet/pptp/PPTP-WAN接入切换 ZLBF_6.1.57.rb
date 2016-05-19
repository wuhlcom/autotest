#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.57", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_server = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_pptp_dfault    = "pap,chap,mschap1,mschap2"
    end

    def process

        operate("1����BAS����ץ����") {
            #����ppptp�������֤ΪĬ������
            @tc_dumpcap_server.init_routeros_obj(@ts_pptp_server_ip)
            @tc_dumpcap_server.routeros_send_cmd(@ts_pptp_default_set)
            rs = @tc_dumpcap_server.pptp_srv_pri(@pptp_pri)
            p "�޸ķ�����PPTP��֤��ʽΪ:#{rs["authentication"]}".to_gbk
            assert_equal(@tc_pptp_dfault, rs["authentication"], "�޸���֤��ʽʧ��")
        }

        operate("2������DUT��WAN���ŷ�ʽΪPPTP��DUT��������Ӧ��PPTP��ʽ�������ã�DNSΪ�Զ���ȡ��ʽ����֤������Ϊ�Զ�������д��ȷ�Ĳ����û��������룬�鿴�����Ƿ�ɹ���") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @sys_page     = RouterPageObject::SystatusPage.new(@browser)
            @options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)

            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns

            assert_match(@ip_regxp, wan_addr, 'PPTP��ȡip��ַʧ�ܣ�')
            assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���')
            assert_match(@ip_regxp, mask, 'PPTP��ȡip��ַ����ʧ�ܣ�')
            assert_match(@ip_regxp, gateway_addr, 'PPTP��ȡ����ip��ַʧ�ܣ�')
            assert_match(@ip_regxp, dns_addr, 'PPTP��ȡdns ip��ַʧ�ܣ�')
        }

        operate("3���л�DUT��WAN��ʽΪDHCP��ʽ��BASץ��ȷ���л���DHCPʱ���Ƿ��Ե�ǰ��call ID����Call-Clear-Request�Ͽ��������л���PPTP��ʽ���Ƿ��ܿ��ٲ��ųɹ���") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "�л�WAN�ķ�ʽΪDHCP".to_gbk
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp_mode(@browser.url)
            # end
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'DHCP��ȡip��ַʧ�ܣ�')
            assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���')
            assert_match(@ip_regxp, mask, 'DHCP��ȡip��ַ����ʧ�ܣ�')
            assert_match(@ip_regxp, gateway_addr, 'DHCP��ȡ����ip��ַʧ�ܣ�')
            assert_match(@ip_regxp, dns_addr, 'DHCP��ȡdns ip��ַʧ�ܣ�')
            p "�л�WAN�ķ�ʽΪPPTP".to_gbk
            @options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'PPTP��ȡip��ַʧ�ܣ�')
            assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���')
            assert_match(@ip_regxp, mask, 'PPTP��ȡip��ַ����ʧ�ܣ�')
            assert_match(@ip_regxp, gateway_addr, 'PPTP��ȡ����ip��ַʧ�ܣ�')
            assert_match(@ip_regxp, dns_addr, 'PPTP��ȡdns ip��ַʧ�ܣ�')
        }

        operate("4���л�DUT��WAN��ʽ�ֱ�ΪSTATIC��PPPoE��PPTP���������뷽ʽ���ظ�����3��ȷ�Ͻ����") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "�л�WAN�ķ�ʽΪPPPOE".to_gbk
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�')
            assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���')
            assert_match(@ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�')
            assert_match(@ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�')
            assert_match(@ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�')
            p "�л�WAN�ķ�ʽΪPPTP".to_gbk
            @options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'PPTP��ȡip��ַʧ�ܣ�')
            assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���')
            assert_match(@ip_regxp, mask, 'PPTP��ȡip��ַ����ʧ�ܣ�')
            assert_match(@ip_regxp, gateway_addr, 'PPTP��ȡ����ip��ַʧ�ܣ�')
            assert_match(@ip_regxp, dns_addr, 'PPTP��ȡdns ip��ַʧ�ܣ�')
        }
    end

    def clearup
        operate("�Ͽ�����������") {
            @tc_dumpcap_server.logout_routeros
        }

        operate("�ָ�Ĭ��DHCP����") {
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
