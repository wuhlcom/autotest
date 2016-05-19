#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.3", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2   = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time     = 3
        @tc_lan_wait_time = 10
        @tc_net_wait_time = 60
        @tc_ap_login_btn  = "loginBtn"
    end

    def process

        operate("1��AP����2.4GƵ�ε����߹��ܣ��鿴״̬ҳ�����߿���״̬��") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #�����߿���
                @lan_frame.button(id: @ts_tag_sbm).click #����

                wifi_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                    wifi_reset_div.present?
                }
                sleep @tc_lan_wait_time
                @browser.span(id: @ts_tag_lan).click #������������
                @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
                assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            end
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "on"
                p "wifi���ؿ����ɹ���".to_gbk
            else
                assert(false, "wifi���ؿ���ʧ�ܣ�")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.span(id: @tag_status).click #��״̬����
            @status_frame = @browser.iframe(src: @tag_status_iframe_src)
            @status_frame.b(id: @ts_wifi_status).wait_until_present(@tc_wait_time)
            wifi_status = @status_frame.b(id: @ts_wifi_status).parent.text.slice(/WIFI2\.4G\s*(\w+)/i, 1) #��ȡwifi����״̬
            assert_equal("On", wifi_status, "�������߹��ܿ��أ���״̬��ʾδ������")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2��AP�ر�2.4GƵ�ε����߹��ܣ��鿴״̬ҳ�����߿���״̬��") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "on"
                @lan_frame.button(id: @ts_wifi_switch).click #�ر����߿���
                @lan_frame.button(id: @ts_tag_sbm).click #����

                wifi_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                    wifi_reset_div.present?
                }
                sleep @tc_lan_wait_time
                @browser.span(id: @ts_tag_lan).click #������������
                @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
                assert(@lan_frame.exists?, "����������ʧ�ܣ�")
            end
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                p "wifi���عرճɹ���".to_gbk
            else
                assert(false, "wifi���عر�ʧ�ܣ�")
            end
            ssid_name = @lan_frame.text_field(id: @ts_tag_ssid).value #��ȡssid
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.span(id: @tag_status).click #��״̬����
            @status_frame = @browser.iframe(src: @tag_status_iframe_src)
            assert(@status_frame.exists?, "�򿪲鿴״̬����ʧ�ܣ�")
            @status_frame.b(id: @ts_wifi_status).wait_until_present(@tc_wait_time)
            wifi_status = @status_frame.b(id: @ts_wifi_status).parent.text.slice(/WIFI2\.4G\s*(\w+)/i, 1) #��ȡwifi����״̬
            #��״̬��ʾ��ʵ����ʾ��һ��ʱ���������������鿴�ܷ��ѯ����ssid�����ж����ĸ����ܳ�������
            unless wifi_status == "Off"
                search_ssid = @tc_dumpcap_pc2.scan_network(ssid_name)
                p "�ܷ�ɨ�赽ssid��#{search_ssid[:flag]}".to_gbk
                if search_ssid[:flag]
                    assert(false, "wifi������ʾ�رգ�����������������ssid��������wifi���ع���ʧЧ���붨λ��")
                else
                    assert(false, "wifi������ʾ�رգ�ʵ��Ҳ�޷���������ssid��������״̬������ʾ����ʧЧ���붨λ��")
                end
            else
                assert(true, "�ر����߹��ܿ��أ���״̬��ʾδ�رգ�")
            end
            # assert_equal(wifi_status, "Off", "�ر����߹��ܿ��أ���״̬��ʾδ�رգ�")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }


    end

    def clearup
        operate("�ָ�Ĭ������") {
            @browser.span(id: @ts_tag_lan).click #������������
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #�����߿���
                @lan_frame.button(id: @ts_tag_sbm).click #����

                wifi_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                    wifi_reset_div.present?
                }
            end
        }
    end

}
