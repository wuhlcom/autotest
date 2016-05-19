#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.5", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time      = 3
        @tc_net_wait_time  = 60
        @tc_ssid_name      = "~!@#$%^&*()_+-={}:\"<>?[]|\; ',./`"
        @tc_pwd            = "12345678"
        @tc_ssid_default   = "WIFI_00116B"
        @tc_error_msg      = "error_msg"
        @tc_error_msg_text = "SSID������,����,��ĸ,��(��)����,����1-32λ,һ������ռ3λ"
    end

    def process

        operate("1����������SSIDΪ32�������ַ���~!@#$%^&*()_+-={}:\"<>?[]|\; ',./`�����Ƿ�������óɹ���") {
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
                p "����ʾ��ssid��֧������������ַ���".to_gbk
            else
                assert(false, "���벻֧�ֵ������ַ���û����ʾ��")
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
