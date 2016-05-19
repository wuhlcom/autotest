#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_7.1.26", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time           = 2
        @tc_net_wait_time       = 50
        @tc_dispear_time        = 60
        @tc_tag_wan_mode_link   = "tab_ip"
        @tc_tag_wan_mode_span   = "wire"
        @tc_tag_select_state    = "selected"
        @tc_tag_wire_mode_radio = "ip_type_pppoe"
        @tc_tag_net_resset_tip  = "aui_content"
        @tc_tag_style_padding   = "padding"
        @tc_wire_mode           = "PPPOE"
        @tc_tag_pppoe_usrid     = 'pppoeUser'
        @tc_tag_pppoe_pwid      = 'input_password1'

        @tc_tag_wire_mode_radio_dhcp = "ip_type_dhcp"
        @tc_wan_type_dhcp            = "DHCP"


        @tc_tag_wan_mode_span_3g = "dial"
        @tc_tag_wan_mode_link_3g = "tab_3g"
        @tc_tag_3g_auto          = "3g_auto_type"
        @tc_wan_type_3g          = "3G/4G"
        @tc_tag_sim              = "sim"
        @tc_sim                  = "已检测到SIM卡"
        @tc_tag_3g_reg           = "reg"
        @tc_reg                  = "已注册"

    end

    def process

        operate("1 打开外网连接设置") {
            wanset = @browser.span(:id => @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_netset).click if wanset
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败")
        }

        operate("2 设置为有线连接") {
            @wan_iframe.link(:id => @tc_tag_wan_mode_link).wait_until_present(@tc_wait_time)
            rs1=@wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
            unless rs1 =~/#{@tc_tag_select_state}/
                @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
            end
        }

        operate("3 设置外网PPPOE接入") {
            pppoe_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio)
            pppoe_radio_state = pppoe_radio.checked?
            unless pppoe_radio_state
                pppoe_radio.click
                sleep 1
            end

            puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
            @wan_iframe.text_field(id: @tc_tag_pppoe_usrid).set(@ts_pppoe_usr)
            @wan_iframe.text_field(id: @tc_tag_pppoe_pwid).set(@ts_pppoe_pw)
            @wan_iframe.button(id: @ts_tag_sbm).click
            sleep 2
            net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
                net_reset_div.visible?
            }
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                net_reset_div.present?
            }
        }

        operate("4 检查PPPOE接入网络功能") {
            sleep 10
            rs = ping(@ts_web)
            assert(rs, '无法连接网络')
        }

        operate("5 查看WAN状态") {
            #关闭WAN设置
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click

            Watir::Wait.until(@tc_wait_time, "系统状态窗口未出现") {
                @status_iframe = @browser.iframe(:src, @ts_tag_status_iframe_src)
                @status_iframe.present?
            }

            wan_addr     = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type     = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask         = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr     = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@tc_wire_mode}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
        }

        operate("6 重打开外网连接设置") {
            #关闭WAN设置
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            wanset = @browser.span(:id => @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_netset).click if wanset
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败")
        }

        operate("7 设置3/4G连接方式") {
            Watir::Wait.until(@tc_wait_time, "等待网络连接模式出现") {
                @wan_iframe.link(:id, @tc_tag_wan_mode_link_3g).visible?
            }
            #切换到3/4G连接
            rs1=@wan_iframe.link(:id => @tc_tag_wan_mode_link_3g).class_name
            unless rs1 =~/#{@tc_tag_select_state}/
                @wan_iframe.span(:id => @tc_tag_wan_mode_span_3g).click
            end

            #选择3/4的模式为自动模式
            auto_3g       = @wan_iframe.radio(:id => @tc_tag_3g_auto)
            auto_3g_state = auto_3g.checked?
            auto_3g.click unless auto_3g_state
            sleep 1
            @wan_iframe.button(:id, @ts_tag_sbm).click

            sleep 2
            net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
                net_reset_div.visible?
            }
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                net_reset_div.present?
            }
        }

        operate("8 验证业务") {
            #等待SIM卡注册成功
            sleep 90
            rs = ping(@ts_web)
            assert(rs, '无法连接网络')
        }

        operate("9 查看WAN状态") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            Watir::Wait.until(@tc_wait_time, "系统状态窗口未出现") {
                @status_iframe = @browser.iframe(:src, @ts_tag_status_iframe_src)
                @status_iframe.present?
            }
            wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask     = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            #gateway_addr = @status_iframe.b(:id => @tag_wan_gw).parent.text
            dns_addr = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

            assert_match @ts_tag_ip_regxp, wan_addr, '3G获取ip地址失败！'
            assert_match /#{@tc_wan_type_3g}/, wan_type, '接入类型错误！'
            #assert_match @ip_regxp, gateway_addr, '3G获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, mask, '3G获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, '3G获取dns ip地址失败！'

            # 	sim = @status_iframe.p(:id => @tc_tag_sim).text
            # 	puts sim.to_gbk

            # 	reg = @status_iframe.p(:id => @tc_tag_3g_reg).text
            # 	puts reg.to_gbk
            sim = @status_iframe.p(:id => @tc_tag_sim).image(src: @ts_tag_img_normal)
            reg = @status_iframe.p(:id => @tc_tag_3g_reg).image(src: @ts_tag_img_normal)
            # 	assert_match /#{@tc_sim}/, sim, 'sim卡状态异常'
            # 	assert_match /#{@tc_reg}/, reg, 'sim卡注册失败'
            assert(sim.exists?, "sim卡状态异常")
            assert(reg.exists?, "sim卡注册失败")
        }


    end

    def clearup

        operate("1 恢复为默认的接入方式，DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            Watir::Wait.until(@tc_wait_time, "系统状态窗口未出现") {
                @status_iframe = @browser.iframe(:src, @ts_tag_status_iframe_src)
                @status_iframe.present?
            }

            wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            #设置为默认的dhcp模式
            unless wan_type =~ /#{@tc_wan_type_dhcp}/
                #login_recover(@browser, @ts_default_ip)
                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe
                #设置wan连接方式
                rs1         = @wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
                unless rs1 =~/#{@tc_tag_select_state}/
                    @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
                end

                #查询是否为为dhcp模式
                dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio_dhcp)
                dhcp_radio_state = dhcp_radio.checked?

                #设置WIRE WAN为dhcp
                unless dhcp_radio_state
                    dhcp_radio.click
                end
                #提交设置
                @wan_iframe.button(:id, @ts_tag_sbm).click
                sleep @tc_net_wait_time
                # net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
                # Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
                # 	net_reset_div.visible?
                # }
                # Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                # 	net_reset_div.present?
                # }
            end
        }

    end

}
