#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_7.1.37", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_ap_url = "192.168.50.1"
    end

    def process

        operate("1、被测AP中插入中国移动4G卡") {
            @browser1         = Watir::Browser.new :ff, :profile => "default"
            @accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
            @accompany_router.login_accompany_router(@tc_ap_url)
            @ap_lan_ip = @accompany_router.get_lan_ip
            p "AP的LAN侧ip为：#{@ap_lan_ip}".to_gbk
            #获取ssid和密码
            @accompany_router.open_wireless_24g_page #进入2.4G设置页面
            @ap_ssid = @accompany_router.ap_ssid
            @ap_pwd  = @accompany_router.ap_pwd
            p "陪测AP的ssid为：#{@ap_ssid}，密码为：#{@ap_pwd}".to_gbk
        }

        operate("2、配置被测AP为通过桥接方式上网。PC1上网成功") {
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

            p "PC1访问外网#{@ts_web}...".to_gbk
            judge_link_baidu = ping(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网")
        }

        operate("3、然后手动切换为3/4G上网，查看切换是否成功，PC1切换后是否能上网，状态页面显示是否正确") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wan_page.set_3g_auto_dial(@browser.url)
            sleep 20
            p "验证3G/4G是否拨号成功".to_gbk
            @status_page.open_systatus_page(@browser.url)
            sleep 5
            sim_status      = @status_page.sim_status_element.element.image(src: @ts_tag_img_normal)
            wifi_signal     = @status_page.signal_strength_element.element.image(src: @ts_tag_signal_fail)
            register_status = @status_page.reg_status_element.element.image(src: @ts_tag_img_normal)
            net_status      = @status_page.net_stauts_element.element.image(src: @ts_tag_img_normal)
            net_type        = @status_page.net_type
            ispname         = @status_page.isp_name
            assert(sim_status.exists?, '3G/4G SIM卡状态异常')
            refute(wifi_signal.exists?, '3G/4G 信号强度状态异常')
            assert(register_status.exists?, '3G/4G 注册状态异常')
            assert(net_status.exists?, '3G/4G 联网状态异常')
            assert_match(@ts_tag_4g_nettype_text, net_type, '3G/4G 网络类型异常')
            assert_match(@ts_tag_3g_ispname_text, ispname, '3G/4G 运营商名称异常')
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, '3G/4G获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_3g_4g}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, '3G/4G获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, '3G/4G获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, '3G/4G获取dns ip地址失败！')

            p "PC1访问外网#{@ts_web}...".to_gbk
            judge_link_baidu = ping(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网")
        }

        operate("4、手动切换为有线上网，WAN配置为桥接，PC1切换后是否能上网，状态页面显示是否正确") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
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

            p "PC1访问外网#{@ts_web}...".to_gbk
            judge_link_baidu = ping(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网")
        }


    end

    def clearup
        operate("恢复默认DHCP接入") {
            @browser1.close #关闭浏览器
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
