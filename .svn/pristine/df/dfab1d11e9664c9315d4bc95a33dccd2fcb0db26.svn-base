#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.19", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time           = 3
        @tc_net_wait_time       = 60
        @tc_reboot_wait_time    = 90
        @tc_rebooting_wait_time = 120
        @tc_run_time            = "running-time"
        @tc_runtime_cmd         = "uptime"
    end

    def process

        operate("1、点击系统状态的页面，查看页面上显示的运行时长是否正确，与串口下使用命令uptime查看的时长是否一致") {
            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            sys_iframe.b(id: @tc_run_time).wait_until_present(@tc_wait_time)
            run_time = sys_iframe.b(id: @tc_run_time).parent.text #"\u8FD0\u884C\u65F6\u957F\n 4 hour, 20 minute, 37 second"

            #使用命令查看运行时长
            telnet_init(@default_url, @ts_unified_platform_user, @ts_unified_platform_pwd)
            tel_run_time = exp_run_time(@tc_runtime_cmd)
            if tel_run_time =~ /secs$/ #启动还没有一分钟
                judge = run_time.slice(/(\d+)\s*secs/i, 1).to_i - tel_run_time.slice(/(\d+)\s*secs/i, 1).to_i
                assert((judge>=0 && judge < 10), "页面显示与命令查看时长不一致")
            elsif tel_run_time =~ /min$/ #需要一个时间误差,1分钟以内算正常。 run_time为2:52，tel_run_time为3min
                # assert_equal(run_time.slice(/(\d+)\s*[min|mins]/i, 1), tel_run_time.slice(/(\d+)\s*min/i, 1), "页面显示与命令查看时长不一致")
                assert(tel_run_time.slice(/(\d+)\s*min/i, 1).to_i - run_time.slice(/(\d+)\s*[min|mins]/i, 1).to_i <= 1, "页面显示与命令查看时长不一致")
            else
                run_time =~ /(\d+)\s*hou(r|rs),\s*(\d+)\s*(min|minute|mins)/i
                # run_time_as      = $1 + ":" + m
                run_time_as_hour = $1
                run_time_as_mine = $3
                tel_run_time =~ /(\d+):(\d+)/i
                tel_run_time_hour = $1
                tel_run_time_mine = $2
                unless run_time_as_hour.to_i == tel_run_time_hour.to_i
                    unless tel_run_time_mine.to_i == 0 && run_time_as_mine.to_i == 59 && tel_run_time_hour.to_i - run_time_as_hour.to_i == 1 #13:59与14:00
                        assert(false, "页面显示与命令查看时长不一致")
                    end
                end
                assert(tel_run_time_mine.to_i - run_time_as_mine.to_i <= 1, "页面显示与命令查看时长不一致")
            end
        }

        operate("2、页面点击重启，重启成功后，查看运行时长是否重新计时") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_reboot).parent.click #点击重启按钮
            @browser.button(class_name: @ts_tag_reboot_confirm).click

            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_rebooting_wait_time

            #重新登录
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "重启成功，再次登录！".to_gbk
            else
                assert(login_ui, "重启失败，请定位后重试！")
            end
            login_no_default_ip(@browser) #重新登录
            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            sys_iframe.b(id: @tc_run_time).wait_until_present(@tc_wait_time)
            run_time = sys_iframe.b(id: @tc_run_time).parent.text

            #使用命令查看运行时长
            telnet_init(@default_url, @ts_unified_platform_user, @ts_unified_platform_pwd)
            tel_run_time = exp_run_time(@tc_runtime_cmd)
            if tel_run_time =~ /secs$/ #启动还没有一分钟
                judge = run_time.slice(/(\d+)\s*secs/i, 1).to_i - tel_run_time.slice(/(\d+)\s*secs/i, 1).to_i
                assert((judge>=0 && judge < 10), "页面显示与命令查看时长不一致")
            elsif tel_run_time =~ /min$/ #需要一个时间误差,1分钟以内算正常。 run_time为2:52，tel_run_time为3min
                # assert_equal(run_time.slice(/(\d+)\s*[min|mins]/i, 1), tel_run_time.slice(/(\d+)\s*min/i, 1), "页面显示与命令查看时长不一致")
                assert(tel_run_time.slice(/(\d+)\s*min/i, 1).to_i - run_time.slice(/(\d+)\s*[min|mins]/i, 1).to_i <= 1, "页面显示与命令查看时长不一致")
            else
                run_time =~ /(\d+)\s*hou(r|rs),\s*(\d+)\s*(min|minute|mins)/i
                # run_time_as = $1 + ":" + $3
                run_time_as_hour = $1
                run_time_as_mine = $3
                tel_run_time =~ /(\d+):(\d+)/i
                tel_run_time_hour = $1
                tel_run_time_mine = $2
                unless run_time_as_hour.to_i == tel_run_time_hour.to_i
                    unless tel_run_time_mine.to_i == 0 && run_time_as_mine.to_i == 59 && tel_run_time_hour.to_i - run_time_as_hour.to_i == 1 #13:59与14:00
                        assert(false, "页面显示与命令查看时长不一致")
                    end
                end
                assert(tel_run_time_mine.to_i - run_time_as_mine.to_i <= 1, "页面显示与命令查看时长不一致")
            end
        }

        operate("3、长时间将AP上电，进行各种配置和测试后观察运行时长是否正常（例如修改WAN，修改LAN，wifi等操作）") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_netset).click #打开外网
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败！")
            pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
            pppoe_radio_state = pppoe_radio.attribute_value(:checked)
            unless pppoe_radio_state == "true"
                pppoe_radio.click
            end
            puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
            @wan_iframe.text_field(id: @ts_tag_pppoe_usr).wait_until_present(@tc_wait_time)
            @wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            @wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            @wan_iframe.button(id: @ts_tag_sbm).click #保存
            sleep @tc_wait_time
            net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                net_reset_div.present?
            }
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            # sleep @tc_rebooting_wait_time
            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click

            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            sys_iframe.b(id: @tc_run_time).wait_until_present(@tc_wait_time)
            run_time = sys_iframe.b(id: @tc_run_time).parent.text
            #使用命令查看运行时长
            telnet_init(@default_url, @ts_unified_platform_user, @ts_unified_platform_pwd)
            tel_run_time = exp_run_time(@tc_runtime_cmd)
            if tel_run_time =~ /secs$/ #启动还没有一分钟
                judge = run_time.slice(/(\d+)\s*secs/i, 1).to_i - tel_run_time.slice(/(\d+)\s*secs/i, 1).to_i
                assert((judge>=0 && judge < 10), "页面显示与命令查看时长不一致")
            elsif tel_run_time =~ /min$/ #需要一个时间误差,1分钟以内算正常。 run_time为2:52，tel_run_time为3min
                # assert_equal(run_time.slice(/(\d+)\s*[min|mins]/i, 1), tel_run_time.slice(/(\d+)\s*min/i, 1), "页面显示与命令查看时长不一致")
                assert(tel_run_time.slice(/(\d+)\s*min/i, 1).to_i - run_time.slice(/(\d+)\s*[min|mins]/i, 1).to_i <= 1, "页面显示与命令查看时长不一致")
            else
                run_time =~ /(\d+)\s*hou(r|rs),\s*(\d+)\s*(min|minute|mins)/i
                # run_time_as = $1 + ":" + $3
                run_time_as_hour = $1
                run_time_as_mine = $3
                tel_run_time =~ /(\d+):(\d+)/i
                tel_run_time_hour = $1
                tel_run_time_mine = $2
                unless run_time_as_hour.to_i == tel_run_time_hour.to_i
                    unless tel_run_time_mine.to_i == 0 && run_time_as_mine.to_i == 59 && tel_run_time_hour.to_i - run_time_as_hour.to_i == 1 #13:59与14:00
                        assert(false, "页面显示与命令查看时长不一致")
                    end
                end
                assert(tel_run_time_mine.to_i - run_time_as_mine.to_i <= 1, "页面显示与命令查看时长不一致")
            end
        }


    end

    def clearup
        operate("恢复默认配置") {
            p "恢复为默认的接入方式，DHCP接入".to_gbk
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip) #登录
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
