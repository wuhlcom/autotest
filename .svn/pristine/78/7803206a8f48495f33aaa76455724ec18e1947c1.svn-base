#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_30.1.9", "level" => "P3", "auto" => "n"}

    def prepare
        @backup_wifi_one          = "wifi_llp"
        @backup_wifi_two          = "wifi_setting"
        @tc_dumpcap_server        = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_wait_time             = 5
        @tc_net_time              = 50
        @tc_submit_time           = 60
        @tc_reset_to_default_time = 120
    end

    def process

        operate("0、首先先恢复出厂设置") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_op_system).click #系统设置
            @option_iframe.link(id: @ts_tag_recover).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_recover).click #恢复出厂设置
            @option_iframe.button(id: @ts_tag_reset_factory).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_reset_factory).click #点击恢复出厂设置按钮
            @option_iframe.button(class_name: @ts_tag_reboot_confirm).wait_until_present(@tc_wait_time)
            @option_iframe.button(class_name: @ts_tag_reboot_confirm).click #点击现在重启
            sleep @tc_reset_to_default_time
            login_default(@browser) #重新登录
        }

        operate("1、PC1修改DUT的无线，拨号，防火墙，LAN侧IP等配置，视为配置1；") {
            #修改为pppoe接入方式
            @browser.span(id: @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            #设置wan连接方式为网线连接
            rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(id: @ts_tag_wired_mode_span).click #网线连接
            end
            @wan_iframe.radio(id: @ts_tag_wired_pppoe).click #pppoe接入
            @wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            @wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            @wan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_submit_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #设置wifi的ssid
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            @lan_iframe.text_field(id: @ts_tag_ssid).set(@backup_wifi_one)
            @lan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_submit_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #打开防火墙开关
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
                @option_iframe.button(id: @ts_tag_security_save).click #保存
            end
        }

        operate("2、PC2远程备份该配置文件，查看是否备分成功；") {
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
            #外网登录后导出配置文件并返回配置信息
            set_info = @tc_dumpcap_server.export_configuration_file(network_url, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_tag_export)
            assert(!set_info.empty?, "外网登录后导出配置文件出现异常")
            p "外网登录后并导出配置文件成功，查看是否备份成功".to_gbk
            #连接类型
            match = set_info =~ /wanConnectionMode=#{@ts_wan_mode_pppoe}/i &&
                set_info =~ /wan_pppoe_user=#{@ts_pppoe_usr}/i &&
                set_info =~ /wan_pppoe_pass=#{@ts_pppoe_pw}/i &&
                set_info =~ /wan_pppoe_opmode=KeepAlive/i &&
                set_info =~ /wan_pppoe_optime=60/i &&
                #lan无线ssid
                set_info =~ /SSID1=#{@backup_wifi_one}/i &&
                #防火墙
                set_info =~ /firewallEn=on/i
            if match
                assert(true, "备份成功") #msg无关紧要
            else
                assert(false, "备份失败") #msg无关紧要
            end

        }

        operate("3、PC1再次修改无线，拨号，防火墙，LAN侧IP等配置，视为配置2；") {
            #修改连接方式为DHCP连接方式
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
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
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #设置wifi的ssid
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            @lan_iframe.text_field(id: @ts_tag_ssid).set(@backup_wifi_two)
            @lan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_submit_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #关闭防火墙开关
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
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
                @option_iframe.button(id: @ts_tag_security_save).click #保存
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("4、PC2远程导入配置1，查看是否导入成功，当前配置是否为配置1。") {
            #打开外网访问开关
            @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_op_system).wait_until_present(@tc_wait_time)
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
            #外网登录后导入配置文件
            export_info = @tc_dumpcap_server.import_configuration_file(network_url, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_reset_default_fname, @ts_tag_update_btn, @ts_tag_import, @ts_tag_import_text)
            assert(export_info, "外网登录后导入配置文件出现异常")
            sleep @tc_reset_to_default_time
            p "查看当前配置是否为之前配置1,查看修改配置是否复原即可".to_gbk
            #查看连接方式
            login_default(@browser) #重新登录
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, "PPPOE", "远程恢复出厂设置后，网络连接状态未恢复成配置1的PPPOE类型")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #查看wifi的ssid
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            ssid        = @lan_iframe.text_field(id: @ts_tag_ssid).value
            assert_equal(@backup_wifi_one, ssid, "远程恢复出厂设置后，ssid未恢复成配置1的配置")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #查看防火墙
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
            assert_equal("on", fire_wall_btn.class_name, "远程恢复出厂设置后，防火墙未恢复成配置1的配置")
        }
    end

    def clearup
        operate("恢复默认DHCP接入") {
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
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
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
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
