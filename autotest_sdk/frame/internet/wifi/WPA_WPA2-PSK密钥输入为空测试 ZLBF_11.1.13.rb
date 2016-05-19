#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.13", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time      = 3
        @tc_error_msg      = "error_msg"
        @tc_error_msg_text = "����ֻ�������ֺ���ĸ,�ҳ�����8-63���ַ�֮��"
    end

    def process

        operate("1����Կ����Ϊ�գ�������棬�Ƿ���Ա���ɹ���") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #ѡ��ȫģʽ
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set("") #��������Ϊ��
            @lan_frame.checkbox(id: @ts_pwdshow).click #��ʾ����
            @lan_frame.button(id: @ts_tag_sbm).click #����
            if @lan_frame.span(id: @tc_error_msg, text: @tc_error_msg_text).exists?
                p "����ʾ��wifi���벻֧��Ϊ�գ�".to_gbk
            else
                assert(false, "wifi��������Ϊ�պ�û����ʾ��")
            end
        }
    end

    def clearup

    end

}
