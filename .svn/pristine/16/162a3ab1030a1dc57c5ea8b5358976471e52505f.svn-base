#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.9", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time   = 3
        @tc_ip_table    = "iptable"
        @tc_start_time1 = "中国"
        @tc_start_time2 = "!@#$%^&*("
        @tc_start_time3 = "12345"
        @tc_start_time4 = "2222"
        @tc_start_time5 = "1111"
    end

    def process

        operate("1、登录到AP的管理界面，进入到IP过虑设置界面；") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).click #进入安全设置
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
        }

        operate("2、新添加一条规则，查看生效时间默认是否为0000-2359；") {
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_start_time).wait_until_present(@tc_wait_time)
            @start_time = @option_iframe.text_field(id: @ts_ip_start_time)
            assert_equal(@start_time.value, "0000", "起始生效时间不是0000")
            @end_time = @option_iframe.text_field(id: @ts_ip_end_time)
            assert_equal(@end_time.value, "2359", "结束生效时间不是2359")
        }

        operate("3、修改生效时间为中文：“中国”，保存；") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @start_time.clear
            @start_time.set(@tc_start_time1)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_time_err_text)
            assert(err_msg.exists?, "生效时间输入中文时未出现错误提示")
        }

        operate("4、修改生效时间为特殊字符：“!@#$%^&*(”，保存；") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @start_time.clear
            @start_time.set(@tc_start_time2)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_time_err_text)
            assert(err_msg.exists?, "生效时间输入特殊字符时未出现错误提示")
        }

        operate("5、修改生效时间输入大于4个数字，点保存；") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @start_time.clear
            @start_time.set(@tc_start_time3)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            start_time = @option_iframe.table(id: @tc_ip_table).trs[1][0].text.slice(/(\d+)\-\d+/i, 1)
            assert_equal(start_time, "1234", "输入生效时间大于4个数字后，还可以输入")
        }

        operate("6、修改生效时间起始大于终止时间，保存；") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @start_time.clear
            @start_time.set(@tc_start_time4)
            @end_time.set(@tc_start_time5)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_time_err_text)
            assert(err_msg.exists?, "生效时间起始大于终止时间时未出现错误提示")
        }


    end

    def clearup
        operate("删除所有条目") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).click #进入安全设置
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            ip_clauses = @option_iframe.table(id: @tc_ip_table).trs.size
            if ip_clauses > 1 #如果有条目就删除
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
            end
        }
    end

}
