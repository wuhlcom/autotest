#
# description:
# author:liluping
# date:2015-09-16
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.1", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time                = 3
        @tc_net_wait_time            = 60
        @tc_tag_wire_mode_radio      = "ip_type_pppoe"
        @tc_tag_sbm                  = "submit_btn"
        @tc_tag_iframe_close         = "aui_close"
        @tc_tag_wire_mode_radio_dhcp = "ip_type_dhcp"
        @tc_tag_link_error           = "errorTitleText"
        @tc_tag_wan_mode_link        = "tab_ip"
        @tc_select_state             = "selected"
        @tc_tag_wan_mode_span        = "wire"

        # @tc_tag_options              = "options"
        @tc_tag_secseting            = "securitysetting"
        @tc_tag_fw_seting            = "Firewall-Settings"
        @tc_tag_url_setting          = "menu_set"
        @tc_tag_select               = "b_w_select"
        @tc_tag_select_black         = "opa"
        @tc_tag_select_white         = "opb"
        @tc_tag_select_text          = "b_w_url"
        @tc_tag_select_add_btn       = "add_btn"

        @tc_tag_fw_button         = "switch1"
        @tc_tag_url_button        = "switch4"
        @tc_tag_save_button       = "save_btn"
        @tc_tag_button_switch_off = "off"
        @tc_tag_button_switch_on  = "on"
        @tc_intset_list           = "intset_list"
        @tc_intset_list_black     = "black"
        @tc_intset_list_white     = "white"
        @tc_intset_list_cls       = "text"
        @tc_select_type           = "黑名单"

        @tc_pppoe_usr       = 'pppoe@163.gd'
        @tc_pppoe_pw        = 'PPPOETEST'
        @tc_tag_pppoe_usrid = 'pppoeUser'
        @tc_tag_pppoe_pwid  = 'input_password1'
        @tc_tag_select_url  = 'www.yahoo.com'
        @tc_tag_url_baidu   = 'www.baidu.com'
        @tc_tag_url_sina    = 'www.sina.com.cn'
    end

    def process

        operate("1、登陆DUT，WAN接入设置为PPPoE方式；") {
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time) #等待2s
            @browser.span(id: @ts_tag_netset).click

            @pop_iframe = @browser.iframe(src: @ts_tag_netset_src) #新面板，新对象
            assert(@pop_iframe.exists?, "打开外网设置失败！")
            pppoe_radio       = @pop_iframe.radio(id: @tc_tag_wire_mode_radio)
            pppoe_radio_state = pppoe_radio.attribute_value(:checked)
            unless pppoe_radio_state == "true"
                pppoe_radio.click
            end
            sleep @tc_wait_time
            puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
            @pop_iframe.text_field(id: @tc_tag_pppoe_usrid).set(@tc_pppoe_usr)
            @pop_iframe.text_field(id: @tc_tag_pppoe_pwid).set(@tc_pppoe_pw)
            @pop_iframe.button(id: @tc_tag_sbm).click

            sleep @tc_wait_time
            net_reset_div = @pop_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
                net_reset_div.visible?
            }
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                net_reset_div.present?
            }

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、先进入到安全设置的防火墙设置界面，开启防火墙总开关和URL过虑开关，保存；") {
            @browser.link(id: @ts_tag_options).click

            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            option_link       = @option_iframe.link(id: @tc_tag_secseting)
            option_link_state = option_link.attribute_value(:checked)
            unless option_link_state == "true"
                option_link.click
            end

            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "开启防火墙总开关和URL过滤开关".to_gbk
            btn_fw_off = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_off)
            if btn_fw_off.exists? #关闭状态就不再操作了
                btn_fw_off.click
            end
            btn_url_off = @option_iframe.button(id: @tc_tag_url_button, class_name: @tc_tag_button_switch_off)
            if btn_url_off.exists?
                btn_url_off.click
            end

            @option_iframe.button(id: @tc_tag_save_button).click

        }

        operate("3、进入URL过滤设置页面，选择黑名单，添加过滤关键字www.yahoo.com，保存；") {
            @option_iframe.link(id: @tc_tag_url_setting).wait_until_present(@tc_wait_time)
            option_url_iframe = @option_iframe.link(id: @tc_tag_url_setting)
            option_url_iframe.click

            puts "添加过滤关键字".to_gbk
            select_click = @option_iframe.select_list(id: @tc_tag_select)
            select_click.select("黑名单")
            #名单中有则不添加
            url_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            if !url_arr.include?(@tc_tag_select_url)
                @option_iframe.text_field(id: @tc_tag_select_text).set(@tc_tag_select_url)
                @option_iframe.link(class_name: @tc_tag_select_add_btn).click
                @option_iframe.button(id: @tc_tag_save_button).click

                urlnew_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
                urlnew_arr = urlnew_str.split("\n")

                sleep 2
                assert(urlnew_arr.include?(@tc_tag_select_url), "error-->添加关键字#{@tc_tag_select_url}不成功！")
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }


        operate("4、PC1,PC2是否可以访问www.sina.com.cn，www.yahoo.cn，www.baidu.com等站点。") {
            puts "正在访问#{@tc_tag_url_baidu}站点...".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "黑名单过滤规则中无#{@tc_tag_url_baidu}，但不可以访问#{@tc_tag_url_baidu}".to_gbk)

            puts "正在访问#{@tc_tag_url_sina}站点...".to_gbk
            response = send_http_request(@tc_tag_url_sina)
            assert(response, "黑名单过滤规则中无#{@tc_tag_url_sina}，但可以访问#{@tc_tag_url_sina}".to_gbk)

            puts "正在访问#{@tc_tag_select_url}站点...".to_gbk
            response = send_http_request(@tc_tag_select_url)
            assert(!response, "黑名单过滤规则中有#{@tc_tag_select_url}，可以访问#{@tc_tag_select_url}".to_gbk)
        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end

            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe

            flag = false
            #设置wan连接方式为网线连接
            rs1  = @wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
            unless rs1 =~/ #{@tc_select_state}/
                @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
                flag = true
            end

            #查询是否为为dhcp模式
            dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio_dhcp)
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

        operate("2 关闭防火墙总开关和URL过滤开关") {
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser) #重新登录
            end
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_security).click #进入安全设置
            @option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
            # @option_iframe.link(id: @ts_tag_fwset).click #防火墙设置
            switch_flag = false
            @option_iframe.button(id: @ts_tag_security_sw).wait_until_present(@tc_wait_time)
            if @option_iframe.button(id: @ts_tag_security_sw).class_name == "on"
                @option_iframe.button(id: @ts_tag_security_sw).click
                switch_flag = true
            end
            if @option_iframe.button(id: @ts_tag_security_url).class_name == "on"
                @option_iframe.button(id: @ts_tag_security_url).click
                switch_flag = true
            end
            if switch_flag
                @option_iframe.button(id: @ts_tag_security_save).click #保存
                sleep @tc_wait_time
            end

        }

        operate("3 清除黑名单") {
            @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_url_set).click
            b_select = @option_iframe.select_list(id: @ts_url_black) #选择黑名单
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)
            url_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            #需要模拟鼠标移动到该条目上(在该条目上做点击操作)，才能实施删除操作
            begin
                unless url_arr.empty?
                    url_arr.each do |url|
                        puts "删除黑名单:#{url}".to_gbk
                        @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
                        delete_btn = @option_iframe.span(text: url, class_name: @tc_intset_list_cls).parent.link(class_name: "delete")
                        sleep 1 #延迟1s
                        for n in 0..3
                            if delete_btn.exists?
                                delete_btn.click
                                break
                            end
                            @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
                            sleep 1 #延迟1s
                        end
                        # delete_btn.click
                        sleep @tc_wait_time
                    end
                end
            ensure
                @option_iframe.button(id: @ts_tag_security_save).click #保存
                sleep @tc_wait_time
            end
        }
    end

}
