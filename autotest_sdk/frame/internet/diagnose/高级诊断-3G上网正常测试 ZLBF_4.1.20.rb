#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.20", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time                = 2
        @tc_clearup_time             = 30
        @tc_net_wait_time            = 50
        @tc_dial_time                = 90
        @tc_diagnose_time            = 120
        @tc_tag_3g_mode_link         = "tab_3g"
        @tc_tag_3g_mode_span         = "dial"
        @tc_tag_3g_auto              = "3g_auto_type"
        @tc_tag_wan_mode_span        = "wire"
        @tc_tag_wan_mode_link        = "tab_ip"
        @tc_tag_wire_mode_label      = "wire-dhcp"
        @tc_tag_wire_mode_radio_dhcp = "ip_type_dhcp"
        @tc_tag_3g_mode              = "3g_auto_type"
        @tc_tag_check_status         = "checked"
        @tc_tag_select_state         = "selected"
        @tc_wan_status               = "正常"
        @tc_wan_dial_reg             =/[34]G/
    end

    def process

        operate("1、插入3G上网卡，参数配置正确，进行高级诊断") {
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, '打开外网设置失败！')


            rs1=@wan_iframe.link(:id => @tc_tag_3g_mode_link).class_name
            unless rs1 =~/#{@tc_tag_select_state}/
                rs2 = @wan_iframe.span(:id => @tc_tag_3g_mode_span).click
                rs3 = @wan_iframe.link(:id => @tc_tag_3g_mode_link).class_name
                assert_match /#{@tc_tag_select_state}/, rs3, '未选择3/4G设置'
            end

            auto_3g       = @wan_iframe.radio(:id => @tc_tag_3g_auto)
            auto_3g_state = auto_3g.checked?
            auto_3g.click unless auto_3g_state
            @wan_iframe.button(:id, @ts_tag_sbm).click
            sleep @tc_wait_time
            net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
                net_reset_div.visible?
            }
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                net_reset_div.present?
            }
            sleep @tc_dial_time
        }

        operate("2、进行高级诊断") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            sleep @tc_wait_time
            #open diagnose
            @browser.link(id: @ts_tag_diagnose).click()
            sleep @tc_wait_time
            #获取@browser对象下各个窗口对象的句柄对象
            @tc_handles = @browser.driver.window_handles
            assert(@tc_handles.size==2, "未打开诊断窗口")
            #通过句柄来切换不同的windows窗口
            @browser.driver.switch_to.window(@tc_handles[1])
            # 打开高级诊断
            @browser.link(id: @ts_tag_ad_diagnose).click
            @browser.text_field(id: @ts_tag_url).wait_until_present(@tc_wait_time)
            @browser.text_field(id: @ts_tag_url).set(@ts_diag_web)
            @browser.button(id: @ts_tag_diag_btn).click
            Watir::Wait::until(@tc_wait_time, "正在进行高级诊断") {
                @browser.div(text: @ts_tag_diag_ad_detecting).present?
            }
            Watir::Wait::until(@tc_diagnose_time, "高级诊断完成") {
                @browser.p(text: /#{@ts_tag_diag_nettype}/).present?
            }

            tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
            puts "上网连接类型：#{tc_net_type}".to_gbk
            assert_match(/#{@tc_wan_dial_reg}/, tc_net_type, "上网连接类型错误")
            if @browser.p(text: /#{@ts_tag_net_status}/).exists?
                tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
                puts "WAN口连接状态：#{tc_net_status}".to_gbk
                assert_equal(@tc_wan_status, tc_net_status, "上网连接状态异常")
            end
            tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
            puts "域名：#{@ts_diag_web}，解析为：#{tc_net_domain_ip}".to_gbk
            assert_match(@ts_ip_reg, tc_net_domain_ip, "域名解析失败")
            tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
            puts "诊断过程丢包率为：#{tc_loss_rate}".to_gbk
            assert_equal(@ts_loss_rate, tc_loss_rate, "诊断过程丢包过多")
            tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
            puts "DNS解析状态：#{tc_dns_status}".to_gbk
            assert_equal(@ts_dns_status, tc_dns_status, "DNS解析失败")
            tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
            puts "HTTP响应码：#{tc_http_code}".to_gbk
            assert_equal(tc_http_code, @ts_http_status, "HTTP响应错误")
        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
            unless @tc_handles.nil?
                @browser.driver.switch_to.window(@tc_handles[0])
            end

            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            sleep @tc_wait_time
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe
            #设置wan连接方式为网线连接
            rs1         =@wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
            flag        =false
            unless rs1 =~/#{@tc_tag_select_state}/
                @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
                flag=true
            end

            #查询是否为为dhcp模式
            dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio_dhcp)
            dhcp_radio_state = dhcp_radio.checked?

            #设置WIRE WAN为dhcp
            unless dhcp_radio_state
                dhcp_radio.click
                flag=true
            end

            if flag
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "Waiting for net reset..."
                sleep @tc_clearup_time
            end
        }
    end

}
