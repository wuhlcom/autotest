#
#description:#
# ���������Ĳ��Ե�̫�̫࣬�����ӣ��Զ�������ʵ��
# ʵ����Ҳ������ά���ɱ�
# ��������ֺ���ʵ��
# ʵ����dhcp,pppoe,static���뷽ʽ�л�ʱwan״̬��ʾ
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.22", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time  = 5
        @tc_input_time = 2
        @tc_net_time   = 50
    end

    def process

        operate("1 ��������������") {
        }

        operate("2 �����������뷽ʽΪ��DHCP") {
            #�鿴WAN���뷽ʽ�Ƿ�ΪDHCP
            @browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_status).click
            sleep @tc_wait_time
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            #�������DHCP���޸�ΪDHCP
            unless wan_type =~ /#{@ts_wan_mode_dhcp}/
                puts "�л�ΪDHCP���뷽ʽ".to_gbk
                if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                    @browser.execute_script(@ts_close_div)
                end
                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                assert(@wan_iframe.exists?, "����������ʧ��")
                @wan_iframe.link(:id => @ts_tag_wired_mode_link).click #ѡ����������
                dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
                dhcp_radio.click
                #�������ã��л�ΪDHCPģʽ
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "sleep #{@tc_net_time} second for net reseting..."
                sleep @tc_net_time
            end
        }

        operate("3 �鿴DHCP����ʱWAN״̬") {
            #�ر�WAN����
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            assert(@status_iframe.exists?, '��WAN״̬ʧ�ܣ�')

            wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_addr =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

            wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            wan_type =~/(#{@ts_wan_mode_dhcp})/
            puts "WAN״̬��ʾ��������Ϊ��#{Regexp.last_match(1)}".to_gbk

            mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            mask =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ�������ַΪ��#{Regexp.last_match(1)}".to_gbk

            gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            gateway_addr =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ������IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

            dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            dns_addr =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ��DNS IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp��ȡip��ַʧ�ܣ�'
            assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, 'dhcp��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'dhcp��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, 'dhcp��ȡdns ip��ַʧ�ܣ�'
        }

        operate("4 �޸Ľ��뷽ʽΪPPPOE") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            wanset = @browser.span(:id => @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_netset).click if wanset
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "����������ʧ�ܣ�")

            rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
            unless rs1 =~/#{@ts_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
            end

            pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
            pppoe_radio_state = pppoe_radio.checked?
            unless pppoe_radio_state
                pppoe_radio.click
                @wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
                @wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
                @wan_iframe.button(:id, @ts_tag_sbm).click
                # Watir::Wait.until(@tc_wait_time, "�ȴ�����������ʾ����".to_gbk) {
                # 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
                # }
                # Watir::Wait.while(@tc_net_time, "����������������".to_gbk) {
                # 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present?
                # }
                sleep @tc_net_time
            end
        }

        operate("5 �鿴PPPOE����ʱWAN״̬") {
            #�ر�WAN����
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            assert(@status_iframe.exists?, '��WAN״̬ʧ�ܣ�')
            wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_addr =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

            wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            wan_type =~/(#{@ts_wan_mode_pppoe})/
            puts "WAN״̬��ʾ��������Ϊ��#{Regexp.last_match(1)}".to_gbk

            mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            mask =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ�������ַΪ��#{Regexp.last_match(1)}".to_gbk

            gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            gateway_addr =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ������IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

            dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            dns_addr =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ��DNS IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�'
        }

        operate("6 ���ý��뷽ʽΪStatic") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            wanset = @browser.span(:id => @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_netset).click if wanset
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "����������ʧ�ܣ�")

            rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
            unless rs1 =~/#{@ts_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
            end

            static_radio       = @wan_iframe.radio(id: @ts_tag_wired_static)
            static_radio_state = static_radio.checked?
            unless static_radio_state
                static_radio.click
            end

            puts "���þ�̬IP��ַΪ��#{@ts_staticIp}".to_gbk
            @wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
            @wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
            @wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
            @wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
            sleep @tc_input_time
            if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
                @wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
            end
            @wan_iframe.button(:id, @ts_tag_sbm).click
            # Watir::Wait.until(@tc_wait_time, "�ȴ�����������ʾ����".to_gbk) {
            # 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
            # }
            # Watir::Wait.while(@tc_net_time, "����������������".to_gbk) {
            # 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present?
            # }
            sleep @tc_net_time
        }

        operate("7 ��̬����ʱ�鿴WAN״̬") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            assert(@status_iframe.exists?, '��WAN״̬ʧ�ܣ�')
            wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_addr =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

            wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            wan_type =~/(#{@ts_wan_mode_static})/
            puts "WAN״̬��ʾ��������Ϊ��#{Regexp.last_match(1)}".to_gbk

            mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            mask =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ�������ַΪ��#{Regexp.last_match(1)}".to_gbk

            gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            gateway_addr =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ������IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

            dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            dns_addr =~@ts_tag_ip_regxp
            puts "WAN״̬��ʾ��DNS IP��ַΪ��#{Regexp.last_match(1)}".to_gbk
            assert_match @ts_tag_ip_regxp, wan_addr, '��̬ip����ʧ�ܣ�'
            assert_match /#{@ts_wan_mode_static}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, '��̬ip��������ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, '��̬��������ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, '��̬����dns ip��ַʧ�ܣ�'
        }


    end

    def clearup

        operate("1 �ָ�Ĭ�ϵĽ��뷽ʽ") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end

            wanset = @browser.span(:id => @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_netset).click if wanset
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)

            rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
            unless rs1 =~/#{@ts_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
            end

            dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
            dhcp_radio_state = dhcp_radio.checked?
            unless dhcp_radio_state
                dhcp_radio.click
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "sleep #{@tc_net_time} seconds for net reseting....."
                sleep @tc_net_time
            end
        }
    end

}
