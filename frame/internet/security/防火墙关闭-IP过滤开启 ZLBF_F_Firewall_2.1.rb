#
# description:
# author:liluping
# date:2015-09-23
# modify:
#
testcase {
    attr = {"id" => "ZLBF_29.1.4", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time     = 3
        @tc_dumpcap_pc2   = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_ipfilter_err  = "源起始IP应该小于结束IP"
        @tc_default_ssid  = "Wireless0"
    end

    def process

        operate("1、AP工作在路由方式下，添加一条IP过滤规则，源地址包括PC1和PC2的地址其它默认；") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @tc_ssid1_name = rs_wifi[:ssid]
            @tc_ssid1_pwd  = rs_wifi[:pwd]
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @tc_ssid1_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败")

            @pc1_dut_ip       = ipconfig("all")[@ts_nicname][:ip][0] #获取pc1网卡ip
            @pc2_wireless_ip  = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0] #获取pc2网卡ip

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "on", "off", "off")
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
        }

        operate("2、再进入到防火墙界面，将防火墙总开关关闭，IP过滤开启，保存，PC1和PC2能否访问外网。") {
            @options_page.firewall_click
            @options_page.open_switch("off", "on", "off", "off")

            puts "验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "过滤失败，过滤总开关已关闭，但PC1有线客户端不可以访问外网~")

            response = @tc_dumpcap_pc2.send_http_request(@ts_web)
            assert(response, "过滤失败，过滤总开关已关闭，但PC2无线客户端不可以访问外网~")
        }


    end

    def clearup

        operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }

        operate("2 恢复默认ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end

}
