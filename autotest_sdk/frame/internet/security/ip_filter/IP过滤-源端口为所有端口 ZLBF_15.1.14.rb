#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.14", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time           = 3
        @tc_rebooting_wait_time = 120
        @tc_src_port            = 1
        @tc_src_port_end        = 65535
        @dut_ip                 = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
    end

    def process

        operate("1��DUT�Ľ�������ѡ��ΪDHCP���������á��ٽ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ����棻") {
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_netset).click #����
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            flag        = false
            #����wan���ӷ�ʽΪ��������
            rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(id: @ts_tag_wired_mode_span).click #��������
                flag = true
            end
            #��ѯ�Ƿ�ΪΪdhcpģʽ
            dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
            dhcp_radio_state = dhcp_radio.checked?
            #����WIRE WANΪDHCPģʽ
            unless dhcp_radio_state
                dhcp_radio.click
                flag = true
            end
            if flag
                @wan_iframe.button(:id, @ts_tag_sbm).click
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "off"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "off"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #����
        }

        operate("2�����һ�����˹�����������ΪĬ�ϣ�Դ�˿�����Ϊ1-65535��Э��ΪTCP/UDP���������á�") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_src_port)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_src_port_end)
            @option_iframe.button(id: @ts_tag_save_filter).click #����
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert(false, "��������Ŀʧ��") if ip_clauses == 1
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("3����PC1�������ݰ����������磺�������ݰ���������IPTEST��������Ŀ�Ķ˿�Ϊ1��TCP��UDP�����ݰ������ݰ���IP��ַ�����Ϣ�������ã���LAN��WAN�������ݰ���PC2���Ƿ���ץ��PC1�Ϸ��������ݰ���") {
            begin
                rs = HtmlTag::TestUdpClient.new(@dut_ip, 1, "192.168.0.57", 15801)
            rescue => ex
                p ex.message.to_s
                p "��������ʱ�����쳣".to_gbk
                assert(false,"��������ʱ�����쳣")
            end
            assert_equal("", rs.udp_message, "�˿ڹ���ʧ�ܣ�")
        }

        operate("4���༭����2�����ݰ�����������Դ�˿ڸ���Ϊ65535��80��21��1024��60000�����ݰ����鿴���Խ����") {
            begin
                rs = HtmlTag::TestUdpClient.new(@dut_ip, 65535, "192.168.0.57", 15801)
            rescue => ex
                p ex.message.to_s
                p "��������ʱ�����쳣".to_gbk
                assert(false,"��������ʱ�����쳣")
            end
            assert_equal("", rs.udp_message, "�˿ڹ���ʧ�ܣ�")

            begin
                rs = HtmlTag::TestUdpClient.new(@dut_ip, 1024, @ts_tcp_server, 15801)
            rescue => ex
                p ex.message.to_s
                p "��������ʱ�����쳣".to_gbk
                assert(false,"��������ʱ�����쳣")
            end
            assert_equal("", rs.udp_message, "�˿ڹ���ʧ�ܣ�")
        }

        operate("5������DUT��ִ�в���3���鿴���Խ����") {
            @browser.span(id: @ts_tag_reboot).parent.click #���������ť
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "·���������У����Ժ�...".to_gbk
            sleep @tc_rebooting_wait_time
            #���µ�¼
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "�����ɹ����ٴε�¼��".to_gbk
                login_no_default_ip(@browser)
                sleep @tc_wait_time #�ȴ�������Ч
            else
                assert(login_ui, "����ʧ�ܣ�")
            end

            begin
                rs = HtmlTag::TestUdpClient.new(@dut_ip, 1, "192.168.0.57", 15801)
            rescue => ex
                p ex.message.to_s
                p "��������ʱ�����쳣".to_gbk
                assert(false,"��������ʱ�����쳣")
            end
            assert_equal("", rs.udp_message, "�˿ڹ���ʧ�ܣ�")
        }


    end

    def clearup
        operate("1���رշ���ǽ�ܿ��غ�IP���˿���") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "on"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #����
        }

        operate("2��ɾ��������Ŀ") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #����IP��������
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses > 1 #�������Ŀ��ɾ��
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #ɾ��������Ŀ
            end
        }
    end

}
