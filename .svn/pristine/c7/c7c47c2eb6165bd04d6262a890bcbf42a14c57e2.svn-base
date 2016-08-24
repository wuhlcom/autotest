#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_34.1.4", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
        @tc_ping_num  = 100
    end

    def process
        operate("0、分别对WAN，LAN，WIFI，防火墙，QOS做相应的配置，记录配置信息。") {
            p "设置WAN口为PPPOE拨号".to_gbk
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

            #lan口ip修改后如果恢复失败，会在连跑的过程中影响其他脚本，所以脚本中不做lan口配置修改 modify 2016/01/13
            p "修改ssid".to_gbk
            @wifi_page   = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi      = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @change_ssid = rs_wifi[:ssid]

            p "开启防火墙总开关，并在IP过滤设置中新增一条规则".to_gbk
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #安全设置
            @options_page.firewall_click
            @options_page.open_switch("on", "on", "off", "off") #打开防火墙跟IP过滤总开关
        }

        operate("1、登录AP，进入到定时任务页面") {

        }

        operate("2、配置一个定时时间，例如配置为当前时间的下一分钟，然后关闭定时任务，点击保存") {
            @options_page.restart_step(@browser.url)
        }

        operate("3、查看时间到后路由器是否重启，重启完成后，查看之前配置的业务是否都正常") {
            sleep @tc_wait_time
            #启动ping 192.168.100.1，查看丢包率
            lost_pack = ping_lost_pack(@default_url, @tc_ping_num)
            if lost_pack >= 5 && lost_pack <= 20
                lost_flag = true
            else
                lost_flag = false
            end
            assert(lost_flag, "100个包中丢失#{lost_pack}个包，超过设定区间[5,20],判定为重启不成功！")

            p "查询是否为为PPPOE模式".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            wan_type = @status_page.get_wan_type
            assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, "重启后配置发生改变，连接类型不是PPPOE拨号！")

            p "查询wifi配置是否正确".to_gbk
            @wifi_page.open_wifi_page(@browser.url)
            ssid = @wifi_page.ssid1
            assert_equal(@change_ssid, ssid, "重启后ssid发生了改变！")

            p "查询防火墙配置是否正确".to_gbk
            @options_page.open_security_setting(@browser.url) #安全设置
            @options_page.firewall_click
            fire_wall_btn = @options_page.firewall_switch_element.class_name
            ip_btn        = @options_page.ip_filter_switch_element.class_name
            assert_equal("on", fire_wall_btn, "重启后防火墙总开关配置发生了改化！")
            assert_equal("on", ip_btn, "重启后IP过滤开关配置发生了改变！")
        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                rs_login = login_no_default_ip(@browser) #重新登录
                p rs_login[:flag]
                p rs_login[:message]
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }

        operate("2、关闭防火墙总开关和IP过滤开关") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.open_security_setting(@browser.url)
            options_page.firewall_click
            options_page.close_switch
        }

        operate("3、恢复ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end

}
