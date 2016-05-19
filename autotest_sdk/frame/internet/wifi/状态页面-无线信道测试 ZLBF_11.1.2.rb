#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.2", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time        = 3
        @tc_lan_wait_time    = 10
        @tc_wait_status_time = 30
        @tc_net_wait_time    = 60
        @tc_ap_login_btn     = "loginBtn"
        @tc_main_content     = "maincontent"
        @tc_ap_channel       = "chan"
        @tc_ap_channel_value = "2412MHz (Channel 1)"
        @tc_ap_channel_auto  = "�Զ�ѡ��"
    end

    def process

        operate("1��AP����2.4GƵ�ε����߹��ܣ�") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ��")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #�������߿���
                @lan_frame.button(id: @ts_tag_sbm).click #����

                wifi_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                    wifi_reset_div.present?
                }
                sleep @tc_lan_wait_time
                @browser.span(id: @ts_tag_lan).click #������������
                @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
                assert(@lan_frame.exists?, "����������ʧ��")
            end
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "on"
                p "wifi���ؿ����ɹ���".to_gbk
            else
                assert(false, "wifi���ؿ���ʧ�ܣ�")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2���޸��ŵ�Ϊ1�ŵ����鿴״̬��") {
            @browser.link(id: @ts_tag_options).click #�߼�����
            @advance_frame = @browser.iframe(src: @ts_tag_advance_src)
            @advance_frame.link(id: @ts_advance_setup).wait_until_present(@tc_wait_time)
            @advance_frame.link(id: @ts_advance_setup).click #wifi����

            select_channel = @advance_frame.select_list(id: @ts_wifi_channel) #ѡ���ŵ�
            select_channel.wait_until_present(@tc_wait_time)
            select_channel.select(@tc_ap_channel_value)
            @advance_frame.button(id: @ts_tag_sbm).click #����
            sleep @tc_wait_status_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            p "�鿴״̬".to_gbk
            @browser.span(id: @tag_status).click #�鿴״̬
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            assert(@status_iframe.exists?, "�򿪲鿴״̬����ʧ�ܣ�")
            @status_iframe.b(id: @ts_channel).wait_until_present(@tc_wait_time)
            cur_channel = @status_iframe.b(id: @ts_channel).parent.text.slice(/\d+/i) #��ȡwifi��ǰ�ŵ�
            assert_equal(cur_channel, @tc_ap_channel_value.slice(/Channel\s*(\d+)/i, 1), "�ŵ�����ʧ�ܣ�")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

        }

        operate("3���޸��ŵ�Ϊ�Զ��ŵ����鿴״̬��") {
            @browser.link(id: @ts_tag_options).click #�߼�����
            @advance_frame = @browser.iframe(src: @ts_tag_advance_src)
            @advance_frame.link(id: @ts_advance_setup).wait_until_present(@tc_wait_time)
            @advance_frame.link(id: @ts_advance_setup).click #wifi����

            select_channel = @advance_frame.select_list(id: @ts_wifi_channel) #ѡ���ŵ�
            select_channel.wait_until_present(@tc_wait_time)
            select_channel.select(@tc_ap_channel_auto)
            @advance_frame.button(id: @ts_tag_sbm).click #����
            sleep @tc_wait_status_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            p "�鿴״̬".to_gbk
            @browser.span(id: @tag_status).click #�鿴״̬
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            assert(@status_iframe.exists?, "�򿪲鿴״̬����ʧ�ܣ�")
            @status_iframe.b(id: @ts_channel).wait_until_present(@tc_wait_time)
            cur_channel = @status_iframe.b(id: @ts_channel).parent.text.slice(/\d+/i) #��ȡwifi��ǰ�ŵ�
            # assert_equal(cur_channel, @tc_ap_channel_value.slice(/Channel\s*(\d+)/i, 1), "�ŵ�����ʧ�ܣ�")   #�޷��Ƚ�
            assert(cur_channel, "�ŵ�����ʧ�ܣ�") #û��ȡ���ŵ��ͱ�ʾʧ��
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

        }
    end

    def clearup
        operate("�ָ�Ĭ���ŵ�") {
            @browser.link(id: @ts_tag_options).click #�߼�����
            @advance_frame = @browser.iframe(src: @ts_tag_advance_src)
            @advance_frame.link(id: @ts_advance_setup).wait_until_present(@tc_wait_time)
            @advance_frame.link(id: @ts_advance_setup).click #wifi����

            select_channel = @advance_frame.select_list(id: @ts_wifi_channel) #ѡ���ŵ�
            select_channel.wait_until_present(@tc_wait_time)
            unless select_channel.value.to_gbk == "0" #0��ʾ�Զ�ѡ��
                select_channel.select(@tc_ap_channel_auto)
                @advance_frame.button(id: @ts_tag_sbm).click #����
                sleep @tc_lan_wait_time
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
