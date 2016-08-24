#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.12", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time      = 3
        @tc_wifi_pwd1      = "Yuh nBfg"
        @tc_wifi_pwd2      = " YuhnBfgc "
        @tc_error_msg      = "error_msg"
        @tc_error_msg_text = "密码只能是数字和字母,且长度是8-63个字符之间"
    end

    def process

        operate("1、秘钥输入“Yuh nBfg”，是否可以输入成功，STA是否可以连接成功；") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #选择安全模式
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_wifi_pwd1) #输入密码
            @lan_frame.checkbox(id: @ts_pwdshow).click #显示密码
            @lan_frame.button(id: @ts_tag_sbm).click #保存
            if @lan_frame.span(id: @tc_error_msg, text: @tc_error_msg_text).exists?
                p "wifi密码不支持字段中为空格！".to_gbk
            else
                assert(false, "wifi密码输入字段中为空格的字段后，没有提示！")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、秘钥输入“ YuhnBfgc ”，也就是密钥的第一和最后一位是空格，是否可以输入成功，STA是否可以连接成功；") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #选择安全模式
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            wifi_pwd.clear
            wifi_pwd.set(@tc_wifi_pwd2) #输入密码
            @lan_frame.checkbox(id: @ts_pwdshow).click #显示密码
            @lan_frame.button(id: @ts_tag_sbm).click #保存
            if @lan_frame.span(id: @tc_error_msg, text: @tc_error_msg_text).exists?
                p "【提示】wifi密码不支持第一和最后一位是空格！".to_gbk
            else
                assert(false, "wifi密码输入字段中第一和最后一位是空格后，没有提示！")
            end
        }


    end

    def clearup

    end

}
