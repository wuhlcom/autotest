#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.4", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2  = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time    = 3
        @tc_url_type_b   = "黑名单"
        @tc_tag_url_sina = "www.sina.com.cn"
        @tc_del_type     = "black"
        @tc_default_ssid = "Wireless0"
    end

    def process
        operate("0、获取ssid跟密码") {
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
        }

        operate("1、先进入到安全设置的防火墙设置界面，开启防火墙总开关和URL过虑开关，保存；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #开启防火墙和URL总开关
        }

        operate("2、进入到URL过滤设置页面；选择黑名单，增加过滤项：www.sina.com.cn，保存生效") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_b) #选择黑名单
            url_text = @options_page.url_text_b_element.text
            unless url_text.include?(@tc_tag_url_sina) #已添加则不再重复添加
                @options_page.url_filter_input(@tc_tag_url_sina)
                @options_page.url_filter_save
            end

            puts "设置黑名单后验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@tc_tag_url_sina)
            refute(response, "URL过滤失败，#{@tc_tag_url_sina}已添加到黑名单，PC1仍能访问外网")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_sina)
            refute(response_pc2, "URL过滤失败，#{@tc_tag_url_sina}已添加到黑名单，PC2仍能访问外网")
        }

        operate("3、删除前面添加的www.sina.com.cn，点保存；") {
            @options_page.urlfilter_click #必须再进入url过滤界面，否则无法保存，具体原因未知
            @options_page.select_urlfilter_type(@tc_url_type_b) #选择黑名单
            @options_page.urlfilter_del(@tc_del_type, @tc_tag_url_sina) #删除url
            url_text = @options_page.url_text_b_element.text
            refute(url_text.include?(@tc_tag_url_sina), "删除已添加的规则#{@tc_tag_url_sina}失败！")
        }

        operate("4、在PC1和PC2上是否可以访问www.sina.com。") {
            response = send_http_request(@tc_tag_url_sina)
            assert(response, "URL过滤失败，#{@tc_tag_url_sina}未添加到黑名单，PC1不能访问外网")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_sina)
            assert(response_pc2, "URL过滤失败，#{@tc_tag_url_sina}未添加到黑名单，PC2不能访问外网")
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
