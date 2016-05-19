#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.7", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2   = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time     = 3
        @tc_url_type_b    = "������"
        @tc_default_ssid  = "Wireless0"
        @tc_tag_url_baidu = "www.baidu.com"
        @tc_tag_url       = ["www.sina.com.cn", "www.yahoo.com"]
    end

    def process
        operate("0����ȡssid������") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            mac_last   = @wifi_page.get_mac_last
            @wifi_page.open_wifi_page(@browser.url)
            @tc_ssid1_name = @wifi_page.ssid1
            puts "��ǰSSID1��Ϊ#{@tc_ssid1_name}".to_gbk
            puts "��ǰSSID1 ���ܷ�ʽΪ#{@wifi_page.ssid1_pwmode}".to_gbk
            #�жϼ��ܷ�ʽ�Ƿ�ΪWPA,�������������ΪWPA
            flag = false
            unless @wifi_page.ssid1_pwmode == @ts_sec_mode_wpa
                @wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                @wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                    = true
            end
            unless @tc_ssid1_name=~/#{mac_last}/i
                @tc_ssid1_name   = "#{@tc_ssid1_name}_#{mac_last}"
                @wifi_page.ssid1 = @tc_ssid1_name
                puts "�޸�SSID1��Ϊ#{@tc_ssid1_name}".to_gbk
                flag = true
            end
            @wifi_page.save_wifi_config if flag
            puts "Dut ssid: #{@tc_ssid1_name},passwd:#{@ts_default_wlan_pw}"
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2����dut����
            p "PC2����wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @ts_default_wlan_pw, @ts_wlan_nicname)
            assert(rs, "PC2 wifi����ʧ��")
        }

        operate("1����½DUT��WAN��������ΪPPPoE��ʽ��") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("2���Ƚ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�URL���ǿ��أ����棻") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #��������ǽ��URL�ܿ���
        }

        operate("3������URL��������ҳ�棬ѡ�����������ӹ��˹ؼ���www.baidu.com�����棻") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_b) #ѡ�������
            url_text = @options_page.url_text_b
            unless url_text.include?(@tc_tag_url_baidu) #����������ظ����
                @options_page.url_filter_input(@tc_tag_url_baidu)
                @options_page.url_filter_save
            end
        }

        operate("4��PC1,PC2�Ƿ���Է���www.sina.com.cn��www.yahoo.cn��www.baidu.com��վ�㣻") {
            puts "���ú���������֤PC1��PC2�ܷ��������".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            refute(response, "URL����ʧ�ܣ�#{@tc_tag_url_baidu}����ӵ���������PC1���ܷ�������")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            refute(response_pc2, "URL����ʧ�ܣ�#{@tc_tag_url_baidu}����ӵ���������PC2���ܷ�������")

            puts "���ʺ�����֮���վ��".to_gbk
            @tc_tag_url.each do |url|
                puts "PC1���ʣ�#{url}".to_gbk
                response = send_http_request(url)
                assert(response, "URL����ʧ�ܣ�#{url}δ��ӵ������������߲��ܷ��ʣ�")
                puts "PC2���ʣ�#{url}".to_gbk
                response_pc2 = @tc_dumpcap_pc2.send_http_request(url)
                assert(response_pc2, "URL����ʧ�ܣ�#{url}δ��ӵ������������߲��ܷ��ʣ�")
            end
        }

        operate("5������AP��PC1,PC2�Ƿ���Է���www.sina.com.cn��www.yahoo.cn��www.baidu.com��վ�㣻") {
            @options_page.refresh
            sleep 2
            @options_page.reboot
            login_ui    = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "������δ�Զ���ת����¼ҳ�棡")
            #���µ�¼·����
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
            p "������PC2����wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @ts_default_wlan_pw, @ts_wlan_nicname)
            assert(rs, "������PC2 wifi����ʧ��")

            puts "��������֤�������Ƿ���Ч��".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            refute(response, "URL����ʧ�ܣ�#{@tc_tag_url_baidu}����ӵ���������PC1���ܷ�������")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            refute(response_pc2, "URL����ʧ�ܣ�#{@tc_tag_url_baidu}����ӵ���������PC2���ܷ�������")

            puts "���ʺ�����֮���վ��".to_gbk
            @tc_tag_url.each do |url|
                puts "PC1���ʣ�#{url}".to_gbk
                response = send_http_request(url)
                assert(response, "URL����ʧ�ܣ�#{url}δ��ӵ������������߲��ܷ��ʣ�")
                puts "PC2���ʣ�#{url}".to_gbk
                response_pc2 = @tc_dumpcap_pc2.send_http_request(url)
                assert(response_pc2, "URL����ʧ�ܣ�#{url}δ��ӵ������������߲��ܷ��ʣ�")
            end
        }


    end

    def clearup
        operate("1 �رշ���ǽ�ܿ��غ�URL���˿��ز�ɾ�����й��˹���") {
            p "�Ͽ�wifi����".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����
            sleep @tc_wait_time

            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.urlfilter_close_sw_del_all_step(@browser.url)
        }
        operate("2 �ָ�Ĭ��ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.open_wifi_page(@browser.url)
            current_ssid   = wifi_page.ssid1
            current_pwmode = wifi_page.ssid1_pwmode
            flag           = false
            unless current_ssid == @tc_default_ssid
                wifi_page.ssid1 = @tc_default_ssid
                flag            = true
            end
            unless current_pwmode == @ts_sec_mode_wpa
                wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                   = true
            end
            wifi_page.save_wifi_config if flag
        }
        operate("3 �ָ�DHCP����") {
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
