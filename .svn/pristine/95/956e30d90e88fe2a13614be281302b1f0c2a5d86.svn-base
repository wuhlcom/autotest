#
# description:
# author:liluping
# date:2015-09-23
# modify:
#
testcase {
    attr = {"id" => "ZLBF_29.1.9", "level" => "P2", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time   = 3
        @tag_usr_id     = 'admuser'
        @tag_pw_id      = 'admpass'

        @tc_tag_fw_button         = "switch1"
        @tc_tag_url_button        = "switch4"
        @tc_tag_button_switch_off = "off"
        @tc_tag_button_switch_on  = "on"

        @tc_tag_options        = "options"
        @tc_tag_secseting      = "securitysetting"
        @tc_tag_select_text    = "b_w_url"
        @tc_tag_url_setting    = "menu_set"
        @tc_tag_select         = "b_w_select"
        @tc_tag_select_add_btn = "add_btn"
        @tc_tag_save_button    = "save_btn"
        @tc_tag_fw_seting      = "Firewall-Settings"
        @tc_tag_select_black   = "opa"
        @tc_tag_select_white   = "opb"
        @tc_intset_list        = "intset_list"
        @tc_intset_list_black  = "black"
        @tc_intset_list_white  = "white"
        @tc_intset_list_cls    = "text"

        @tc_tag_url_baidu  = "www.baidu.com"
        @tc_tag_url_sohu   = "www.sohu.com"
        @tc_tag_link_error = "errorTitleText"

        @ssid_pwd             = "12345678"
        @tc_net_status        = "setstatus"
        @tc_dut_wifi_ssid     = "ssid"
        @tc_dut_wifi_ssid_pwd = "input_password1"
    end

    def process

        operate("1、进入到防火墙界面，将防火墙总开关开启，URL过滤关闭，保存；") {
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

            puts "进入高级选项面板".to_gbk
            # @browser.span(id: @tc_tag_options, class_name: @tc_tag_options).wait_until_present(@tc_wait_time)
            @browser.link(id: @tc_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            option_link       = @option_iframe.link(id: @tc_tag_secseting)
            option_link_state = option_link.attribute_value(:checked)
            unless option_link_state == "true"
                option_link.click
            end

            puts "进入防火墙选项".to_gbk
            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "开启防火墙总开关并关闭开URL过滤开关".to_gbk
            btn_fw_on = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_on)
            if btn_fw_on.exists?
                btn_fw_on.click
            end
            btn_url_off = @option_iframe.button(id: @tc_tag_url_button, class_name: @tc_tag_button_switch_off)
            if btn_url_off.exists?
                btn_url_off.click
            end
            @option_iframe.button(id: @tc_tag_save_button).click #保存
        }

        operate("2、进入URL过滤界面添加黑名单，添加www.baidu.com的规则，PC1和PC2能否访问www.baidu.com及其它网站；") {
            puts "进入URL过滤选项".to_gbk
            @option_iframe.link(id: @tc_tag_url_setting).wait_until_present(@tc_wait_time)
            option_url_iframe = @option_iframe.link(id: @tc_tag_url_setting)
            option_url_iframe.click

            puts "添加过滤关键字".to_gbk
            select_click = @option_iframe.select_list(id: @tc_tag_select)
            select_click.select("黑名单")
            #名单中有则不添加
            if !@option_iframe.span(text: @tc_tag_url_baidu).exists?
                @option_iframe.text_field(id: @tc_tag_select_text).set(@tc_tag_url_baidu)
                @option_iframe.link(class_name: @tc_tag_select_add_btn).click

                assert_equal(@option_iframe.div(id: "black").text, @tc_tag_url_baidu, "error-->添加关键字#{@tc_tag_url_baidu}不成功！")
                @option_iframe.button(id: @tc_tag_save_button).click
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            puts "验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)

            response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)

            response = send_http_request(@tc_tag_url_sohu)
            assert(response, "不可以访问#{@tc_tag_url_sohu}".to_gbk)

            response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_sohu)
            assert(response, "不可以访问#{@tc_tag_url_sohu}".to_gbk)
        }

        operate("3、再设置就白名单，添加www.sohu.com的规则，PC1和PC2能否访问www.sohu.com及其它网站。") {
            #再次登录路由器
            @browser.goto(@default_url)
            @browser.text_field(name: @ts_tag_usr).set(@ts_default_usr)
            @browser.text_field(name: @ts_tag_pw).set(@ts_default_pw)
            @browser.button(id: @ts_tag_sbm).click

            puts "进入高级选项面板".to_gbk
            # @browser.span(id: @tc_tag_options).wait_until_present(@tc_wait_time)
            @browser.link(id: @tc_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            option_link       = @option_iframe.link(id: @tc_tag_secseting)
            option_link_state = option_link.attribute_value(:checked)
            unless option_link_state == "true"
                option_link.click
            end

            puts "进入URL过滤选项".to_gbk
            @option_iframe.link(id: @tc_tag_url_setting).wait_until_present(@tc_wait_time)
            option_url_iframe = @option_iframe.link(id: @tc_tag_url_setting)
            option_url_iframe.click

            puts "添加过滤关键字".to_gbk
            select_click = @option_iframe.select_list(id: @tc_tag_select)
            select_click.select("白名单")
            #名单中有则不添加
            if !@option_iframe.span(text: @tc_tag_url_sohu).exists?
                @option_iframe.text_field(id: @tc_tag_select_text).set(@tc_tag_url_sohu)
                @option_iframe.link(class_name: @tc_tag_select_add_btn).click

                assert_equal(@option_iframe.div(id: "white").text, @tc_tag_url_sohu, "error-->添加关键字#{@tc_tag_url_sohu}不成功！")
                @option_iframe.button(id: @tc_tag_save_button).click
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            puts "验证PC1和PC2能否访问外网".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)

            response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            assert(response, "不可以访问#{@tc_tag_url_baidu}".to_gbk)

            response = send_http_request(@tc_tag_url_sohu)
            assert(response, "不可以访问#{@tc_tag_url_sohu}".to_gbk)

            response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_sohu)
            assert(response, "不可以访问#{@tc_tag_url_sohu}".to_gbk)
        }


    end

    def clearup
        operate("1 关闭防火墙总开关和URL过滤开关") {
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
            puts "关闭防火墙总开关和URL过滤开关".to_gbk
            btn_fw_on = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_on)

            if btn_fw_on.exists?
                btn_fw_on.click
            end
            btn_url_on = @option_iframe.button(id: @tc_tag_url_button, class_name: @tc_tag_button_switch_on)
            if btn_url_on.exists?
                btn_url_on.click
            end

            @option_iframe.button(id: @tc_tag_save_button).click

        }

        operate("3 清除黑名单和白名单") {

            @option_iframe.link(id: @tc_tag_url_setting).wait_until_present(@tc_wait_time)
            option_url_iframe = @option_iframe.link(id: @tc_tag_url_setting)
            option_url_iframe.click

            @option_iframe.select_list(id: @tc_tag_select).click
            @option_iframe.option(id: @tc_tag_select_black).click

            black_url_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            black_url_arr = black_url_str.split("\n")
            if !black_url_arr.empty?
                #需要模拟鼠标移动到该条目上(在该条目上做点击操作)，才能实施删除操作
                black_url_arr.each do |url|
                    puts "删除黑名单#{url}".to_gbk
                    @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
                    sleep 1
                    @option_iframe.span(text: url, class_name: @tc_intset_list_cls).parent.link(class_name: "delete").click
                    sleep 2
                end
                @option_iframe.button(id: @tc_tag_save_button).click
            end

            sleep 5
            # @option_iframe.div(class_name: @ts_tag_net_reset_tip).wait_while_present(5) #等待界面消失
            @option_iframe.select_list(id: @tc_tag_select).click
            @option_iframe.option(id: @tc_tag_select_white).click
            sleep 2
            # p @option_iframe.div(id: "white",class_name: @tc_intset_list).text
            white_url_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
            white_url_arr = white_url_str.split("\n")
            if !white_url_arr.empty?
                white_url_arr.each do |url|
                    puts "删除白名单#{url}".to_gbk
                    #需要模拟鼠标移动到该条目上(在该条目上做点击操作)，才能实施删除操作
                    @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
                    sleep 1
                    @option_iframe.span(text: url, class_name: @tc_intset_list_cls).parent.link(class_name: "delete").click
                    sleep 2
                end
                @option_iframe.button(id: @tc_tag_save_button).click
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
