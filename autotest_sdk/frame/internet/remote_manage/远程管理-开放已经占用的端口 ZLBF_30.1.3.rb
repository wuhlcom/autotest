#
# description:
# 1.
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_30.1.3", "level" => "P2", "auto" => "n"}

    def prepare
        @dut_ip                     = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
        @tc_dumpcap_server          = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_wait_time               = 3
        @tc_virtual_server_set_time = 5
        @tc_remote_wait_time        = 10
        @tc_private_port            = "80"
    end

    def process

        operate("1��DUT����������WAN��������ΪDHCP���������ȡ���ĵ�ַΪ10.10.0.100����") {
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

            #��ȡwan��ŶIP
            @browser.span(id: @tag_status).wait_until_present(@tc_wait_time)
            @browser.span(id: @tag_status).click
            @state_iframe = @browser.iframe(src: @tag_status_iframe_src)
            assert(@state_iframe.exists?, "��״̬����ʧ�ܣ�")
            @wan_ip = @state_iframe.b(id: @tag_wan_ip).parent.text.slice(/IP\u5730\u5740\n(\d+\.\d+\.\d+\.\d+)/i, 1)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2������Զ�̷��ʹ����ܣ�����Ȩ������Ϊ�κ��ˣ��˿�ΪĬ��ֵ") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_op_system).click #ϵͳ����
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click #Զ�̹���
            remote_sw = @option_iframe.span(class_name: @ts_remote_sw)
            if remote_sw.button.class_name == "off"
                remote_sw.button.click
            end
            @option_iframe.button(id: @ts_remote_save_btn).click
            sleep @tc_remote_wait_time
            @remote_default_port = @option_iframe.text_field(id: @ts_remote_port_id, name: @ts_remote_port_name).value
            assert(@remote_default_port, "Ĭ�϶˿�ֵ�쳣��")
        }

        operate("3��PC2ͨ��WAN��IP��ַ+���õ�Զ�̷��ʶ˿ں��Ƿ��ܷ��ʵ�DUT��WEB����ҳ�棻") {
            #����http����
            http_server(@dut_ip)
            #����http����
            remote_html = @tc_dumpcap_server.http_client(@wan_ip, "/", @remote_default_port)
            assert(remote_html.include?("html"), "����Զ�̷��ʶ˿ں����������ܷ��ʹ���ҳ��!")
        }

        operate("4������������������ܣ���ӹ���ת���˿�����Ϊ2000-3000���������ã�") {
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_virtualsrv).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_virtualsrv).click
            virtual_server_sw = @option_iframe.button(id: @ts_tag_virtualsrv_sw)
            if virtual_server_sw.class_name == "off"
                virtual_server_sw.click
            end
            @option_iframe.button(id: @ts_tag_addvir).click
            @option_iframe.text_field(name: @ts_tag_virip1).set(@dut_ip)
            @option_iframe.text_field(name: @ts_tag_virpub_port1).set(@remote_default_port)
            @option_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_private_port)
            @option_iframe.button(id: @ts_tag_save_btn).click
            sleep @tc_virtual_server_set_time

            remote_html = @tc_dumpcap_server.http_client(@wan_ip, "/", @remote_default_port)
            assert(remote_html.include?("html"), "����Զ�̷��ʶ˿ں�����������󣬷������ȼ�����Զ�̷��ʶ˿����ȼ�Ӧ�ô�������������˿�")
        }

        operate("5���޸�Զ�̷��ʹ���˿�Ϊ2000-3000֮�������˿ڣ��Ƿ������óɹ���") {
            @option_iframe.link(id: @ts_tag_op_system).click #ϵͳ����
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click #Զ�̹���
            remote_sw = @option_iframe.span(class_name: @ts_remote_sw)
            if remote_sw.button.class_name == "on"
                remote_sw.button.click
            end
            @option_iframe.button(id: @ts_remote_save_btn).click
            sleep @tc_remote_wait_time

            remote_html = @tc_dumpcap_server.http_client(@wan_ip, "/", @remote_default_port)
            assert(remote_html.include?("succeed"), "�ر�Զ�̷��ʶ˿�֮������������˿������쳣")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }



    end

    def clearup

        operate("1,�ر�Զ�̷��ʹ���"){
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_op_system).click #ϵͳ����
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click #Զ�̹���
            remote_sw = @option_iframe.span(class_name: @ts_remote_sw)
            if remote_sw.button.class_name == "on"
                remote_sw.button.click
            end
            @option_iframe.button(id: @ts_remote_save_btn).click
            sleep @tc_remote_wait_time
        }

        operate("2,ɾ���������������"){
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_virtualsrv).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_virtualsrv).click
            virtual_server_sw = @option_iframe.button(id: @ts_tag_virtualsrv_sw)
            if virtual_server_sw.class_name == "on"
                virtual_server_sw.click
            end
            @option_iframe.button(id: @ts_tag_delvir).click
            sleep @tc_wait_time
            @option_iframe.button(id: @ts_tag_save_btn).click
            sleep @tc_virtual_server_set_time
        }
    end

}
