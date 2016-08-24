#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.4", "level" => "P1", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_dumpcap_pc2      = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time        = 3
        @tc_wait_time_effect = 10
        @tc_net_wait_time    = 60
        @tc_ssid_name        = "test123"
        @tc_pwd              = "12345678"
        # @tc_ssid_default         = "WIFI_00116B"

    end

    def process

        operate("1、无线SSID输入test123，查看是否设置成功，STA是否连接成功；") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            @tc_ssid_default = wifi_ssid.value
            p "默认ssid是：#{@tc_ssid_default}".to_gbk
            wifi_ssid.clear
            wifi_ssid.set(@tc_ssid_name) #输入ssid
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #选择安全模式
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            @tc_pwd_default = wifi_pwd.value
            p "默认密码是：#{@tc_pwd_default}".to_gbk
            wifi_pwd.clear
            wifi_pwd.set(@tc_pwd) #输入密码
            @lan_frame.checkbox(id: @ts_pwdshow).click #显示密码
            @lan_frame.button(id: @ts_tag_sbm).click #保存
            lan_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                lan_reset_div.present?
            }
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            p "ssid设置完毕，马上进行验证！".to_gbk
            @browser.span(id: @tag_status).click #打开状态窗口
            @status_frame = @browser.iframe(src: @tag_status_iframe_src)
            assert(@status_frame.exists?, "打开状态设置失败！")
            @status_frame.b(id: @ts_dut_ssid).wait_until_present(@tc_wait_time)
            cur_ssid = @status_frame.b(id: @ts_dut_ssid).parent.text.slice(/SSID\s*(.+)/i, 1)
            assert_equal(cur_ssid, @tc_ssid_name, "ssid设置失败！")
            p "ssid设置成功！".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            p "PC连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid_name, flag, @tc_pwd, @ts_wlan_nicname)
            assert(rs, "PC wifi连接失败".to_gbk)
            sleep @tc_wait_time_effect
            p "PC访问外网#{@ts_web}...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.ping(@ts_web)
            assert(judge_link_pc2, "PC无法访问外网#{@ts_web}".to_gbk)
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
        }


    end

    def clearup
        operate("恢复配置") {
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接

            p "恢复默认ssid".to_gbk
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            wifi_ssid  = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            unless wifi_ssid.value == @tc_ssid_default
                wifi_ssid.clear
                wifi_ssid.set(@tc_ssid_default) #输入ssid
                wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
                wifi_pwd.wait_until_present(@tc_wait_time)
                wifi_pwd.clear
                wifi_pwd.set(@tc_pwd_default)
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
