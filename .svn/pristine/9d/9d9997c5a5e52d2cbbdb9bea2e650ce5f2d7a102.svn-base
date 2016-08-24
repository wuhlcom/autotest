#
#description:#
# 用例描述的测试点太多，太过复杂，自动化不好实现
# 实现了也会增加维护成本
# 将用例拆分后再实现
# 实现了dhcp,pppoe,static接入方式切换时wan状态显示
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.22", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time  = 5
        @tc_input_time = 2
        @tc_net_time   = 50
    end

    def process

        operate("1 打开外网连接设置") {
        }

        operate("2 设置外网接入方式为：DHCP") {
            #查看WAN接入方式是否为DHCP
            @browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_status).click
            sleep @tc_wait_time
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            #如果不是DHCP则修改为DHCP
            unless wan_type =~ /#{@ts_wan_mode_dhcp}/
                puts "切换为DHCP接入方式".to_gbk
                if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                    @browser.execute_script(@ts_close_div)
                end
                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                assert(@wan_iframe.exists?, "打开外网设置失败")
                @wan_iframe.link(:id => @ts_tag_wired_mode_link).click #选择网线连接
                dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
                dhcp_radio.click
                #保存设置，切换为DHCP模式
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "sleep #{@tc_net_time} second for net reseting..."
                sleep @tc_net_time
            end
        }

        operate("3 查看DHCP接入时WAN状态") {
            #关闭WAN设置
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            assert(@status_iframe.exists?, '打开WAN状态失败！')

            wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_addr =~@ts_tag_ip_regxp
            puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

            wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            wan_type =~/(#{@ts_wan_mode_dhcp})/
            puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

            mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            mask =~@ts_tag_ip_regxp
            puts "WAN状态显示的掩码地址为：#{Regexp.last_match(1)}".to_gbk

            gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            gateway_addr =~@ts_tag_ip_regxp
            puts "WAN状态显示的网关IP地址为：#{Regexp.last_match(1)}".to_gbk

            dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            dns_addr =~@ts_tag_ip_regxp
            puts "WAN状态显示的DNS IP地址为：#{Regexp.last_match(1)}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
            assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'dhcp获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'dhcp获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'dhcp获取dns ip地址失败！'
        }

        operate("4 修改接入方式为PPPOE") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            wanset = @browser.span(:id => @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_netset).click if wanset
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败！")

            rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
            unless rs1 =~/#{@ts_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
            end

            pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
            pppoe_radio_state = pppoe_radio.checked?
            unless pppoe_radio_state
                pppoe_radio.click
                @wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
                @wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
                @wan_iframe.button(:id, @ts_tag_sbm).click
                # Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
                # 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
                # }
                # Watir::Wait.while(@tc_net_time, "正在重启网络配置".to_gbk) {
                # 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present?
                # }
                sleep @tc_net_time
            end
        }

        operate("5 查看PPPOE接入时WAN状态") {
            #关闭WAN设置
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            assert(@status_iframe.exists?, '打开WAN状态失败！')
            wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_addr =~@ts_tag_ip_regxp
            puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

            wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            wan_type =~/(#{@ts_wan_mode_pppoe})/
            puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

            mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            mask =~@ts_tag_ip_regxp
            puts "WAN状态显示的掩码地址为：#{Regexp.last_match(1)}".to_gbk

            gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            gateway_addr =~@ts_tag_ip_regxp
            puts "WAN状态显示的网关IP地址为：#{Regexp.last_match(1)}".to_gbk

            dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            dns_addr =~@ts_tag_ip_regxp
            puts "WAN状态显示的DNS IP地址为：#{Regexp.last_match(1)}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
        }

        operate("6 设置接入方式为Static") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            wanset = @browser.span(:id => @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_netset).click if wanset
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败！")

            rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
            unless rs1 =~/#{@ts_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
            end

            static_radio       = @wan_iframe.radio(id: @ts_tag_wired_static)
            static_radio_state = static_radio.checked?
            unless static_radio_state
                static_radio.click
            end

            puts "设置静态IP地址为：#{@ts_staticIp}".to_gbk
            @wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
            @wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
            @wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
            @wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
            sleep @tc_input_time
            if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
                @wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
            end
            @wan_iframe.button(:id, @ts_tag_sbm).click
            # Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
            # 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
            # }
            # Watir::Wait.while(@tc_net_time, "正在重启网络配置".to_gbk) {
            # 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present?
            # }
            sleep @tc_net_time
        }

        operate("7 静态接入时查看WAN状态") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            assert(@status_iframe.exists?, '打开WAN状态失败！')
            wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_addr =~@ts_tag_ip_regxp
            puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

            wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            wan_type =~/(#{@ts_wan_mode_static})/
            puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

            mask = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            mask =~@ts_tag_ip_regxp
            puts "WAN状态显示的掩码地址为：#{Regexp.last_match(1)}".to_gbk

            gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            gateway_addr =~@ts_tag_ip_regxp
            puts "WAN状态显示的网关IP地址为：#{Regexp.last_match(1)}".to_gbk

            dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            dns_addr =~@ts_tag_ip_regxp
            puts "WAN状态显示的DNS IP地址为：#{Regexp.last_match(1)}".to_gbk
            assert_match @ts_tag_ip_regxp, wan_addr, '静态ip配置失败！'
            assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, '静态ip掩码配置失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, '静态配置网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, '静态配置dns ip地址失败！'
        }


    end

    def clearup

        operate("1 恢复默认的接入方式") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end

            wanset = @browser.span(:id => @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_netset).click if wanset
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)

            rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
            unless rs1 =~/#{@ts_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
            end

            dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
            dhcp_radio_state = dhcp_radio.checked?
            unless dhcp_radio_state
                dhcp_radio.click
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "sleep #{@tc_net_time} seconds for net reseting....."
                sleep @tc_net_time
            end
        }
    end

}
