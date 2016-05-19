#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.11", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time   = 5
        @lose_efficacy  = "ʧЧ"
        @take_effect    = "��Ч"
    end

    def process

        operate("0��׼�����裺��ȡDUT��ssid��pwd��PC2�������Ӹ�ssid����ȡPC1��PC2������IP��ַ") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #�����߿���
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            @ssid     = wifi_ssid.value
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #ѡ��ȫģʽ
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            @pwd = wifi_pwd.value
            p "ssid->#{@ssid}".to_gbk
            p "pwd->#{@pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi����ʧ��".to_gbk)
            @dut_ip      = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
            @wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
        }

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

        operate("2������������˹���һ��ԴIPΪ192.168.100.100,����һ����192.168.100.101��PC1��PC2�ܷ��������") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
            @option_iframe.text_field(id: @ts_ip_src).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click #����
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
            @option_iframe.text_field(id: @ts_ip_src).clear
            @option_iframe.text_field(id: @ts_ip_src).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_ip_src).set(@wireless_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click #����
            # @option_iframe.table(id: @ts_iptable).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses == 1
                assert(false, "��������Ŀʧ��")
            end

            response = send_http_request(@ts_web)
            if response == true
                sleep @tc_wait_time
                response = send_http_request(@ts_web)
            end
            assert(!response, "���Է���#{@ts_web}".to_gbk)
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            if response_pc2 == true
                sleep @tc_wait_time
                response_pc2 = send_http_request(@ts_web)
            end
            assert(!response_pc2, "���Է���#{@ts_web}".to_gbk)
        }

        operate("3����IP���˽��棬���ʹ������ĿʧЧ��PC1��PC2�ܷ��������") {
            @option_iframe.span(id: @ts_ip_invalid).click #���й���ʧЧ
            sleep @tc_wait_time

            response = send_http_request(@ts_web)
            if response == true
                sleep @tc_wait_time
                response = send_http_request(@ts_web)
            end
            assert(response, "�����Է���#{@ts_web}".to_gbk)
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            if response_pc2 == true
                sleep @tc_wait_time
                response_pc2 = send_http_request(@ts_web)
            end
            assert(response_pc2, "�����Է���#{@ts_web}".to_gbk)
        }

        operate("4����IP���˽��棬���ʹ������Ŀ��Ч��PC1��PC2�ܷ��������") {
            @option_iframe.span(id: @ts_ip_valid).click #���й�����Ч
            sleep @tc_wait_time

            response = send_http_request(@ts_web)
            if response == true
                sleep @tc_wait_time
                response = send_http_request(@ts_web)
            end
            assert(!response, "���Է���#{@ts_web}".to_gbk)
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            if response_pc2 == true
                sleep @tc_wait_time
                response_pc2 = send_http_request(@ts_web)
            end
            assert(!response_pc2, "���Է���#{@ts_web}".to_gbk)
        }


    end

    def clearup
        operate("1���رշ���ǽ�ܿ��غ�IP���˿���") {
            p "�Ͽ�wifi����".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����

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
