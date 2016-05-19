#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.14", "level" => "P2", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_dumpcap_pc2   = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time     = 3
        @tc_net_wait_time = 60
        @tc_pwd_default   = "12345678"
        @tc_pwd1          = "qwertyuioplkjhgfdsazxcvbnm896543210krtghjuiopasdfghjklmnbvcx123"
        @tc_pwd2          = "12345678901234567890123456789012345678901234567890ABCDEFabcdef34"
        @tc_error_msg      = "error_msg"
        @tc_error_msg_text = "����ֻ�������ֺ���ĸ,�ҳ�����8-63���ַ�֮��"
    end

    def process

        operate("1����Կ���롰qwertyuioplkjhgfdsazxcvbnm896543210krtghjuiopasdfghjklmnbvcx123��63���ַ����Ƿ�������óɹ��� STA�Ƿ����ӳɹ���") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #�����߿���
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            ssid      = wifi_ssid.value
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #ѡ��ȫģʽ
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_pwd1) #��������
            @lan_frame.checkbox(id: @ts_pwdshow).click #��ʾ����
            @lan_frame.button(id: @ts_tag_sbm).click #����
            lan_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                lan_reset_div.present?
            }
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "PC��������wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(ssid, flag, @tc_pwd1, @ts_wlan_nicname)
            assert(rs, "PC wifi����ʧ��".to_gbk)
        }

        operate("2����Կ���롰12345678901234567890123456789012345678901234567890ABCDEFabcdef34��64��16���ƣ��Ƿ�������óɹ���STA�Ƿ����ӳɹ���") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #�����߿���
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            ssid      = wifi_ssid.value
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #ѡ��ȫģʽ
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_pwd2) #��������
            @lan_frame.checkbox(id: @ts_pwdshow).click #��ʾ����
            @lan_frame.button(id: @ts_tag_sbm).click #����
            if @lan_frame.span(id: @tc_error_msg, text: @tc_error_msg_text).exists?
                p "����ʾ��wifi���벻�ܳ���63���ַ���".to_gbk
            else
                assert(false, "wifi���볬��63���ַ���û����ʾ��")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }


    end

    def clearup
        operate("�ָ�Ĭ������"){
            @tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����

            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #�����߿���
            end
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_pwd_default) #��������
            @lan_frame.checkbox(id: @ts_pwdshow).click #��ʾ����
            @lan_frame.button(id: @ts_tag_sbm).click #����
            lan_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                lan_reset_div.present?
            }
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
