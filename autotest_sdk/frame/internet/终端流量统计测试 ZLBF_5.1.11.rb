#
# description:
# author:liluping
# date:2015-09-28
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.11", "level" => "P1", "auto" => "n"}
    def prepare
        DRb.start_service
        @tc_dumpcap                     = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time                   = 2
        @tc_net_wait_time               = 60
        @tc_tag_wan_mode_link           = "tab_ip"
        @tc_tag_wire_mode_radio         = "ip_type_dhcp"
        @tc_tag_vedio_url               = "www.iqiyi.com"
        @tc_tag_traffic_info            = "traffic_info"
        @tc_terminal_traffic_statistics = "terminal-titile"
        @tc_chart_color1                = "chart_color color1"
        @tc_chart_color2                = "chart_color color2"
        @tc_traffic_titile              = "traffic-titile"
        @tc_tag_link_error              = "errorTitleText"
        @tc_traffic_cls                 = "box setup_box"
        @tc_tag_wan_mode_link           = "tab_ip"
        @tc_select_state                = "selected"
        @tc_tag_wan_mode_span           = "wire"
        @tc_tag_wire_mode_radio_dhcp    = "ip_type_dhcp"

        @ssid_pwd             = "12345678"
        @tc_net_status        = "setstatus"
        @tc_dut_wifi_ssid     = "ssid"
        @tc_dut_wifi_ssid_pwd = "input_password1"
    end

    def process
        puts "����֪���ýű�ֻ�ж��ն�����ͳ����Ϣ�Ƿ�׼ȷ��δ�ж�����������ͼ��ʾ�Ƿ���ȷ".to_gbk
        operate("1������APͨ��WAN���ӵ�����������Ӷ�̨���ߣ�����PC���ʼǱ����ֻ���ipad���豸��") {
            @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time) #�ȴ�2s
            @browser.span(id: @ts_tag_lan).click

            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "����������ʧ�ܣ�")
            p "��ȡDUT��ssid".to_gbk
            @dut_ssid = @lan_iframe.text_field(id: @tc_dut_wifi_ssid).value
            p "DUTssid --> #{@dut_ssid}".to_gbk
            @dut_ssid_pwd = @lan_iframe.text_field(id: @tc_dut_wifi_ssid_pwd).value
            p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2����dut����
            p "PC2����wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap.connect(@dut_ssid, flag, @dut_ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi����ʧ��".to_gbk)

            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time) #�ȴ�2s
            @browser.span(id: @ts_tag_netset).click

            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src) #����壬�¶���
            assert(@wan_iframe.exists?, "����������ʧ�ܣ�")

            @wan_iframe.link(:id => @tc_tag_wan_mode_link).click #ѡ����������
            dhcp_radio = @wan_iframe.radio(id: @tc_tag_wire_mode_radio)

            unless dhcp_radio.checked?
                dhcp_radio.click
            end

            #����
            @wan_iframe.button(:id, @ts_tag_sbm).click

            sleep @tc_wait_time
            net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.until(@tc_wait_time, "�ȴ�����������ʾ����".to_gbk) {
                net_reset_div.visible?
            }
            Watir::Wait.while(@tc_net_wait_time, "����������������".to_gbk) {
                net_reset_div.present?
            }

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2��������PC��ipad������Ƶ�㲥�����������ն�ֻ���Ӳ��������鿴�ն�����ͳ����Ϣ�Ƿ�׼ȷ������ÿ���ն˵��ϴ������������������ն��ϴ�����������������ͼ�Ƿ���ʾ��ȷ��") {
            #�鿴ʵʱ�����仯
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            option_link = @option_iframe.link(id: @tc_traffic_titile)
            option_link.click


            @option_iframe.link(id: @tc_terminal_traffic_statistics).wait_until_present(@tc_wait_time)
            option_tra_iframe = @option_iframe.link(id: @tc_terminal_traffic_statistics)
            option_tra_iframe.click #�ն�����ͳ��

            @option_iframe.div(class_name: @tc_traffic_cls).wait_until_present(@tc_wait_time)
            assert(@option_iframe.div(class_name: @tc_traffic_cls).exists?, "���ն�����ͳ��ʧ��")

            c1_start_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[0].text
            c1_start_traffic_inf =~ /\u4E0A\u4F20: (.+[MB|KB]) \u4E0B\u8F7D: (.+[MB|KB])/i
            c1_start_uploading = $1
            c1_start_download  = $2
            puts "�豸1�㲥ǰ��ʵʱ����Ϊ���ϴ���#{c1_start_uploading}�����أ�#{c1_start_download}".to_gbk
            c2_start_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[1].text
            c2_start_traffic_inf =~ /\u4E0A\u4F20: (.+[MB|KB]) \u4E0B\u8F7D: (.+[MB|KB])/i
            c2_start_uploading = $1
            c2_start_download  = $2
            puts "�豸2�㲥ǰ��ʵʱ����Ϊ���ϴ���#{c2_start_uploading}�����أ�#{c2_start_download}".to_gbk

            if c1_start_uploading.include?("MB")
                c1_start_uploading = (c1_start_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c1_start_uploading = c1_start_uploading.slice(/\d+\.\d+|\d+/).to_f
            end
            if c1_start_download.include?("MB")
                c1_start_download = (c1_start_download.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c1_start_download = c1_start_download.slice(/\d+\.\d+|\d+/).to_f
            end
            if c2_start_uploading.include?("MB")
                c2_start_uploading = (c2_start_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c2_start_uploading = c2_start_uploading.slice(/\d+\.\d+|\d+/).to_f
            end
            if c2_start_download.include?("MB")
                c2_start_download = (c2_start_download.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c2_start_download = c2_start_download.slice(/\d+\.\d+|\d+/).to_f
            end

            #���ϵͳ��ϵ���һ���´��ڣ�����������Ƶ�㲥
            sleep @tc_wait_time

            #open diagnose
            @browser.link(id: @ts_tag_diagnose).click()
            sleep @tc_wait_time
            #��ȡ@browser�����¸������ڶ���ľ������
            @tc_handles = @browser.driver.window_handles
            assert(@tc_handles.size==2, "δ����ϴ���")
            #ͨ��������л���ͬ��windows����
            @browser.driver.switch_to.window(@tc_handles[1]) #�л���ϵͳ��ϴ���

            @browser.goto(@tc_tag_vedio_url)
            judge = @browser.h1(id: @tc_tag_link_error).exists?
            assert(!judge, "�޷���½#{@tc_tag_vedio_url}�����㲥")

            @browser.ul(class_name: "txt-item fl").lis[0].span(class_name: "txt").click
            sleep @tc_wait_time
            assert(@browser.driver.window_handles.size==3, "δ�򿪵㲥����")

            sleep @tc_net_wait_time
            @browser.driver.switch_to.window(@tc_handles[0]) #�л���ʵʱ����ͳ�ƴ���

            @option_iframe.link(id: @tc_terminal_traffic_statistics).wait_until_present(@tc_wait_time)
            option_tra_iframe = @option_iframe.link(id: @tc_terminal_traffic_statistics)
            option_tra_iframe.click #����ն�����ͳ������ˢ������
            @option_iframe.div(class_name: @tc_traffic_cls).wait_until_present(@tc_wait_time)
            assert(@option_iframe.div(class_name: @tc_traffic_cls).exists?, "���ն�����ͳ��ʧ��")

            c1_end_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[0].text
            c1_end_traffic_inf =~ /\u4E0A\u4F20: (.+[MB|KB]) \u4E0B\u8F7D: (.+[MB|KB])/i
            c1_end_uploading = $1
            c1_end_download  = $2
            puts "�豸1�㲥���ʵʱ����Ϊ���ϴ���#{c1_end_uploading}�����أ�#{c1_end_download}".to_gbk
            c2_end_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[1].text
            c2_end_traffic_inf =~ /\u4E0A\u4F20: (.+[MB|KB]) \u4E0B\u8F7D: (.+[MB|KB])/i
            c2_end_uploading = $1
            c2_end_download  = $2
            puts "�豸2ֻ���Ӳ��㲥���ʵʱ����Ϊ���ϴ���#{c2_end_uploading}�����أ�#{c2_end_download}".to_gbk
            if c1_end_uploading.include?("MB")
                c1_end_uploading = (c1_end_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c1_end_uploading = c1_end_uploading.slice(/\d+\.\d+|\d+/).to_f
            end
            if c1_end_download.include?("MB")
                c1_end_download = (c1_end_download.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c1_end_download = c1_end_download.slice(/\d+\.\d+|\d+/).to_f
            end
            if c2_end_uploading.include?("MB")
                c2_end_uploading = (c2_end_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c2_end_uploading = c2_end_uploading.slice(/\d+\.\d+|\d+/).to_f
            end
            if c2_end_download.include?("MB")
                c2_end_download = (c2_end_download.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c2_end_download = c2_end_download.slice(/\d+\.\d+|\d+/).to_f
            end

            # p c1_end_uploading
            # p c1_start_uploading
            c1up_d_value   = c1_end_uploading - c1_start_uploading
            c1down_d_value = c1_end_download - c1_start_download
            #�㲥���ϴ�����������С�����ܲ��䣬��[0,100)KB��Χ����Ϊ��������
            assert(c1up_d_value>=0 && c1up_d_value<100, "�豸1���е㲥��ʵʱ�ϴ�����δ��[0,100)��Χ���㲥ǰ#{c1_start_uploading},�㲥��#{c1_end_uploading}")
            assert(c1down_d_value > 0, "�豸1���е㲥��ʵʱ���������ޱ仯���㲥ǰ#{c1_start_download},�㲥��#{c1_end_download}")

            c2up_d_value   = c2_end_uploading - c2_start_uploading
            c2down_d_value = c2_end_download - c2_start_download
            #ֻ���Ӳ�����ʱ��Ҳ����С��Χ���������������������һ����Χ�ھ����������仯
            assert((c2up_d_value>=0 && c2up_d_value<100), "�豸2ֻ���Ӳ����е㲥��ʵʱ�ϴ������б仯���仯ǰ#{c2_start_uploading},�仯��#{c2_end_uploading}")
            assert((c2down_d_value>=0 && c2down_d_value<100), "�豸2ֻ���Ӳ����е㲥��ʵʱ���������б仯���仯ǰ#{c2_start_download},�仯��#{c2_end_download}")
        }

        operate("3����ÿ���ն��϶�������������ҵ�񣬲鿴�ն�����ͳ����Ϣ�Ƿ�׼ȷ������ÿ���ն˵��ϴ������������������ն��ϴ�����������������ͼ�Ƿ���ʾ��ȷ��") {
            sleep @tc_wait_time
            @browser.driver.switch_to.window(@tc_handles[0]) #�л���ʵʱ����ͳ�ƴ���
            @option_iframe.link(id: @tc_terminal_traffic_statistics).wait_until_present(@tc_wait_time)
            option_tra_iframe = @option_iframe.link(id: @tc_terminal_traffic_statistics)
            option_tra_iframe.click #����ն�����ͳ������ˢ������
            @option_iframe.div(class_name: @tc_traffic_cls).wait_until_present(@tc_wait_time)
            assert(@option_iframe.div(class_name: @tc_traffic_cls).exists?, "���ն�����ͳ��ʧ��")

            c1_start_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[0].text
            c1_start_traffic_inf =~ /\u4E0A\u4F20: (.+[MB|KB]) \u4E0B\u8F7D: (.+[MB|KB])/i
            c1_start_uploading = $1
            c1_start_download  = $2
            puts "�豸1�㲥ǰ��ʵʱ����Ϊ���ϴ���#{c1_start_uploading}�����أ�#{c1_start_download}".to_gbk
            c2_start_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[1].text
            c2_start_traffic_inf =~ /\u4E0A\u4F20: (.+[MB|KB]) \u4E0B\u8F7D: (.+[MB|KB])/i
            c2_start_uploading = $1
            c2_start_download  = $2
            puts "�豸2�㲥ǰ��ʵʱ����Ϊ���ϴ���#{c2_start_uploading}�����أ�#{c2_start_download}".to_gbk

            if c1_start_uploading.include?("MB")
                c1_start_uploading = (c1_start_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c1_start_uploading = c1_start_uploading.slice(/\d+\.\d+|\d+/).to_f
            end
            if c1_start_download.include?("MB")
                c1_start_download = (c1_start_download.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c1_start_download = c1_start_download.slice(/\d+\.\d+|\d+/).to_f
            end
            if c2_start_uploading.include?("MB")
                c2_start_uploading = (c2_start_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c2_start_uploading = c2_start_uploading.slice(/\d+\.\d+|\d+/).to_f
            end
            if c2_start_download.include?("MB")
                c2_start_download = (c2_start_download.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c2_start_download = c2_start_download.slice(/\d+\.\d+|\d+/).to_f
            end


            @browser.driver.switch_to.window(@tc_handles[1]) #�л����㲥����
            @browser.ul(class_name: "txt-item fl").lis[0].span(class_name: "txt").click #�豸1�����㲥
            sleep @tc_wait_time
            @tc_dumpcap.login_vedio(@tc_tag_vedio_url) #�豸2�����㲥


            sleep @tc_net_wait_time
            @browser.driver.switch_to.window(@tc_handles[0]) #�л���ʵʱ����ͳ�ƴ���

            @option_iframe.link(id: @tc_terminal_traffic_statistics).wait_until_present(@tc_wait_time)
            option_tra_iframe = @option_iframe.link(id: @tc_terminal_traffic_statistics)
            option_tra_iframe.click #����ն�����ͳ������ˢ������
            @option_iframe.div(class_name: @tc_traffic_cls).wait_until_present(@tc_wait_time)
            assert(@option_iframe.div(class_name: @tc_traffic_cls).exists?, "���ն�����ͳ��ʧ��")

            c1_end_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[0].text
            c1_end_traffic_inf =~ /\u4E0A\u4F20: (.+[MB|KB]) \u4E0B\u8F7D: (.+[MB|KB])/i
            c1_end_uploading = $1
            c1_end_download  = $2
            puts "�豸1�㲥���ʵʱ����Ϊ���ϴ���#{c1_end_uploading}�����أ�#{c1_end_download}".to_gbk
            c2_end_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[1].text
            c2_end_traffic_inf =~ /\u4E0A\u4F20: (.+[MB|KB]) \u4E0B\u8F7D: (.+[MB|KB])/i
            c2_end_uploading = $1
            c2_end_download  = $2
            puts "�豸2�㲥���ʵʱ����Ϊ���ϴ���#{c2_end_uploading}�����أ�#{c2_end_download}".to_gbk
            if c1_end_uploading.include?("MB")
                c1_end_uploading = (c1_end_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c1_end_uploading = c1_end_uploading.slice(/\d+\.\d+|\d+/).to_f
            end
            if c1_end_download.include?("MB")
                c1_end_download = (c1_end_download.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c1_end_download = c1_end_download.slice(/\d+\.\d+|\d+/).to_f
            end
            if c2_end_uploading.include?("MB")
                c2_end_uploading = (c2_end_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c2_end_uploading = c2_end_uploading.slice(/\d+\.\d+|\d+/).to_f
            end
            if c2_end_download.include?("MB")
                c2_end_download = (c2_end_download.slice(/\d+\.\d+|\d+/).to_f)*1024
            else
                c2_end_download = c2_end_download.slice(/\d+\.\d+|\d+/).to_f
            end

            c1up_d_value   = c1_end_uploading - c1_start_uploading
            c1down_d_value = c1_end_download - c1_start_download
            #�㲥���ϴ�����������С�����ܲ��䣬��[0,100)KB��Χ����Ϊ��������
            assert(c1up_d_value>=0 && c1up_d_value<100, "�豸1���е㲥��ʵʱ�ϴ�����δ��[0,100)��Χ���㲥ǰ#{c1_start_uploading},�㲥��#{c1_end_uploading}")
            assert(c1down_d_value > 0, "�豸1���е㲥��ʵʱ���������ޱ仯���㲥ǰ#{c1_start_download},�㲥��#{c1_end_download}")

            c2up_d_value   = c2_end_uploading - c2_start_uploading
            c2down_d_value = c2_end_download - c2_start_download
            #�㲥���ϴ�����������С�����ܲ��䣬��[0,100)KB��Χ����Ϊ��������
            assert(c2up_d_value>=0 && c2up_d_value<100, "�豸2���е㲥��ʵʱ�ϴ�����δ��[0,100)��Χ���㲥ǰ#{c2_start_uploading},�㲥��#{c2_end_uploading}")
            assert(c2down_d_value>0, "�豸2���е㲥��ʵʱ���������ޱ仯���㲥ǰ#{c2_start_download},�㲥��#{c2_end_download}")
        }


    end

    def clearup
        operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
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

            p "�Ͽ�wifi����".to_gbk
            @tc_dumpcap.netsh_disc_all #�Ͽ�wifi����
        }
    end

}
