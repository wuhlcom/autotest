#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#

testcase {
    attr = {"id" => "ZLBF_15.1.21", "level" => "P3", "auto" => "n"}

    def prepare
        @s_ip            = "192.168.100.100"
        @s_ip_end        = "192.168.100.103"
        @tc_wait_time    = 5
        @tc_s_port1      = "1111"
        @tc_s_port2      = "2222"
        @tc_s_port3      = "3333"
        @tc_s_port3_end  = "3344"
        @tc_protocol_tcp = "TCP"
        @tc_protocol_udp = "UDP"
    end

    def process

        operate("1、进入IP过滤配置页面；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
            @options_page.ipfilter_click
            @options_page.ip_add_item_element.click #新增条目
        }

        operate("2、添加一条协议选择TCP，起始与结束端口设置1111，过滤IP设置为192.168.100.100，是否可以保存；") {
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port1, @tc_s_port1)
            @options_page.ip_protocol_type_element.select(@tc_protocol_tcp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "添加规则失败~")
        }

        operate("3、添加一条协议选择TCP，起始与结束端口设置1111，过滤IP设置为192.168.100.100，是否可以保存；") {
            @options_page.ip_add_item_element.click #新增条目
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port1, @tc_s_port1)
            @options_page.ip_protocol_type_element.select(@tc_protocol_tcp)
            @options_page.ip_save
            sleep 1
            ip_hint = @options_page.ip_filter_err_msg_element
            assert(ip_hint.exists?, "添加相同规则时没有提示！")
            @options_page.ip_back #返回
        }

        operate("4、添加一条协议选择UDP，起始与结束端口设置2222，过滤IP设置为192.168.100.100，是否可以保存；") {
            p "添加新规则前删除所有规则".to_gbk
            @options_page.ip_all_del_element.click
            sleep @tc_wait_time
            @options_page.ip_add_item_element.click #新增条目
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port2, @tc_s_port2)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "添加规则失败~")
        }

        operate("5、添加一条协议选择UDP，起始与结束端口设置2222，过滤IP设置为192.168.100.100，是否可以保存；") {
            @options_page.ip_add_item_element.click #新增条目
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port2, @tc_s_port2)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_save
            sleep 1
            ip_hint = @options_page.ip_filter_err_msg_element
            assert(ip_hint.exists?, "添加相同规则时没有提示！")
            @options_page.ip_back #返回
        }

        operate("6、添加一条协议选择TCP/UDP，起始与结束端口设置3333~3344，过滤IP设置为192.168.100.100~105，是否可以保存；") {
            p "添加新规则前删除所有规则".to_gbk
            @options_page.ip_all_del_element.click
            sleep @tc_wait_time
            @options_page.ip_add_item_element.click #新增条目
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip_end)
            @options_page.ip_filter_src_port_input(@tc_s_port3, @tc_s_port3_end)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "添加规则失败~")
        }

        operate("7、添加一条协议选择TCP/UDP，起始与结束端口设置3333~3344，过滤IP设置为192.168.100.100~105，是否可以保存；") {
            @options_page.ip_add_item_element.click #新增条目
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip_end)
            @options_page.ip_filter_src_port_input(@tc_s_port3, @tc_s_port3_end)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_save
            sleep 1
            ip_hint = @options_page.ip_filter_err_msg_element
            assert(ip_hint.exists?, "添加相同规则时没有提示！")
            @options_page.ip_back #返回
        }

        operate("8、添加一条协议选择TCP，起始与结束端口设置3333，过滤IP设置为192.168.100.100，是否可以保存；") {
            p "添加新规则前删除所有规则".to_gbk
            @options_page.ip_all_del_element.click
            sleep @tc_wait_time
            @options_page.ip_add_item_element.click #新增条目
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port3, @tc_s_port3)
            @options_page.ip_protocol_type_element.select(@tc_protocol_tcp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(2, filter_item, "添加规则失败~")
        }

        operate("9、添加一条协议选择UDP，起始与结束端口设置3333，过滤IP设置为192.168.100.100，是否可以保存；") {
            @options_page.ip_add_item_element.click #新增条目
            @options_page.ip_filter_src_ip_input(@s_ip, @s_ip)
            @options_page.ip_filter_src_port_input(@tc_s_port3, @tc_s_port3)
            @options_page.ip_protocol_type_element.select(@tc_protocol_udp)
            @options_page.ip_filter_save
            filter_item = @options_page.ip_filter_table_element.element.trs.size
            assert_equal(3, filter_item, "添加规则失败~")
        }

        operate("10、编辑步骤9中添加的规则，修改协议为TCP，是否可以保存。") {
            @options_page.ip_filter_table_element.element.trs[2][7].link(class_name: @ts_tag_edit).image.click #编辑第二条规则
            @options_page.ip_protocol_type1_element.select(@tc_protocol_tcp)
            @options_page.ip_save1
            sleep 1
            ip_hint = @options_page.ip_filter_err_msg_element
            assert(ip_hint.exists?, "添加相同规则时没有提示！")
        }

        operate("建议：对IP地址重叠，端口重叠可以不作检测。") {

        }


    end

    def clearup
        operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
