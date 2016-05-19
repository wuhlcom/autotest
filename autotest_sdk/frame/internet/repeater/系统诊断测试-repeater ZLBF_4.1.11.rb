#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.11", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_diagnose_time                  = 120
        @tc_wait_time                      = 3
        @tc_search_ssid_wait_time          = 10
        @tc_net_start_wait_time            = 20
        @tc_net_wait_time                  = 60
        @tc_ap_wireless_pattern_value      = "802.11b/g/n"
        @tc_ap_channel_value               = "11"
        @tc_ap_bandwidth_value             = "Auto 20/40M"
        @tc_ap_safe_option_value           = "WPA-PSK/WPA2-PSK AES"
        @tc_tag_wan_mode_link              = "tab_ip"
        @tc_select_state                   = "selected"
        @tc_tag_wan_mode_span              = "wire"
        @tc_tag_wire_mode_radio_dhcp       = "ip_type_dhcp"
        @ap_wireless_pattern_default_value = "802.11b/g/n"
        @ap_channel_auto                   = "11"
        @ap_bandwidth_default_value        = "Auto 20/40M"
        @ap_safe_option_default_value      = "��"
    end

    def process
        operate("-1����ȡdut��ssid������") {
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

        operate("0�����APʹ��Atheros����������Internet������ģʽΪb/g/n���ŵ�ָ��ΪCH11��Ƶ������Ϊ40MƵ������ΪWPA-AES.") {
            @browser1 = Watir::Browser.new :ff, :profile => "default"
            @browser1.goto(@ts_tag_ap_url) #���뵽��¼����

            @browser1.button(id: @ts_ap_login_btn).click #��¼
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)

            @ap_frame.link(href: @ts_ap_status).click #����״̬ģ��
            sleep @tc_wait_time
            @ap_lan_ip = @ap_frame.div(id: @ts_main_content).tables[3].trs[1][0].tables[0].trs[0][1].text
            p "AP��LAN��ip��#{@ap_lan_ip}".to_gbk
            assert(!@ap_lan_ip.nil?, "AP��LAN��ip��ȡʧ�ܣ�")
            @ap_frame.link(href: @ts_ap_wireless).click #��������2.4Gģ��

            select_pattern = @ap_frame.select_list(name: @ts_ap_wireless_pattern) #ѡ������ģʽ
            select_pattern.wait_until_present(@tc_wait_time)
            select_pattern.select(@tc_ap_wireless_pattern_value)

            select_channel = @ap_frame.select_list(name: @ts_ap_channel) #ѡ���ŵ�
            select_channel.wait_until_present(@tc_wait_time)
            select_channel.select(@tc_ap_channel_value)

            select_bandwidth = @ap_frame.select_list(name: @ts_ap_bandwidth) #ѡ�����
            select_bandwidth.wait_until_present(@tc_wait_time)
            select_bandwidth.select(@tc_ap_bandwidth_value)

            select_safe_option = @ap_frame.select_list(id: @ts_ap_safe_option) #ѡ��ȫѡ��
            select_safe_option.wait_until_present(@tc_wait_time)
            select_safe_option.select(@tc_ap_safe_option_value)

            #��ȡssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            #��ȡssid����
            @ssid_pwd = @ap_frame.text_field(name: "pskValue").value
            p "APssid_pwd --> #{@ssid_pwd}"
            @ap_frame.button(name: @ts_tag_ap_save).click #Ӧ�ð�ť

            loading_div = @ap_frame.div(id: @ts_ap_save_hint)
            Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                loading_div.present?
            }
        }

        operate("1��������������Ϊ�м�ģʽ��ɨ��һ����������������AP�������ӣ�������ȷ���������ӳɹ���") {
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #��¼��ˢ�������
            end
            5.times do #ѭ��5�δ���������
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
                @browser.refresh #ˢ�������
            end
            @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @tc_wireless_id).click #��������
            @wan_iframe.label(id: @tc_relay_id).click #ѡ���м�ģʽ
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
                    @wan_iframe.label(id: @tc_relay_id).click #ѡ���м�ģʽ
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
            sleep @tc_net_start_wait_time #�м��Ϻ󣬵ȴ�һ��ʱ���ٲ鿴�����AP�Ƿ�����ɹ�
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2�����ϵͳ��ϣ��鿴��Ͻ����") {
            @browser.link(id: @ts_tag_diagnose).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_tag_diagnose).click
            #��ȡ@browser�����¸������ڶ���ľ������
            @tc_handles = @browser.driver.window_handles
            assert(@tc_handles.size==2, "δ����ϴ���")
            #ͨ��������л���ͬ��windows����
            @browser.driver.switch_to.window(@tc_handles[1]) #�л���ϵͳ��ϴ���
            Watir::Wait::until(@tc_diagnose_time, "ϵͳ������") {
                @browser.h1(text: /#{@ts_tag_diag_fini_success}|#{@ts_tag_diag_fini_fail}/).present?
            }

            @browser.span(id: @ts_tag_diag_internet_status).wait_until_present(@tc_wait_time)
            net_status = @browser.span(id: @ts_tag_diag_internet_status).text
            assert_equal(net_status, "\u6B63\u5E38", "��������״̬������!")
            @browser.span(id: @ts_tag_diag_netspeed_status).wait_until_present(@tc_wait_time)
            net_speed_status = @browser.span(id: @ts_tag_diag_netspeed_status).text
            assert_equal(net_speed_status, "\u6B63\u5E38", "�����������ʲ�����!")
        }

        operate("3��ɨ��һ������AP�������ӣ�������������������ӣ�ʹ���Ӳ��ɹ���") {
            @browser.driver.switch_to.window(@tc_handles[0]) #�л���dut����
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #��¼��ˢ�������
            end
            5.times do #ѭ��5�δ���������
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
                @browser.refresh #ˢ�������
            end
            @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @tc_wireless_id).click #��������
            @wan_iframe.label(id: @tc_relay_id).click #ѡ���м�ģʽ
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
                    @wan_iframe.label(id: @tc_relay_id).click #ѡ���м�ģʽ
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
                select_pwd_click.set(@ssid_pwd+"1") #��������ap  ssid����
                @wan_iframe.checkbox(id: @ts_pwdshow2).click #��ʾ����
            end
            @wan_iframe.button(id: @ts_tag_sbm).click #����
            sleep @tc_wait_time
            net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "����������������".to_gbk) {
                net_reset_div.present?
            }
            sleep @tc_net_start_wait_time #�м��Ϻ󣬵ȴ�һ��ʱ���ٲ鿴�����AP�Ƿ�����ɹ�
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("4�����ϵͳ��ϣ��鿴��Ͻ����") {
            @browser.link(id: @ts_tag_diagnose).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_tag_diagnose).click
            #��ȡ@browser�����¸������ڶ���ľ������
            @tc_handles = @browser.driver.window_handles
            assert(@tc_handles.size==3, "δ����ϴ���")
            #ͨ��������л���ͬ��windows����
            @browser.driver.switch_to.window(@tc_handles[2]) #�л���ϵͳ��ϴ���
            Watir::Wait::until(@tc_diagnose_time, "ϵͳ������") {
                @browser.h1(text: /#{@ts_tag_diag_fini_success}|#{@ts_tag_diag_fini_fail}/).present?
            }

            @browser.span(id: @ts_tag_diag_internet_status).wait_until_present(@tc_wait_time)
            net_status = @browser.span(id: @ts_tag_diag_internet_status).text
            assert_equal(net_status, "\u5F02\u5E38", "��������״̬����!")
            p @browser.span(id: @ts_tag_diag_internet_status).parent.parent.text.to_gbk
            @browser.span(id: @ts_tag_diag_netspeed_status).wait_until_present(@tc_wait_time)
            net_speed_status = @browser.span(id: @ts_tag_diag_netspeed_status).text
            p @browser.span(id: @ts_tag_diag_netspeed_status).parent.parent.text.to_gbk
            assert_equal(net_speed_status, "\u5F02\u5E38", "����������������!")
        }

        # operate("5��ɨ�貢����һ������������AP�����ӳɹ������ϵͳ��ϣ��鿴��Ͻ����") {
        #
        # }


    end

    def clearup
        operate("�ָ�Ĭ������") {
            begin
                p "�ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����".to_gbk
                @tc_handles = @browser.driver.window_handles
                if @tc_handles.size > 1
                    @browser.driver.switch_to.window(@tc_handles[0])
                end
                unless @browser.span(:id => @ts_tag_netset).exists?
                    login_no_default_ip(@browser)
                end

                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe

                flag = false
                #����wan���ӷ�ʽΪ��������
                rs1  = @wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
                unless rs1 =~/ #{@tc_select_state}/
                    @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
                    flag = true
                end

                #��ѯ�Ƿ�ΪΪdhcpģʽ
                dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio_dhcp)
                dhcp_radio_state = dhcp_radio.checked?

                #����WIRE WANΪDHCPģʽ
                unless dhcp_radio_state
                    dhcp_radio.click
                    flag = true
                end

                if flag
                    @wan_iframe.button(:id, @ts_tag_sbm).click
                    puts "Waiting for net reset..."
                    sleep @tc_net_wait_time
                end

                if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                    @browser.execute_script(@ts_close_div)
                end

                p "�ָ�dut��ssid".to_gbk
                @browser.span(id: @ts_tag_lan).click
                @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
                sleep @tc_wait_time
                unless @lan_iframe.text_field(id: @ts_tag_ssid, name: @ts_tag_ssid).value == @dut_ssid
                    @lan_iframe.text_field(id: @ts_tag_ssid, name: @ts_tag_ssid).set(@dut_ssid)
                    @lan_iframe.text_field(id: @ts_tag_input_pw).set(@dut_ssid_pwd)
                    @lan_iframe.button(id: @ts_tag_sbm).click #����
                    sleep @tc_net_wait_time
                end

                if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                    @browser.execute_script(@ts_close_div)
                end


                p "�ָ�AP·��������Ĭ������".to_gbk
                @browser1.goto(@ts_tag_ap_url) #���뵽��¼����
                @browser1.button(id: @ts_ap_login_btn).click #��¼
                sleep @tc_wait_time
                @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
                @ap_frame.link(href: @ts_ap_wireless).wait_until_present(@tc_net_wait_time)
                @ap_frame.link(href: @ts_ap_wireless).click #��������2.4Gģ��
                @ap_frame.select_list(name: @ts_ap_wireless_pattern).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(name: @ts_ap_wireless_pattern).select(@ap_wireless_pattern_default_value) #ѡ������ģʽ
                @ap_frame.select_list(name: @ts_ap_channel).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(name: @ts_ap_channel).select(@ap_channel_auto) #ѡ���ŵ�
                @ap_frame.select_list(name: @ts_ap_bandwidth).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(name: @ts_ap_bandwidth).select(@ap_bandwidth_default_value) #ѡ�����
                @ap_frame.select_list(id: @ts_ap_safe_option).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(id: @ts_ap_safe_option).select(@ap_safe_option_default_value) #ѡ��ȫѡ��
                @ap_frame.button(name: @ts_tag_ap_save).click #Ӧ�ð�ť

                loading_div = @ap_frame.div(id: @ts_ap_save_hint)
                Watir::Wait.while(@tc_net_wait_time, "���ڱ�������".to_gbk) {
                    loading_div.present?
                }
            ensure
                @browser1.close
            end
        }
    end

}
