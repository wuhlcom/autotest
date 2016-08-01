#
# description:
# author:
# date:
# modify:
#
testcase {
    attr = {"id" => "ZLBF_F_MACFilter_2.7", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
        @tc_mac_error = "MAC��ַ��ʽ����"
        @tc_mac_desc  = "test"
    end

    def process

        operate("1��AP������·�ɷ�ʽ�£��򿪰�ȫ���÷���ǽ����MAC���˿�����MAC��������ҳ��,������������ŵ�MAC") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "on", "off")
            @options_page.macfilter_click
            @options_page.mac_add_item_element.click #������Ŀ
        }

        operate("2��������MAC������Ŀ,�ֱ�����MACΪ\"b0:aa:00:00:00:01\",�������Ϊtest,����") {
            tc_mac1 = "b0:aa:00:00:00:01"
            puts "���MAC #{tc_mac1}Ϊ��������".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #���룬״̬Ĭ��Ϊ��Ч
            @options_page.mac_save #����mac��������
            sleep @tc_wait_time
            mac_addr = @options_page.mac_filter_table_element.element.trs[1][0].text
            assert_equal(tc_mac1.upcase, mac_addr, "MAC��ַδת���ɴ�д��ʽ")
            @options_page.mac_add_item_element.click #������Ŀ
        }

        operate("3��������MAC������Ŀ,�ֱ�����MACΪ\"00:cD:00:00:00:01\",�������Ϊtest,����") {
            tc_mac2 = "00:cD:00:00:00:01"
            puts "���MAC #{tc_mac2}Ϊ��������".encode("GBK")
            @options_page.mac_filter_input(tc_mac2, @tc_mac_desc) #���룬״̬Ĭ��Ϊ��Ч
            @options_page.mac_save #����mac��������
            sleep @tc_wait_time
            mac_addr = @options_page.mac_filter_table_element.element.trs[2][0].text
            assert_equal(tc_mac2.upcase, mac_addr, "MAC��ַδת���ɴ�д��ʽ")
            @options_page.mac_add_item_element.click #������Ŀ
        }

        operate("4��������MAC������Ŀ,�ֱ�����MACΪ\"00:02:Cc:00:00:Fb\",�������Ϊtest,����") {
            tc_mac3 = "00:02:Cc:00:00:Fb"
            puts "���MAC #{tc_mac3}Ϊ��������".encode("GBK")
            @options_page.mac_filter_input(tc_mac3, @tc_mac_desc) #���룬״̬Ĭ��Ϊ��Ч
            @options_page.mac_save #����mac��������
            sleep @tc_wait_time
            mac_addr = @options_page.mac_filter_table_element.element.trs[3][0].text
            assert_equal(tc_mac3.upcase, mac_addr, "MAC��ַδת���ɴ�д��ʽ")
            @options_page.mac_add_item_element.click #������Ŀ
        }
    end

    def clearup

        operate("1���ָ�����ǽĬ�����ã��ر��ܿ��ز�ɾ�����й���") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.macfilter_close_sw_del_all(@browser.url)
        }

    end

}
