#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.2", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_upload_file_text = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/text/i }

        @tc_wait_time     = 3
        @tc_net_wait_time = 50
    end

    def process
        operate("1、WAN接入设置为PPPoE拨号，正确设置PPPoE拨号参数，保存，LAN PC浏览网页是否正常；") {
            sysversion_text    = @browser.span(id: @ts_tag_systemver).parent.text
            @sysversion_before = sysversion_text.slice(/\s*(V.+?)\s*MAC/i, 1)
            p "升级前的版本是：#{@sysversion_before}".to_gbk
            @browser.span(id: @ts_tag_netset).click
            wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(wan_iframe.exists?, "打开外网设备页面失败")
            wan_iframe.link(id: @ts_tag_wired_mode_link).wait_until_present(@tc_wait_time)
            wan_iframe.link(id: @ts_tag_wired_mode_link).click
            wan_iframe.radio(id: @ts_tag_wired_pppoe).click
            wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            wan_iframe.button(id: @ts_tag_sbm).click
            net_reset_div = wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                net_reset_div.present?
            }
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网#{@ts_web}".to_gbk)
        }

        operate("2、进入升级页面；") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置界面失败")
            @option_iframe.link(id: @ts_tag_op_system).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_update).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_update).click #进入升级页面
        }

        operate("3、在升级页面中，选择浏览，选择其它格式错误的升级文件（.txt,.jpg,.doc等）,点击升级，查看升级是否成功，PC浏览网页是否正常；") {
            @option_iframe.file_field(id: @ts_update_filename).set(@tc_upload_file_text)
            sleep @tc_wait_time
            @option_iframe.button(id: @ts_tag_update_btn).click
            uploading = @option_iframe.div(class_name: @ts_upload, text: @ts_upload_text)
            assert(uploading.exists?, "选择错误的升级文件，没有出现提示信息")

            sysversion_text   = @browser.span(id: @ts_tag_systemver).parent.text
            @sysversion_after = sysversion_text.slice(/\s*(V.+?)\s*MAC/i, 1)
            p "升级后的版本是：#{@sysversion_after}".to_gbk
            assert_equal(@sysversion_before, @sysversion_after, "升级失败后，系统版本不一致！")
            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网#{@ts_web}".to_gbk)
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
