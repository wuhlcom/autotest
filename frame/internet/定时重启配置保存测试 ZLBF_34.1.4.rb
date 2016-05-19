#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_34.1.4", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
        @tc_ping_num  = 100
    end

    def process
        operate("0���ֱ��WAN��LAN��WIFI������ǽ��QOS����Ӧ�����ã���¼������Ϣ��") {
            p "����WAN��ΪPPPOE����".to_gbk
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

            #lan��ip�޸ĺ�����ָ�ʧ�ܣ��������ܵĹ�����Ӱ�������ű������Խű��в���lan�������޸� modify 2016/01/13
            p "�޸�ssid".to_gbk
            @wifi_page   = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi      = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @change_ssid = rs_wifi[:ssid]

            p "��������ǽ�ܿ��أ�����IP��������������һ������".to_gbk
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #��ȫ����
            @options_page.firewall_click
            @options_page.open_switch("on", "on", "off", "off") #�򿪷���ǽ��IP�����ܿ���
        }

        operate("1����¼AP�����뵽��ʱ����ҳ��") {

        }

        operate("2������һ����ʱʱ�䣬��������Ϊ��ǰʱ�����һ���ӣ�Ȼ��رն�ʱ���񣬵������") {
            @options_page.restart_step(@browser.url)
        }

        operate("3���鿴ʱ�䵽��·�����Ƿ�������������ɺ󣬲鿴֮ǰ���õ�ҵ���Ƿ�����") {
            sleep @tc_wait_time
            #����ping 192.168.100.1���鿴������
            lost_pack = ping_lost_pack(@default_url, @tc_ping_num)
            if lost_pack >= 5 && lost_pack <= 20
                lost_flag = true
            else
                lost_flag = false
            end
            assert(lost_flag, "100�����ж�ʧ#{lost_pack}�����������趨����[5,20],�ж�Ϊ�������ɹ���")

            p "��ѯ�Ƿ�ΪΪPPPOEģʽ".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            wan_type = @status_page.get_wan_type
            assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, "���������÷����ı䣬�������Ͳ���PPPOE���ţ�")

            p "��ѯwifi�����Ƿ���ȷ".to_gbk
            @wifi_page.open_wifi_page(@browser.url)
            ssid = @wifi_page.ssid1
            assert_equal(@change_ssid, ssid, "������ssid�����˸ı䣡")

            p "��ѯ����ǽ�����Ƿ���ȷ".to_gbk
            @options_page.open_security_setting(@browser.url) #��ȫ����
            @options_page.firewall_click
            fire_wall_btn = @options_page.firewall_switch_element.class_name
            ip_btn        = @options_page.ip_filter_switch_element.class_name
            assert_equal("on", fire_wall_btn, "���������ǽ�ܿ������÷����˸Ļ���")
            assert_equal("on", ip_btn, "������IP���˿������÷����˸ı䣡")
        }


    end

    def clearup
        operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                rs_login = login_no_default_ip(@browser) #���µ�¼
                p rs_login[:flag]
                p rs_login[:message]
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }

        operate("2���رշ���ǽ�ܿ��غ�IP���˿���") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.open_security_setting(@browser.url)
            options_page.firewall_click
            options_page.close_switch
        }

        operate("3���ָ�ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end

}
