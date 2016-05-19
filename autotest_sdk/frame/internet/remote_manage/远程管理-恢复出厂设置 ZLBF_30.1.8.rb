#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_30.1.8", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time             = 5
        @tc_net_time              = 50
        @tc_submit_time           = 60
        @tc_reset_to_default_time = 120
        @dut_ip                   = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
        @tc_dumpcap_server        = DRbObject.new_with_uri(@ts_drb_server2)
    end

    def process

        operate("1��PC1��¼DUTҳ���޸ĵ�ǰ����(WAN ����(�ֱ�����ΪPPPOE��PPTP��L2TP��DHCP)�����ߡ�����ǽ��DDNS��UPNP��QOS���鲥����)��") {
            #�޸�Ϊpppoe���뷽ʽ
            @browser.span(id: @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            #����wan���ӷ�ʽΪ��������
            rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(id: @ts_tag_wired_mode_span).click #��������
            end
            @wan_iframe.radio(id: @ts_tag_wired_pppoe).wait_until_present(@tc_wait_time)
            @wan_iframe.radio(id: @ts_tag_wired_pppoe).click #pppoe����
            @wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            @wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            @wan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_submit_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #��wifi���أ�Ĭ��Ϊ�ر�
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            if @lan_iframe.button(id: @ts_wifi_switch).class_name == "off"
                @lan_iframe.button(id: @ts_wifi_switch).click
                @lan_iframe.button(id: @ts_tag_sbm).click
                sleep @tc_submit_time
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #�򿪷���ǽ���غ�ip���˿��أ�������һ������
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
            filter_flag   = false
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "off"
                fire_wall_btn.click
                filter_flag = true
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "off"
                ip_btn.click
                filter_flag = true
            end
            if filter_flag
                @option_iframe.button(id: @ts_tag_security_save).click #����
            end
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click
            @option_iframe.text_field(id: @ts_ip_src).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click
            #��dns����
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time) #����Ӧ������
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_ddns).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_ddns).click
            @option_iframe.button(id: @ts_tag_ddns_sw).wait_until_present(@tc_wait_time)
            if @option_iframe.button(id: @ts_tag_ddns_sw).class_name == "off"
                @option_iframe.button(id: @ts_tag_ddns_sw).click
                @option_iframe.text_field(id: @ts_tag_ddns_host).set(@dut_ip)
                @option_iframe.text_field(id: @ts_tag_ddns_user).set("admin")
                @option_iframe.text_field(id: @ts_tag_ddns_pwd).set("admin")
                @option_iframe.button(id: @ts_tag_ddns_save).click
                sleep @tc_wait_time
            end
        }

        operate("2��PC2Զ�̵�¼DUTҳ�棬�ָ�����Ĭ�����ã�") {
            #���������ʿ���
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click
            if @option_iframe.span(class_name: @ts_remote_sw).button.class_name == "off"
                @option_iframe.span(class_name: @ts_remote_sw).button.click
                @option_iframe.button(id: @ts_remote_save_btn).click
                sleep @tc_wait_time
            end
            port = @option_iframe.text_field(id: @ts_remote_port_id).value
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @tag_status).click #��״̬
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            wan_ip         = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
            network_url    = wan_ip + ":" + port
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #������¼��ָ���������
            network_status = @tc_dumpcap_server.reset_to_defaults(network_url, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_tag_reset_factory, @ts_tag_reboot_confirm, @ts_tag_rebooting, @ts_tag_reseting_text)
            assert(network_status, "������¼�󲢻ָ��������ù����г����쳣")
            sleep @tc_reset_to_default_time

            p "�鿴�����Ƿ�ָ���������".to_gbk
            #�鿴������������
            login_default(@browser) #���µ�¼
            @browser.span(id: @tag_status).click #��״̬
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, "DHCP", "Զ�ָ̻��������ú���������״̬δ�ָ���Ĭ��DHCP����")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #�鿴wifi����״̬
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert_equal(@lan_iframe.button(id: @ts_wifi_switch).class_name, "on", "Զ�ָ̻��������ú�wifi����δ�ָ���Ĭ�ϴ�״̬")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #�鿴����ǽ��������
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
            assert_equal(fire_wall_btn.class_name, "off", "Զ�ָ̻��������ú󣬷���ǽ����δ�ָ���Ĭ�ϵĹر�״̬")
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            assert_equal(ip_btn.class_name, "off", "Զ�ָ̻��������ú�IP���˿���δ�ָ���Ĭ�Ϲر�״̬")
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 1, "Զ�ָ̻��������ú�IP���˹���δ���")
            #�鿴ddns����
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time) #����Ӧ������
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_ddns).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_ddns).click
            @option_iframe.button(id: @ts_tag_ddns_sw).wait_until_present(@tc_wait_time)
            assert_equal(@option_iframe.button(id: @ts_tag_ddns_sw).class_name, "off", "Զ�ָ̻��������ú�ddns����δ�ָ���Ĭ�Ϲر�״̬")
            assert_equal(@option_iframe.text_field(id: @ts_tag_ddns_host).value, "", "Զ�ָ̻��������ú�, ddns��������Ϊ��")
            assert_equal(@option_iframe.text_field(id: @ts_tag_ddns_user).value, "", "Զ�ָ̻��������ú�, ddns�û�����Ϊ��")
            assert_equal(@option_iframe.text_field(id: @ts_tag_ddns_pwd).value, "", "Զ�ָ̻��������ú�, ddns���벻Ϊ��")
            #�鿴Զ�̷�������
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click
            assert_equal(@option_iframe.span(class_name: @ts_remote_sw).button.class_name, "off", "Զ�ָ̻��������ú�, Զ�̷��ʿ���δ�ָ���Ĭ�Ϲر�״̬")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

    end

    def clearup
        operate("�ָ�Ĭ��DHCP����") {
            if !@wan_iframe.exists? && @browser.span(:id => @ts_tag_netset).exists?
                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            end

            flag = false
            #����wan���ӷ�ʽΪ��������
            rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
            unless rs1.class_name =~/ #{@tc_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
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
                puts "Waiting for net reset..."
                sleep @tc_net_time
            end
        }
        operate("�ر�wifi����") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            if @lan_iframe.button(id: @ts_wifi_switch).class_name == "on"
                @lan_iframe.button(id: @ts_wifi_switch).click
                @lan_iframe.button(id: @ts_tag_sbm).click
                sleep @tc_submit_time
            end
        }
        operate("�رշ���ǽ���ز�ɾ������") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            filter_flag   = false
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
                filter_flag = true
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "on"
                ip_btn.click
                filter_flag = true
            end
            if filter_flag
                @option_iframe.button(id: @ts_tag_security_save).click #����
            end
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses > 1 #�������Ŀ��ɾ��
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #ɾ��������Ŀ
                sleep @tc_wait_time
            end
        }
        operate("�ر�ddns����") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time) #����Ӧ������
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_ddns).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_ddns).click
            @option_iframe.button(id: @ts_tag_ddns_sw).wait_until_present(@tc_wait_time)
            if @option_iframe.button(id: @ts_tag_ddns_sw).class_name == "on"
                @option_iframe.button(id: @ts_tag_ddns_sw).click
                @option_iframe.text_field(id: @ts_tag_ddns_host).clear
                @option_iframe.text_field(id: @ts_tag_ddns_user).clear
                @option_iframe.text_field(id: @ts_tag_ddns_pwd).clear
                @option_iframe.button(id: @ts_tag_ddns_save).click
                sleep @tc_wait_time
            end
        }
        operate("�ر��������ʿ���") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click
            if @option_iframe.span(class_name: @ts_remote_sw).button.class_name == "on"
                @option_iframe.span(class_name: @ts_remote_sw).button.click
                @option_iframe.button(id: @ts_remote_save_btn).click
                sleep @tc_wait_time
            end
        }
    end

}
