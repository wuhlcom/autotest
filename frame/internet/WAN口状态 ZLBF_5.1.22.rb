#
#description:#
# ���������Ĳ��Ե�̫�̫࣬�����ӣ��Զ�������ʵ��
# ʵ����Ҳ������ά���ɱ�
# ��������ֺ���ʵ��
# ʵ����dhcp,pppoe,static���뷽ʽ�л�ʱwan״̬��ʾ
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.22", "level" => "P1", "auto" => "n"}

    def prepare
        
    end

    def process

        operate("1 ��������������") {
        }

        operate("2 �����������뷽ʽΪ��DHCP") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }

        operate("3 �鿴DHCP����ʱWAN״̬") {
            @browser.refresh #ˢ�������
            #�ر�WAN����
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            wan_addr = @status_page.get_wan_ip
            puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{wan_addr}".to_gbk

            wan_type = @status_page.get_wan_type
            puts "WAN״̬��ʾ��������Ϊ��#{wan_type}".to_gbk

            mask = @status_page.get_wan_mask
            puts "WAN״̬��ʾ�������ַΪ��#{mask}".to_gbk

            gateway_addr = @status_page.get_wan_gw
            puts "WAN״̬��ʾ������IP��ַΪ��#{gateway_addr}".to_gbk

            dns_addr = @status_page.get_wan_dns
            puts "WAN״̬��ʾ��DNS IP��ַΪ��#{dns_addr}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp��ȡip��ַʧ�ܣ�'
            assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, 'dhcp��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'dhcp��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, 'dhcp��ȡdns ip��ַʧ�ܣ�'
        }

        operate("4 �޸Ľ��뷽ʽΪPPPOE") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("5 �鿴PPPOE����ʱWAN״̬") {
            @browser.refresh #ˢ�������
            #�ر�WAN����
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            wan_addr = @status_page.get_wan_ip
            puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{wan_addr}".to_gbk

            wan_type = @status_page.get_wan_type
            puts "WAN״̬��ʾ��������Ϊ��#{wan_type}".to_gbk

            mask = @status_page.get_wan_mask
            puts "WAN״̬��ʾ�������ַΪ��#{mask}".to_gbk

            gateway_addr = @status_page.get_wan_gw
            puts "WAN״̬��ʾ������IP��ַΪ��#{gateway_addr}".to_gbk

            dns_addr = @status_page.get_wan_dns
            puts "WAN״̬��ʾ��DNS IP��ַΪ��#{dns_addr}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�'
        }

        operate("6 ���ý��뷽ʽΪStatic") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
        }

        operate("7 ��̬����ʱ�鿴WAN״̬") {
            @browser.refresh #ˢ�������
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            wan_addr = @status_page.get_wan_ip
            puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{wan_addr}".to_gbk

            wan_type = @status_page.get_wan_type
            puts "WAN״̬��ʾ��������Ϊ��#{wan_type}".to_gbk

            mask = @status_page.get_wan_mask
            puts "WAN״̬��ʾ�������ַΪ��#{mask}".to_gbk

            gateway_addr = @status_page.get_wan_gw
            puts "WAN״̬��ʾ������IP��ַΪ��#{gateway_addr}".to_gbk

            dns_addr = @status_page.get_wan_dns
            puts "WAN״̬��ʾ��DNS IP��ַΪ��#{dns_addr}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, '��̬ip����ʧ�ܣ�'
            assert_match /#{@ts_wan_mode_static}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, '��̬ip��������ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, '��̬��������ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, '��̬����dns ip��ַʧ�ܣ�'
        }


    end

    def clearup

        operate("1 �ָ�Ĭ�ϵĽ��뷽ʽ") {
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
