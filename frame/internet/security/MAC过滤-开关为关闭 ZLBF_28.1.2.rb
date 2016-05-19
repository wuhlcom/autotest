#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
    attr = {"id" => "ZLBF_28.1.2", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time    = 3
        @tc_dumpcap_pc2  = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_default_ssid = "Wireless0"
    end

    def process

        operate("1��AP������·��ģʽ��,���Է���������") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)

            rs = ping(@ts_web)
            assert(rs, "����ǰPC�޷�����")
            puts "PC1 TCP server connect"
            client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            assert(client.tcp_state, "����ǰPC���ܽ���tcp����")
        }

        operate("2 ���߿ͻ�������·��������ping����") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            mac_last   = @wifi_page.get_mac_last
            @wifi_page.open_wifi_page(@browser.url)
            @tc_ssid1_name = @wifi_page.ssid1
            puts "��ǰSSID1��Ϊ#{@tc_ssid1_name}".to_gbk
            puts "��ǰSSID1 ���ܷ�ʽΪ#{@wifi_page.ssid1_pwmode}".to_gbk
            #�жϼ��ܷ�ʽ�Ƿ�ΪWPA,�������������ΪWPA
            flag = false
            unless @wifi_page.ssid1_pwmode == @ts_sec_mode_wpa
                @wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                @wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                    = true
            end
            unless @tc_ssid1_name=~/#{mac_last}/i
                @tc_ssid1_name   = "#{@tc_ssid1_name}_#{mac_last}"
                @wifi_page.ssid1 = @tc_ssid1_name
                puts "�޸�SSID1��Ϊ#{@tc_ssid1_name}".to_gbk
                flag = true
            end
            @wifi_page.save_wifi_config if flag
            puts "Dut ssid: #{@tc_ssid1_name},passwd:#{@ts_default_wlan_pw}"
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2����dut����
            p "PC2����wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @ts_default_wlan_pw, @ts_wlan_nicname)
            assert(rs, "PC2 wifi����ʧ��")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            assert wifi_rs, "WIFI�ͻ����޷���������"
        }

        operate("3�����뵽MAC��ַ����ҳ�棬����PC1��MAC��ַ��") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "on", "off")
            @options_page.macfilter_click
            @options_page.mac_add_item_element.click #������Ŀ
            puts "PC MAC address : #{@ts_pc_mac}"
            @options_page.mac_filter_input(@ts_pc_mac, @ts_nicname) #���룬״̬Ĭ��Ϊ��Ч
            @options_page.mac_filter_save
        }

        operate("4�����mac���˺���֤�Ƿ���Ч") {
            rs = ping(@ts_web)
            refute(rs, "���˺�ͻ���������������")
            puts "���˺�PC1 TCP server connect".encode("GBK")
            client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(client.tcp_state, "���˺�PC���ܽ���tcp����")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            assert(wifi_rs, "�������߿ͻ��˵���WIFI�ͻ���Ҳ�޷���������")
        }

        operate("5���ڷ���ǽ����ҳ��ر�MAC��ַ����") {
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "off")
        }

        operate("6���鿴PC1��PC2�Ƿ񶼿��Է��ʵ�����PC3��FTP����") {
            rs = ping(@ts_web)
            assert(rs, "�رչ��˺�ͻ��˲�����������")
            puts "�رչ��˺�PC1 TCP server connect".encode("GBK")
            client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            assert(client.tcp_state, "�رչ���PC���ܽ���tcp����")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            assert wifi_rs, "�������߿ͻ��˵���WIFI�ͻ���Ҳ�޷���������"
        }
    end

    def clearup
        operate("1���ָ�����ǽĬ�����ã��ر��ܿ��ز�ɾ�����й���") {
            p "�Ͽ�wifi����".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����
            sleep @tc_wait_time
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.macfilter_close_sw_del_all(@browser.url)
        }

        operate("2 �ָ�Ĭ��ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.open_wifi_page(@browser.url)
            current_ssid   = wifi_page.ssid1
            current_pwmode = wifi_page.ssid1_pwmode
            flag = false
            unless current_ssid == @tc_default_ssid
                wifi_page.ssid1 = @tc_default_ssid
                flag = true
            end
            unless current_pwmode == @ts_sec_mode_wpa
                wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                    = true
            end
            wifi_page.save_wifi_config if flag
        }
    end

}
