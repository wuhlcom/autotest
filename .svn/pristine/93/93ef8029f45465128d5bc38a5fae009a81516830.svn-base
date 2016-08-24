#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_34.1.4", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time      = 3
        @tc_rebot_net      = 30
        @tc_net_wait_time  = 60
        @tc_ping_num       = 100
        @tc_strategy       = "一次"
        @tc_strategy_value = "1"
    end

    def process
        operate("0、分别对WAN，LAN，WIFI，防火墙，QOS做相应的配置，记录配置信息。") {
            p "设置WAN口为PPPOE拨号".to_gbk
            @browser.span(id: @ts_tag_netset).click
            wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(wan_iframe.exists?, "打开外网设备页面失败")
            wan_iframe.link(id: @ts_tag_wired_mode_link).wait_until_present(@tc_wait_time)
            wan_iframe.link(id: @ts_tag_wired_mode_link).click
            wan_iframe.radio(id: @ts_tag_wired_pppoe).click
            wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            wan_iframe.button(id: @ts_tag_sbm).click
            net_reset_div = wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                net_reset_div.present?
            }
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_lan).click
            lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(lan_iframe.exists?, "打开内网设备页面失败")
            #lan口ip修改后如果恢复失败，会在连跑的过程中影响其他脚本，所以脚本中不做lan口配置修改 modify 2016/01/13
            # p "修改LAN口IP".to_gbk
            # @lan_ip =lan_iframe.text_field(id: @ts_tag_lanip).value
            # @lan_ip =~ /(\d+\.\d+\.)(\d+)(\.\d+)/i
            # @lan_ip_change = $1 + ($2.to_i-1).to_s + $3
            # lan_iframe.text_field(id: @ts_tag_lanip).set(@lan_ip_change)
            p "修改ssid".to_gbk
            wifi_btn = lan_iframe.button(id: @ts_wifi_switch)
            if wifi_btn.class_name == "off"
                wifi_btn.click
            end
            @ssid        = lan_iframe.text_field(id: @ts_tag_ssid).value
            @ssid_change = @ssid + "change"
            lan_iframe.text_field(id: @ts_tag_ssid).set(@ssid_change)
            lan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_rebot_net
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
            end
            p "开启防火墙总开关，并在IP过滤设置中新增一条规则".to_gbk
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "off"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "off"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #保存
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
            @option_iframe.text_field(id: @ts_ip_dst).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_ip_dst).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click
            sleep @tc_wait_time
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("1、登录AP，进入到定时任务页面") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            sys_link       = @option_iframe.link(id: @ts_tag_op_system)
            sys_link_state = sys_link.attribute_value(:checked)
            unless sys_link_state == "true"
                sys_link.click
            end
            @option_iframe.link(id: @ts_tag_plan_task).wait_until_present(@tc_wait_time)
            option_plan_iframe = @option_iframe.link(id: @ts_tag_plan_task)
            option_plan_iframe.click
        }

        operate("2、配置一个定时时间，例如配置为当前时间的下一分钟，然后关闭定时任务，点击保存") {
            timing_btn = @option_iframe.button(id: @ts_btn_id)
            timing_btn.wait_until_present(@tc_wait_time)
            if timing_btn.class_name == "off"
                timing_btn.click #打开开关
            end
            timing_strategy = @option_iframe.select_list(id: @ts_timing_strategy)
            timing_strategy.wait_until_present(@tc_wait_time)
            timing_strategy.select_value(@tc_strategy_value) #选择策略
            @option_iframe.text_field(id: @ts_select_time_id).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_select_time_id).click #选择时间
            @option_iframe.link(id: @ts_taday_id).click #点击今天按钮
            cur_time = @option_iframe.text_field(id: @ts_select_time_id).value #获取当前时间值
            minnew   = cur_time.slice(/\d+\-\d+\-\d+\s\d+:(\d+):\d+/i, 1).to_i + 2 #配置当前时间的下一分钟。###由于有时间差，配置两分钟能够防止出错
            if minnew == 60
                sleep 60 #等待下个整点再配置
                minnew = minnew - 60 + 2 #配置当前时间的下一分钟
                @option_iframe.text_field(id: @ts_select_time_id).click #选择时间
                @option_iframe.link(id: @ts_taday_id).click #点击今天按钮
                @option_iframe.li(class_name: @ts_time_classname).parent.lis[2].text_field.click
                @option_iframe.div(id: @ts_time_minute).span(text: minnew.to_s).click #修改分钟
            else
                @option_iframe.text_field(id: @ts_select_time_id).click #选择时间
                @option_iframe.li(class_name: @ts_time_classname).parent.lis[2].text_field.click
                @option_iframe.div(id: @ts_time_minute).span(text: minnew.to_s).click #修改分钟
            end
            @option_iframe.link(id: @ts_time_ok).click #确定
            @option_iframe.p(id: @ts_rebot_btn).click #保存
        }

        operate("3、查看时间到后路由器是否重启，重启完成后，查看之前配置的业务是否都正常") {
            sleep 60
            #启动ping 192.168.100.1，查看丢包率
            lost_pack = ping_lost_pack(@dut_ip, @tc_ping_num)
            if lost_pack >= 5 && lost_pack <= 30
                lost_flag = true
            else
                lost_flag = false
            end
            assert(lost_flag, "100个包中丢失#{lost_pack}个包，超过设定区间[5,30],判定为重启不成功！")

            p "查询是否为为PPPOE模式".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, '重启后配置发生改变，WAN口不为PPPOE拨号！')
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "查询LAN口IP配置是否正确".to_gbk
            @browser.span(id: @ts_tag_lan).click
            lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(lan_iframe.exists?, "打开内网设备页面失败")
            # lan_ip =lan_iframe.text_field(id: @ts_tag_lanip).value
            # assert_equal(lan_ip, @lan_ip_change, "LAN口IP发生了改变！")
            p "查询wifi配置是否正确".to_gbk
            wifi_btn = lan_iframe.button(id: @ts_wifi_switch)
            assert_equal(wifi_btn.class_name, "on", "wifi开关配置发生改变！")
            ssid = lan_iframe.text_field(id: @ts_tag_ssid).value
            assert_equal(ssid, @ssid_change, "ssid发生了改变！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "查询防火墙配置是否正确".to_gbk
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            assert_equal(fire_wall_btn.class_name, "on", "防火墙总开关配置发生了改变！")
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            assert_equal(ip_btn.class_name, "on", "IP过滤总开关配置发生了改变！")
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            unless ip_clauses == 1
                rule_srcip = @option_iframe.table(id: @ts_iptable).trs[1][3].text.slice(/(.+)\-/i, 1)
            end
            if (ip_clauses == 1 || rule_srcip != @dut_ip)
                assert(false, "IP过滤规则配置发生了改变！")
            end
        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
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

        operate("2、关闭防火墙总开关和IP过滤开关") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "on"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #保存
        }

        operate("3、删除所有条目") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses > 1 #如果有条目就删除
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("4、恢复LAN口IP，ssid") {
            flag = false
            @browser.span(id: @ts_tag_lan).click
            lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            # unless lan_iframe.text_field(id: @ts_tag_lanip).value == @lan_ip
            #     lan_iframe.text_field(id: @ts_tag_lanip).set(@lan_ip)
            #     flag = true
            # end
            p "修改ssid".to_gbk
            wifi_btn = lan_iframe.button(id: @ts_wifi_switch)
            if wifi_btn.class_name == "off"
                wifi_btn.click
                flag = true
            end
            unless lan_iframe.text_field(id: @ts_tag_ssid).value == @ssid
                lan_iframe.text_field(id: @ts_tag_ssid).set(@ssid)
                flag = true
            end
            if flag
                lan_iframe.button(id: @ts_tag_sbm).click
                sleep @tc_rebot_net
                # lan_reset_div = lan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                # Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                #     lan_reset_div.present?
                # }
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

}
