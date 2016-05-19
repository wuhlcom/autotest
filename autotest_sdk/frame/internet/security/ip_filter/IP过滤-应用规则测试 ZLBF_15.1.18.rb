#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.18", "level" => "P3", "auto" => "n"}

    def prepare
        # @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time           = 5
        @tc_rebooting_wait_time = 120
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

            # flag ="1"
            # rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
            # assert(rs, "PC2 wifi����ʧ��".to_gbk)
            @dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
            # @wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
        }

        operate("1��DUT�Ľ�������ѡ��ΪDHCP���������ã�") {
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
        }

        operate("2�����뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ���IP���ǽ�����ӹ���ֱ���������Ϊֹ���鿴�Ƿ���ӳɹ��������Ŀ�����������Ŀ�Ƿ�һ�£�") {
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
            rs = @dut_ip.slice(/(\d+\.\d+\.\d+\.)\d+/i, 1)

            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
            @option_iframe.text_field(id: @ts_ip_src).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_ip_src).clear
            @option_iframe.text_field(id: @ts_ip_src).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click #����
            for n in 1..31
                rule_ip = rs + n.to_s
                @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
                @option_iframe.text_field(id: @ts_ip_src).wait_until_present(@tc_wait_time)
                @option_iframe.text_field(id: @ts_ip_src).clear
                @option_iframe.text_field(id: @ts_ip_src).set(rule_ip)
                @option_iframe.button(id: @ts_tag_save_filter).click #����
            end
        }


        operate("3��ʹ��iptables-nvx-L����鿴���й��������������ƹ������ʾ������Ŀ���˿ڵ��Ƿ���ȷ��") {
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 33, "���������Ŀ��һ��")
        }

        operate("4��ʹ�����ݰ�ģ����ģ��ƥ���һ�������һ�������м��������������ݰ�����LAN��WAN�������ݰ�����PC2��ץ�����Ƿ����յ�PC1���������ݰ���") {
            rs = ping(@ts_web)
            assert(!rs, "���˹�����Ч�����˹�������һ��Ϊ������ԴIPΪdut����ip#{@dut_ip},��Ȼ�ܹ�pingͨ������")
        }

        operate("5��DUT������������ӹ����Ƿ񶼴����޶�ʧ��") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_reboot).click
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "·���������У����Ժ�...".to_gbk
            sleep @tc_rebooting_wait_time
            login_no_default_ip(@browser) #���µ�¼
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 33, "����������ӹ������б仯��")
        }

        operate("6����˳��ɾ����ӵ����й��򣬲鿴ɾ���Ƿ�ɹ���iptables-nvx-L����鿴�Ƿ�ɾ���ɹ���") {
            @option_iframe.table(id: @ts_iptable).wait_until_present(@tc_wait_time)
            ip_trs = @option_iframe.table(id: @ts_iptable).trs
            ip_trs[3][7].link(class_name: @ts_tag_del).click #ɾ����3����¼
            ip_trs[1][7].link(class_name: @ts_tag_del).click #ɾ����1����¼
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 31, "ɾ��������ܹ�������һ�£�")
        }

        operate("7��DUT��������ӹ����Ƿ񻹴��ڡ�") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_reboot).click
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "·���������У����Ժ�...".to_gbk
            sleep @tc_rebooting_wait_time
            login_no_default_ip(@browser) #���µ�¼
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 31, "�������ܹ������б仯��")
        }


    end

    def clearup
        operate("�رշ���ǽ����") {
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
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "on"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #����
        }

        operate("ɾ����������") {
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
