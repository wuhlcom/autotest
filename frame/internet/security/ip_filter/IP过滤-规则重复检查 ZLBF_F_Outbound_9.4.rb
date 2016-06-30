#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#

testcase {
    attr = {"id" => "ZLBF_15.1.21", "level" => "P3", "auto" => "n"}

    def prepare
        @s_ip            = "192.168.100.100"
        @s_ip_end        = "192.168.100.103"
        @tc_wait_time    = 5
        @tc_s_port1      = "1111"
        @tc_s_port2      = "2222"
        @tc_s_port3      = "3333"
        @tc_s_port3_end  = "3344"
        @tc_protocol_tcp = "TCP"
        @tc_protocol_udp = "UDP"
    end

    def process

        operate("1������IP��������ҳ�棻") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #�򿪷���ǽ��IP�ܿ���
            @options_page.ipfilter_click
            @options_page.ip_add_item_element.click #������Ŀ
        }

        operate("2�����һ��Э��ѡ��TCP����ʼ������˿�����1111������IP����Ϊ192.168.100.100���Ƿ���Ա��棻") {
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port1, @tc_s_port1)
            @options_page.ip_protocol_type_element.select(@tc_protocol_tcp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "��ӹ���ʧ��~")
        }

        operate("3�����һ��Э��ѡ��TCP����ʼ������˿�����1111������IP����Ϊ192.168.100.100���Ƿ���Ա��棻") {
            @options_page.ip_add_item_element.click #������Ŀ
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port1, @tc_s_port1)
            @options_page.ip_protocol_type_element.select(@tc_protocol_tcp)
            @options_page.ip_save
            sleep 1
            ip_hint = @options_page.ip_filter_err_msg_element
            assert(ip_hint.exists?, "�����ͬ����ʱû����ʾ��")
            @options_page.ip_back #����
        }

        operate("4�����һ��Э��ѡ��UDP����ʼ������˿�����2222������IP����Ϊ192.168.100.100���Ƿ���Ա��棻") {
            p "����¹���ǰɾ�����й���".to_gbk
            @options_page.ip_all_del_element.click
            sleep @tc_wait_time
            @options_page.ip_add_item_element.click #������Ŀ
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port2, @tc_s_port2)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "��ӹ���ʧ��~")
        }

        operate("5�����һ��Э��ѡ��UDP����ʼ������˿�����2222������IP����Ϊ192.168.100.100���Ƿ���Ա��棻") {
            @options_page.ip_add_item_element.click #������Ŀ
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port2, @tc_s_port2)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_save
            sleep 1
            ip_hint = @options_page.ip_filter_err_msg_element
            assert(ip_hint.exists?, "�����ͬ����ʱû����ʾ��")
            @options_page.ip_back #����
        }

        operate("6�����һ��Э��ѡ��TCP/UDP����ʼ������˿�����3333~3344������IP����Ϊ192.168.100.100~105���Ƿ���Ա��棻") {
            p "����¹���ǰɾ�����й���".to_gbk
            @options_page.ip_all_del_element.click
            sleep @tc_wait_time
            @options_page.ip_add_item_element.click #������Ŀ
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip_end)
            @options_page.ip_filter_src_port_input(@tc_s_port3, @tc_s_port3_end)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "��ӹ���ʧ��~")
        }

        operate("7�����һ��Э��ѡ��TCP/UDP����ʼ������˿�����3333~3344������IP����Ϊ192.168.100.100~105���Ƿ���Ա��棻") {
            @options_page.ip_add_item_element.click #������Ŀ
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip_end)
            @options_page.ip_filter_src_port_input(@tc_s_port3, @tc_s_port3_end)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_save
            sleep 1
            ip_hint = @options_page.ip_filter_err_msg_element
            assert(ip_hint.exists?, "�����ͬ����ʱû����ʾ��")
            @options_page.ip_back #����
        }

        operate("8�����һ��Э��ѡ��TCP����ʼ������˿�����3333������IP����Ϊ192.168.100.100���Ƿ���Ա��棻") {
            p "����¹���ǰɾ�����й���".to_gbk
            @options_page.ip_all_del_element.click
            sleep @tc_wait_time
            @options_page.ip_add_item_element.click #������Ŀ
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port3, @tc_s_port3)
            @options_page.ip_protocol_type_element.select(@tc_protocol_tcp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "��ӹ���ʧ��~")
        }

        operate("9�����һ��Э��ѡ��UDP����ʼ������˿�����3333������IP����Ϊ192.168.100.100���Ƿ���Ա��棻") {
            @options_page.ip_add_item_element.click #������Ŀ
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port3, @tc_s_port3)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(3, filter_item, "��ӹ���ʧ��~")
        }

        operate("10���༭����9����ӵĹ����޸�Э��ΪTCP���Ƿ���Ա��档") {
            @options_page.ip_filter_table_element.element.trs[2][7].link(class_name: @ts_tag_edit).image.click #�༭�ڶ�������
            @options_page.ip_protocol_type1_element.select(@tc_protocol_tcp)
            @options_page.ip_save1
            sleep 1
            ip_hint = @options_page.ip_filter_err_msg_element
            assert(ip_hint.exists?, "�����ͬ����ʱû����ʾ��")
        }

        operate("���飺��IP��ַ�ص����˿��ص����Բ�����⡣") {

        }


    end

    def clearup
        operate("1 �رշ���ǽ�ܿ��غ�IP���˿��ز�ɾ����������") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
