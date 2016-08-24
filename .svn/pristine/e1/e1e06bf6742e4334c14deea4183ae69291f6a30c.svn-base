#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_7.1.34", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time       = 3
        @tc_static_time     = 50
        @tc_net_time        = 60
        @tc_staticbackupDns = "8.8.8.8"
    end

    def process

        operate("1、被测AP中插入中国电信4G卡") {

        }

        operate("2、配置被测AP为通过STATIC方式上网。PC1上网成功") {
            #设置为STATIC拨号
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败")
            @wan_iframe.link(id: @ts_tag_wired_mode_link).wait_until_present(@tc_wait_time)
            @wan_iframe.link(id: @ts_tag_wired_mode_link).click #网线连接
            static_radio = @wan_iframe.radio(id: @ts_tag_wired_static)
            static_radio.click #静态IP，手动方式
            #输入后如果发现未输入成功，则再输入一次
            static_ip = @wan_iframe.text_field(:id, @ts_tag_staticIp)
            static_ip.set(@ts_staticIp)
            static_ip.set(@ts_staticIp) unless static_ip.value == @ts_staticIp
            static_mask = @wan_iframe.text_field(:id, @ts_tag_staticNetmask)
            static_mask.set(@ts_staticNetmask)
            static_mask.set(@ts_staticNetmask) unless static_mask.value == @ts_staticNetmask
            static_gateway = @wan_iframe.text_field(:id, @ts_tag_staticGateway)
            static_gateway.set(@ts_staticGateway)
            static_gateway.set(@ts_staticGateway) unless static_gateway.value == @ts_staticGateway
            static_dns = @wan_iframe.text_field(:id, @ts_tag_staticPriDns)
            static_dns.set(@ts_staticPriDns)
            static_dns.set(@ts_staticPriDns) unless static_dns.value == @ts_staticPriDns
            if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
                static_bkdns = @wan_iframe.text_field(:id, @ts_tag_backupDns)
                static_bkdns.set(@tc_staticbackupDns)
                static_bkdns.set(@tc_staticbackupDns) unless static_bkdns.value == @tc_staticbackupDns
            end
            @wan_iframe.button(:id, @ts_tag_sbm).click
            sleep @tc_static_time
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "验证STATIC是否拨号成功".to_gbk
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            assert_match(@ip_regxp, wan_addr, 'STATIC获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_static}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'STATIC获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'STATIC获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'STATIC获取dns ip地址失败！')
            p "判断是否上网成功".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "不可以访问#{@ts_web}".to_gbk)
        }

        operate("3、然后手动切换为3/4G上网，查看切换是否成功，PC1切换后是否能上网，状态页面显示是否正确") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败")
            @wan_iframe.link(id: @ts_tag_3g_mode_link).click
            @wan_iframe.radio(id: @ts_tag_3g_auto).click
            @wan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_net_time
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "验证3G/4G是否拨号成功".to_gbk
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            sleep @tc_wait_time

            sim_status = @status_iframe.b(:id => @ts_tag_sim_status).parent.img.src
            wifi_signal = @status_iframe.b(:id => @ts_tag_signal_strenth).parent.img.src
            register_status = @status_iframe.b(:id => @ts_tag_reg_status).parent.img.src
            net_status = @status_iframe.b(:id => @ts_tag_3g_net_status).parent.img.src
            net_type = @status_iframe.b(:id => @ts_tag_3g_net_type).parent.text
            ispname = @status_iframe.b(:id => @ts_tag_3g_ispname).parent.text
            assert_match(@ts_tag_img_normal, sim_status, '3G/4G SIM卡状态异常')
            assert_match(@ts_tag_signal_normal, wifi_signal, '3G/4G 信号强度状态异常')
            assert_match(@ts_tag_img_normal, register_status, '3G/4G 注册状态异常')
            assert_match(@ts_tag_img_normal, net_status, '3G/4G 联网状态异常')
            assert_match(@ts_tag_4g_nettype_text, net_type, '3G/4G 网络类型异常')
            assert_match(@ts_tag_3g_ispname_text, ispname, '3G/4G 运营商名称异常')
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            assert_match(@ip_regxp, wan_addr, '3G/4G获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_3g_4g}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, '3G/4G获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, '3G/4G获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, '3G/4G获取dns ip地址失败！')

            p "判断是否上网成功".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "不可以访问#{@ts_web}".to_gbk)
        }

        operate("4、手动切换为有线上网，WAN配置为STATIC，PC1切换后是否能上网，状态页面显示是否正确") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            #设置为STATIC拨号
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败")
            @wan_iframe.link(id: @ts_tag_wired_mode_link).wait_until_present(@tc_wait_time)
            @wan_iframe.link(id: @ts_tag_wired_mode_link).click #网线连接
            static_radio = @wan_iframe.radio(id: @ts_tag_wired_static)
            static_radio.click #静态IP，手动方式
            #输入后如果发现未输入成功，则再输入一次
            static_ip = @wan_iframe.text_field(:id, @ts_tag_staticIp)
            static_ip.set(@ts_staticIp)
            static_ip.set(@ts_staticIp) unless static_ip.value == @ts_staticIp
            static_mask = @wan_iframe.text_field(:id, @ts_tag_staticNetmask)
            static_mask.set(@ts_staticNetmask)
            static_mask.set(@ts_staticNetmask) unless static_mask.value == @ts_staticNetmask
            static_gateway = @wan_iframe.text_field(:id, @ts_tag_staticGateway)
            static_gateway.set(@ts_staticGateway)
            static_gateway.set(@ts_staticGateway) unless static_gateway.value == @ts_staticGateway
            static_dns = @wan_iframe.text_field(:id, @ts_tag_staticPriDns)
            static_dns.set(@ts_staticPriDns)
            static_dns.set(@ts_staticPriDns) unless static_dns.value == @ts_staticPriDns
            if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
                static_bkdns = @wan_iframe.text_field(:id, @ts_tag_backupDns)
                static_bkdns.set(@tc_staticbackupDns)
                static_bkdns.set(@tc_staticbackupDns) unless static_bkdns.value == @tc_staticbackupDns
            end
            @wan_iframe.button(:id, @ts_tag_sbm).click
            sleep @tc_static_time
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "验证STATIC是否拨号成功".to_gbk
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            assert_match(@ip_regxp, wan_addr, 'STATIC获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_static}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'STATIC获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'STATIC获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'STATIC获取dns ip地址失败！')
            p "判断是否上网成功".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "不可以访问#{@ts_web}".to_gbk)
        }


    end

    def clearup
        operate("恢复默认DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            flag        = false
            #设置wan连接方式为网线连接
            rs1         = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
            unless rs1.class_name =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
                flag = true
            end

            #查询是否为为dhcp模式
            dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
            dhcp_radio_state = dhcp_radio.checked?
            #设置WIRE WAN为DHCP模式
            unless dhcp_radio_state
                dhcp_radio.click
                flag = true
            end

            if flag
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "Waiting for net reset..."
                sleep @tc_net_time
            end
        }
    end

}
