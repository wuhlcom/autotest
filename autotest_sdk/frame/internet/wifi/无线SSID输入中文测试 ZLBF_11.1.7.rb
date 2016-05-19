#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.7", "level" => "P2", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_dumpcap_pc2   = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time      = 3
        @tc_net_wait_time  = 60
        @tc_ssid_name      = "�й�"
        @tc_pwd            = "12345678"
        @tc_ssid_default   = "WIFI_00116B"
        @tc_error_msg      = "error_msg"
        @tc_error_msg_text = "SSID������,����,��ĸ,��(��)����,����1-32λ,һ������ռ3λ"
    end

    def process

        operate("1����������SSIDΪ���й������Ƿ���Ա���ɹ���") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #�����߿���
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            wifi_ssid.clear
            wifi_ssid.set(@tc_ssid_name) #����ssid
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #ѡ��ȫģʽ
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_pwd) #��������
            @lan_frame.checkbox(id: @ts_pwdshow).click #��ʾ����
            @lan_frame.button(id: @ts_tag_sbm).click #����
            if @lan_frame.span(id: @tc_error_msg, text: @tc_error_msg_text).exists?
                p "����ʾ��ssid��֧�����������ַ���".to_gbk
            else
                lan_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                    lan_reset_div.present?
                }
                if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                    @browser.execute_script(@ts_close_div)
                end
                p "ssid������ϣ����Ͻ�����֤��".to_gbk
                @browser.span(id: @tag_status).click #��״̬����
                @status_frame = @browser.iframe(src: @tag_status_iframe_src)
                assert(@status_frame.exists?, "��״̬����ʧ�ܣ�")
                @status_frame.b(id: @ts_dut_ssid).wait_until_present(@tc_wait_time)
                cur_ssid = @status_frame.b(id: @ts_dut_ssid).parent.text.slice(/SSID\n(.+)/i, 1)
                assert_equal(cur_ssid, @tc_ssid_name, "ssid����ʧ�ܣ�")
                p "ssid���óɹ���".to_gbk
                if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                    @browser.execute_script(@ts_close_div)
                end

                p "PC��������wifi".to_gbk
                flag ="1"
                rs   = @tc_dumpcap_pc2.connect(@tc_ssid_name, flag, @tc_pwd, @ts_wlan_nicname)
                assert(rs, "PC wifi����ʧ��".to_gbk)
                p "PC��������#{@ts_web}...".to_gbk
                judge_link_pc2 = @tc_dumpcap_pc2.ping(@ts_web)
                assert(judge_link_pc2, "PC�޷���������#{@ts_web}".to_gbk)
                @tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����
            end
        }


    end

    def clearup
        operate("�ָ�����") {
            p "�ָ�Ĭ��ssid".to_gbk
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            wifi_ssid  = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            unless wifi_ssid.value == @tc_ssid_default
                wifi_ssid.clear
                wifi_ssid.set(@tc_ssid_default) #����ssid
                @lan_frame.button(id: @ts_tag_sbm).click #����
                lan_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                    lan_reset_div.present?
                }
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
