#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.42", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time             = 3
        @tc_net_time              = 60
        @tc_reset_to_default_time = 120
    end

    def process

        operate("1、当前为AP为PPPOE拨号，导出配置文件") {
            @browser.span(id: @ts_tag_netset).click
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
            end
            @wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            @wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            @wan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_net_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, @ts_wan_mode_pppoe, "修改网络连接类型失败！")
            p "导出配置文件".to_gbk
            set_info = export_configuration_file(@ts_default_ip, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_tag_export_name)
            assert(!set_info.empty?, "导出配置文件出现异常")
            match = set_info =~ /wanConnectionMode=#{@ts_wan_mode_pppoe}/i
            if match
                assert(true, "备份成功") #msg无关紧要
            else
                assert(false, "备份失败") #msg无关紧要
            end
        }

        operate("2、修改WAN设置为DHCP，然后导入步骤1中的配置文件，导入成功后，查看AP的连接模式") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #修改连接方式为DHCP连接方式
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            #设置wan连接方式为网线连接
            @wan_iframe.link(:id => @ts_tag_wired_mode_link)
            @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
            dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
            #设置WIRE WAN为DHCP模式
            dhcp_radio.click
            @wan_iframe.button(:id, @ts_tag_sbm).click
            puts "Waiting for net reset..."
            sleep @tc_net_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, @ts_wan_mode_dhcp, "修改网络连接类型#{@ts_wan_mode_dhcp}失败！")

            p "导入配置文件".to_gbk
            export_info = import_configuration_file(@ts_default_ip, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_reset_default_fname, @ts_tag_update_btn, @ts_tag_import, @ts_tag_import_text)
            assert(export_info, "导入配置文件出现异常")
            sleep @tc_reset_to_default_time
            p "查看配置是否恢复！".to_gbk
            login_default(@browser) #重新登录
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, @ts_wan_mode_pppoe, "恢复出厂设置后，网络连接状态未恢复成#{@ts_wan_mode_pppoe}类型")
        }

        operate("3、修改WAN设置为静态IP，然后导入步骤1中的配置文件，导入成功后，查看AP的连接模式") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
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
            @wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
            @wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
            @wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
            @wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
            if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
                @wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
            end
            @wan_iframe.button(:id, @ts_tag_sbm).click
            sleep @tc_net_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, @ts_wan_mode_static, "修改网络连接类型#{@ts_wan_mode_static}失败！")

            p "导入配置文件".to_gbk
            export_info = import_configuration_file(@ts_default_ip, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_reset_default_fname, @ts_tag_update_btn, @ts_tag_import, @ts_tag_import_text)
            assert(export_info, "导入配置文件出现异常")
            sleep @tc_reset_to_default_time
            p "查看配置是否恢复！".to_gbk
            login_default(@browser) #重新登录
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, @ts_wan_mode_pppoe, "恢复出厂设置后，网络连接状态未恢复成#{@ts_wan_mode_pppoe}类型")
        }

        operate("4、修改WAN设置为PPTP拨号，然后导入步骤1中的配置文件，导入成功后，查看AP的连接模式") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #设置为PPTP拨号
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_op_pptp).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_pptp).click #pptp设置
            @option_iframe.text_field(id: @ts_tag_pptp_server).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_tag_pptp_server).set(@ts_pptp_server_ip) #服务器IP
            @option_iframe.text_field(id: @ts_tag_pptp_usr).set(@ts_pptp_usr) #用户名
            @option_iframe.text_field(id: @ts_tag_pptp_pw).set(@ts_pptp_pw) #口令
            @option_iframe.button(id: @ts_tag_sbm).click #保存
            sleep @tc_net_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, @ts_wan_mode_pptp, "修改网络连接类型#{@ts_wan_mode_pptp}失败！")

            p "导入配置文件".to_gbk
            export_info = import_configuration_file(@ts_default_ip, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_reset_default_fname, @ts_tag_update_btn, @ts_tag_import, @ts_tag_import_text)
            assert(export_info, "导入配置文件出现异常")
            sleep @tc_reset_to_default_time
            p "查看配置是否恢复！".to_gbk
            login_default(@browser) #重新登录
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, @ts_wan_mode_pppoe, "恢复出厂设置后，网络连接状态未恢复成#{@ts_wan_mode_pppoe}类型")
        }


    end

    def clearup
        operate("恢复默认DHCP接入") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
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
    end

}
