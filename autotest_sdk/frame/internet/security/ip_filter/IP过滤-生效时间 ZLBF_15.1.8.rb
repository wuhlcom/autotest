#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.8", "level" => "P2", "auto" => "n"}

    def prepare
        @dut_ip       = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
        @tc_wait_time = 5
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_netset).click #外网
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            flag        = false
            #设置wan连接方式为网线连接
            rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(id: @ts_tag_wired_mode_span).click #网线连接
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
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "off"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "off"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #保存
        }

        operate("2、在IP过虑界面添加一条规则，生效时间设置为0000-1200,源IP为192.168.100.100,其它设置为默认的。当前时间为上午10点，PC1能否访问外网") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            #获取系统当前时间(小时)
            time_for_hour = Time.now.strftime("%H").to_i
            if (time_for_hour >= 0 && time_for_hour < 12)
                effective_time_start = "0000"
                effective_time_end   = "1200"
            else
                effective_time_start = "1200"
                effective_time_end   = "2359"
            end
            @option_iframe.text_field(id: @ts_ip_start_time).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_ip_start_time).set(effective_time_start)
            @option_iframe.text_field(id: @ts_ip_end_time).set(effective_time_end)
            @option_iframe.text_field(id: @ts_ip_src).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click
            @option_iframe.table(id: @ts_iptable).wait_until_present(@tc_wait_time)
            ip_clauses     = @option_iframe.table(id: @ts_iptable).trs.size
            effective_time = @option_iframe.table(id: @ts_iptable).trs[1][0].text
            time_math      = effective_time_start+"-"+effective_time_end
            if (ip_clauses == 1 && time_math != effective_time)
                assert(false, "生成新条目失败")
            end
            response = send_http_request(@ts_web)
            assert(!response, "可以访问#{@ts_web}".to_gbk)
        }

        operate("3、更改生效时间设置为1200-2300，PC1能否访问外网") {
            #获取系统当前时间(小时)
            time_for_hour = Time.now.strftime("%H").to_i
            if (time_for_hour >= 0 && time_for_hour < 12)
                effective_time_start = "1200"
                effective_time_end   = "2359"
            else
                effective_time_start = "0000"
                effective_time_end   = "1200"
            end
            @option_iframe.link(class_name: @ts_tag_edit).wait_until_present(@tc_wait_time)
            @option_iframe.link(class_name: @ts_tag_edit).click
            @option_iframe.text_field(id: @ts_ip_start_time1).set(effective_time_start)
            @option_iframe.text_field(id: @ts_ip_end_time1).set(effective_time_end)
            @option_iframe.button(id: @ts_tag_save_filter1).click
            sleep @tc_wait_time
            rs = @option_iframe.table(id: @ts_iptable)
            unless rs.exists? #出现空白时，刷新页面
                @browser.link(id: @ts_tag_options).click
                @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
                @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
                @option_iframe.link(id: @ts_tag_security).click
                @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
                @option_iframe.link(id: @ts_ip_set).click #IP过滤
                sleep @tc_wait_time
            end
            ip_clauses     = @option_iframe.table(id: @ts_iptable).trs.size
            effective_time = @option_iframe.table(id: @ts_iptable).trs[1][0].text
            time_math      = effective_time_start+"-"+effective_time_end
            if (ip_clauses == 1 || time_math != effective_time)
                assert(false, "生成新条目失败")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            response = send_http_request(@ts_web)
            assert(response, "不可以访问#{@ts_web}".to_gbk)
        }


    end

    def clearup
        operate("1、关闭防火墙总开关和IP过滤开关") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "on"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #保存
        }

        operate("2、删除所有条目") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses > 1 #如果有条目就删除
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
            end
        }
    end

}
