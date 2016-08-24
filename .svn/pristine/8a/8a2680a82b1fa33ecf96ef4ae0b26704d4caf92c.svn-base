#
# description:
# author:liluping
# date:2015-09-23
#
testcase {
    attr = {"id" => "ZLBF_29.1.1", "level" => "P2", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time   = 3
        @tag_usr_id     = 'admuser'
        @tag_pw_id      = 'admpass'

        @tc_tag_options              = "options"
        @tc_tag_secseting            = "securitysetting"
        @tc_tag_fw_seting            = "Firewall-Settings"
        @tc_tag_save_button          = "save_btn"
        @tc_tag_save_button_ipfilter = "save_btniptb"
        @tc_tag_add_ipfilter         = "additem"
        @tc_tag_ip_setting           = "IP-Filter"

        @tc_tag_source_fip_text   = "fip"
        @tc_tag_source_endip_text = "endip"
        @tc_tag_error_msg         = "error_msg"

        @tc_tag_fw_button         = "switch1"
        @tc_tag_ip_button         = "switch2"
        @tc_tag_button_switch_off = "off"
        @tc_tag_button_switch_on  = "on"

        @tc_tag_url_baidu  = "www.baidu.com"
        @tc_tag_link_error = "errorTitleText"

        @ssid_pwd             = "12345678"
        @tc_net_status        = "setstatus"
        @tc_dut_wifi_ssid     = "ssid"
        @tc_dut_wifi_ssid_pwd = "input_password1"
    end

    def process

        operate("1、AP工作在路由方式下，添加一条IP过滤规则，源地址包括PC1和PC2的地址其它默认；") {
            @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time) #等待2s
            @browser.span(id: @ts_tag_lan).click

            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "打开内网设置失败！")
            p "获取DUT的ssid".to_gbk
            @dut_ssid = @lan_iframe.text_field(id: @tc_dut_wifi_ssid).value
            p "DUTssid --> #{@dut_ssid}".to_gbk
            @dut_ssid_pwd = @lan_iframe.text_field(id: @tc_dut_wifi_ssid_pwd).value
            p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@dut_ssid, flag, @dut_ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)

            puts "进入高级设置后，打开安全设置！".to_gbk
            # @browser.span(id: @tc_tag_options).wait_until_present(@tc_wait_time)
            @browser.link(id: @tc_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            option_link       = @option_iframe.link(id: @tc_tag_secseting)
            option_link_state = option_link.attribute_value(:checked)
            unless option_link_state == "true"
                option_link.click
            end

            puts "选择IP过滤选项".to_gbk
            @option_iframe.link(id: @tc_tag_ip_setting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_ip_setting)
            option_fw_iframe.click

            puts "添加IP过滤规则".to_gbk
            #获取PC1和PC2的网卡地址
            @pc1_dut_ip      = ipconfig("all")[@ts_nicname][:ip][0] #获取pc1网卡ip
            @pc2_wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0] #获取pc2网卡ip

            #添加新条目之前先删除所有的条目
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click

            @option_iframe.span(id: @tc_tag_add_ipfilter).click #添加新条目
            @option_iframe.text_field(id: @tc_tag_source_fip_text).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @tc_tag_source_fip_text).set(@pc1_dut_ip) #设置源IP网段
            @option_iframe.text_field(id: @tc_tag_source_endip_text).set(@pc2_wireless_ip)

            @option_iframe.button(id: @tc_tag_save_button_ipfilter).click #保存
            err_msg = @option_iframe.p(id: @tc_tag_error_msg).text #如果出现错误提示信息
            if err_msg == "\u6E90\u8D77\u59CBIP\u5E94\u8BE5\u5C0F\u4E8E\u7ED3\u675FIP"
                @option_iframe.text_field(id: @tc_tag_source_fip_text).wait_until_present(@tc_wait_time)
                @option_iframe.text_field(id: @tc_tag_source_fip_text).set(@pc2_wireless_ip) #重新设置源IP网段
                @option_iframe.text_field(id: @tc_tag_source_endip_text).set(@pc1_dut_ip)
                @option_iframe.button(id: @tc_tag_save_button_ipfilter).click #保存
            end

        }

        operate("2、再进入到防火墙界面，将防火墙总开关关闭，IP过滤关闭，保存，PC1和PC2能否访问外网。") {
            puts "进入防火墙选项".to_gbk
            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "关闭防火墙总开关和IP过滤开关".to_gbk
            btn_fw_on = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_on)
            if btn_fw_on.exists? #关闭状态就不再操作了
                btn_fw_on.click
            end
            btn_ip_on = @option_iframe.button(id: @tc_tag_ip_button, class_name: @tc_tag_button_switch_on)
            if btn_ip_on.exists?
                btn_ip_on.click
            end
            @option_iframe.button(id: @tc_tag_save_button).click #保存

            puts "验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)

            response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)
        }
    end

    def clearup

        operate("1 关闭防火墙总开关和IP过滤开关") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            @browser.goto(@default_url)
            @browser.text_field(name: @ts_tag_usr).set(@ts_default_usr)
            @browser.text_field(name: @ts_tag_pw).set(@ts_default_pw)
            @browser.button(id: @ts_tag_sbm).click

            @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_tag_options).click

            @option_iframe    = @browser.iframe(src: @ts_tag_advance_src)
            option_link       = @option_iframe.link(id: @tc_tag_secseting)
            option_link_state = option_link.attribute_value(:checked)
            unless option_link_state == "true"
                option_link.click
            end

            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "关闭防火墙总开关和IP过滤开关".to_gbk
            btn_fw_on = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_on)

            if btn_fw_on.exists?
                btn_fw_on.click
            end
            btn_ip_on = @option_iframe.button(id: @tc_tag_ip_button, class_name: @tc_tag_button_switch_on)
            if btn_ip_on.exists?
                btn_ip_on.click
            end

            @option_iframe.button(id: @tc_tag_save_button).click

        }

        operate("2 删除所有的过滤规则") {
            @option_iframe.link(id: @tc_tag_ip_setting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_ip_setting)
            option_fw_iframe.click
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
