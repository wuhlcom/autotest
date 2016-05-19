#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.3", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2      = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time        = 3
        @tc_url_type_b       = "������"
        @tc_tag_url_baidu    = "www.baidu.com"
        @tc_url_arr_17       = "www.youku.com"
        @tc_url_warning_text = "�����������16��!"
        @tc_default_ssid     = "Wireless0"
        @tc_url_arr          = []
        @tc_url_arr << "www.sohu.com"
        @tc_url_arr << "www.tudou.com"
        @tc_url_arr << "www.huanqiu.com"
        @tc_url_arr << "www.qq.com"
        @tc_url_arr << "www.ifeng.com"
        @tc_url_arr << "www.sina.com.cn"
        @tc_url_arr << "www.weibo.com"
        @tc_url_arr << "www.mop.com"
        @tc_url_arr << "www.163.com"
        @tc_url_arr << "www.hupu.com"
        @tc_url_arr << "www.tieba.com"
        @tc_url_arr << "www.bilibili.com"
        @tc_url_arr << "www.tmall.com"
        @tc_url_arr << "www.taobao.com"
        @tc_url_arr << "www.zhihu.com"
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

        operate("1���Ƚ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�URL���ǿ��أ����棻") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #��������ǽ��URL�ܿ���
        }

        operate("2�����뵽URL��������ҳ�棻") {
            @options_page.urlfilter_click
        }

        operate("3��ѡ��������������������www.baidu.com,��������ӡ�+�����ţ����棻") {
            @options_page.select_urlfilter_type(@tc_url_type_b) #ѡ�������
            url_text = @options_page.url_text_b_element.text
            unless url_text.include?(@tc_tag_url_baidu) #����������ظ����
                @options_page.url_filter_input(@tc_tag_url_baidu)
                @options_page.url_filter_save
            end
        }

        operate("4����PC1��PC2���Ƿ���Է���www.baidu.com��") {
            puts "���ú���������֤PC1��PC2�ܷ��������".to_gbk
            response     = send_http_request(@tc_tag_url_baidu)
            refute(response, "URL����ʧ�ܣ�#{@tc_tag_url_baidu}����ӵ���������PC1���ܷ�������")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            refute(response_pc2, "URL����ʧ�ܣ�#{@tc_tag_url_baidu}����ӵ���������PC2���ܷ�������")
        }

        operate("5���������URL���˹�����ӵ�16����ʱ���ٴ���ӣ��Ƿ�����ʾ��Ϣ������ӵĹ���ͳ���������δ��ӳɹ��Ĺ����Ƿ���Ч��") {
            @options_page.urlfilter_click #�����ٽ���url���˽��棬�����޷����棬����ԭ��δ֪
            @options_page.select_urlfilter_type(@tc_url_type_b) #ѡ�������
            url_text = @options_page.url_text_b_element.text
            @tc_url_arr.each do |url|
                @options_page.url_filter_input(url) unless url_text.include?(url) #����������ظ����
                sleep 1
            end
            @options_page.url_filter_save
            #���16�����ٴ����һ�����Ƿ�����ʾ
            @options_page.url_filter_input(@tc_url_arr_17) unless url_text.include?(@tc_url_arr_17) #����������ظ����
            assert_equal(@tc_url_warning_text, @options_page.url_items_max, "��ӳ���16�������ϵͳ����ʾ������ӹ����쳣��")

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "��֤����ӵ�16�������δ��ӳɹ��Ĺ����Ƿ���Ч".to_gbk
            @tc_url_arr.each_with_index do |url, index|
                p "PC1����������֤����ӹ����������#{url}".to_gbk
                response = send_http_request(url)
                refute(response, "URL����ʧ�ܣ�#{url}����ӵ���������PC1���ܷ�������")
                p "PC2����������֤����ӹ����������#{url}".to_gbk
                response_pc2 = @tc_dumpcap_pc2.send_http_request(url)
                refute(response_pc2, "URL����ʧ�ܣ�#{url}����ӵ���������PC2���ܷ�������")
                break if index == 15 #����ӡ���һ�С�========��
                p "=================================================="
            end
            p "PC1����������֤δ��ӳɹ��Ĺ���#{@tc_url_arr_17}".to_gbk
            response = send_http_request(@url_arr_other)
            assert(response, "URL����ʧ�ܣ�#{@url_arr_other}δ��ӵ���������PC1���ܷ�������")
            p "PC2����������֤����ӹ����������#{@url_arr_other}".to_gbk
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@url_arr_other)
            assert(response_pc2, "URL����ʧ�ܣ�#{@url_arr_other}δ��ӵ���������PC2���ܷ�������")
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
    end

}
