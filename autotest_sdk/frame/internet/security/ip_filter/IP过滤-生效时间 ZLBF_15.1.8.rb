#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.8", "level" => "P2", "auto" => "n"}

    def prepare
        @dut_ip       = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
        @tc_wait_time = 5
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

        operate("2����IP���ǽ������һ��������Чʱ������Ϊ0000-1200,ԴIPΪ192.168.100.100,��������ΪĬ�ϵġ���ǰʱ��Ϊ����10�㣬PC1�ܷ��������") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
            #��ȡϵͳ��ǰʱ��(Сʱ)
            time_for_hour = Time.now.strftime("%H").to_i
            if (time_for_hour >= 0 && time_for_hour < 12)
                effective_time_start = "0000"
                effective_time_end   = "1200"
            else
                effective_time_start = "1200"
                effective_time_end   = "2359"
            end
            @option_iframe.text_field(id: @ts_ip_start_time).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_ip_start_time).set(effective_time_start)
            @option_iframe.text_field(id: @ts_ip_end_time).set(effective_time_end)
            @option_iframe.text_field(id: @ts_ip_src).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click
            @option_iframe.table(id: @ts_iptable).wait_until_present(@tc_wait_time)
            ip_clauses     = @option_iframe.table(id: @ts_iptable).trs.size
            effective_time = @option_iframe.table(id: @ts_iptable).trs[1][0].text
            time_math      = effective_time_start+"-"+effective_time_end
            if (ip_clauses == 1 && time_math != effective_time)
                assert(false, "��������Ŀʧ��")
            end
            response = send_http_request(@ts_web)
            assert(!response, "���Է���#{@ts_web}".to_gbk)
        }

        operate("3��������Чʱ������Ϊ1200-2300��PC1�ܷ��������") {
            #��ȡϵͳ��ǰʱ��(Сʱ)
            time_for_hour = Time.now.strftime("%H").to_i
            if (time_for_hour >= 0 && time_for_hour < 12)
                effective_time_start = "1200"
                effective_time_end   = "2359"
            else
                effective_time_start = "0000"
                effective_time_end   = "1200"
            end
            @option_iframe.link(class_name: @ts_tag_edit).wait_until_present(@tc_wait_time)
            @option_iframe.link(class_name: @ts_tag_edit).click
            @option_iframe.text_field(id: @ts_ip_start_time1).set(effective_time_start)
            @option_iframe.text_field(id: @ts_ip_end_time1).set(effective_time_end)
            @option_iframe.button(id: @ts_tag_save_filter1).click
            sleep @tc_wait_time
            rs = @option_iframe.table(id: @ts_iptable)
            unless rs.exists? #���ֿհ�ʱ��ˢ��ҳ��
                @browser.link(id: @ts_tag_options).click
                @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
                @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
                @option_iframe.link(id: @ts_tag_security).click
                @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
                @option_iframe.link(id: @ts_ip_set).click #IP����
                sleep @tc_wait_time
            end
            ip_clauses     = @option_iframe.table(id: @ts_iptable).trs.size
            effective_time = @option_iframe.table(id: @ts_iptable).trs[1][0].text
            time_math      = effective_time_start+"-"+effective_time_end
            if (ip_clauses == 1 || time_math != effective_time)
                assert(false, "��������Ŀʧ��")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            response = send_http_request(@ts_web)
            assert(response, "�����Է���#{@ts_web}".to_gbk)
        }


    end

    def clearup
        operate("1���رշ���ǽ�ܿ��غ�IP���˿���") {
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
