#
# description:
# 用例应 验证格式和及内容由0-9，A-F就可以，无需验证MAC地址类别
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_28.1.7", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_mac_error = "MAC地址格式错误"
        @tc_mac_desc  = "test"
    end

    def process

        operate("1、AP工作在路由方式下，输入MAC地址包含~!@#$%^&*()_+{}|:\"<>?等键盘上33个特殊字符,查看是否允许输入保存；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "on", "off")
            @options_page.macfilter_click
            @options_page.mac_add_item_element.click #新增条目
        }

        operate("2、输入MAC地址：00:00:00:00:00:00，查看是否允许输入保存；") {
            tc_mac1 = "GG:02:00:00:00:01"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            tc_mac1 = "00:02:GG:00:00:01"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            tc_mac1 = "00:02:00:GG:00:01"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            tc_mac1 = "00:02:00:00:00:GG"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            tc_mac1 = "0002000001"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
        }

    end

    def clearup

        operate("1、恢复防火墙默认设置：关闭总开关并删除所有规则") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.macfilter_close_sw_del_all(@browser.url)
        }

    end

}
