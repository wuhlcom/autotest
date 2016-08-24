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
        @tc_url_type_b    = "黑名单"
        @tc_default_ssid  = "Wireless0"
        @tc_tag_url_baidu = "www.baidu.com"
        @tc_tag_url       = ["www.sina.com.cn", "www.yahoo.com"]
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

        operate("1、登陆DUT，WAN接入设置为PPPoE方式；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("2、先进入到安全设置的防火墙设置界面，开启防火墙总开关和URL过虑开关，保存；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #开启防火墙和URL总开关
        }

        operate("3、进入URL过滤设置页面，选择黑名单，添加过滤关键字www.baidu.com，保存；") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_b) #选择黑名单
            url_text = @options_page.url_text_b
            unless url_text.include?(@tc_tag_url_baidu) #已添加则不再重复添加
                @options_page.url_filter_input(@tc_tag_url_baidu)
                @options_page.url_filter_save
            end
        }

        operate("4、PC1,PC2是否可以访问www.sina.com.cn，www.yahoo.cn，www.baidu.com等站点；") {
            puts "设置黑名单后验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            refute(response, "URL过滤失败，#{@tc_tag_url_baidu}已添加到黑名单，PC1仍能访问外网")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            refute(response_pc2, "URL过滤失败，#{@tc_tag_url_baidu}已添加到黑名单，PC2仍能访问外网")

            puts "访问黑名单之外的站点".to_gbk
            @tc_tag_url.each do |url|
                puts "PC1访问：#{url}".to_gbk
                response = send_http_request(url)
                assert(response, "URL过滤失败，#{url}未添加到黑名单，有线不能访问！")
                puts "PC2访问：#{url}".to_gbk
                response_pc2 = @tc_dumpcap_pc2.send_http_request(url)
                assert(response_pc2, "URL过滤失败，#{url}未添加到黑名单，无线不能访问！")
            end
        }

        operate("5、重启AP后，PC1,PC2是否可以访问www.sina.com.cn，www.yahoo.cn，www.baidu.com等站点；") {
            @options_page.refresh
            sleep 2
            @options_page.reboot
            login_ui    = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "重启后未自动跳转到登录页面！")
            #重新登录路由器
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            p "重启后PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @ts_default_wlan_pw, @ts_wlan_nicname)
            assert(rs, "重启后PC2 wifi连接失败")

            puts "重启后验证黑名单是否有效！".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            refute(response, "URL过滤失败，#{@tc_tag_url_baidu}已添加到黑名单，PC1仍能访问外网")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            refute(response_pc2, "URL过滤失败，#{@tc_tag_url_baidu}已添加到黑名单，PC2仍能访问外网")

            puts "访问黑名单之外的站点".to_gbk
            @tc_tag_url.each do |url|
                puts "PC1访问：#{url}".to_gbk
                response = send_http_request(url)
                assert(response, "URL过滤失败，#{url}未添加到黑名单，有线不能访问！")
                puts "PC2访问：#{url}".to_gbk
                response_pc2 = @tc_dumpcap_pc2.send_http_request(url)
                assert(response_pc2, "URL过滤失败，#{url}未添加到黑名单，无线不能访问！")
            end
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
        operate("3 恢复DHCP接入") {
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
