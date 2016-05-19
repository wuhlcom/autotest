#
# description:
# author:liluping
# date:2015-09-21
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.6", "level" => "P2", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_dumpcap             = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_dumpcap_pc2         = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time           = 3
        @tc_net_wait_time       = 60
        @tc_tag_wire_mode_radio = "ip_type_dhcp"
        @tc_tag_wan_mode_link   = "tab_ip"
        @tc_tag_ip_setting      = "IP-Filter"

        @tc_tag_options              = "options"
        @tc_tag_secseting            = "securitysetting"
        @tc_tag_fw_seting            = "Firewall-Settings"
        @tc_tag_save_button          = "save_btn"
        @tc_tag_save_button_ipfilter = "save_btniptb"
        @tc_tag_add_ipfilter         = "additem"

        @tc_tag_fw_button         = "switch1"
        @tc_tag_ip_button         = "switch2"
        @tc_tag_button_switch_off = "off"
        @tc_tag_button_switch_on  = "on"

        @tc_tag_destination_fip_text   = "gip"
        @tc_tag_destination_endip_text = "gendip"
        @tc_tag_source_port_text       = "gport"
        @tc_tag_destination_port_text  = "gendport"
        @tc_tag_agreement_select       = "protocol"
        @tc_tag_ipfilter_list_id       = "iptable"
        @tc_tag_ipfilter_list_cls_name = "macguolv"
        @tc_tag_error_msg              = "error_msg"

        @tc_tag_source_port      = "1"
        @tc_tag_destination_port = "65535"

        @tc_tag_url_baidu = 'www.baidu.com'
        @tc_tag_url_yahoo = 'www.yahoo.com'
        @tc_tag_url_sohu  = 'www.sohu.com'
        @tc_ping_num      = 5

        @ssid_pwd             = "12345678"
        @tc_net_status        = "setstatus"
        @tc_dut_wifi_ssid     = "ssid"
        @tc_dut_wifi_ssid_pwd = "input_password1"

    end

    def process

        operate("1��DUT�Ľ�������ѡ��ΪDHCP���������á��ٽ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ����棻") {
            @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time) #�ȴ�2s
            @browser.span(id: @ts_tag_lan).click

            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "����������ʧ�ܣ�")
            p "��ȡDUT��ssid".to_gbk
            @dut_ssid = @lan_iframe.text_field(id: @tc_dut_wifi_ssid).value
            p "DUTssid --> #{@dut_ssid}".to_gbk
            @dut_ssid_pwd = @lan_iframe.text_field(id: @tc_dut_wifi_ssid_pwd).value
            p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2����dut����
            p "PC2����wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@dut_ssid, flag, @dut_ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi����ʧ��".to_gbk)

            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time) #�ȴ�2s
            @browser.span(id: @ts_tag_netset).click

            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src) #����壬�¶���
            assert(@wan_iframe.exists?, "����������ʧ�ܣ�")

            @wan_iframe.link(:id => @tc_tag_wan_mode_link).click #ѡ����������
            dhcp_radio = @wan_iframe.radio(id: @tc_tag_wire_mode_radio)
            unless dhcp_radio.checked?
                dhcp_radio.click
                #����
                @wan_iframe.button(:id, @ts_tag_sbm).click

                sleep @tc_wait_time
                net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
                # Watir::Wait.until(@tc_wait_time, "�ȴ�����������ʾ����".to_gbk) {
                #     net_reset_div.visible?
                # }
                Watir::Wait.while(@tc_net_wait_time, "����������������".to_gbk) {
                    net_reset_div.present?
                }
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            puts "�򿪸߼�����".to_gbk
            @browser.link(id: @tc_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            option_link = @option_iframe.link(id: @tc_tag_secseting)
            option_link.click

            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "��������ǽ�ܿ���IP���˿���".to_gbk
            btn_fw_off = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_off)
            if btn_fw_off.exists? #�ر�״̬�Ͳ��ٲ�����
                btn_fw_off.click
            end
            btn_url_off = @option_iframe.button(id: @tc_tag_ip_button, class_name: @tc_tag_button_switch_off)
            if btn_url_off.exists?
                btn_url_off.click
            end

            @option_iframe.button(id: @tc_tag_save_button).click
        }

        operate("2������IP���˹��ܣ�����Ŀ��IPΪһ��ַ�Σ���192.168.20.100~192.168.20.200����������ΪĬ�ϣ��������ã���PC���������ping������ping��IPΪ���������ڵĵ�ַ��Ȼ���ڷ������鿴�Ƿ���ץ�����ݰ���") {

            @option_iframe.link(id: @tc_tag_ip_setting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_ip_setting)
            option_fw_iframe.click

            require "ipaddr"
            rs = Addrinfo.ip(@tc_tag_url_yahoo) #��ѯ��url��Ӧ��ip
            dst_ip = rs.ip_address #"116.214.12.74"
            dstip_toi = IPAddr.new(dst_ip).to_i

            ns = Addrinfo.ip(@tc_tag_url_baidu) #��ѯ��url��Ӧ��ip
            dst_ipt = ns.ip_address #"58.217.200.112"
            dstipt_toi = IPAddr.new(dst_ipt).to_i

            ss = Addrinfo.ip(@tc_tag_url_sohu) #��ѯ��url��Ӧ��ip
            sohu_ip = ss.ip_address #"14.18.240.6"
            sohu_toi = IPAddr.new(sohu_ip).to_i

            if dstip_toi > dstipt_toi && dstip_toi > sohu_toi #dstip_toi���
                if dstipt_toi > sohu_toi
                    ping_ip           = sohu_ip
                    destination_ip    = dst_ipt
                    destination_endip = dst_ip
                else
                    ping_ip           = dst_ipt
                    destination_ip    = sohu_ip
                    destination_endip = dst_ip
                end
            elsif dstipt_toi > dstip_toi && dstipt_toi > sohu_toi #dstipt_toi���
                if dstip_toi > sohu_toi
                    ping_ip           = sohu_ip
                    destination_ip    = dst_ip
                    destination_endip = dst_ipt
                else
                    ping_ip           = dst_ip
                    destination_ip    = sohu_ip
                    destination_endip = dst_ipt
                end
            elsif sohu_toi > dstipt_toi && sohu_toi > dstip_toi #sohu_ip���
                if dstip_toi > dstipt_toi
                    ping_ip           = dst_ipt
                    destination_ip    = dst_ip
                    destination_endip = sohu_ip
                else
                    ping_ip           = dst_ip
                    destination_ip    = dst_ipt
                    destination_endip = sohu_ip
                end
            end

            @option_iframe.span(id: @tc_tag_add_ipfilter).click #�������Ŀ
            @option_iframe.text_field(id: @tc_tag_destination_fip_text).set(destination_ip) #����Ŀ��IP
            @option_iframe.text_field(id: @tc_tag_destination_endip_text).set(destination_endip)

            @option_iframe.button(id: @tc_tag_save_button_ipfilter).click #����
            ip_network_segment = destination_ip + "-" + destination_endip

            # err_msg = @option_iframe.p(id: @tc_tag_error_msg).text #������ִ�����ʾ��Ϣ
            # if err_msg == "\u6E90\u8D77\u59CBIP\u5E94\u8BE5\u5C0F\u4E8E\u7ED3\u675FIP"
            #     @option_iframe.text_field(id: @tc_tag_destination_fip_text).set(destination_endip) #��������ԴIP����
            #     @option_iframe.text_field(id: @tc_tag_destination_endip_text).set(destination_ip)
            #     @option_iframe.button(id: @tc_tag_save_button_ipfilter).click #����
            #     ip_network_segment = destination_endip + "-" + destination_ip
            # end

            #�ж��Ƿ�����������Ŀ
            #��ȡ��Ŀ�е�Դip
            # ip_network_segment = destination_ip + "-" + destination_endip
            sleep @tc_wait_time
            source_ip = @option_iframe.table(id: @tc_tag_ipfilter_list_id, class_name: @tc_tag_ipfilter_list_cls_name).trs[1][3].text.to_gbk
            assert_equal(ip_network_segment, source_ip, "���IP����ʧ��!")
            puts "����IP��ַ��Ϊ:#{source_ip}".to_gbk


            #��֤ip�Ƿ����
            puts "��֤ip�����Ƿ���Ч".to_gbk
            p "��֤PC1�� #{destination_endip}".to_gbk
            rs = ping(destination_endip, @tc_ping_num)
            # rs = send_http_request(destination_endip)
            assert(!rs, "ip����ʧ�ܣ�#{destination_endip}�ڹ�������#{source_ip}�ڣ���pingͨ!")

            p "��֤PC2�� #{destination_ip}".to_gbk
            ts = @tc_dumpcap_pc2.ping(destination_ip, @tc_ping_num)
            # ts = @tc_dumpcap_pc2.send_http_request(destination_ip)
            assert(!ts, "ip����ʧ�ܣ�#{destination_ip}�ڹ�������#{source_ip}�ڣ���pingͨ!")

            p "��֤PC1�� #{ping_ip}".to_gbk
            rss = ping(ping_ip, @tc_ping_num)
            # rss = send_http_request(ping_ip)
            assert(rss, "ip����ʧ�ܣ�#{ping_ip}�ڹ�������#{source_ip}�⣬����pingͨ!")

            p "��֤PC2�� #{ping_ip}".to_gbk
            tss = @tc_dumpcap_pc2.ping(ping_ip, @tc_ping_num)
            # tss = @tc_dumpcap_pc2.send_http_request(ping_ip)
            assert(tss, "ip����ʧ�ܣ�#{ping_ip}�ڹ�������#{source_ip}�⣬����pingͨ!")

        }
    end

    def clearup

        operate("�ָ�Ĭ������") {
            p "�Ͽ�wifi����".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����
            sleep @tc_wait_time
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            p "1 �رշ���ǽ�ܿ��غ�URL���˿���".to_gbk
            @browser.link(id: @ts_tag_options).click

            @option_iframe    = @browser.iframe(src: @ts_tag_advance_src)
            # assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            option_link       = @option_iframe.link(id: @tc_tag_secseting)
            option_link_state = option_link.attribute_value(:checked)
            unless option_link_state == "true"
                option_link.click
            end

            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "�رշ���ǽ�ܿ��غ�IP���˿���".to_gbk
            btn_fw_on = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_on)

            if btn_fw_on.exists? #�ر�״̬�Ͳ��ٲ�����
                btn_fw_on.click
            end
            btn_ip_on = @option_iframe.button(id: @tc_tag_ip_button, class_name: @tc_tag_button_switch_on)
            if btn_ip_on.exists?
                btn_ip_on.click
            end

            @option_iframe.button(id: @tc_tag_save_button).click

            p "2 ɾ�����еĹ��˹���".to_gbk
            @option_iframe.link(id: @tc_tag_ip_setting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_ip_setting)
            option_fw_iframe.click
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
