#
# description:
# author:liluping
# date:2015-10-10 11:38:55
# modify:
#
testcase {
    attr = {"id" => "ZLRM_1.1.21", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_connect_time     = 60
        @tc_reboot_time           = 90
        @tc_wait_time             = 3
        @tc_search_ssid_wait_time = 10
        @tc_wait_web_respond_time = 10
        @tc_net_start_wait_time   = 20
        @tc_net_wait_time         = 60
        @tc_ap_login_btn          = "loginBtn"
        @tc_ap_wireless           = "d_wlan_basic.asp"
        @tc_wireless_id           = "wireless"
        @tc_relay_id              = "mode-relay"
        @tc_search_net            = "ssid_reflash"
        @tc_ssid_list             = "ssid_list"
        @tc_net_status            = "setstatus"
        @tc_ap_maintain           = "d_reboot.asp"
        @tc_net_pwd               = "input_password3"
        @tc_ap_status             = "d_status.asp"
        @tc_main_content          = "maincontent"
        @tc_ap_reboot             = "reboot"
        @tc_ap_status             = "d_status.asp"
        @tc_main_content          = "maincontent"

        @tc_tag_wan_mode_link        = "tab_ip"
        @tc_select_state             = "selected"
        @tc_tag_wan_mode_span        = "wire"
        @tc_tag_wire_mode_radio_dhcp = "ip_type_dhcp"
        @tc_dut_ssid                 = "WIFI_039E99"
        @default_ssid_pwd            = "12345678"
    end

    def process
        operate("0����ȡdut��ssid������") {
            @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_lan).click
            @wan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@wan_iframe.exists?, "����������ʧ�ܣ�")
            @dut_ssid = @wan_iframe.text_field(id: @ts_tag_ssid).value
            p "DUT��ssid -> #{@dut_ssid}".to_gbk
            @dut_ssid_pwd = @wan_iframe.text_field(id: @ts_tag_ssid_pwd).value
            p "DUT���������� -> #{@dut_ssid_pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("1��ɨ������AP�����ӵ�����һ��AP") {
            @browser1 = Watir::Browser.new :ff, :profile => "default"
            @browser1.goto(@ts_tag_ap_url) #���뵽��¼����

            @browser1.button(id: @tc_ap_login_btn).click #��¼
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @tc_ap_status).click #����״̬ģ��
            sleep @tc_wait_time
            @ap_lan_ip = @ap_frame.div(id: @tc_main_content).tables[3].trs[1][0].tables[0].trs[0][1].text
            p "AP��LAN��ip��#{@ap_lan_ip}".to_gbk
            assert(!@ap_lan_ip.nil?, "AP��LAN��ip��ȡʧ�ܣ�")
            @ap_frame.link(href: @tc_ap_wireless).click #��������2.4Gģ��
            #��ȡssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            # #��ȡssid����
            if @ap_frame.text_field(name: "pskValue").exists?
                @ssid_pwd = @ap_frame.text_field(name: "pskValue").value
                p "APssid_pwd --> #{@ssid_pwd}"
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #��¼��ˢ�������
            end
            5.times do #ѭ��5�δ���������
                @browser.refresh #ˢ�������
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @tc_wireless_id).exists?
            end
            @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @tc_wireless_id).click #��������
            @wan_iframe.label(id: @ts_bridge_id).click #ѡ���Ž�ģʽ
            @dut_ssid = @wan_iframe.text_field(id: @ts_dut_wifi_ssid).value
            p "DUTssid --> #{@dut_ssid}".to_gbk
            @dut_ssid_pwd = @wan_iframe.text_field(id: @ts_dut_wifi_ssid_pwd).value
            p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
            ssid_flag = false
            n         = 0
            until ssid_flag == true
                arr_option = []
                begin
                    @wan_iframe.button(id: @ts_search_net).wait_until_present(@tc_search_ssid_wait_time)
                    @wan_iframe.button(id: @ts_search_net).click #���ɨ������
                rescue #ɨ��ssidʱ�����쳣����ɨ������ʱһֱ��תȦȦ��ˢ�����������
                    @browser.refresh #ˢ�������
                    @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                    @browser.span(id: @ts_tag_netset).click
                    @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                    @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
                    @wan_iframe.span(id: @tc_wireless_id).click #��������
                    @wan_iframe.label(id: @ts_relay_id).click #ѡ���м�ģʽ
                    @wan_iframe.button(id: @ts_search_net).wait_until_present(@tc_search_ssid_wait_time)
                    @wan_iframe.button(id: @ts_search_net).click #���ɨ������
                end
                sleep @tc_wait_time
                select_click = @wan_iframe.select_list(id: @ts_ssid_list)
                options      = select_click.options #�����������ֵ�Ķ���
                options.each do |item|
                    arr_option << item.value #�����������ֵ
                end
                n         += 1
                ssid_flag = true if arr_option.include?(@ssid)
                break if n == 5 #���ֻ��ѯ5��ssid
            end
            assert(ssid_flag, "δɨ�赽ap��ssid->#{@ssid}")
            select_click.select(@ssid) #ѡ��ap��ssid
            select_pwd_click = @wan_iframe.text_field(id: @tc_net_pwd)
            if select_pwd_click.exists?
                select_pwd_click.set(@ssid_pwd) #����ap��ssid����
                @wan_iframe.checkbox(id: @ts_pwdshow2).click #��ʾ����
            end
            @wan_iframe.button(id: @ts_tag_sbm).click #����
            sleep @tc_wait_time
            net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "����������������".to_gbk) {
                net_reset_div.present?
            }
            sleep @tc_net_start_wait_time #�Ž��Ϻ󣬵ȴ�һ��ʱ���ٲ鿴�����AP�Ƿ�����ɹ�
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "�鿴״̬".to_gbk
            5.times do
                @browser.refresh #ˢ�������
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #�鿴״̬
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #û���ְװ�
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #������ְװ�
                    @dut_wan_ip #����
                    sleep @tc_wait_time
                end
            end
            p "dut��wan��ip��#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUTδ��ȡ�����AP�ĵ�ַ��")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT�����AP����ͬһ���Σ�����ʧ�ܣ�".to_gbk)

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2����������AP�����������DUT�Ƿ����ٴ��Զ����ӵ�����AP") {
            require 'selenium-webdriver' #��������ʱ������alert����Ҫģ����ȷ����ť
            @browser1.goto(@ts_tag_ap_url) #���뵽��¼����
            @browser1.button(id: @tc_ap_login_btn).click #��¼
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @tc_ap_maintain).click #����ά��ģ��
            sleep @tc_wait_time
            @ap_frame.button(name: @tc_ap_reboot).click #�������
            #��alert�������У�ģ����ȷ����ť
            key_obj = @ap_frame.driver.switch_to.alert
            key_obj.accept

            assert(@ap_frame.text_field(name: "time").exists?, "����ʧ�ܣ�")
            sleep @tc_reboot_time
            p "������ϣ��ȴ�60s�󣬲鿴DUT�Ƿ����ٴ��Զ����ӵ�����AP...".to_gbk
            sleep @tc_wait_connect_time

            5.times do
                @browser.refresh #ˢ�������
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #�鿴״̬
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #û���ְװ�
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #������ְװ�
                    @dut_wan_ip #����
                    sleep @tc_wait_time
                end
            end
            p "dut��wan��ip��#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUTδ��ȡ�����AP�ĵ�ַ��")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT�����AP����ͬһ���Σ�����ʧ�ܣ�".to_gbk)
        }


    end

    def clearup
        operate("�ָ�Ĭ������") {
            @browser1.close #�ر������

            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end

            @browser.span(:id => @ts_tag_netset).click
            sleep @tc_wait_time
            @wan_iframe = @browser.iframe
            @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
            #����WIRE WANΪDHCPģʽ
            dhcp_radio.click
            @wan_iframe.button(:id, @ts_tag_sbm).click
            puts "Waiting for net reset..."
            sleep @tc_net_wait_time

            #�ָ�dut·������ssid
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            sleep @tc_wait_time
            unless @lan_iframe.text_field(id: @ts_tag_ssid, name: @ts_tag_ssid).value == @dut_ssid
                @lan_iframe.text_field(id: @ts_tag_ssid, name: @ts_tag_ssid).set(@dut_ssid)
                @lan_iframe.select_list(id: @ts_tag_sec_select_list).select(@ts_sec_mode_wpa)
                @lan_iframe.text_field(id: @ts_tag_input_pw).set(@dut_ssid_pwd)
                @lan_iframe.button(id: @ts_tag_sbm).click #����
                sleep @tc_net_wait_time
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
