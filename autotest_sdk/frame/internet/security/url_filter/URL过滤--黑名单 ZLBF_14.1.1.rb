#
# description:
# author:liluping
# date:2015-09-16
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.1", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time                = 3
        @tc_net_wait_time            = 60
        @tc_tag_wire_mode_radio      = "ip_type_pppoe"
        @tc_tag_sbm                  = "submit_btn"
        @tc_tag_iframe_close         = "aui_close"
        @tc_tag_wire_mode_radio_dhcp = "ip_type_dhcp"
        @tc_tag_link_error           = "errorTitleText"
        @tc_tag_wan_mode_link        = "tab_ip"
        @tc_select_state             = "selected"
        @tc_tag_wan_mode_span        = "wire"

        # @tc_tag_options              = "options"
        @tc_tag_secseting            = "securitysetting"
        @tc_tag_fw_seting            = "Firewall-Settings"
        @tc_tag_url_setting          = "menu_set"
        @tc_tag_select               = "b_w_select"
        @tc_tag_select_black         = "opa"
        @tc_tag_select_white         = "opb"
        @tc_tag_select_text          = "b_w_url"
        @tc_tag_select_add_btn       = "add_btn"

        @tc_tag_fw_button         = "switch1"
        @tc_tag_url_button        = "switch4"
        @tc_tag_save_button       = "save_btn"
        @tc_tag_button_switch_off = "off"
        @tc_tag_button_switch_on  = "on"
        @tc_intset_list           = "intset_list"
        @tc_intset_list_black     = "black"
        @tc_intset_list_white     = "white"
        @tc_intset_list_cls       = "text"
        @tc_select_type           = "������"

        @tc_pppoe_usr       = 'pppoe@163.gd'
        @tc_pppoe_pw        = 'PPPOETEST'
        @tc_tag_pppoe_usrid = 'pppoeUser'
        @tc_tag_pppoe_pwid  = 'input_password1'
        @tc_tag_select_url  = 'www.yahoo.com'
        @tc_tag_url_baidu   = 'www.baidu.com'
        @tc_tag_url_sina    = 'www.sina.com.cn'
    end

    def process

        operate("1����½DUT��WAN��������ΪPPPoE��ʽ��") {
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time) #�ȴ�2s
            @browser.span(id: @ts_tag_netset).click

            @pop_iframe = @browser.iframe(src: @ts_tag_netset_src) #����壬�¶���
            assert(@pop_iframe.exists?, "����������ʧ�ܣ�")
            pppoe_radio       = @pop_iframe.radio(id: @tc_tag_wire_mode_radio)
            pppoe_radio_state = pppoe_radio.attribute_value(:checked)
            unless pppoe_radio_state == "true"
                pppoe_radio.click
            end
            sleep @tc_wait_time
            puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
            @pop_iframe.text_field(id: @tc_tag_pppoe_usrid).set(@tc_pppoe_usr)
            @pop_iframe.text_field(id: @tc_tag_pppoe_pwid).set(@tc_pppoe_pw)
            @pop_iframe.button(id: @tc_tag_sbm).click

            sleep @tc_wait_time
            net_reset_div = @pop_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
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

        operate("2���Ƚ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�URL���ǿ��أ����棻") {
            @browser.link(id: @ts_tag_options).click

            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            option_link       = @option_iframe.link(id: @tc_tag_secseting)
            option_link_state = option_link.attribute_value(:checked)
            unless option_link_state == "true"
                option_link.click
            end

            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "��������ǽ�ܿ��غ�URL���˿���".to_gbk
            btn_fw_off = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_off)
            if btn_fw_off.exists? #�ر�״̬�Ͳ��ٲ�����
                btn_fw_off.click
            end
            btn_url_off = @option_iframe.button(id: @tc_tag_url_button, class_name: @tc_tag_button_switch_off)
            if btn_url_off.exists?
                btn_url_off.click
            end

            @option_iframe.button(id: @tc_tag_save_button).click

        }

        operate("3������URL��������ҳ�棬ѡ�����������ӹ��˹ؼ���www.yahoo.com�����棻") {
            @option_iframe.link(id: @tc_tag_url_setting).wait_until_present(@tc_wait_time)
            option_url_iframe = @option_iframe.link(id: @tc_tag_url_setting)
            option_url_iframe.click

            puts "��ӹ��˹ؼ���".to_gbk
            select_click = @option_iframe.select_list(id: @tc_tag_select)
            select_click.select("������")
            #�������������
            url_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            if !url_arr.include?(@tc_tag_select_url)
                @option_iframe.text_field(id: @tc_tag_select_text).set(@tc_tag_select_url)
                @option_iframe.link(class_name: @tc_tag_select_add_btn).click
                @option_iframe.button(id: @tc_tag_save_button).click

                urlnew_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
                urlnew_arr = urlnew_str.split("\n")

                sleep 2
                assert(urlnew_arr.include?(@tc_tag_select_url), "error-->��ӹؼ���#{@tc_tag_select_url}���ɹ���")
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }


        operate("4��PC1,PC2�Ƿ���Է���www.sina.com.cn��www.yahoo.cn��www.baidu.com��վ�㡣") {
            puts "���ڷ���#{@tc_tag_url_baidu}վ��...".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "���������˹�������#{@tc_tag_url_baidu}���������Է���#{@tc_tag_url_baidu}".to_gbk)

            puts "���ڷ���#{@tc_tag_url_sina}վ��...".to_gbk
            response = send_http_request(@tc_tag_url_sina)
            assert(response, "���������˹�������#{@tc_tag_url_sina}�������Է���#{@tc_tag_url_sina}".to_gbk)

            puts "���ڷ���#{@tc_tag_select_url}վ��...".to_gbk
            response = send_http_request(@tc_tag_select_url)
            assert(!response, "���������˹�������#{@tc_tag_select_url}�����Է���#{@tc_tag_select_url}".to_gbk)
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
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2 �رշ���ǽ�ܿ��غ�URL���˿���") {
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser) #���µ�¼
            end
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_security).click #���밲ȫ����
            @option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
            # @option_iframe.link(id: @ts_tag_fwset).click #����ǽ����
            switch_flag = false
            @option_iframe.button(id: @ts_tag_security_sw).wait_until_present(@tc_wait_time)
            if @option_iframe.button(id: @ts_tag_security_sw).class_name == "on"
                @option_iframe.button(id: @ts_tag_security_sw).click
                switch_flag = true
            end
            if @option_iframe.button(id: @ts_tag_security_url).class_name == "on"
                @option_iframe.button(id: @ts_tag_security_url).click
                switch_flag = true
            end
            if switch_flag
                @option_iframe.button(id: @ts_tag_security_save).click #����
                sleep @tc_wait_time
            end

        }

        operate("3 ���������") {
            @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_url_set).click
            b_select = @option_iframe.select_list(id: @ts_url_black) #ѡ�������
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)
            url_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            #��Ҫģ������ƶ�������Ŀ��(�ڸ���Ŀ�����������)������ʵʩɾ������
            begin
                unless url_arr.empty?
                    url_arr.each do |url|
                        puts "ɾ��������:#{url}".to_gbk
                        @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
                        delete_btn = @option_iframe.span(text: url, class_name: @tc_intset_list_cls).parent.link(class_name: "delete")
                        sleep 1 #�ӳ�1s
                        for n in 0..3
                            if delete_btn.exists?
                                delete_btn.click
                                break
                            end
                            @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
                            sleep 1 #�ӳ�1s
                        end
                        # delete_btn.click
                        sleep @tc_wait_time
                    end
                end
            ensure
                @option_iframe.button(id: @ts_tag_security_save).click #����
                sleep @tc_wait_time
            end
        }
    end

}
