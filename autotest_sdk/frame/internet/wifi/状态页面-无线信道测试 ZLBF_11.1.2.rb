#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.2", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time        = 3
        @tc_lan_wait_time    = 10
        @tc_wait_status_time = 30
        @tc_net_wait_time    = 60
        @tc_ap_login_btn     = "loginBtn"
        @tc_main_content     = "maincontent"
        @tc_ap_channel       = "chan"
        @tc_ap_channel_value = "2412MHz (Channel 1)"
        @tc_ap_channel_auto  = "自动选择"
    end

    def process

        operate("1、AP开启2.4G频段的无线功能；") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #开启无线开关
                @lan_frame.button(id: @ts_tag_sbm).click #保存

                wifi_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    wifi_reset_div.present?
                }
                sleep @tc_lan_wait_time
                @browser.span(id: @ts_tag_lan).click #进入内网设置
                @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
                assert(@lan_frame.exists?, "打开内网设置失败")
            end
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "on"
                p "wifi开关开启成功！".to_gbk
            else
                assert(false, "wifi开关开启失败！")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、修改信道为1信道，查看状态；") {
            @browser.link(id: @ts_tag_options).click #高级设置
            @advance_frame = @browser.iframe(src: @ts_tag_advance_src)
            @advance_frame.link(id: @ts_advance_setup).wait_until_present(@tc_wait_time)
            @advance_frame.link(id: @ts_advance_setup).click #wifi设置

            select_channel = @advance_frame.select_list(id: @ts_wifi_channel) #选择信道
            select_channel.wait_until_present(@tc_wait_time)
            select_channel.select(@tc_ap_channel_value)
            @advance_frame.button(id: @ts_tag_sbm).click #保存
            sleep @tc_wait_status_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            p "查看状态".to_gbk
            @browser.span(id: @tag_status).click #查看状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            assert(@status_iframe.exists?, "打开查看状态窗口失败！")
            @status_iframe.b(id: @ts_channel).wait_until_present(@tc_wait_time)
            cur_channel = @status_iframe.b(id: @ts_channel).parent.text.slice(/\d+/i) #获取wifi当前信道
            assert_equal(cur_channel, @tc_ap_channel_value.slice(/Channel\s*(\d+)/i, 1), "信道更改失败！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

        }

        operate("3、修改信道为自动信道，查看状态；") {
            @browser.link(id: @ts_tag_options).click #高级设置
            @advance_frame = @browser.iframe(src: @ts_tag_advance_src)
            @advance_frame.link(id: @ts_advance_setup).wait_until_present(@tc_wait_time)
            @advance_frame.link(id: @ts_advance_setup).click #wifi设置

            select_channel = @advance_frame.select_list(id: @ts_wifi_channel) #选择信道
            select_channel.wait_until_present(@tc_wait_time)
            select_channel.select(@tc_ap_channel_auto)
            @advance_frame.button(id: @ts_tag_sbm).click #保存
            sleep @tc_wait_status_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            p "查看状态".to_gbk
            @browser.span(id: @tag_status).click #查看状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            assert(@status_iframe.exists?, "打开查看状态窗口失败！")
            @status_iframe.b(id: @ts_channel).wait_until_present(@tc_wait_time)
            cur_channel = @status_iframe.b(id: @ts_channel).parent.text.slice(/\d+/i) #获取wifi当前信道
            # assert_equal(cur_channel, @tc_ap_channel_value.slice(/Channel\s*(\d+)/i, 1), "信道更改失败！")   #无法比较
            assert(cur_channel, "信道更改失败！") #没获取到信道就表示失败
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

        }
    end

    def clearup
        operate("恢复默认信道") {
            @browser.link(id: @ts_tag_options).click #高级设置
            @advance_frame = @browser.iframe(src: @ts_tag_advance_src)
            @advance_frame.link(id: @ts_advance_setup).wait_until_present(@tc_wait_time)
            @advance_frame.link(id: @ts_advance_setup).click #wifi设置

            select_channel = @advance_frame.select_list(id: @ts_wifi_channel) #选择信道
            select_channel.wait_until_present(@tc_wait_time)
            unless select_channel.value.to_gbk == "0" #0表示自动选择
                select_channel.select(@tc_ap_channel_auto)
                @advance_frame.button(id: @ts_tag_sbm).click #保存
                sleep @tc_lan_wait_time
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
