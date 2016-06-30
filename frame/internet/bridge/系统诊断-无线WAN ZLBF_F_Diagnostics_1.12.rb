#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.29", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_error_pw            = "errorpasswd"
        @tc_tag_diag_fini_fail2 = "诊断完成：网络不通。"
        @tc_handle_num0         = 0
        @tc_handle_num1         = 1
        @tc_diag_time           = 30
    end

    def process

        operate("1、配置外网设置为无线WAN，扫描一个可以上网的上行AP进行连接，输入正确的密码连接成功；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_bridge_pattern(@browser.url, @ts_upssid_name, @ts_ap_pw)
            #查看WAN状态
            @systatus_page = RouterPageObject::SystatusPage.new(@browser)
            @systatus_page.open_systatus_page(@browser.url)
            wan_type = @systatus_page.get_wan_type
            wan_ip   = @systatus_page.get_wan_ip
            wan_gw   = @systatus_page.get_wan_gw
            puts "WAN接入方式为:#{wan_type}".to_gbk
            assert_match(/#{@ts_tag_wifiwan}/, wan_type, "接入类型错误")
            puts "WAN IP地址:#{wan_ip}".to_gbk
            assert_match(@ts_tag_ip_regxp, wan_ip, "无线WAN获取IP地址失败")
            puts "WAN 网关为:#{wan_gw}".to_gbk
            assert_match(@ts_tag_ip_regxp, wan_gw, "无线WAN获取网关地址失败")
            rs = ping(@ts_web)
            assert(rs, "网络连接失败!")
        }

        operate("2、点击系统诊断，查看诊断结果；") {
            @diagnose_page = RouterPageObject::DiagnosePage.new(@browser)
            @diagnose_page.initialize_diag(@browser)
            rs = @diagnose_page.detect_rs
            puts "诊断结果:#{rs}".to_gbk
            assert_equal(@ts_tag_diag_fini_success, rs, "诊断结果错误!")

            net_status = @diagnose_page.net_status
            puts "外网连接状态:#{net_status}".to_gbk
            assert_equal(@ts_tag_diag_success, net_status, "外网连接结果显示错误")

            wan_conn = @diagnose_page.wan_conn
            puts "WAN口连接状态:#{wan_conn}".to_gbk
            assert_equal(@ts_tag_diag_success, wan_conn, "WAN口物理状态显示错误")

            net_speed = @diagnose_page.net_speed
            puts "连接速率状态:#{net_speed}".to_gbk
            assert_equal(@ts_tag_diag_success, net_speed, "WAN口连接速率显示错误")
        }

        operate("3、扫描一个上行AP进行连接，输入错误的密码进行连接，使连接不成功；") {
            @diagnose_page.switch_page(@tc_handle_num0)
            @wan_page.set_bridge_pattern(@browser.url, @ts_upssid_name, @tc_error_pw)
            rs = ping(@ts_web)
            refute(rs, "网络连接应该是失败的!")
        }

        operate("4、点击系统诊断，查看诊断结果；") {
            @diagnose_page.switch_page(@tc_handle_num1)
            @diagnose_page.rediag #重启诊断
            sleep @tc_diag_time
            rs = @diagnose_page.detect_rs
            puts "诊断结果:#{rs}".to_gbk
            assert_equal(@tc_tag_diag_fini_fail2, rs, "诊断结果错误!")

            net_status = @diagnose_page.net_status
            puts "外网连接状态:#{net_status}".to_gbk
            assert_equal(@ts_tag_diag_fail, net_status, "外网连接结果显示错误")

            wan_conn = @diagnose_page.wan_conn
            puts "WAN口连接状态:#{wan_conn}".to_gbk

            net_speed = @diagnose_page.net_speed
            puts "连接速率状态:#{net_speed}".to_gbk
            assert_equal(@ts_tag_diag_fail, net_speed, "WAN口连接速率显示错误")
        }

        # operate("5、扫描并连接一个不能上网的AP，连接成功后进行系统诊断，查看诊断结果；") {
        #
        # }

    end

    def clearup

        operate("1、恢复默认接入方式DHCP") {
            @diagnose_page.switch_page(@tc_handle_num0)
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }

    end

}
