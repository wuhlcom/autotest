#
# description:
# ����Ӧ ��֤��ʽ�ͼ�������0-9��A-F�Ϳ��ԣ�������֤MAC��ַ���
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_28.1.7", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_mac_error = "MAC��ַ��ʽ����"
        @tc_mac_desc  = "test"
    end

    def process

        operate("1��AP������·�ɷ�ʽ�£�����MAC��ַ����~!@#$%^&*()_+{}|:\"<>?�ȼ�����33�������ַ�,�鿴�Ƿ��������뱣�棻") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "on", "off")
            @options_page.macfilter_click
            @options_page.mac_add_item_element.click #������Ŀ
        }

        operate("2������MAC��ַ��00:00:00:00:00:00���鿴�Ƿ��������뱣�棻") {
            tc_mac1 = "01:00:5e:00:00:01"
            puts "���MAC #{tc_mac1}Ϊ��������".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #���룬״̬Ĭ��Ϊ��Ч
            @options_page.mac_save #����mac��������
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "δ��ʾMAC��ַ��ʽ����")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "��ʾ���ݴ���")

            tc_mac1 = "03:00:5e:00:00:01"
            puts "���MAC #{tc_mac1}Ϊ��������".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #���룬״̬Ĭ��Ϊ��Ч
            @options_page.mac_save #����mac��������
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "δ��ʾMAC��ַ��ʽ����")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "��ʾ���ݴ���")

            tc_mac1 = "07:00:5e:00:00:01"
            puts "���MAC #{tc_mac1}Ϊ��������".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #���룬״̬Ĭ��Ϊ��Ч
            @options_page.mac_save #����mac��������
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "δ��ʾMAC��ַ��ʽ����")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "��ʾ���ݴ���")

            tc_mac1 = "0a:00:5e:00:00:01"
            puts "���MAC #{tc_mac1}Ϊ��������".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #���룬״̬Ĭ��Ϊ��Ч
            @options_page.mac_save #����mac��������
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "δ��ʾMAC��ַ��ʽ����")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "��ʾ���ݴ���")

            tc_mac1 = "0f:00:5e:00:00:01"
            puts "���MAC #{tc_mac1}Ϊ��������".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #���룬״̬Ĭ��Ϊ��Ч
            @options_page.mac_save #����mac��������
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "δ��ʾMAC��ַ��ʽ����")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "��ʾ���ݴ���")
        }

    end

    def clearup

        operate("1���ָ�����ǽĬ�����ã��ر��ܿ��ز�ɾ�����й���") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.macfilter_close_sw_del_all(@browser.url)
        }

    end

}
