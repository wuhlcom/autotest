#
# description:
# author:liluping
# date:2015-10-%qos 17:05:05
# modify:
#
testcase {
    attr = {"id" => "ZLRM_1.1.19", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_relevance_time       = 550
        @tc_ap_channel_value     = "1"
        @tc_ap_channel_new_value = "6"
        @tc_ap_url               = "192.168.50.1"
    end

    def process

        operate("1、上行AP设置为某一固定信道，如CH1；") {
            @browser1         = Watir::Browser.new :ff, :profile => "default"
            @accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
            @accompany_router.login_accompany_router(@tc_ap_url)
            @ap_lan_ip = @accompany_router.get_lan_ip
            p "AP的LAN侧ip为：#{@ap_lan_ip}".to_gbk
            #陪测AP 2.4G配置，设置信道为1
            @accompany_router.modify_channel(@tc_ap_channel_value)
            #获取ssid和密码
            @ap_ssid = @accompany_router.ap_ssid
            @ap_pwd  = @accompany_router.ap_pwd
            p "陪测AP的ssid为：#{@ap_ssid}，密码为：#{@ap_pwd}".to_gbk
        }

        operate("2、PC1设置与DUT同一网段的固定IP，登录DUT扫描到上行AP的SSID并进行连接，检查DUT是否能与上行AP关联成功，并在状态页面检查信道是否与上行AP的一致；") {
            unless @browser.span(:id => @ts_tag_netset).exists?
                rs_login = login_no_default_ip(@browser) #重新登录
                assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            end
            p "路由器连接方式改为无线WAN接(桥接)".to_gbk
            @wan_page = RouterPageObject::WanPage.new(@browser)
            ssid_flag = @wan_page.set_bridge_pattern(@browser.url, @ap_ssid, @ap_pwd)
            assert(ssid_flag, "无线WAN连接出现异常！")

            p "查看路由器与陪测AP是否关联成功".to_gbk
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            dut_wan_ip  = @status_page.get_wan_ip
            dut_channel = @status_page.get_wifi_channel
            p "路由器wan侧ip：#{dut_wan_ip}".to_gbk
            refute(dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = dut_wan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，关联失败！")
            assert_equal(@tc_ap_channel_value, dut_channel, "DUT与陪测AP关联成功，但信道不相同！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("3、修改上行AP的信道为CH6，检查DUT是否能自动重新关联到上行AP，并在状态页面检查与上行网络的信道是否一致；") {
            @accompany_router.login_accompany_router(@tc_ap_url)
            @accompany_router.modify_channel(@tc_ap_channel_new_value)

            #等待dut自动关联上行AP数据
            p "sleeping #{@tc_relevance_time} seconds for relevance data..."
            sleep @tc_relevance_time

            p "修改上行AP信道后，查看路由器与陪测AP是否关联成功".to_gbk
            @status_page.open_systatus_page(@browser.url)
            dut_wan_ip  = @status_page.get_wan_ip
            dut_channel = @status_page.get_wifi_channel
            p "路由器wan侧ip：#{dut_wan_ip}".to_gbk
            refute(dut_wan_ip.nil?, "修改上行AP信道后，DUT未获取到陪测AP的地址！")
            dut_network = dut_wan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "修改上行AP信道后，DUT与陪测AP不在同一网段，关联失败！")
            assert_equal(@tc_ap_channel_new_value, dut_channel, "修改上行AP信道后，DUT与陪测AP关联成功，但信道不相同！")
        }


    end

    def clearup

        operate("1.恢复陪测AP路由器无线默认设置") {
            begin
                @accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
                @accompany_router.login_accompany_router(@tc_ap_url)
                @accompany_router.wireless_24g_options(@browser1)
            ensure
                @browser1.close
            end
        }

        operate("2.恢复默认DHCP连接") {
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

    end

}
