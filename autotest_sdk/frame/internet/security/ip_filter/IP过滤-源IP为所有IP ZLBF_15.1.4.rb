#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.4", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
        dut_ip          = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
        filter_net      = dut_ip.slice(/(\d+\.\d+\.\d+\.)\d+/, 1)
        @tc_wait_time   = 5
        @tc_src_fip     = filter_net + "2"
        @tc_src_endip   = filter_net + "254"
    end

    def process

        operate("1��DUT�Ľ�������ѡ��ΪDHCP���������ã��ٽ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ����棻") {
            @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "����������ʧ�ܣ�")
            p "��ȡDUT��ssid".to_gbk
            @dut_ssid = @lan_iframe.text_field(id: @ts_tag_ssid).value
            p "DUTssid --> #{@dut_ssid}".to_gbk
            @dut_ssid_pwd = @lan_iframe.text_field(id: @ts_tag_ssid_pwd).value
            p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

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

        operate("2�����һ���¹�������ԴIPΪ����IP�����������192.168.100.2-192.168.100.254�����������ã�pc1�ܷ��������") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click
            @option_iframe.text_field(id: @ts_ip_src).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_ip_src).set(@tc_src_fip)
            @option_iframe.text_field(id: @ts_ip_src_end).set(@tc_src_endip)
            @option_iframe.button(id: @ts_tag_save_filter).click
            @option_iframe.table(id: @ts_iptable).wait_until_present(@tc_wait_time)
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            ip_filter  = @option_iframe.table(id: @ts_iptable).trs[1][1].text
            ip_math    = @tc_src_fip+"-"+@tc_src_endip
            if (ip_clauses == 1 && ip_filter != ip_math)
                assert(false, "��������Ŀʧ��")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            response = send_http_request(@ts_web)
            assert(!response, "���Է���#{@ts_web}".to_gbk)
        }

        operate("3��pc2����·��wifi���ܷ��������") {
            p "PC2����wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@dut_ssid, flag, @dut_ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi����ʧ��".to_gbk)
            response = @tc_dumpcap_pc2.send_http_request(@ts_web)
            assert(!response, "���Է���#{@ts_web}".to_gbk)
        }

    end

    def clearup
        operate("1���رշ���ǽ�ܿ��غ�IP���˿���") {
            p "�Ͽ�wifi����".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����
            sleep @tc_wait_time

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
