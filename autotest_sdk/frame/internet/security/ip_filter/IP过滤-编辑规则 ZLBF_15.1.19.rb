#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.19", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
        @tc_port      = 80
        @tc_port_new  = 90
    end

    def process

        operate("1��DUT�Ľ�������ѡ��ΪDHCP���������ã�") {
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_netset).click #����
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            flag        = false
            #����wan���ӷ�ʽΪ��������
            rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(id: @ts_tag_wired_mode_span).click #��������
                flag = true
            end
            #��ѯ�Ƿ�ΪΪdhcpģʽ
            dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
            dhcp_radio_state = dhcp_radio.checked?
            #����WIRE WANΪDHCPģʽ
            unless dhcp_radio_state
                dhcp_radio.click
                flag = true
            end
            if flag
                @wan_iframe.button(:id, @ts_tag_sbm).click
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2�����뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ���IP���ǽ�����ӹ������һ��IP���ˣ�����ԴIPΪ192.168.100.100���˿�Ϊ80��Э��ΪTCP���������ã�") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "off"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "off"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #����

            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP����
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #�������Ŀ
            @option_iframe.text_field(id: @ts_ip_dst_port).set(@tc_port)
            @option_iframe.button(id: @ts_tag_save_filter).click #����
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            dst_port   = @option_iframe.table(id: @ts_iptable).trs[1][4].text.slice(/(\d+)-/i, 1).to_i
            if (ip_clauses == 1 || dst_port != @tc_port)
                assert(false, "��������Ŀʧ��")
            end
        }

        operate("3����PC1�������ݰ�����������������ݰ���������IPTEST������TCP�����ݰ����˿�Ϊ80��ԴIP��ַΪ��192.168.100.100��PC2���Ƿ���ץ��PC1�Ϸ��������ݰ���") {
            begin
                rs = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip, '/', @ts_wan_pppoe_httpport).get
            rescue => ex
                p "��#{@ts_wan_pppoe_httpip}��#{@ts_wan_pppoe_httpport}�˿ڷ�������ʱ�����쳣����Ϊ�ö˿ڱ��������£�rs�ķ���ֵΪnil".to_gbk
                p "�����쳣��Ϣ�ǣ�#{ex.message}".to_gbk
                assert(false,"��������ʱ�����쳣")
            end
            assert(rs.nil?, "�˿ڹ��˹�����Ч��#{@ts_wan_pppoe_httpport}�˿ڱ����˺���Ȼ����ö˿ڷ���http����")
        }

        operate("4���༭����2���޸Ĺ��˹����޸Ĺ��˶˿�Ϊ90�����棻") {
            @option_iframe.table(id: @ts_iptable).trs[1][7].link(class_name: @ts_tag_edit).click #����Ŀ�༭
            @option_iframe.text_field(id: @ts_ip_dst_port1).set(@tc_port_new)
            @option_iframe.button(id: @ts_tag_save_filter1).click #����
            sleep @tc_wait_time
        }

        operate("5���ظ�����3���鿴���Խ����") {
            begin
                rs = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip, '/', @ts_wan_pppoe_httpport).get
            rescue => ex
                p "��#{@ts_wan_pppoe_httpip}��#{@tc_port}�˿ڷ�������ʱ�����쳣�������Ǹö˿ڱ���������".to_gbk
                p "�����쳣��Ϣ�ǣ�#{ex.message}".to_gbk
                assert(false,"��������ʱ�����쳣")
            end
            assert_match("succeed", rs, "�˿ڹ��˹�����Ч��#{@tc_port_new}�˿ڱ����˺���#{@tc_port}�˿ڷ���http����ʱ�޷������Ӧ��")
        }

    end

    def clearup
        operate("1���رշ���ǽ�ܿ��غ�IP���˿���") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "on"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #����
        }

        operate("2��ɾ��������Ŀ") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #����IP��������
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses > 1 #�������Ŀ��ɾ��
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #ɾ��������Ŀ
            end
        }
    end

}
