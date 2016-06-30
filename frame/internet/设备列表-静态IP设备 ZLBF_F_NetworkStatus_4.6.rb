#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.28", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time = 180 #·������̨û������ˢ��һ���豸�б�
    end

    def process

        operate("1������AP�½�����PC,�豸PCΪ��̬IP��ַ�󣬲鿴�����豸��Ϣ�Ƿ񻹰�����PC") {
            dut_net   = ipconfig("all")[@ts_nicname]
            @dut_mac  = dut_net[:mac].downcase
            @dut_ip   = dut_net[:ip][0]
            @dut_gw   = dut_net[:gateway][0]
            @dut_mask = dut_net[:mask]
            @dut_ip =~ /(\d+\.\d+\.\d+\.)(\d+)/
            if $2.to_i - 10 < 2
                @same_segment_ip = $1 + ($2.to_i+10).to_s
            else
                @same_segment_ip = $1 + ($2.to_i-10).to_s
            end
            @static_ip     = @dut_ip

            p "���þ�̬IP��ַ��#{@static_ip}".to_gbk
            args           = {}
            args[:ip]      = @static_ip
            args[:mask]    = @dut_mask
            args[:gateway] = @dut_gw
            args[:nicname] = @ts_nicname
            args[:source]  = "static"
            static_ip      = netsh_if_ip_setip(args)
            assert(static_ip, "PC1���ù̶���̬IPʧ�ܣ�")
            sleep @tc_wait_time #�ȴ�ϵͳ��̨ˢ��
            @devlist_page = RouterPageObject::DevlistPage.new(@browser)
            5.times do
                break if @devlist_page.dev_list_element.parent.em_element.exists? && !(@devlist_page.dev_list_element.parent.em_element.text.nil?)
                @devlist_page.refresh
                sleep 1
            end
            dev_size      = @devlist_page.get_dev_size #�����豸��
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            p "�豸�б���MAC��ַΪ#{@dut_mac}����Ӧ�������ǣ�#{dev_data}".to_gbk
            dev_ip   = dev_data[:ip]
            assert_equal(@static_ip, dev_ip, "�豸PCΪ��̬IP��ַ��,�������豸�б����豸ip��Ϣ��ʾ����ȷ��")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2����PC�ľ�̬��ַ�޸�Ϊͬ����������ַ���鿴�����豸��Ϣ�Ƿ񻹰�����PC") {
            p "����PC��ַΪͬ��������IP��ַ��#{@same_segment_ip}".to_gbk
            args            = {}
            args[:ip]       = @same_segment_ip
            args[:mask]     = @dut_mask
            args[:gateway]  = @dut_gw
            args[:nicname]  = @ts_nicname
            args[:source]   = "static"
            same_segment_ip = netsh_if_ip_setip(args)
            assert(same_segment_ip, "PC1����ͬ��������IPʧ�ܣ�")
            sleep @tc_wait_time #�ȴ�ϵͳ��̨ˢ��
            5.times do
                break if @devlist_page.dev_list_element.parent.em_element.exists? && !(@devlist_page.dev_list_element.parent.em_element.text.nil?)
                @devlist_page.refresh
                sleep 1
            end
            dev_size = @devlist_page.get_dev_size #�����豸��
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            p "�豸�б���MAC��ַΪ#{@dut_mac}����Ӧ�������ǣ�#{dev_data}".to_gbk
            dev_ip   = dev_data[:ip]
            assert_equal(@same_segment_ip, dev_ip, "�豸PC����Ϊͬ��������IP��ַ��,�������豸�б����豸ip��Ϣ��ʾ����ȷ��")
        }
    end

    def clearup
        operate("�ָ�Ĭ������") {
            args           = {}
            args[:nicname] = @ts_nicname
            args[:source]  = "dhcp"
            dhcp_ip        = netsh_if_ip_setip(args)
            netsh_if_ip_setip(args) unless dhcp_ip #����ָ�ʧ���ٻָ�һ��
        }
    end

}
