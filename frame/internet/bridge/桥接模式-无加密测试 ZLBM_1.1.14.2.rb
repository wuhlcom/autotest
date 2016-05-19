#
# description:
# author:liluping
# date:2015-10-%qos 17:05:05
# modify:
#
testcase {
    attr = {"id" => "ZLBM_1.1.14", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2               = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_ap_url                    = "192.168.50.1"
        @tc_ap_wireless_pattern_value = "802.11b/g/n"
        @tc_ap_channel_value          = "1"
        @tc_ap_bandwidth_value        = "20M"
        @tc_ap_safe_option_value      = "无"
    end

    def process

        operate("1、陪测AP使用Atheros方案并接入Internet，无线模式为b/g/n，信道指定为CH1，频宽设置为20M频宽，加密为无；") {
            @browser1         = Watir::Browser.new :ff, :profile => "default"
            @accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
            @accompany_router.login_accompany_router(@tc_ap_url)
            @ap_lan_ip = @accompany_router.get_lan_ip
            p "AP的LAN侧ip为：#{@ap_lan_ip}".to_gbk
            #陪测AP 2.4G配置
            @accompany_router.wireless_24g_options(@tc_ap_wireless_pattern_value, @tc_ap_channel_value, @tc_ap_bandwidth_value, @tc_ap_safe_option_value)
            #获取ssid和密码
            @ap_ssid = @accompany_router.ap_ssid
            p "陪测AP的ssid为：#{@ap_ssid}".to_gbk
        }

        operate("2、PC1设置与DUT同一网段的固定IP，登录DUT扫描到陪测AP的SSID并进行连接，检查DUT是否能与陪测AP关联成功；") {
            unless @browser.span(:id => @ts_tag_netset).exists?
                rs_login = login_no_default_ip(@browser) #重新登录
                assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            end

            p "获取路由器ssid跟密码".to_gbk
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi    = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @dut_ssid  = rs_wifi[:ssid]
            @dut_pwd   = rs_wifi[:pwd]

            p "路由器连接方式改为无线WAN接".to_gbk
            @wan_page = RouterPageObject::WanPage.new(@browser)
            ssid_flag = @wan_page.set_bridge_pattern(@browser.url, @ap_ssid)
            assert(ssid_flag, "无线WAN连接出现异常！")

            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@dut_ssid, flag, @dut_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)

            p "查看路由器与陪测AP是否关联成功".to_gbk
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            dut_wan_ip = @status_page.get_wan_ip
            p "路由器wan侧ip：#{dut_wan_ip}".to_gbk
            refute(dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = dut_wan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，关联失败！".to_gbk)
        }

        operate("3、PC1地址获取方式设置为自动获取，检查PC1是否能通过DUT获取到陪测AP派发的地址，是否能访问外网，PC2通过无线连接到DUT，检查是否能成功获取地址，是否能正常访问外网；") {
            p "PC1访问外网#{@ts_web}...".to_gbk
            judge_link_baidu = ping(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网")

            p "PC2访问外网#{@ts_web}...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.ping(@ts_web)
            assert(judge_link_pc2, "PC2无法访问外网")
            # @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
        }

        operate("4、断电重启DUT，检查PC1、PC2是否依然能成功获取地址，是否能正常访问外网；") {
            @browser.refresh
            sleep 1
            @status_page.reboot(130) #等待时间增加到130s
            login_ui = @status_page.login_with_exists(@browser.url)
            assert(login_ui, "重启后未跳转到登录界面")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@dut_ssid, flag, @dut_pwd, @ts_wlan_nicname)
            assert(rs, "重启后PC2 wifi连接失败")

            @status_page.open_systatus_page(@browser.url)
            dut_wan_ip = @status_page.get_wan_ip
            p "dut的wan侧ip：#{dut_wan_ip}".to_gbk
            refute(dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = dut_wan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "重启后DUT与陪测AP不在同一网段，关联失败！".to_gbk)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            p "PC1访问外网...".to_gbk
            judge_link_baidu = ping(@ts_web)
            assert(judge_link_baidu, "重启后PC1无法访问外网")

            p "PC2访问外网...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.ping(@ts_web)
            assert(judge_link_pc2, "重启后PC2无法访问外网")
            # @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
        }
        
    end

    def clearup

        operate("1 恢复陪测AP路由器无线默认设置") {
            begin
                p "断开wifi连接".to_gbk
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接

                @accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
                @accompany_router.login_accompany_router(@tc_ap_url)
                @accompany_router.wireless_24g_options
            ensure
                @browser1.close
            end
        }

        operate("2 恢复为默认的接入方式，DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                rs_login = login_no_default_ip(@browser) #重新登录
                p rs_login[:flag]
                p rs_login[:message]
            end

            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }

        operate("3 恢复dut路由器的ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end


}
