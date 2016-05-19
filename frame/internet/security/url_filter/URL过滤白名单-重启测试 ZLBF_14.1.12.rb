#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.12", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2   = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time     = 3
        @tc_url_type_w    = "白名单"
        @tc_default_ssid  = "Wireless0"
        @tc_tag_url_baidu = "www.baidu.com"
        @tc_tag_url       = ["www.sina.com.cn", "www.yahoo.com"]
    end

    def process
        operate("0、获取ssid跟密码") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @tc_ssid1_name = rs_wifi[:ssid]
            @tc_pwd1_name = rs_wifi[:pwd]

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @tc_pwd1_name, @ts_wlan_nicname)
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

        operate("3、在URL过滤设置界面选择白名单，添加过滤关键字www.baidu.com,保存；") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_w) #选择白名单
            url_text = @options_page.url_text_w
            unless url_text.include?(@tc_tag_url_baidu) #已添加则不再重复添加
                @options_page.url_filter_input(@tc_tag_url_baidu)
                @options_page.url_filter_save
            end
        }

        operate("4、PC1,PC2是否可以访问www.sina.com.cn，www.yahoo.cn，www.baidu.com等站点；") {
            puts "设置白名单后验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "URL过滤失败，#{@tc_tag_url_baidu}已添加到白名单，PC1不能访问外网")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            assert(response_pc2, "URL过滤失败，#{@tc_tag_url_baidu}已添加到白名单，PC2不能访问外网")

            puts "访问白名单之外的站点".to_gbk
            @tc_tag_url.each do |url|
                puts "PC1访问：#{url}".to_gbk
                response = send_http_request(url)
                refute(response, "URL过滤失败，#{url}未添加到白名单，有线仍能访问！")
                puts "PC2访问：#{url}".to_gbk
                response_pc2 = @tc_dumpcap_pc2.send_http_request(url)
                refute(response_pc2, "URL过滤失败，#{url}未添加到白名单，无线仍能访问！")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
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
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @tc_pwd1_name, @ts_wlan_nicname)
            assert(rs, "重启后PC2 wifi连接失败")

            puts "重启后验证白名单是否有效！".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "URL过滤失败，#{@tc_tag_url_baidu}已添加到白名单，PC1不能访问外网")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            assert(response_pc2, "URL过滤失败，#{@tc_tag_url_baidu}已添加到白名单，PC2不能访问外网")

            puts "访问白名单之外的站点".to_gbk
            @tc_tag_url.each do |url|
                puts "PC1访问：#{url}".to_gbk
                response = send_http_request(url)
                refute(response, "URL过滤失败，#{url}未添加到白名单，有线仍能访问！")
                puts "PC2访问：#{url}".to_gbk
                response_pc2 = @tc_dumpcap_pc2.send_http_request(url)
                refute(response_pc2, "URL过滤失败，#{url}未添加到白名单，无线仍能访问！")
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
            wifi_page.modify_default_ssid(@browser.url)
        }
        operate("3 恢复DHCP接入") {
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
