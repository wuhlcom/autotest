#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
#现版本新增重复规则时没有提示
#脚本写作时@ts_ip_repetition_text变量没有定义，需要在版本修改后定义
testcase {
    attr = {"id" => "ZLBF_15.1.21", "level" => "P3", "auto" => "n"}

    def prepare
        @s_ip            = "192.168.100.100"
        @s_ip_end        = "192.168.100.103"
        @tc_wait_time    = 3
        @tc_s_port1      = "1111"
        @tc_s_port2      = "2222"
        @tc_s_port3      = "3333"
        @tc_s_port3_end  = "3344"
        @tc_protocol_tcp = "TCP"
        @tc_protocol_udp = "UDP"
    end

    def process

        operate("1、进入IP过滤配置页面；") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
        }

        operate("2、添加一条协议选择TCP，起始与结束端口设置1111，过滤IP设置为192.168.100.100，是否可以保存；") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).set(@s_ip)
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_s_port1)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_s_port1)
            protocol = @option_iframe.select_list(id: @ts_tag_vir_protocol1)
            protocol.select(@tc_protocol_tcp)
            @option_iframe.button(id: @ts_tag_save_filter).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 2, "未能成功添加规则！")
        }

        operate("3、添加一条协议选择TCP，起始与结束端口设置1111，过滤IP设置为192.168.100.100，是否可以保存；") {
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).set(@s_ip)
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_s_port1)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_s_port1)
            protocol = @option_iframe.select_list(id: @ts_tag_vir_protocol1)
            protocol.select(@tc_protocol_tcp)
            @option_iframe.button(id: @ts_tag_save_filter).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            # assert(@option_iframe.p(id: @ts_ip_err, text: @ts_ip_repetition_text).exists?, "添加相同规则时没有提示！") #版本修改后使用此代码
            # @option_iframe.button(id: @ts_tag_ip_back).click
            assert(@option_iframe.p(id: @ts_ip_err).exists?, "添加相同规则时没有提示！")
        }

        operate("4、添加一条协议选择UDP，起始与结束端口设置2222，过滤IP设置为192.168.100.100，是否可以保存；") {
            p "添加新规则前删除所有规则".to_gbk
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).set(@s_ip)
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_s_port2)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_s_port2)
            protocol = @option_iframe.select_list(id: @ts_tag_vir_protocol1)
            protocol.select(@tc_protocol_udp)
            @option_iframe.button(id: @ts_tag_save_filter).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 2, "未能成功添加规则！")
        }

        operate("5、添加一条协议选择UDP，起始与结束端口设置2222，过滤IP设置为192.168.100.100，是否可以保存；") {
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).set(@s_ip)
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_s_port2)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_s_port2)
            protocol = @option_iframe.select_list(id: @ts_tag_vir_protocol1)
            protocol.select(@tc_protocol_udp)
            @option_iframe.button(id: @ts_tag_save_filter).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            # assert(@option_iframe.p(id: @ts_ip_err, text: @ts_ip_repetition_text).exists?, "添加相同规则时没有提示！") #版本修改后使用此代码
            # @option_iframe.button(id: @ts_tag_ip_back).click
            assert(@option_iframe.p(id: @ts_ip_err).exists?, "添加相同规则时没有提示！")
        }

        operate("6、添加一条协议选择TCP/UDP，起始与结束端口设置3333~3344，过滤IP设置为192.168.100.100~105，是否可以保存；") {
            p "添加新规则前删除所有规则".to_gbk
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).set(@s_ip)
            @option_iframe.text_field(id: @ts_ip_src_end).set(@s_ip_end)
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_s_port3)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_s_port3_end)
            protocol = @option_iframe.select_list(id: @ts_tag_vir_protocol1)
            protocol.select(@tc_protocol_udp)
            @option_iframe.button(id: @ts_tag_save_filter).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 2, "未能成功添加规则！")
        }

        operate("7、添加一条协议选择TCP/UDP，起始与结束端口设置3333~3344，过滤IP设置为192.168.100.100~105，是否可以保存；") {
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).set(@s_ip)
            @option_iframe.text_field(id: @ts_ip_src_end).set(@s_ip_end)
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_s_port3)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_s_port3_end)
            protocol = @option_iframe.select_list(id: @ts_tag_vir_protocol1)
            protocol.select(@tc_protocol_udp)
            @option_iframe.button(id: @ts_tag_save_filter).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            # assert(@option_iframe.p(id: @ts_ip_err, text: @ts_ip_repetition_text).exists?, "添加相同规则时没有提示！") #版本修改后使用此代码
            # @option_iframe.button(id: @ts_tag_ip_back).click
            assert(@option_iframe.p(id: @ts_ip_err).exists?, "添加相同规则时没有提示！")
        }

        operate("8、添加一条协议选择TCP，起始与结束端口设置3333，过滤IP设置为192.168.100.100，是否可以保存；") {
            p "添加新规则前删除所有规则".to_gbk
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).set(@s_ip)
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_s_port3)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_s_port3)
            protocol = @option_iframe.select_list(id: @ts_tag_vir_protocol1)
            protocol.select(@tc_protocol_tcp)
            @option_iframe.button(id: @ts_tag_save_filter).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 2, "未能成功添加规则！")
        }

        operate("9、添加一条协议选择UDP，起始与结束端口设置3333，过滤IP设置为192.168.100.100，是否可以保存；") {
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).set(@s_ip)
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_s_port3)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_s_port3)
            protocol = @option_iframe.select_list(id: @ts_tag_vir_protocol1)
            protocol.select(@tc_protocol_udp)
            @option_iframe.button(id: @ts_tag_save_filter).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 3, "未能成功添加规则！")
        }

        operate("10、编辑步骤9中添加的规则，修改协议为TCP，是否可以保存。") {
            ip_trs = @option_iframe.table(id: @ts_iptable).trs
            ip_trs[2][7].link(class_name: @ts_tag_edit).click
            protocol = @option_iframe.select_list(id: @ts_tag_vir_protocol)
            protocol.select(@tc_protocol_tcp)
            @option_iframe.button(id: @ts_tag_save_filter1).wait_until_present(@tc_wait_time)
            @option_iframe.button(id: @ts_tag_save_filter1).click #保存
            sleep @tc_wait_time
            # assert(@option_iframe.p(id: @ts_ip_err, text: @ts_ip_repetition_text).exists?, "添加相同规则时没有提示！") #版本修改后使用此代码
            # @option_iframe.button(id: @ts_tag_ip_back).click
            assert(@option_iframe.p(id: @ts_ip_err).exists?, "添加相同规则时没有提示！")
        }

        operate("建议：对IP地址重叠，端口重叠可以不作检测。") {

        }


    end

    def clearup
        operate("删除所有配置") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses > 1 #如果有条目就删除
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
            end
        }
    end

}
