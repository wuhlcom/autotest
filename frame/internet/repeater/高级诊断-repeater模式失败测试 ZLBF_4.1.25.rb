#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.25", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time             = 3
        @tc_repeater_time         = 10
        @tc_ap_step_time          = 10
        @tc_net_wait_time         = 60
        @tc_diagnose_time         = 120
        @tc_net_time              = 120
        @tc_search_ssid_wait_time = 10
        @tc_net_start_wait_time   = 20
        @tc_wan_status            = "�쳣"
        @tc_ip_addr               = "ʧ��"
        @tc_loss_rate             = "100%"
        @tc_loss_rate_f           = "0%"
        @tc_dns_status            = "ʧ��"
        @tc_http_status           = "404"
        @tc_ap_wan_type_static    = "��̬IP"
        @tc_ap_wan_type_dhcp      = "DHCP�ͻ���"
        @tc_ap_id                 = "10.10.11.89"
        @tc_ap_mask               = "255.255.255.0"
        @tc_ap_gateway            = "10.11.11.1"
        @tc_ap_dns1               = "1.1.1.1"
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

        operate("1��������3G������������������ΪLAN�ڣ�����WIFI����Ϊ�м�ģʽ���м̵�ʱ����������ROOTAP���룬���и߼����") {
            @browser1 = Watir::Browser.new :ff, :profile => "default"
            @browser1.goto(@ts_tag_ap_url) #���뵽��¼����

            @browser1.button(id: @ts_ap_login_btn).click #��¼
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @ts_ap_wireless).click #��������2.4Gģ��
            #��ȡssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            #��ȡssid����
            @ssid_pwd     = @ap_frame.text_field(name: "pskValue").value
            @ssid_pwd_err = @ssid_pwd + "_err"
            p "APssid_pwd --> #{@ssid_pwd}"
            p "APssid_pwd_err --> #{@ssid_pwd_err}"

            5.times do #ѭ��5�δ���������
                @browser.refresh #ˢ�������
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
            end
            @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @ts_wireless_id).click #��������
            @wan_iframe.label(id: @ts_relay_id).click #ѡ���м�ģʽ
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
                    @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
                    @wan_iframe.span(id: @ts_wireless_id).click #��������
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
            select_pwd_click = @wan_iframe.text_field(id: @ts_net_pwd)
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
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.link(id: @ts_tag_diagnose).click #ϵͳ���
            sleep @tc_wait_time
            #��ȡ@browser�����¸������ڶ���ľ������
            @tc_handles = @browser.driver.window_handles
            assert(@tc_handles.size==2, "δ����ϴ���")
            #ͨ��������л���ͬ��windows����
            @browser.driver.switch_to.window(@tc_handles[1])
            # �򿪸߼����
            @browser.link(id: @ts_tag_ad_diagnose).click
            @browser.text_field(id: @ts_tag_url).wait_until_present(@tc_wait_time)
            @browser.text_field(id: @ts_tag_url).set(@ts_diag_web)
            @browser.button(id: @ts_tag_diag_btn).click
            Watir::Wait::until(@tc_diagnose_time, "�߼�������") {
                @browser.p(text: /#{@ts_tag_diag_nettype}/).present?
            }

            tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
            puts "�����������ͣ�#{tc_net_type}".to_gbk
            assert_match(/#{@tc_wan_dial_reg}/, tc_net_type, "�����������ʹ���")
            if @browser.p(text: /#{@ts_tag_net_status}/).exists?
                tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
                puts "WAN������״̬��#{tc_net_status}".to_gbk
                assert_equal(@tc_wan_status, tc_net_status, "��������״̬����")
            end
            tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
            puts "������#{@ts_diag_web}������Ϊ��#{tc_net_domain_ip}".to_gbk
            assert_equal(@tc_ip_addr, tc_net_domain_ip, "���������ɹ�")
            tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
            puts "��Ϲ��̶�����Ϊ��#{tc_loss_rate}".to_gbk
            assert_equal(@tc_loss_rate, tc_loss_rate, "��Ϲ��̶�����δ�ﵽ100%")
            tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
            puts "DNS����״̬��#{tc_dns_status}".to_gbk
            assert_equal(@tc_dns_status, tc_dns_status, "DNS�����ɹ�")
            tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
            puts "HTTP��Ӧ�룺#{tc_http_code}".to_gbk
            assert_equal(tc_http_code, @tc_http_status, "HTTP��Ӧ����")
        }

        operate("2��������ȷ��ROOTAP���룬����ROOTAP������Internet�����и߼����") {
            p "��������AP������Internet�����õķ��������þ�̬IP��������ʹ��IP��������ģ�ⲻ����Internet".to_gbk
            @browser1.goto(@ts_tag_ap_url) #���뵽��¼����
            @browser1.button(id: @ts_ap_login_btn).click #��¼
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @ts_ap_setting).click
            @ap_frame.button(name: @ts_manual_step_name).wait_until_present(@tc_wait_time)
            @ap_frame.button(name: @ts_manual_step_name).click
            select_wan_type = @ap_frame.select_list(name: @ts_ap_wan_type)
            select_wan_type.wait_until_present(@tc_wait_time)
            select_wan_type.select(@tc_ap_wan_type_static)
            @ap_frame.text_field(name: @ts_ap_ip_addr_static).wait_until_present(@tc_wait_time)
            @ap_frame.text_field(name: @ts_ap_ip_addr_static).set(@tc_ap_id)
            @ap_frame.text_field(name: @ts_ap_mask_static).set(@tc_ap_mask)
            @ap_frame.text_field(name: @ts_ap_gateway_static).set(@tc_ap_gateway)
            @ap_frame.text_field(name: @ts_ap_dns1_static).set(@tc_ap_dns1)
            @ap_frame.button(name: @ts_tag_ap_save).click
            sleep @tc_ap_step_time
            p "����AP������ϣ�".to_gbk

            unless @tc_handles.nil?
                @browser.driver.switch_to.window(@tc_handles[0])
            end
            5.times do #ѭ��5�δ���������
                @browser.refresh #ˢ�������
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
            end
            @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @ts_wireless_id).click #��������
            @wan_iframe.label(id: @ts_relay_id).click #ѡ���м�ģʽ
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
                    @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
                    @wan_iframe.span(id: @ts_wireless_id).click #��������
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
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.driver.switch_to.window(@tc_handles[1])
            # �򿪸߼����
            @browser.text_field(id: @ts_tag_url).set(@ts_diag_web)
            @browser.button(id: @ts_tag_diag_btn).click
            Watir::Wait::until(@tc_diagnose_time, "�߼�������") {
                @browser.p(text: /#{@ts_tag_diag_nettype}/).present?
            }

            tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
            puts "�����������ͣ�#{tc_net_type}".to_gbk
            assert_match(/#{@tc_wan_dial_reg}/, tc_net_type, "�����������ʹ���")
            if @browser.p(text: /#{@ts_tag_net_status}/).exists?
                tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
                puts "WAN������״̬��#{tc_net_status}".to_gbk
                assert_equal(@tc_wan_status, tc_net_status, "��������״̬����")
            end
            tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
            puts "������#{@ts_diag_web}������Ϊ��#{tc_net_domain_ip}".to_gbk
            assert_equal(@tc_ip_addr, tc_net_domain_ip, "���������ɹ�")
            tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
            puts "��Ϲ��̶�����Ϊ��#{tc_loss_rate}".to_gbk
            assert_equal(@tc_loss_rate_f, tc_loss_rate, "��Ϲ��̶�����δ�ﵽ100%")
            tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
            puts "DNS����״̬��#{tc_dns_status}".to_gbk
            assert_equal(@tc_dns_status, tc_dns_status, "DNS�����ɹ�")
            tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
            puts "HTTP��Ӧ�룺#{tc_http_code}".to_gbk
            assert_equal(tc_http_code, @tc_http_status, "HTTP��Ӧ�ɹ�")
        }


    end

    def clearup
        operate("�ָ�����AP���뷽ʽΪDHCP") {
            @browser1.goto(@ts_tag_ap_url) #���뵽��¼����
            @browser1.button(id: @ts_ap_login_btn).click #��¼
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @ts_ap_setting).click
            @ap_frame.button(name: @ts_manual_step_name).wait_until_present(@tc_wait_time)
            @ap_frame.button(name: @ts_manual_step_name).click
            select_wan_type = @ap_frame.select_list(name: @ts_ap_wan_type)
            select_wan_type.wait_until_present(@tc_wait_time)
            select_wan_type.select(@tc_ap_wan_type_dhcp)
            @ap_frame.button(name: @ts_tag_ap_save).click
            sleep @tc_ap_step_time
            @browser1.close #�ر������
        }

        operate("�ָ�Ĭ��DHCP����") {
            unless @tc_handles.nil?
                @browser.driver.switch_to.window(@tc_handles[0])
            end

            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            @browser.span(:id => @ts_tag_netset).click
            sleep @tc_wait_time
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
            #����WIRE WANΪDHCPģʽ
            dhcp_radio.click
            @wan_iframe.button(:id, @ts_tag_sbm).click
            puts "Waiting for net reset..."
            sleep @tc_net_time
        }

        operate("3���ָ�Ĭ��ssid") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            wifi_ssid   = @lan_iframe.text_field(id: @ts_tag_ssid).value
            unless wifi_ssid == @dut_ssid
                wifi_ssid.set(@dut_ssid)
                @lan_iframe.text_field(id: @ts_tag_ssid_pwd).set(@dut_ssid_pwd)
                @lan_iframe.button(id: @ts_tag_sbm).click
                net_reset_div = @wan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "����������������".to_gbk) {
                    net_reset_div.present?
                }
            end
        }
    end

}
