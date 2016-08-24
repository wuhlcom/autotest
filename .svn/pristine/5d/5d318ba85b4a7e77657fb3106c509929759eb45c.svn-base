#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.5", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time      = 3
        @tc_net_wait_time  = 60
        @tc_ssid_name      = "~!@#$%^&*()_+-={}:\"<>?[]|\; ',./`"
        @tc_pwd            = "12345678"
        @tc_ssid_default   = "WIFI_00116B"
        @tc_error_msg      = "error_msg"
        @tc_error_msg_text = "SSID是中文,数字,字母,中(下)划线,长度1-32位,一个中文占3位"
    end

    def process

        operate("1、设置无线SSID为32个特殊字符“~!@#$%^&*()_+-={}:\"<>?[]|\; ',./`”，是否可以设置成功；") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            wifi_ssid.clear
            wifi_ssid.set(@tc_ssid_name) #输入ssid
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #选择安全模式
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_pwd) #输入密码
            @lan_frame.checkbox(id: @ts_pwdshow).click #显示密码
            @lan_frame.button(id: @ts_tag_sbm).click #保存
            if @lan_frame.span(id: @tc_error_msg, text: @tc_error_msg_text).exists?
                p "【提示】ssid不支持输入的特殊字符！".to_gbk
            else
                assert(false, "输入不支持的特殊字符后，没有提示！")
            end
        }
    end

    def clearup
        operate("恢复配置") {
            p "恢复默认ssid".to_gbk
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            wifi_ssid  = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            unless wifi_ssid.value == @tc_ssid_default
                wifi_ssid.clear
                wifi_ssid.set(@tc_ssid_default) #输入ssid
                @lan_frame.button(id: @ts_tag_sbm).click #保存
                lan_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    lan_reset_div.present?
                }
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
