#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.18", "level" => "P2", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_dumpcap_pc2      = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time        = 5
        @tc_wait_time_effect = 10
        @tc_net_wait_time    = 60
    end

    def process

        operate("1、进入路由器内网设置页面；") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
        }

        operate("2、设置无线开关为关；") {
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "on"
                @lan_frame.button(id: @ts_wifi_switch).click #关闭无线开关
            end
            p "获取ssid及密码".to_gbk
            wifi_ssid_obj = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid_obj.wait_until_present(@tc_wait_time)
            @wifi_ssid = wifi_ssid_obj.value
            p "路由器wifi的ssid为 --> #{@wifi_ssid}".to_gbk
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #选择安全模式
            wifi_pwd_obj = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd_obj.wait_until_present(@tc_wait_time)
            @wifi_pwd = wifi_pwd_obj.value
            p "路由器wifi的密码为 --> #{@wifi_pwd}".to_gbk
            @lan_frame.button(id: @ts_tag_sbm).click #保存
            lan_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                lan_reset_div.present?
            }
        }

        operate("3、使用无线网卡扫描该SSID，是否可以扫描成功；手动输入连接该SSID，是否可以连接成功；") {
            sleep @tc_wait_time_effect
            p "PC扫描ssid：#{@wifi_ssid}".to_gbk
            if_connect = @tc_dumpcap_pc2.scan_network("#{@wifi_ssid}") #if_connect[:flag] == true表示能扫描到
            refute(if_connect[:flag], "无线网卡能扫描到该ssid：#{@wifi_ssid}")
        }

        operate("4、设置无线开关为开；") {
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
            end
            @lan_frame.button(id: @ts_tag_sbm).click #保存
            lan_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                lan_reset_div.present?
            }
        }

        operate("5、使用无线网卡扫描该SSID，是否可以扫描成功，且能连接成功；") {
            sleep @tc_wait_time_effect
            p "PC扫描ssid：#{@wifi_ssid}".to_gbk
            if_connect = @tc_dumpcap_pc2.scan_network("#{@wifi_ssid}")
            assert(if_connect[:flag], "无线网卡不能扫描到该ssid：#{@wifi_ssid}")
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@wifi_ssid, flag, @wifi_pwd, @ts_wlan_nicname)
            assert(rs, "PC wifi连接失败".to_gbk)
        }


    end

    def clearup
        operate("恢复配置") {
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
                @lan_frame.button(id: @ts_tag_sbm).click #保存
                lan_reset_div = @lan_frame.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    lan_reset_div.present?
                }
            end
        }
    end

}
