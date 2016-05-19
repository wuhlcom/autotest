#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.12", "level" => "P3", "auto" => "n"}

    def prepare
        require 'net/http'
        DRb.start_service
        @tc_dumpcap_pc2       = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time         = 3
        @tc_net_wait_time     = 60
        @tc_reboot_wait_time  = 120
        @tc_select_type       = "白名单"
        @url_filter           = "www.baidu.com"
        @url_unfilter_arr     = ["www.sina.com.cn", "www.yahoo.com"]
        @tc_intset_list_white = "white"
        @tc_intset_list       = "intset_list"
        @tc_intset_list_cls   = "text"
        @tc_url_b_save_text   = "设置白名单成功，黑名单失效！"
    end

    def process
        operate("0、获取ssid跟密码") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            @ssid     = wifi_ssid.value
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #选择安全模式
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            @pwd = wifi_pwd.value
            p "ssid->#{@ssid}".to_gbk
            p "pwd->#{@pwd}".to_gbk
        }

        operate("1、登陆DUT，WAN接入设置为PPPoE方式；") {
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_netset).click #打开外网
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败！")
            pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
            pppoe_radio_state = pppoe_radio.attribute_value(:checked)
            unless pppoe_radio_state == "true"
                pppoe_radio.click
            end
            puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
            @wan_iframe.text_field(id: @ts_tag_pppoe_usr).wait_until_present(@tc_wait_time)
            @wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            @wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            @wan_iframe.button(id: @ts_tag_sbm).click #保存
            net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
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
            @option_iframe.link(id: @ts_tag_security).click #进入安全设置
            @option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
            # @option_iframe.link(id: @ts_tag_fwset).click #防火墙设置
            switch_flag = false
            @option_iframe.button(id: @ts_tag_security_sw).wait_until_present(@tc_wait_time)
            if @option_iframe.button(id: @ts_tag_security_sw).class_name == "off"
                @option_iframe.button(id: @ts_tag_security_sw).click
                switch_flag = true
            end
            if @option_iframe.button(id: @ts_tag_security_url).class_name == "off"
                @option_iframe.button(id: @ts_tag_security_url).click
                switch_flag = true
            end
            if switch_flag
                @option_iframe.button(id: @ts_tag_security_save).click #保存
                sleep @tc_wait_time
            end
        }

        operate("3、在URL过滤设置界面选择白名单，添加过滤关键字www.baidu.com,保存；") {
            @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_url_set).click
            b_select = @option_iframe.select_list(id: @ts_url_black) #选择白名单
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)
            # @option_iframe.text_field(id: @ts_web_url).set(@url)
            #名单中有则不添加
            url_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            unless url_arr.include?(@url_filter)
                @option_iframe.text_field(id: @ts_web_url).set(@url_filter)
                @option_iframe.link(class_name: @ts_tag_addvir).click
                @option_iframe.button(id: @ts_tag_security_save).click
                url_save_div = @option_iframe.div(class_name: @ts_tag_net_reset, text: @tc_url_b_save_text)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    url_save_div.present?
                }

                urlnew_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
                urlnew_arr = urlnew_str.split("\n")

                sleep @tc_wait_time
                assert(urlnew_arr.include?(@url_filter), "error-->添加关键字#{@tc_tag_select_url}不成功！")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("4、PC1,PC2是否可以访问www.sina.com.cn，www.yahoo.cn，www.baidu.com等站点；") {
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)

            p "访问未添加白名单过滤规则的站点".to_gbk
            @url_unfilter_arr.each do |url|
                p "PC1访问站点：#{url}".to_gbk
                response = send_http_request(url)
                assert(!response, "#{url}未添加到到白名单过滤规则，但PC1能访问外网#{url}".to_gbk)
                p "PC2访问站点：#{url}".to_gbk
                response = @tc_dumpcap_pc2.send_http_request(url)
                assert(!response, "#{url}未添加到到白名单过滤规则，但PC2能访问外网#{url}".to_gbk)
            end
            p "访问已添加到白名单过滤规则的站点：#{@url_filter}".to_gbk
            p "PC1访问站点：#{@url_filter}".to_gbk
            response = send_http_request(@url_filter)
            assert(response, "#{@url_filter}已经添加到到白名单过滤规则，但PC1不能访问外网#{@url_filter}".to_gbk)
            p "PC2访问站点：#{@url_filter}".to_gbk
            response = @tc_dumpcap_pc2.send_http_request(@url_filter)
            assert(response, "#{@url_filter}已经添加到到白名单过滤规则，但PC2不能访问外网#{@url_filter}".to_gbk)
        }

        operate("5、重启AP后，PC1,PC2是否可以访问www.sina.com.cn，www.yahoo.cn，www.baidu.com等站点；") {
            @browser.span(id: @ts_tag_reboot).parent.click #点击重启按钮
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_reboot_wait_time
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            assert(login_ui, "重启失败！")

            p "等待过滤规则生效...".to_gbk
            sleep @tc_net_wait_time  #等待重启后过滤规则生效
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)

            p "访问未添加白名单过滤规则的站点".to_gbk
            @url_unfilter_arr.each do |url|
                p "PC1访问站点：#{url}".to_gbk
                response = send_http_request(url)
                assert(!response, "#{url}未添加到到白名单过滤规则，但PC1能访问外网#{url}".to_gbk)
                p "PC2访问站点：#{url}".to_gbk
                response = @tc_dumpcap_pc2.send_http_request(url)
                assert(!response, "#{url}未添加到到白名单过滤规则，但PC2能访问外网#{url}".to_gbk)
            end
            p "访问已添加到白名单过滤规则的站点：#{@url_filter}".to_gbk
            p "PC1访问站点：#{@url_filter}".to_gbk
            response = send_http_request(@url_filter)
            assert(response, "#{@url_filter}已经添加到到白名单过滤规则，但PC1不能访问外网#{@url_filter}".to_gbk)
            p "PC2访问站点：#{@url_filter}".to_gbk
            response = @tc_dumpcap_pc2.send_http_request(@url_filter)
            assert(response, "#{@url_filter}已经添加到到白名单过滤规则，但PC2不能访问外网#{@url_filter}".to_gbk)
        }


    end

    def clearup
        operate("恢复默认配置") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            p "恢复为默认的接入方式，DHCP接入".to_gbk
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip) #登录
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

            p "关闭防火墙总开关和url过滤总开关".to_gbk
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
            p "删除所有添加规则".to_gbk
            @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_url_set).click
            b_select = @option_iframe.select_list(id: @ts_url_black) #选择白名单
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)
            url_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            #需要模拟鼠标移动到该条目上(在该条目上做点击操作)，才能实施删除操作
            begin
                unless url_arr.empty?
                    url_arr.each do |url|
                        puts "删除白名单:#{url}".to_gbk
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
