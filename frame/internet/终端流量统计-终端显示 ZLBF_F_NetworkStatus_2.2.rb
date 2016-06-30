#
# description:
# author:liluping
# date:2015-09-24
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.10", "level" => "P1", "auto" => "n"}

    def prepare
        @wifi_drb          = DRbObject.new_with_uri(@ts_drb_pc2)
        # @tc_wait_time      = 180
        @dut_con_type      = "����"
        @wireless_con_type = "����"
    end

    def process

        operate("1������APͨ��WAN���ӵ�����������Ӷ�̨���ߣ�����PC���ʼǱ����ֻ���ipad���豸�����ն���ʾ�б����Ƿ�������ʾ���е��豸") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi    = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @dut_ssid  = rs_wifi[:ssid]
            @dut_pwd   = rs_wifi[:pwd]
            #pc2����dut����
            flag       ="1"
            rs         = @wifi_drb.connect(@dut_ssid, flag, @dut_pwd, @ts_wlan_nicname)
            assert(rs, "PC2��������wifiʧ��".to_gbk)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            # �������豸����̨PC�����Ȼ�ȡ����PC����ز�����mac��ip���豸����
            dut_net   = ipconfig("all")[@ts_nicname]
            @dut_ip   = dut_net[:ip][0]
            @dut_mac  = dut_net[:mac].downcase
            @dut_name = get_host_name

            wireless_net   = @wifi_drb.ipconfig("all")[@ts_wlan_nicname]
            @wireless_ip   = wireless_net[:ip][0]
            @wireless_mac  = wireless_net[:mac].downcase
            @wireless_name = @wifi_drb.get_host_name

            # p "�ȴ�#{@tc_wait_time}s����ϵͳ��̨ˢ�¡�����".to_gbk
            # sleep @tc_wait_time #�ȴ�ϵͳ��̨ˢ��
            @browser.refresh
            sleep 1
            @browser.refresh
            sleep 1
            @devlist_page = RouterPageObject::DevlistPage.new(@browser)
            dev_size      = @devlist_page.get_dev_size #�����豸��
            assert_equal(2, dev_size, "�������б������豸��Ŀ����ȷ��")
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            p "�豸�б���MAC��ַΪ#{@dut_mac}����Ӧ�������ǣ�#{dev_data}".to_gbk
            dev_ip       = dev_data[:ip]
            dev_name     = dev_data[:dev_name]
            dev_con_type = dev_data[:connect_type]
            assert_equal(@dut_ip, dev_ip, "�������豸�б���MAC��ַΪ#{@dut_mac}���豸ip��Ϣ��ʾ����ȷ��")
            assert_match(dev_name, @dut_name, "�������豸�б���MAC��ַΪ#{@dut_mac}���豸�豸������Ϣ��ʾ����ȷ��")
            assert_match(@dut_con_type, dev_con_type, "�������豸�б���MAC��ַΪ#{@dut_mac}���豸���ӷ�ʽ��Ϣ��ʾ����ȷ��")
            wireless_data = @devlist_page.get_data(dev_size, @wireless_mac)
            p "�豸�б���MAC��ַΪ#{@wireless_mac}����Ӧ�������ǣ�#{wireless_data}".to_gbk
            wireless_ip       = wireless_data[:ip]
            wireless_name     = wireless_data[:dev_name]
            wireless_con_type = wireless_data[:connect_type]
            assert_equal(@wireless_ip, wireless_ip, "�������豸�б���MAC��ַΪ#{@wireless_mac}���豸ip��Ϣ��ʾ����ȷ��")
            assert_match(wireless_name, @wireless_name, "�������豸�б���MAC��ַΪ#{@wireless_mac}���豸�豸������Ϣ��ʾ����ȷ��")
            assert_match(@wireless_con_type, wireless_con_type, "�������豸�б���MAC��ַΪ#{@wireless_mac}���豸���ӷ�ʽ��Ϣ��ʾ����ȷ��")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2���������豸�Ͽ����Ӻ������ն���ʾ�б����Ƿ�������ʾ��ǰ���µ��豸") {
            p "�Ͽ�wifi����".to_gbk
            @wifi_drb.netsh_disc_all #�Ͽ�wifi����
            # sleep @tc_wait_time #�ȴ�ϵͳ��̨ˢ��
            @browser.refresh
            sleep 1
            @browser.refresh
            sleep 1
            dev_size = @devlist_page.get_dev_size #�����豸��
            assert_equal(1, dev_size, "�������б������豸��Ŀ��ʾ����ȷ!")
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            p "�豸�б���MAC��ַΪ#{@dut_mac}����Ӧ�������ǣ�#{dev_data}".to_gbk
            dev_ip       = dev_data[:ip]
            dev_name     = dev_data[:dev_name]
            dev_con_type = dev_data[:connect_type]
            assert_equal(@dut_ip, dev_ip, "�������豸�б���MAC��ַΪ#{@dut_mac}���豸ip��Ϣ��ʾ����ȷ��")
            assert_match(dev_name, @dut_name, "�������豸�б���MAC��ַΪ#{@dut_mac}���豸�豸������Ϣ��ʾ����ȷ��")
            assert_match(@dut_con_type, dev_con_type, "�������豸�б���MAC��ַΪ#{@dut_mac}���豸���ӷ�ʽ��Ϣ��ʾ����ȷ��")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("3���ٽ��Ͽ����豸���Ϻ����ն���ʾ�б����Ƿ�������ʾ�����ĵ�ǰ���µ��豸") {
            #pc2����dut����
            flag ="1"
            rs   = @wifi_drb.connect(@dut_ssid, flag, @dut_pwd, @ts_wlan_nicname)
            assert(rs, "PC2��������wifiʧ��".to_gbk)
            wireless_net   = @wifi_drb.ipconfig("all")[@ts_wlan_nicname]
            @wireless_ip   = wireless_net[:ip][0]
            @wireless_mac  = wireless_net[:mac].downcase
            @wireless_name = @wifi_drb.get_host_name
            # sleep @tc_wait_time #�ȴ�ϵͳ��̨ˢ��
            @browser.refresh
            sleep 1
            @browser.refresh
            sleep 1
            @devlist_page = RouterPageObject::DevlistPage.new(@browser)
            dev_size      = @devlist_page.get_dev_size #�����豸��
            assert_equal(2, dev_size, "�������б������豸��Ŀ����ȷ��")
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            p "�豸�б���MAC��ַΪ#{@dut_mac}����Ӧ�������ǣ�#{dev_data}".to_gbk
            dev_ip       = dev_data[:ip]
            dev_name     = dev_data[:dev_name]
            dev_con_type = dev_data[:connect_type]
            assert_equal(@dut_ip, dev_ip, "�������豸�б���MAC��ַΪ#{@dut_mac}���豸ip��Ϣ��ʾ����ȷ��")
            assert_match(dev_name, @dut_name, "�������豸�б���MAC��ַΪ#{@dut_mac}���豸�豸������Ϣ��ʾ����ȷ��")
            assert_match(@dut_con_type, dev_con_type, "�������豸�б���MAC��ַΪ#{@dut_mac}���豸���ӷ�ʽ��Ϣ��ʾ����ȷ��")
            wireless_data = @devlist_page.get_data(dev_size, @wireless_mac)
            p "�豸�б���MAC��ַΪ#{@wireless_mac}����Ӧ�������ǣ�#{wireless_data}".to_gbk
            wireless_ip       = wireless_data[:ip]
            wireless_name     = wireless_data[:dev_name]
            wireless_con_type = wireless_data[:connect_type]
            assert_equal(@wireless_ip, wireless_ip, "�������豸�б���MAC��ַΪ#{@wireless_mac}���豸ip��Ϣ��ʾ����ȷ��")
            assert_match(wireless_name, @wireless_name, "�������豸�б���MAC��ַΪ#{@wireless_mac}���豸�豸������Ϣ��ʾ����ȷ��")
            assert_match(@wireless_con_type, wireless_con_type, "�������豸�б���MAC��ַΪ#{@wireless_mac}���豸���ӷ�ʽ��Ϣ��ʾ����ȷ��")
        }

        # operate("4���޸������ն��豸������Ϊ�������ַ��ģ������ĵ����ƣ����ն���ʾ�б����Ƿ���������ʾ") {
        #
        # }


    end

    def clearup
        operate("1.�Ͽ�wifi����") {
            @wifi_drb.netsh_disc_all #�Ͽ�wifi����
        }
        operate("2.�ָ�Ĭ��ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end

}
