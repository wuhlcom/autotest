#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_17.1.3", "level" => "P4", "auto" => "n"}

    def prepare

        @tc_normal_port  = 4002
        @tc_pub_srvport  = 9000
        @tc_port_err_tip = "�˿ڷ�Χ1-65535"
        DRb.start_service
        @tc_wan_drb     = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_remote_time = 10
    end

    def process

        operate("1���ڡ��˿ڡ�����ȫ-11��0��65536���Ƿ���������") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            puts "���ý��뷽ʽΪDHCP".to_gbk
            @wan_page.set_dhcp(@browser, @browser.url)

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            ip_info       = ipconfig
            @tc_srv_ip    = ip_info[@ts_nicname][:ip][0]
            @options_page.open_vps_step(@browser.url)
            @options_page.add_vps
            p "�������������IP��ַΪ:#{@tc_srv_ip}".encode("GBK")
            port1 = 0
            p "���빫���˿�Ϊ#{port1}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port1, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")
            p "����˽�ж˿�Ϊ#{port1}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port1, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")

            port2 = 65536
            p "���빫���˿�Ϊ#{port2}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port2, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")
            p "����˽�ж˿�Ϊ#{port2}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port2, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")
        }

        operate("2���ڡ��˿ڡ�����A~Z,a~z,~!@#$%^��33�������ַ������ģ��ո�Ϊ�յȣ��Ƿ��������룻") {
            port1 = "a"
            p "���빫���˿�Ϊ#{port1}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port1, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")
            p "����˽�ж˿�Ϊ#{port1}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port1, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")

            port2 = "@@@@"
            p "���빫���˿�Ϊ#{port2}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port2, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")
            p "����˽�ж˿�Ϊ#{port2}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port2, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")

            port3 = ""
            p "�����˿�Ϊ��".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port3, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")
            p "˽�ж˿�Ϊ��".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port3, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")

            port4 = "����"
            p "���빫���˿�Ϊ#{port4}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port4, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")
            p "����˽�ж˿�Ϊ#{port4}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port4, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "δ��ʾ����˿ڴ���")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "��ʾ��Ϣ����")
        }

        operate("3������Զ�����ӵĶ˿ڣ��Ƿ��������롣����������룬��Ҫ��֤Զ�����Ӻ���������������ȼ�") {
            p "���빫���˿�Ϊ#{@tc_pub_srvport}".encode("GBK")
            p "����˽�ж˿�Ϊ#{@tc_normal_port}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_pub_srvport, @tc_normal_port, 1)
            @options_page.save_vps
            sleep @tc_remote_time
            #�鿴Wan ip��ַ
            @sys_page = RouterPageObject::SystatusPage.new(@browser)
            @sys_page.open_systatus_page(@browser.url)
            @tc_wan_ipaddr = @sys_page.get_wan_ip
            puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{@tc_wan_ipaddr}".to_gbk

            #����tcp_server
            tcp_multi_server(@tc_srv_ip, @tc_normal_port)
            #WAN���û��������������
            rs      = @tc_wan_drb.tcp_client(@tc_wan_ipaddr, @tc_pub_srvport)
            tcp_msg = rs.tcp_message
            puts "=================Message from TCP server==============="
            print tcp_msg
            assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")

            #����Զ�̷���WEB,Զ���������������������Ϊͬһ�˿�
            @options_page.open_web_access_btn(@browser.url) #���������ʿ���
            @options_page.web_access_port_input(@tc_pub_srvport)
            @options_page.save_web_access
            remote_url = "#{@tc_wan_ipaddr}:#{@tc_pub_srvport}"
            puts "Remote Web Login :#{remote_url}"
            rs=@tc_wan_drb.login_router(remote_url, @ts_default_usr, @ts_default_pw)
            assert(rs, "Զ��WEB����ʧ��!")

            #Զ���������������������Ϊͬһ�˿ں��������������ʧ��
            rs      = @tc_wan_drb.tcp_client(@tc_wan_ipaddr, @tc_pub_srvport)
            tcp_msg = rs.tcp_message
            puts "=================Message from TCP server==============="
            print tcp_msg
            refute(rs.tcp_state, "����Զ�̷��ʺ�ͬ�˵����������Ӧ�ò��ܷ���")
        }

    end

    def clearup

        operate("1 ɾ���������������") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.delete_allvps_close_switch_step(@browser.url)
        }
        operate("2 �ر���������WEB����") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.close_web_access(@browser.url)
        }
    end

}
