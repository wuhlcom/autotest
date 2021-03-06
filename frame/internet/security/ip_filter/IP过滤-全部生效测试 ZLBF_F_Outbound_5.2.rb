#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.11", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2  = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time    = 5
        @tc_default_ssid = "Wireless0"
        @tc_ipfilter_err = "源起始IP应该小于结束IP"
    end

    def process

        operate("0、准备步骤：获取DUT的ssid跟pwd，PC2无线连接该ssid。获取PC1和PC2的网卡IP地址") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @tc_ssid1_name = rs_wifi[:ssid]
            @tc_pwd1_name = rs_wifi[:pwd]
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @tc_pwd1_name, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败")

            @pc1_dut_ip      = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
            @pc2_wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
        }

        operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "on", "off", "off")
        }

        operate("2、添加两条过滤规则，一条源IP为192.168.100.100,另外一条是192.168.100.101；PC1和PC2能否访问外网") {
            @options_page.ipfilter_click
            @options_page.ip_add_item_element.click
            @options_page.ip_filter_src_ip_input(@pc1_dut_ip, @pc2_wireless_ip)
            @options_page.ip_filter_save
            #出现“源起始IP应该小于结束IP”错误提示时，将起始结束ip互换
            if @options_page.ip_filter_err_msg == @tc_ipfilter_err
                @options_page.ip_filter_src_ip_input(@pc2_wireless_ip, @pc1_dut_ip)
                @options_page.ip_filter_save
            end
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "添加过滤规则失败！")

            puts "验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@ts_web)
            refute(response, "IP过滤失败，有线客户端已被过滤却仍可以访问外网")
            response = @tc_dumpcap_pc2.send_http_request(@ts_web)
            refute(response, "IP过滤失败，无线客户端已被过滤却仍可以访问外网")
        }

        operate("3、在IP过滤界面，点击使所有条目失效，PC1和PC2能否访问外网") {
            rs = @options_page.login_with_exists(@browser.url)
            if rs
                @options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)
                @options_page.open_security_setting(@browser.url)
                @options_page.ipfilter_click
            end
            @options_page.ip_all_invalid_element.click
            sleep @tc_wait_time

            puts "所有条目失效后验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "IP过滤失败，规则失效后有线客户端不可以访问外网")
            response = @tc_dumpcap_pc2.send_http_request(@ts_web)
            assert(response, "IP过滤失败，规则失效后无线客户端不可以访问外网")
        }

        operate("4、在IP过滤界面，点击使所有条目生效，PC1和PC2能否访问外网") {
            @options_page.ip_all_valid_element.click
            sleep @tc_wait_time

            puts "所有条目生效效后验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@ts_web)
            refute(response, "IP过滤失败，规则生效后有线客户端仍可以访问外网")
            response = @tc_dumpcap_pc2.send_http_request(@ts_web)
            refute(response, "IP过滤失败，规则生效后无线客户端仍可以访问外网")
        }
    end

    def clearup
        operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            options_page = RouterPageObject::OptionsPage.new(@browser)
            rs = options_page.login_with_exists(@browser.url)
            if rs
                options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)
            end
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }

        operate("2 恢复默认ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end

}
