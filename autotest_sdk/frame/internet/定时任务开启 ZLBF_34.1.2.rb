#
# description:
# author:liluping
# date:2015-09-28
# modify:
#
testcase {
    attr = {"id" => "ZLBF_34.1.2", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time            = 3
        @tc_ping_num             = 100
        @tc_tag_sys_setting      = "syssetting"
        @tc_tag_plan_task        = "plantask-titile"
        @tc_tag_route_curtime_id = "routetime"
        @tc_select_time_id       = "date_first"
        @tc_select_time_name     = "starttime"
        @tc_select_year_id       = "laydate_y"
        @tc_select_click         = "laydate_click"
        @tc_select_mon_id        = "laydate_m"
        @tc_today_id             = "laydate_today"
        @tc_time_classname       = "laydate_sj"
        @tc_time_text            = "时间"
        @tc_time_minute          = "laydate_hmsno"
        @tc_time_ok              = "laydate_ok"
        @tc_rebot_btn            = "baocun"
        @tc_time_clear           = "laydate_clear"
        @tc_strategy             = "一次"
        @tc_strategy_value       = "1"
    end

    def process

        operate("1、登录AP，进入到定时任务页面") {
            @browser.link(id: @ts_tag_options).click

            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            sys_link       = @option_iframe.link(id: @tc_tag_sys_setting)
            sys_link_state = sys_link.attribute_value(:checked)
            unless sys_link_state == "true"
                sys_link.click
            end

            option_plan_iframe = @option_iframe.link(id: @tc_tag_plan_task)
            option_plan_iframe.wait_until_present(@tc_wait_time)
            option_plan_iframe.click
        }

        operate("2、配置一个定时时间，例如配置为当前时间的下一分钟，然后开启定时任务，点击保存。") {
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
            @option_iframe.link(id: @tc_today_id).click #点击今天按钮
            cur_time = @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).value #获取当前时间值
            @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).click #再点击时间框，调整时间
            cur_time =~ /(\d+)\-(\d+)\-(\d+)\s(\d+):(\d+):(\d+)/i
            minnew = $5.to_i + 2 #配置当前时间的下两分钟
            if minnew >= 60
                sleep 120 #等待120s，防止因时间增加而出现错误
                minnew = minnew - 60 + 2 #配置当前时间的下两分钟
                @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).click
                @option_iframe.link(id: @tc_today_id).click #点击今天按钮
                @option_iframe.li(class_name: @tc_time_classname, text: @tc_time_text).parent.lis[2].text_field.click
                @option_iframe.div(id: @tc_time_minute).span(text: minnew.to_s).click #修改分钟
            else
                @option_iframe.li(class_name: @tc_time_classname, text: @tc_time_text).parent.lis[2].text_field.click
                @option_iframe.div(id: @tc_time_minute).span(text: minnew.to_s).click #修改分钟
            end
            @option_iframe.link(id: @tc_time_ok).click #确定
            sleep @tc_wait_time
            @option_iframe.p(id: @ts_rebot_btn).click #保存

        }

        operate("3，查看时间到后路由器是否重启") {
            sleep 55
            #启动ping 192.168.100.1，查看丢包率
            lost_pack = ping_lost_pack(@default_url, @tc_ping_num)
            if lost_pack >= 5 && lost_pack <= 30
                lost_flag = true
            else
                lost_flag = false
            end
            assert(lost_flag, "100个包中丢失#{lost_pack}个包，超过设定区间[5,30],判定为重启不成功！")
        }


    end

    def clearup
        puts "将计划任务时间清空".to_gbk
        plan_time = @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).value
        if plan_time != ""
            @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).click
            @option_iframe.link(id: @tc_time_clear).click #清空
        end
    end

}
