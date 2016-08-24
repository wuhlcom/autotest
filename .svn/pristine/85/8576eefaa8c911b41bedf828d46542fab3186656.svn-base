#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.4", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time    = 2
        @tc_dumpcap_pc2  = DRbObject.new_with_uri(@ts_drb_pc2)
        dut_ip           = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
        filter_net       = dut_ip.slice(/(\d+\.\d+\.\d+\.)\d+/, 1)
        @tc_src_fip      = filter_net + "2"
        @tc_src_endip    = filter_net + "254"
        @tc_default_ssid = "Wireless0"
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
        }

        operate("2、添加一条新规则，设置源IP为所有IP（不填或设置192.168.100.2-192.168.100.254），保存配置，pc1能否访问外网") {
            @options_page.ipfilter_click
            @options_page.ip_add_item_element.click #新增条目
            @options_page.ip_filter_src_ip_input(@tc_src_fip, @tc_src_endip)
            @options_page.ip_filter_save

            puts "验证是否可以访问外网~".to_gbk
            response = send_http_request(@ts_web)
            refute(response, "IP过滤失败，本机IP在过滤网段之内，仍可以访问外网")
        }

        operate("3、pc2连接路由wifi后，能否访问外网") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @tc_ssid1_name = rs_wifi[:ssid]
            @tc_pwd1_name = rs_wifi[:pwd]

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @tc_pwd1_name, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败")

            puts "验证无线连接客户端能否访问外网".to_gbk
            response = @tc_dumpcap_pc2.send_http_request(@ts_web)
            refute(response, "IP过滤失败，无线客户端IP在过滤网段之内，仍可以访问外网~")
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
