#
# description:
# author:liluping
# date:2015-10-%qos 17:05:05
# modify:
#
testcase {
    attr = {"id" => "ZLRM_1.1.21", "level" => "P3", "auto" => "n"}

    def prepare

        @tc_connect_time = 60
        @tc_ap_url       = "192.168.50.1"
    end

    def process

        operate("1、扫描上行AP后，连接到其中一个AP") {
            @browser1         = Watir::Browser.new :ff, :profile => "default"
            @accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
            @accompany_router.login_accompany_router(@tc_ap_url)
            @ap_lan_ip = @accompany_router.get_lan_ip
            p "AP的LAN侧ip为：#{@ap_lan_ip}".to_gbk
            @accompany_router.open_wireless_24g_page #进入无线2.4G界面
            #获取ssid和密码
            @ap_ssid = @accompany_router.ap_ssid
            @ap_pwd  = @accompany_router.ap_pwd
            p "陪测AP的ssid为：#{@ap_ssid}，密码为：#{@ap_pwd}".to_gbk

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
            dut_wan_ip = @status_page.get_wan_ip
            p "路由器wan侧ip：#{dut_wan_ip}".to_gbk
            refute(dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = dut_wan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，关联失败！")

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、重启上行AP，检查重启后DUT是否能再次自动连接到上行AP") {
            @accompany_router.ap_reboot(@browser1, @tc_ap_url) #上行AP重启

            #等待dut自动连接上行AP
            p "sleeping #{@tc_connect_time} seconds for connect AP..."
            sleep @tc_connect_time

            p "重启后查看路由器是否自动连接AP成功".to_gbk
            @status_page.open_systatus_page(@browser.url)
            dut_wan_ip = @status_page.get_wan_ip
            p "路由器wan侧ip：#{dut_wan_ip}".to_gbk
            refute(dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = dut_wan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，重启后自动连接AP失败！")
        }


    end

    def clearup
        operate("1.恢复默认DHCP连接") {
            begin
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
            ensure
                @browser1.close
            end
        }
    end

}
