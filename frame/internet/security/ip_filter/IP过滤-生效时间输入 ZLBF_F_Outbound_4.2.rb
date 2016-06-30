#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.9", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_start_time1 = "中国"
        @tc_start_time2 = "!@#$%^&*("
        @tc_start_time3 = "12345"
        @tc_start_time4 = "2222"
        @tc_start_time5 = "1111"
    end

    def process
        operate("1、登录到AP的管理界面，进入到IP过虑设置界面；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
            @options_page.ipfilter_click
            @options_page.ip_add_item_element.click #新增条目
        }

        operate("2、新添加一条规则，查看生效时间默认是否为0000-2359；") {
            start_time = @options_page.eff_start_time
            end_time   = @options_page.eff_end_time
            assert_equal("0000", start_time, "起始生效时间不是0000")
            assert_equal("2359", end_time, "结束生效时间不是2359")
        }

        operate("3、修改生效时间为中文：“中国”，保存；") {
            @options_page.eff_start_time = @tc_start_time1
            cur_text_value = @options_page.eff_start_time
            assert_equal("", cur_text_value, "生效时间输入框可以输入中文！")
        }

        operate("4、修改生效时间为特殊字符：“!@#$%^&*(”，保存；") {
            @options_page.eff_start_time = @tc_start_time2
            cur_text_value = @options_page.eff_start_time
            assert_equal("", cur_text_value, "生效时间输入框可以输入特殊字符！")
        }

        operate("5、修改生效时间输入大于4个数字，点保存；") {
            @options_page.eff_start_time = @tc_start_time3
            cur_text_value = @options_page.eff_start_time
            assert_equal(4, cur_text_value.length, "生效时间输入框可以输入大于4个数字的字符！")
        }

        operate("6、修改生效时间起始大于终止时间，保存；") {
            @options_page.eff_start_time = @tc_start_time4
            @options_page.eff_end_time = @tc_start_time5
            @options_page.ip_save
            assert(@options_page.ip_filter_err_msg?, "起始时间大于终止时间时未出现错误提示!")
        }


    end

    def clearup
        operate("1 恢复默认配置") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
