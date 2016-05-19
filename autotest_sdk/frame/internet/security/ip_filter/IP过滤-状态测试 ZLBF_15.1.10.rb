#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.10", "level" => "P2", "auto" => "n"}

    def prepare
        @dut_ip                 = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
        @tc_wait_time           = 5
        @tc_rebooting_wait_time = 120
        @lose_efficacy          = "ʧЧ"
    end

    def process

        operate("1��DUT�Ľ�������ѡ��ΪDHCP���������ã��ٽ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ����棻") {
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

        operate("2������IP���˹��ܣ�����ԴIPΪ192.168.100.100���˿�Ϊ1-65535��Э��ΪTCP/UDP������״̬Ϊ��Ч���������ã�PC1�ܷ��������") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
            @option_iframe.text_field(id: @ts_ip_src).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click #����
            @option_iframe.table(id: @ts_iptable).wait_until_present(@tc_wait_time)
            ip_clauses     = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses == 1
                assert(false, "��������Ŀʧ��")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            response = send_http_request(@ts_web)
            if response == true
                sleep @tc_wait_time
                response = send_http_request(@ts_web)
            end
            assert(!response, "���Է���#{@ts_web}".to_gbk)
        }

        operate("3������AP��PC1�ܷ��������") {
            @browser.span(id: @ts_tag_reboot).parent.click #���������ť
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "·���������У����Ժ�...".to_gbk
            sleep @tc_rebooting_wait_time
            #���µ�¼
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "�����ɹ����ٴε�¼��".to_gbk
                login_no_default_ip(@browser)
            else
                assert(login_ui, "����ʧ�ܣ�")
            end
            response = send_http_request(@ts_web)
            if response == true
                sleep @tc_wait_time
                response = send_http_request(@ts_web)
            end
            assert(!response, "���Է���#{@ts_web}".to_gbk)
        }

        operate("4���༭����2��ӵĹ��򣬰�״̬�޸�ΪʧЧ�����棬PC1�ܷ��������") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            @option_iframe.link(class_name: @ts_tag_edit).wait_until_present(@tc_wait_time)
            @option_iframe.link(class_name: @ts_tag_edit).click #�༭
            status_select = @option_iframe.select_list(id: @ts_tag_vir_status)
            status_select.select(/#{@lose_efficacy}/)
            @option_iframe.button(id: @ts_tag_save_filter1).click #����
            @option_iframe.table(id: @ts_iptable).wait_until_present(@tc_wait_time)
            status = @option_iframe.table(id: @ts_iptable).trs[1][6].text
            assert_equal(status, @lose_efficacy, "�༭���ɹ���")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            response = send_http_request(@ts_web)
            assert(response, "�����Է���#{@ts_web}".to_gbk)
        }

        operate("5������AP,PC1�ܷ��������") {
            @browser.span(id: @ts_tag_reboot).parent.click #���������ť
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "·���������У����Ժ�...".to_gbk
            sleep @tc_rebooting_wait_time
            #���µ�¼
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "�����ɹ����ٴε�¼��".to_gbk
                login_no_default_ip(@browser)
            else
                assert(login_ui, "����ʧ�ܣ�")
            end

            response = send_http_request(@ts_web)
            assert(response, "�����Է���#{@ts_web}".to_gbk)
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
