#
# description:
# author:liluping
# date:2015-09-23
# modify:
#
testcase {
    attr = {"id" => "ZLBF_29.1.4", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time     = 3
        @tc_dumpcap_pc2   = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_ipfilter_err  = "Դ��ʼIPӦ��С�ڽ���IP"
        @tc_default_ssid  = "Wireless0"
    end

    def process

        operate("1��AP������·�ɷ�ʽ�£����һ��IP���˹���Դ��ַ����PC1��PC2�ĵ�ַ����Ĭ�ϣ�") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @tc_ssid1_name = rs_wifi[:ssid]
            @tc_ssid1_pwd  = rs_wifi[:pwd]
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2����dut����
            p "PC2����wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @tc_ssid1_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi����ʧ��")

            @pc1_dut_ip       = ipconfig("all")[@ts_nicname][:ip][0] #��ȡpc1����ip
            @pc2_wireless_ip  = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0] #��ȡpc2����ip

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
            @options_page.firewall_click
            @options_page.open_switch("on", "on", "off", "off")
            @options_page.ipfilter_click
            @options_page.ip_add_item_element.click
            @options_page.ip_filter_src_ip_input(@pc1_dut_ip, @pc2_wireless_ip)
            @options_page.ip_filter_save
            #���֡�Դ��ʼIPӦ��С�ڽ���IP��������ʾʱ������ʼ����ip����
            if @options_page.ip_filter_err_msg == @tc_ipfilter_err
                @options_page.ip_filter_src_ip_input(@pc2_wireless_ip, @pc1_dut_ip)
                @options_page.ip_filter_save
            end
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "��ӹ��˹���ʧ�ܣ�")
        }

        operate("2���ٽ��뵽����ǽ���棬������ǽ�ܿ��عرգ�IP���˿��������棬PC1��PC2�ܷ����������") {
            @options_page.firewall_click
            @options_page.open_switch("off", "on", "off", "off")

            puts "��֤PC1��PC2�ܷ��������".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "����ʧ�ܣ������ܿ����ѹرգ���PC1���߿ͻ��˲����Է�������~")

            response = @tc_dumpcap_pc2.send_http_request(@ts_web)
            assert(response, "����ʧ�ܣ������ܿ����ѹرգ���PC2���߿ͻ��˲����Է�������~")
        }


    end

    def clearup

        operate("1 �رշ���ǽ�ܿ��غ�IP���˿��ز�ɾ����������") {
            p "�Ͽ�wifi����".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����
            sleep @tc_wait_time
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }

        operate("2 �ָ�Ĭ��ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end

}
