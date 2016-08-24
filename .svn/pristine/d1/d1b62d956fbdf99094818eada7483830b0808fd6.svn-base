#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.3", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2   = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time     = 3
        @tc_lan_wait_time = 10
        @tc_net_wait_time = 60
        @tc_ap_login_btn  = "loginBtn"
    end

    def process

        operate("1、AP开启2.4G频段的无线功能，查看状态页面无线开关状态；") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
                @lan_frame.button(id: @ts_tag_sbm).click #保存

                wifi_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    wifi_reset_div.present?
                }
                sleep @tc_lan_wait_time
                @browser.span(id: @ts_tag_lan).click #进入内网设置
                @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
                assert(@lan_frame.exists?, "打开内网设置失败！")
            end
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "on"
                p "wifi开关开启成功！".to_gbk
            else
                assert(false, "wifi开关开启失败！")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.span(id: @tag_status).click #打开状态窗口
            @status_frame = @browser.iframe(src: @tag_status_iframe_src)
            @status_frame.b(id: @ts_wifi_status).wait_until_present(@tc_wait_time)
            wifi_status = @status_frame.b(id: @ts_wifi_status).parent.text.slice(/WIFI2\.4G\s*(\w+)/i, 1) #获取wifi开关状态
            assert_equal("On", wifi_status, "开启无线功能开关，但状态显示未开启！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、AP关闭2.4G频段的无线功能，查看状态页面无线开关状态；") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "on"
                @lan_frame.button(id: @ts_wifi_switch).click #关闭无线开关
                @lan_frame.button(id: @ts_tag_sbm).click #保存

                wifi_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    wifi_reset_div.present?
                }
                sleep @tc_lan_wait_time
                @browser.span(id: @ts_tag_lan).click #进入内网设置
                @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
                assert(@lan_frame.exists?, "打开内网设置失败！")
            end
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                p "wifi开关关闭成功！".to_gbk
            else
                assert(false, "wifi开关关闭失败！")
            end
            ssid_name = @lan_frame.text_field(id: @ts_tag_ssid).value #获取ssid
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.span(id: @tag_status).click #打开状态窗口
            @status_frame = @browser.iframe(src: @tag_status_iframe_src)
            assert(@status_frame.exists?, "打开查看状态窗口失败！")
            @status_frame.b(id: @ts_wifi_status).wait_until_present(@tc_wait_time)
            wifi_status = @status_frame.b(id: @ts_wifi_status).parent.text.slice(/WIFI2\.4G\s*(\w+)/i, 1) #获取wifi开关状态
            #当状态显示与实际显示不一致时，利用无线网卡查看能否查询到该ssid，来判断是哪个功能出现问题
            unless wifi_status == "Off"
                search_ssid = @tc_dumpcap_pc2.scan_network(ssid_name)
                p "能否扫描到ssid：#{search_ssid[:flag]}".to_gbk
                if search_ssid[:flag]
                    assert(false, "wifi开关显示关闭，但网卡能搜索到该ssid，可能是wifi开关功能失效，请定位！")
                else
                    assert(false, "wifi开关显示关闭，实际也无法搜索到该ssid。可能是状态界面显示功能失效，请定位！")
                end
            else
                assert(true, "关闭无线功能开关，但状态显示未关闭！")
            end
            # assert_equal(wifi_status, "Off", "关闭无线功能开关，但状态显示未关闭！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }


    end

    def clearup
        operate("恢复默认配置") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
                @lan_frame.button(id: @ts_tag_sbm).click #保存

                wifi_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    wifi_reset_div.present?
                }
            end
        }
    end

}
