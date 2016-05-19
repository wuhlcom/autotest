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
        @tc_time_text            = "ʱ��"
        @tc_time_minute          = "laydate_hmsno"
        @tc_time_ok              = "laydate_ok"
        @tc_rebot_btn            = "baocun"
        @tc_time_clear           = "laydate_clear"
        @tc_strategy             = "һ��"
        @tc_strategy_value       = "1"
    end

    def process

        operate("1����¼AP�����뵽��ʱ����ҳ��") {
            @browser.link(id: @ts_tag_options).click

            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            sys_link       = @option_iframe.link(id: @tc_tag_sys_setting)
            sys_link_state = sys_link.attribute_value(:checked)
            unless sys_link_state == "true"
                sys_link.click
            end

            option_plan_iframe = @option_iframe.link(id: @tc_tag_plan_task)
            option_plan_iframe.wait_until_present(@tc_wait_time)
            option_plan_iframe.click
        }

        operate("2������һ����ʱʱ�䣬��������Ϊ��ǰʱ�����һ���ӣ�Ȼ������ʱ���񣬵�����档") {
            timing_btn = @option_iframe.button(id: @ts_btn_id)
            timing_btn.wait_until_present(@tc_wait_time)
            if timing_btn.class_name == "off"
                timing_btn.click #�򿪿���
            end
            timing_strategy = @option_iframe.select_list(id: @ts_timing_strategy)
            timing_strategy.wait_until_present(@tc_wait_time)
            timing_strategy.select_value(@tc_strategy_value) #ѡ�����
            @option_iframe.text_field(id: @ts_select_time_id).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_select_time_id).click #ѡ��ʱ��
            @option_iframe.link(id: @tc_today_id).click #������찴ť
            cur_time = @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).value #��ȡ��ǰʱ��ֵ
            @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).click #�ٵ��ʱ��򣬵���ʱ��
            cur_time =~ /(\d+)\-(\d+)\-(\d+)\s(\d+):(\d+):(\d+)/i
            minnew = $5.to_i + 2 #���õ�ǰʱ�����������
            if minnew >= 60
                sleep 120 #�ȴ�120s����ֹ��ʱ�����Ӷ����ִ���
                minnew = minnew - 60 + 2 #���õ�ǰʱ�����������
                @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).click
                @option_iframe.link(id: @tc_today_id).click #������찴ť
                @option_iframe.li(class_name: @tc_time_classname, text: @tc_time_text).parent.lis[2].text_field.click
                @option_iframe.div(id: @tc_time_minute).span(text: minnew.to_s).click #�޸ķ���
            else
                @option_iframe.li(class_name: @tc_time_classname, text: @tc_time_text).parent.lis[2].text_field.click
                @option_iframe.div(id: @tc_time_minute).span(text: minnew.to_s).click #�޸ķ���
            end
            @option_iframe.link(id: @tc_time_ok).click #ȷ��
            sleep @tc_wait_time
            @option_iframe.p(id: @ts_rebot_btn).click #����

        }

        operate("3���鿴ʱ�䵽��·�����Ƿ�����") {
            sleep 55
            #����ping 192.168.100.1���鿴������
            lost_pack = ping_lost_pack(@default_url, @tc_ping_num)
            if lost_pack >= 5 && lost_pack <= 30
                lost_flag = true
            else
                lost_flag = false
            end
            assert(lost_flag, "100�����ж�ʧ#{lost_pack}�����������趨����[5,30],�ж�Ϊ�������ɹ���")
        }


    end

    def clearup
        puts "���ƻ�����ʱ�����".to_gbk
        plan_time = @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).value
        if plan_time != ""
            @option_iframe.text_field(id: @tc_select_time_id, name: @tc_select_time_name).click
            @option_iframe.link(id: @tc_time_clear).click #���
        end
    end

}
