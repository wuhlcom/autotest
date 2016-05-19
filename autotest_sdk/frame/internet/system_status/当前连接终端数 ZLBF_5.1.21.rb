#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.21", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time   = 3
    end

    def process
        operate("0、获取ssid跟密码") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            @ssid     = wifi_ssid.value
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #选择安全模式
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            @pwd = wifi_pwd.value
            p "ssid->#{@ssid}".to_gbk
            p "pwd->#{@pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("1、被测AP下接有线PC，无线网卡，手机，平板等设备后，查看当前连接终端数量是否准确") {
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)
            sleep @tc_wait_time
            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            terminal_num_text = sys_iframe.b(id: @ts_terminal_num_id).parent.text
            terminal_num = terminal_num_text.slice(/\d$/i)
            assert_equal(terminal_num, "2", "终端数量不准确！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、将部分设备断开与被测AP连接后，查看当前连接终端数量是否准确") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            terminal_num_text = sys_iframe.b(id: @ts_terminal_num_id).parent.text
            terminal_num = terminal_num_text.slice(/\d$/i)
            assert_equal(terminal_num, "1", "终端数量不准确！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("3、设备PC为静态IP地址后，查看当前连接终端数量是否准确") {
            p "将PC1设置与DUT同一网段的固定IP".to_gbk
            dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
            dup_gw = ipconfig("all")[@ts_nicname][:gateway][0]
            dut_ip =~ /(\d+\.\d+\.\d+\.)(\d+)/
            pc_ip          = $1 + ($2.to_i+10).to_s
            pc_mask        = "255.255.255.0"
            pc_gw          = dup_gw
            #设置静态IP
            args           = {}
            args[:ip]      = pc_ip
            args[:mask]    = pc_mask
            args[:gateway] = pc_gw
            args[:nicname] = @ts_nicname
            args[:source]  = "static"
            static_ip      = netsh_if_ip_setip(args)
            assert(static_ip, "PC1设置固定静态IP失败！")
            sleep @tc_wait_time
            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            terminal_num_text = sys_iframe.b(id: @ts_terminal_num_id).parent.text
            terminal_num = terminal_num_text.slice(/\d$/i)
            assert_equal(terminal_num, "1", "终端数量不准确！")
        }


    end

    def clearup
        p "断开wifi连接".to_gbk
        @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接

        p "设置pc1为dhcp模式".to_gbk
        args           = {}
        args[:nicname] = @ts_nicname
        args[:source]  = "dhcp"
        netsh_if_ip_setip(args)
    end

}
