#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_30.1.8", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time             = 5
        @tc_net_time              = 50
        @tc_submit_time           = 60
        @tc_reset_to_default_time = 120
        @dut_ip                   = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
        @tc_dumpcap_server        = DRbObject.new_with_uri(@ts_drb_server2)
    end

    def process

        operate("1、PC1登录DUT页面修改当前配置(WAN 连接(分别配置为PPPOE，PPTP，L2TP，DHCP)、无线、防火墙、DDNS、UPNP、QOS、组播控制)；") {
            #修改为pppoe接入方式
            @browser.span(id: @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            #设置wan连接方式为网线连接
            rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(id: @ts_tag_wired_mode_span).click #网线连接
            end
            @wan_iframe.radio(id: @ts_tag_wired_pppoe).wait_until_present(@tc_wait_time)
            @wan_iframe.radio(id: @ts_tag_wired_pppoe).click #pppoe接入
            @wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            @wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            @wan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_submit_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #打开wifi开关，默认为关闭
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            if @lan_iframe.button(id: @ts_wifi_switch).class_name == "off"
                @lan_iframe.button(id: @ts_wifi_switch).click
                @lan_iframe.button(id: @ts_tag_sbm).click
                sleep @tc_submit_time
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #打开防火墙开关和ip过滤开关，并新增一条规则
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
            filter_flag   = false
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "off"
                fire_wall_btn.click
                filter_flag = true
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "off"
                ip_btn.click
                filter_flag = true
            end
            if filter_flag
                @option_iframe.button(id: @ts_tag_security_save).click #保存
            end
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click
            @option_iframe.text_field(id: @ts_ip_src).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click
            #打开dns开关
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time) #进入应用设置
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_ddns).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_ddns).click
            @option_iframe.button(id: @ts_tag_ddns_sw).wait_until_present(@tc_wait_time)
            if @option_iframe.button(id: @ts_tag_ddns_sw).class_name == "off"
                @option_iframe.button(id: @ts_tag_ddns_sw).click
                @option_iframe.text_field(id: @ts_tag_ddns_host).set(@dut_ip)
                @option_iframe.text_field(id: @ts_tag_ddns_user).set("admin")
                @option_iframe.text_field(id: @ts_tag_ddns_pwd).set("admin")
                @option_iframe.button(id: @ts_tag_ddns_save).click
                sleep @tc_wait_time
            end
        }

        operate("2、PC2远程登录DUT页面，恢复出厂默认设置；") {
            #打开外网访问开关
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click
            if @option_iframe.span(class_name: @ts_remote_sw).button.class_name == "off"
                @option_iframe.span(class_name: @ts_remote_sw).button.click
                @option_iframe.button(id: @ts_remote_save_btn).click
                sleep @tc_wait_time
            end
            port = @option_iframe.text_field(id: @ts_remote_port_id).value
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            wan_ip         = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
            network_url    = wan_ip + ":" + port
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #外网登录后恢复出厂设置
            network_status = @tc_dumpcap_server.reset_to_defaults(network_url, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_tag_reset_factory, @ts_tag_reboot_confirm, @ts_tag_rebooting, @ts_tag_reseting_text)
            assert(network_status, "外网登录后并恢复出厂设置过程中出现异常")
            sleep @tc_reset_to_default_time

            p "查看配置是否恢复出厂设置".to_gbk
            #查看网络连接类型
            login_default(@browser) #重新登录
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, "DHCP", "远程恢复出厂设置后，网络连接状态未恢复成默认DHCP类型")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #查看wifi开关状态
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert_equal(@lan_iframe.button(id: @ts_wifi_switch).class_name, "on", "远程恢复出厂设置后，wifi开关未恢复成默认打开状态")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #查看防火墙过滤设置
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
            assert_equal(fire_wall_btn.class_name, "off", "远程恢复出厂设置后，防火墙开关未恢复成默认的关闭状态")
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            assert_equal(ip_btn.class_name, "off", "远程恢复出厂设置后，IP过滤开关未恢复成默认关闭状态")
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 1, "远程恢复出厂设置后，IP过滤规则未清空")
            #查看ddns设置
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time) #进入应用设置
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_ddns).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_ddns).click
            @option_iframe.button(id: @ts_tag_ddns_sw).wait_until_present(@tc_wait_time)
            assert_equal(@option_iframe.button(id: @ts_tag_ddns_sw).class_name, "off", "远程恢复出厂设置后，ddns开关未恢复成默认关闭状态")
            assert_equal(@option_iframe.text_field(id: @ts_tag_ddns_host).value, "", "远程恢复出厂设置后, ddns主机名不为空")
            assert_equal(@option_iframe.text_field(id: @ts_tag_ddns_user).value, "", "远程恢复出厂设置后, ddns用户名不为空")
            assert_equal(@option_iframe.text_field(id: @ts_tag_ddns_pwd).value, "", "远程恢复出厂设置后, ddns密码不为空")
            #查看远程访问设置
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click
            assert_equal(@option_iframe.span(class_name: @ts_remote_sw).button.class_name, "off", "远程恢复出厂设置后, 远程访问开关未恢复成默认关闭状态")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

    end

    def clearup
        operate("恢复默认DHCP接入") {
            if !@wan_iframe.exists? && @browser.span(:id => @ts_tag_netset).exists?
                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            end

            flag = false
            #设置wan连接方式为网线连接
            rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
            unless rs1.class_name =~/ #{@tc_tag_select_state}/
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
        operate("关闭wifi开关") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            if @lan_iframe.button(id: @ts_wifi_switch).class_name == "on"
                @lan_iframe.button(id: @ts_wifi_switch).click
                @lan_iframe.button(id: @ts_tag_sbm).click
                sleep @tc_submit_time
            end
        }
        operate("关闭防火墙开关并删除规则") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

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
            filter_flag   = false
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
                filter_flag = true
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "on"
                ip_btn.click
                filter_flag = true
            end
            if filter_flag
                @option_iframe.button(id: @ts_tag_security_save).click #保存
            end
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses > 1 #如果有条目就删除
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
                sleep @tc_wait_time
            end
        }
        operate("关闭ddns开关") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time) #进入应用设置
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_ddns).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_ddns).click
            @option_iframe.button(id: @ts_tag_ddns_sw).wait_until_present(@tc_wait_time)
            if @option_iframe.button(id: @ts_tag_ddns_sw).class_name == "on"
                @option_iframe.button(id: @ts_tag_ddns_sw).click
                @option_iframe.text_field(id: @ts_tag_ddns_host).clear
                @option_iframe.text_field(id: @ts_tag_ddns_user).clear
                @option_iframe.text_field(id: @ts_tag_ddns_pwd).clear
                @option_iframe.button(id: @ts_tag_ddns_save).click
                sleep @tc_wait_time
            end
        }
        operate("关闭外网访问开关") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click
            if @option_iframe.span(class_name: @ts_remote_sw).button.class_name == "on"
                @option_iframe.span(class_name: @ts_remote_sw).button.click
                @option_iframe.button(id: @ts_remote_save_btn).click
                sleep @tc_wait_time
            end
        }
    end

}
