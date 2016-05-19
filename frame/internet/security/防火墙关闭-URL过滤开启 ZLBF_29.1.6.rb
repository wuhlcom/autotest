#
# description:
# author:liluping
# date:2015-09-23
# modify:
#
testcase {
    attr = {"id" => "ZLBF_29.1.6", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2   = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time     = 3
        @tc_tag_url_baidu = "www.baidu.com"
        @tc_tag_url_sohu  = "www.sohu.com"
        @tc_url_type_b    = "黑名单"
        @tc_url_type_w    = "白名单"
        @tc_default_ssid  = "Wireless0"
    end

    def process

        operate("1、进入到防火墙界面，将防火墙总开关关闭，URL过滤开启，保存；") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            mac_last   = @wifi_page.get_mac_last
            @wifi_page.open_wifi_page(@browser.url)
            @tc_ssid1_name = @wifi_page.ssid1
            puts "当前SSID1名为#{@tc_ssid1_name}".to_gbk
            puts "当前SSID1 加密方式为#{@wifi_page.ssid1_pwmode}".to_gbk
            #判断加密方式是否为WPA,如果不是则设置为WPA
            flag = false
            unless @wifi_page.ssid1_pwmode == @ts_sec_mode_wpa
                @wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                @wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                    = true
            end
            unless @tc_ssid1_name=~/#{mac_last}/i
                @tc_ssid1_name   = "#{@tc_ssid1_name}_#{mac_last}"
                @wifi_page.ssid1 = @tc_ssid1_name
                puts "修改SSID1名为#{@tc_ssid1_name}".to_gbk
                flag = true
            end
            @wifi_page.save_wifi_config if flag
            puts "Dut ssid: #{@tc_ssid1_name},passwd:#{@ts_default_wlan_pw}"
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @ts_default_wlan_pw, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败")

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on")
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_b) #选择黑名单
            url_text = @options_page.url_text_b_element.text
            unless url_text.include?(@tc_tag_url_baidu) #已添加则不再重复添加
                @options_page.url_filter_input(@tc_tag_url_baidu)
                @options_page.url_filter_save
            end
        }

        operate("2、进入URL过滤界面添加黑名单，添加www.baidu.com的规则，PC1和PC2能否访问www.baidu.com及其它网站；") {
            @options_page.firewall_click
            @options_page.open_switch("off", "off", "off", "on")

            puts "设置黑名单后验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)

            response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)

            response = send_http_request(@tc_tag_url_sohu)
            assert(response, "不可以访问#{@tc_tag_url_sohu}".to_gbk)

            response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_sohu)
            assert(response, "不可以访问#{@tc_tag_url_sohu}".to_gbk)
        }

        operate("3、再设置就白名单，添加www.sohu.com的规则，PC1和PC2能否访问www.sohu.com及其它网站。") {
            @options_page.open_switch("on", "off", "off", "on") #配置规则前先打开开关
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_w) #选择白名单
            url_text = @options_page.url_text_w_element.text
            unless url_text.include?(@tc_tag_url_baidu) #已添加则不再重复添加
                @options_page.url_filter_input(@tc_tag_url_sohu)
                @options_page.url_filter_save
            end
            @options_page.firewall_click
            @options_page.open_switch("off", "off", "off", "on")

            puts "设置白名单后验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)

            response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)

            response = send_http_request(@tc_tag_url_sohu)
            assert(response, "不可以访问#{@tc_tag_url_sohu}".to_gbk)

            response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_sohu)
            assert(response, "不可以访问#{@tc_tag_url_sohu}".to_gbk)
        }


    end

    def clearup
        operate("1 关闭防火墙总开关和URL过滤开关并删除所有过滤规则") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time

            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.urlfilter_close_sw_del_all_step(@browser.url)
        }
        operate("2 恢复默认ssid") {
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
