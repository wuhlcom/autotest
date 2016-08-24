#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.60", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time     = 3
        @tc_net_wait_time = 60
        @tc_ip1           = "0.0.0.0"
        @tc_ip2           = "10.0.0.0"
        @tc_ip3           = "239.1.1.1"
        @tc_ip4           = "240.1.1.1"
        @tc_ip5           = "127.0.0.1"
        @tc_ip6           = "192.168.10"
        @tc_ip7           = "192.168.10.256"
        @tc_ip8           = "a.a.a.a"
    end

    def process

        operate("1、选择PPTP拨号方式；") {
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网失败")
            @wan_iframe.span(id: @ts_tag_wired_mode_span).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @ts_tag_wired_mode_span).click
            @wan_iframe.label(id: @ts_wired_static_id).click
        }

        operate("2、在IP地址输入0开头地址、或0结尾地址，如：0.0.0.0，10.0.0.0是否允许输入；") {
            @wan_iframe.text_field(id: @ts_wired_static_ip).set(@tc_ip1)
            @wan_iframe.button(id: @ts_tag_sbm).click
            err_msg = @wan_iframe.p(id: @ts_wired_static_err, text: @ts_wired_static_err_text)
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
            @wan_iframe.text_field(id: @ts_wired_static_ip).clear
            @wan_iframe.text_field(id: @ts_wired_static_ip).set(@tc_ip2)
            @wan_iframe.button(id: @ts_tag_sbm).click
            err_msg = @wan_iframe.p(id: @ts_wired_static_err, text: @ts_wired_static_err_text)
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }

        operate("3、IP地址输入组播地址，如239.1.1.1，是否允许输入；") {
            @wan_iframe.text_field(id: @ts_wired_static_ip).clear
            @wan_iframe.text_field(id: @ts_wired_static_ip).set(@tc_ip3)
            @wan_iframe.button(id: @ts_tag_sbm).click
            err_msg = @wan_iframe.p(id: @ts_wired_static_err, text: @ts_wired_static_err_text)
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }

        operate("4、IP地址输入E类地址，如240.1.1.1，是否允许输入；") {
            @wan_iframe.text_field(id: @ts_wired_static_ip).clear
            @wan_iframe.text_field(id: @ts_wired_static_ip).set(@tc_ip4)
            @wan_iframe.button(id: @ts_tag_sbm).click
            err_msg = @wan_iframe.p(id: @ts_wired_static_err, text: @ts_wired_static_err_text)
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }

        operate("5、IP地址输入环回地址，即127开头的地址，如127.0.0.1，是否允许输入；") {
            @wan_iframe.text_field(id: @ts_wired_static_ip).clear
            @wan_iframe.text_field(id: @ts_wired_static_ip).set(@tc_ip5)
            @wan_iframe.button(id: @ts_tag_sbm).click
            err_msg = @wan_iframe.p(id: @ts_wired_static_err, text: @ts_wired_static_err_text)
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }

        operate("6、IP地址输入错误格式地址，如192.168.10，192.168.10.256，a.a.a.a等；") {
            @wan_iframe.text_field(id: @ts_wired_static_ip).clear
            @wan_iframe.text_field(id: @ts_wired_static_ip).set(@tc_ip6)
            @wan_iframe.button(id: @ts_tag_sbm).click
            err_msg = @wan_iframe.p(id: @ts_wired_static_err, text: @ts_wired_static_err_text)
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
            @wan_iframe.text_field(id: @ts_wired_static_ip).clear
            @wan_iframe.text_field(id: @ts_wired_static_ip).set(@tc_ip7)
            @wan_iframe.button(id: @ts_tag_sbm).click
            err_msg = @wan_iframe.p(id: @ts_wired_static_err, text: @ts_wired_static_err_text)
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
            @wan_iframe.text_field(id: @ts_wired_static_ip).clear
            @wan_iframe.text_field(id: @ts_wired_static_ip).set(@tc_ip8)
            @wan_iframe.button(id: @ts_tag_sbm).click
            err_msg = @wan_iframe.p(id: @ts_wired_static_err, text: @ts_wired_static_err_text)
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
            end

            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe

            flag = false
            #设置wan连接方式为网线连接
            rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
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
                sleep @tc_net_wait_time
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
