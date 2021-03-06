#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_7.1.34", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1、被测AP中插入中国电信4G卡") {

        }

        operate("2、配置被测AP为通过STATIC方式上网。PC1上网成功") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "验证STATIC是否拨号成功".to_gbk
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'STATIC获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_static}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'STATIC获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'STATIC获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'STATIC获取dns ip地址失败！')
            p "判断静态拨号后是否可以上网".to_gbk
            response = ping(@ts_web)
            assert(response, "静态拨号后不可以访问外网！")
        }

        operate("3、然后手动切换为3/4G上网，查看切换是否成功，PC1切换后是否能上网，状态页面显示是否正确") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wan_page.set_3g_auto_dial(@browser.url) #3、4G上网
            sleep 20
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "验证3G/4G是否拨号成功".to_gbk
            @status_page.open_systatus_page(@browser.url)
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

            p "验证3/4G拨号后判断能否上网".to_gbk
            response = ping(@ts_web)
            assert(response, "3/4G拨号后不可以访问外网！")
        }

        operate("4、手动切换为有线上网，WAN配置为STATIC，PC1切换后是否能上网，状态页面显示是否正确") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "验证STATIC是否拨号成功".to_gbk
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'STATIC获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_static}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'STATIC获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'STATIC获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'STATIC获取dns ip地址失败！')

            p "判断静态拨号后是否可以上网".to_gbk
            response = ping(@ts_web)
            assert(response, "静态拨号后不可以访问外网！")
        }


    end

    def clearup
        operate("恢复默认DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
