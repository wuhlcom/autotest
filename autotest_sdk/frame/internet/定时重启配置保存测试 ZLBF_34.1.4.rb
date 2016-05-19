#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_34.1.4", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time      = 3
        @tc_rebot_net      = 30
        @tc_net_wait_time  = 60
        @tc_ping_num       = 100
        @tc_strategy       = "һ��"
        @tc_strategy_value = "1"
    end

    def process
        operate("0���ֱ��WAN��LAN��WIFI������ǽ��QOS����Ӧ�����ã���¼������Ϣ��") {
            p "����WAN��ΪPPPOE����".to_gbk
            @browser.span(id: @ts_tag_netset).click
            wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(wan_iframe.exists?, "�������豸ҳ��ʧ��")
            wan_iframe.link(id: @ts_tag_wired_mode_link).wait_until_present(@tc_wait_time)
            wan_iframe.link(id: @ts_tag_wired_mode_link).click
            wan_iframe.radio(id: @ts_tag_wired_pppoe).click
            wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            wan_iframe.button(id: @ts_tag_sbm).click
            net_reset_div = wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "����������������".to_gbk) {
                net_reset_div.present?
            }
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_lan).click
            lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(lan_iframe.exists?, "�������豸ҳ��ʧ��")
            #lan��ip�޸ĺ�����ָ�ʧ�ܣ��������ܵĹ�����Ӱ�������ű������Խű��в���lan�������޸� modify 2016/01/13
            # p "�޸�LAN��IP".to_gbk
            # @lan_ip =lan_iframe.text_field(id: @ts_tag_lanip).value
            # @lan_ip =~ /(\d+\.\d+\.)(\d+)(\.\d+)/i
            # @lan_ip_change = $1 + ($2.to_i-1).to_s + $3
            # lan_iframe.text_field(id: @ts_tag_lanip).set(@lan_ip_change)
            p "�޸�ssid".to_gbk
            wifi_btn = lan_iframe.button(id: @ts_wifi_switch)
            if wifi_btn.class_name == "off"
                wifi_btn.click
            end
            @ssid        = lan_iframe.text_field(id: @ts_tag_ssid).value
            @ssid_change = @ssid + "change"
            lan_iframe.text_field(id: @ts_tag_ssid).set(@ssid_change)
            lan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_rebot_net
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
            end
            p "��������ǽ�ܿ��أ�����IP��������������һ������".to_gbk
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
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
            @dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
            @option_iframe.text_field(id: @ts_ip_dst).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_ip_dst).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click
            sleep @tc_wait_time
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("1����¼AP�����뵽��ʱ����ҳ��") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            sys_link       = @option_iframe.link(id: @ts_tag_op_system)
            sys_link_state = sys_link.attribute_value(:checked)
            unless sys_link_state == "true"
                sys_link.click
            end
            @option_iframe.link(id: @ts_tag_plan_task).wait_until_present(@tc_wait_time)
            option_plan_iframe = @option_iframe.link(id: @ts_tag_plan_task)
            option_plan_iframe.click
        }

        operate("2������һ����ʱʱ�䣬��������Ϊ��ǰʱ�����һ���ӣ�Ȼ��رն�ʱ���񣬵������") {
            timing_btn = @option_iframe.button(id: @ts_btn_id)
            timing_btn.wait_until_present(@tc_wait_time)
            if timing_btn.class_name == "off"
                timing_btn.click #�򿪿���
            end
            timing_strategy = @option_iframe.select_list(id: @ts_timing_strategy)
            timing_strategy.wait_until_present(@tc_wait_time)
            timing_strategy.select_value(@tc_strategy_value) #ѡ�����
            @option_iframe.text_field(id: @ts_select_time_id).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_select_time_id).click #ѡ��ʱ��
            @option_iframe.link(id: @ts_taday_id).click #������찴ť
            cur_time = @option_iframe.text_field(id: @ts_select_time_id).value #��ȡ��ǰʱ��ֵ
            minnew   = cur_time.slice(/\d+\-\d+\-\d+\s\d+:(\d+):\d+/i, 1).to_i + 2 #���õ�ǰʱ�����һ���ӡ�###������ʱ�������������ܹ���ֹ����
            if minnew == 60
                sleep 60 #�ȴ��¸�����������
                minnew = minnew - 60 + 2 #���õ�ǰʱ�����һ����
                @option_iframe.text_field(id: @ts_select_time_id).click #ѡ��ʱ��
                @option_iframe.link(id: @ts_taday_id).click #������찴ť
                @option_iframe.li(class_name: @ts_time_classname).parent.lis[2].text_field.click
                @option_iframe.div(id: @ts_time_minute).span(text: minnew.to_s).click #�޸ķ���
            else
                @option_iframe.text_field(id: @ts_select_time_id).click #ѡ��ʱ��
                @option_iframe.li(class_name: @ts_time_classname).parent.lis[2].text_field.click
                @option_iframe.div(id: @ts_time_minute).span(text: minnew.to_s).click #�޸ķ���
            end
            @option_iframe.link(id: @ts_time_ok).click #ȷ��
            @option_iframe.p(id: @ts_rebot_btn).click #����
        }

        operate("3���鿴ʱ�䵽��·�����Ƿ�������������ɺ󣬲鿴֮ǰ���õ�ҵ���Ƿ�����") {
            sleep 60
            #����ping 192.168.100.1���鿴������
            lost_pack = ping_lost_pack(@dut_ip, @tc_ping_num)
            if lost_pack >= 5 && lost_pack <= 30
                lost_flag = true
            else
                lost_flag = false
            end
            assert(lost_flag, "100�����ж�ʧ#{lost_pack}�����������趨����[5,30],�ж�Ϊ�������ɹ���")

            p "��ѯ�Ƿ�ΪΪPPPOEģʽ".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, '���������÷����ı䣬WAN�ڲ�ΪPPPOE���ţ�')
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "��ѯLAN��IP�����Ƿ���ȷ".to_gbk
            @browser.span(id: @ts_tag_lan).click
            lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(lan_iframe.exists?, "�������豸ҳ��ʧ��")
            # lan_ip =lan_iframe.text_field(id: @ts_tag_lanip).value
            # assert_equal(lan_ip, @lan_ip_change, "LAN��IP�����˸ı䣡")
            p "��ѯwifi�����Ƿ���ȷ".to_gbk
            wifi_btn = lan_iframe.button(id: @ts_wifi_switch)
            assert_equal(wifi_btn.class_name, "on", "wifi�������÷����ı䣡")
            ssid = lan_iframe.text_field(id: @ts_tag_ssid).value
            assert_equal(ssid, @ssid_change, "ssid�����˸ı䣡")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "��ѯ����ǽ�����Ƿ���ȷ".to_gbk
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
            assert_equal(fire_wall_btn.class_name, "on", "����ǽ�ܿ������÷����˸ı䣡")
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            assert_equal(ip_btn.class_name, "on", "IP�����ܿ������÷����˸ı䣡")
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            unless ip_clauses == 1
                rule_srcip = @option_iframe.table(id: @ts_iptable).trs[1][3].text.slice(/(.+)\-/i, 1)
            end
            if (ip_clauses == 1 || rule_srcip != @dut_ip)
                assert(false, "IP���˹������÷����˸ı䣡")
            end
        }


    end

    def clearup
        operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
            end

            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe

            flag = false
            #����wan���ӷ�ʽΪ��������
            rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
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
                sleep @tc_net_wait_time
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2���رշ���ǽ�ܿ��غ�IP���˿���") {
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

        operate("3��ɾ��������Ŀ") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #����IP��������
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses > 1 #�������Ŀ��ɾ��
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #ɾ��������Ŀ
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("4���ָ�LAN��IP��ssid") {
            flag = false
            @browser.span(id: @ts_tag_lan).click
            lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            # unless lan_iframe.text_field(id: @ts_tag_lanip).value == @lan_ip
            #     lan_iframe.text_field(id: @ts_tag_lanip).set(@lan_ip)
            #     flag = true
            # end
            p "�޸�ssid".to_gbk
            wifi_btn = lan_iframe.button(id: @ts_wifi_switch)
            if wifi_btn.class_name == "off"
                wifi_btn.click
                flag = true
            end
            unless lan_iframe.text_field(id: @ts_tag_ssid).value == @ssid
                lan_iframe.text_field(id: @ts_tag_ssid).set(@ssid)
                flag = true
            end
            if flag
                lan_iframe.button(id: @ts_tag_sbm).click
                sleep @tc_rebot_net
                # lan_reset_div = lan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                # Watir::Wait.while(@tc_net_wait_time, "����������������".to_gbk) {
                #     lan_reset_div.present?
                # }
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
