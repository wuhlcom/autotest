#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.15", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time      = 3
        @tc_wifi_pwd1      = "1234567"
        @tc_wifi_pwd2      = "qwertyuioplkjhgfdsazxcvbnm896543210krtghjuiopasdfghjklmnbvcx1234"
        @tc_wifi_pwd3      = "12345678901234567890123456789012345678901234567890ABCDEFabcdef345"
        @tc_error_msg      = "error_msg"
        @tc_error_msg_text = "����ֻ�������ֺ���ĸ,�ҳ�����8-63���ַ�֮��"
    end

    def process

        operate("1����Կ���롰1234567��7���ַ����Ƿ�������óɹ���") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #ѡ��ȫģʽ
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_wifi_pwd1) #��������
            @lan_frame.checkbox(id: @ts_pwdshow).click #��ʾ����
            @lan_frame.button(id: @ts_tag_sbm).click #����
            if @lan_frame.span(id: @tc_error_msg, text: @tc_error_msg_text).exists?
                p "wifi����������Ҫ8���ַ���".to_gbk
            else
                assert(false, "wifi��������7���ַ���û����ʾ��")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2����Կ���롰qwertyuioplkjhgfdsazxcvbnm896543210krtghjuiopasdfghjklmnbvcx1234��64���ַ��Ƿ���Ա���ɹ���") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #ѡ��ȫģʽ
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_wifi_pwd2) #��������
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

        operate("3����Կ���롰12345678901234567890123456789012345678901234567890ABCDEFabcdef345��65��16���ƣ��Ƿ�������óɹ���") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #ѡ��ȫģʽ
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_wifi_pwd3) #��������
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

    end

}
