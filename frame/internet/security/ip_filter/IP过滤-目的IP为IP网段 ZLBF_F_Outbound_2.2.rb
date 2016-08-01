#
# description:
# author:liluping
# date:2015-09-21
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.6", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time     = 3
        @tc_tag_url_baidu = 'www.baidu.com'
        @tc_tag_url_yahoo = 'www.yahoo.com'
        @tc_tag_url_sohu  = 'www.sohu.com'
        @tc_ping_num      = 5

    end

    def process

        operate("1��DUT�Ľ�������ѡ��ΪDHCP���������á��ٽ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ����棻") {
            #���ӷ�ʽ����ΪDHCP
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #�򿪷���ǽ��IP�ܿ���
        }

        operate("2������IP���˹��ܣ�����Ŀ��IPΪһ��ַ�Σ���192.168.20.100~192.168.20.200����������ΪĬ�ϣ��������ã���PC���������ping������ping��IPΪ���������ڵĵ�ַ��Ȼ���ڷ������鿴�Ƿ���ץ�����ݰ���") {
            require "ipaddr"
            rs        = Addrinfo.ip(@tc_tag_url_yahoo) #��ѯ��url��Ӧ��ip
            dst_ip    = rs.ip_address #"116.214.12.74"
            dstip_toi = IPAddr.new(dst_ip).to_i

            ns         = Addrinfo.ip(@tc_tag_url_baidu) #��ѯ��url��Ӧ��ip
            dst_ipt    = ns.ip_address #"58.217.200.112"
            dstipt_toi = IPAddr.new(dst_ipt).to_i

            ss       = Addrinfo.ip(@tc_tag_url_sohu) #��ѯ��url��Ӧ��ip
            sohu_ip  = ss.ip_address #"14.18.240.6"
            sohu_toi = IPAddr.new(sohu_ip).to_i

            if dstip_toi > dstipt_toi && dstip_toi > sohu_toi #dstip_toi���
                if dstipt_toi > sohu_toi
                    ping_ip           = sohu_ip
                    destination_ip    = dst_ipt
                    destination_endip = dst_ip
                else
                    ping_ip           = dst_ipt
                    destination_ip    = sohu_ip
                    destination_endip = dst_ip
                end
            elsif dstipt_toi > dstip_toi && dstipt_toi > sohu_toi #dstipt_toi���
                if dstip_toi > sohu_toi
                    ping_ip           = sohu_ip
                    destination_ip    = dst_ip
                    destination_endip = dst_ipt
                else
                    ping_ip           = dst_ip
                    destination_ip    = sohu_ip
                    destination_endip = dst_ipt
                end
            elsif sohu_toi > dstipt_toi && sohu_toi > dstip_toi #sohu_ip���
                if dstip_toi > dstipt_toi
                    ping_ip           = dst_ipt
                    destination_ip    = dst_ip
                    destination_endip = sohu_ip
                else
                    ping_ip           = dst_ip
                    destination_ip    = dst_ipt
                    destination_endip = sohu_ip
                end
            end
            @options_page.ipfilter_click #��IP����ҳ��
            @options_page.ip_add_item_element.click #�������Ŀ
            @options_page.ip_filter_dst_ip_input(destination_ip, destination_endip)
            @options_page.ip_save #����
            sleep @tc_wait_time
            ip_network_segment = destination_ip + "-" + destination_endip
            puts "����IP��ַ��Ϊ:#{ip_network_segment}".to_gbk

            #��֤ip�Ƿ����
            puts "��֤ip�����Ƿ���Ч".to_gbk
            p "��֤PC1�� #{destination_endip}".to_gbk
            rs = send_http_request(destination_endip)
            refute(rs, "ip����ʧ�ܣ�#{destination_endip}�ڹ���������ȴ��pingͨ����!")

            p "��֤PC1�� #{ping_ip}".to_gbk
            rss = send_http_request(ping_ip)
            assert(rss, "ip����ʧ�ܣ�#{ping_ip}�ڹ���������ȴ����pingͨ����!")

        }
    end

    def clearup

        operate("�ָ�Ĭ������") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            rs = options_page.login_with_exists(@browser.url)
            if rs
                options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)
            end
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
