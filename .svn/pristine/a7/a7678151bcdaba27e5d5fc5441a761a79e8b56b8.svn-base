#
# description:
# author:
# date:
# modify:
#
testcase {
    attr = {"id" => "ZLBF_F_MACFilter_2.7", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
        @tc_mac_error = "MAC地址格式错误"
        @tc_mac_desc  = "test"
    end

    def process

        operate("1、AP工作在路由方式下，打开安全设置防火墙开和MAC过滤开，打开MAC过滤设置页面,输入有特殊符号的MAC") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "on", "off")
            @options_page.macfilter_click
            @options_page.mac_add_item_element.click #新增条目
        }

        operate("2、新增加MAC过滤条目,分别输入MAC为\"b0:aa:00:00:00:01\",添加描述为test,保存") {
            tc_mac1 = "b0:aa:00:00:00:01"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep @tc_wait_time
            mac_addr = @options_page.mac_filter_table_element.element.trs[1][0].text
            assert_equal(tc_mac1.upcase, mac_addr, "MAC地址未转换成大写格式")
            @options_page.mac_add_item_element.click #新增条目
        }

        operate("3、新增加MAC过滤条目,分别输入MAC为\"00:cD:00:00:00:01\",添加描述为test,保存") {
            tc_mac2 = "00:cD:00:00:00:01"
            puts "添加MAC #{tc_mac2}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac2, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep @tc_wait_time
            mac_addr = @options_page.mac_filter_table_element.element.trs[2][0].text
            assert_equal(tc_mac2.upcase, mac_addr, "MAC地址未转换成大写格式")
            @options_page.mac_add_item_element.click #新增条目
        }

        operate("4、新增加MAC过滤条目,分别输入MAC为\"00:02:Cc:00:00:Fb\",添加描述为test,保存") {
            tc_mac3 = "00:02:Cc:00:00:Fb"
            puts "添加MAC #{tc_mac3}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac3, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep @tc_wait_time
            mac_addr = @options_page.mac_filter_table_element.element.trs[3][0].text
            assert_equal(tc_mac3.upcase, mac_addr, "MAC地址未转换成大写格式")
            @options_page.mac_add_item_element.click #新增条目
        }
    end

    def clearup

        operate("1、恢复防火墙默认设置：关闭总开关并删除所有规则") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.macfilter_close_sw_del_all(@browser.url)
        }

    end

}
