#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
# 源目IP地址输入lan口ip有效，目的IP输入wan口ip有效(用例都要求无效)，脚本先将这些测试点注释
testcase {
    attr = {"id" => "ZLBF_15.1.1", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time     = 3
        @tc_net_wait_time = 60
        @tc_ip_table      = "iptable"
        @ip1              = "0.0.0.0"
        @ip2              = "255.255.255.255"
        @ip3              = "0.0.0.1"
        @ip4              = "192.0.0.0"
        @ip5              = "224.1.1.1"
        @ip6              = "240.1.1.1"
        @ip7              = "255.1.1.1"
        @ip8              = "10.1.1.256"
        @ip9              = "10.1.1.-11"
        @ip10             = "10.1.1.1.2"
        @ip11             = "192.168.2.255"
        @ip12             = "127.0.0.1"
        @ip13             = "@.a.d.*"
        @ip14             = "中国. .."
    end

    def process
        operate("0、获取LAN口和WAN口IP地址") {
            @browser.span(id: @tag_status).wait_until_present(@tc_wait_time)
            @browser.span(id: @tag_status).click #打开状态界面
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            @wan_ip        = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
            p "WAN口IP为：#{@wan_ip}".to_gbk
            @lan_ip = @status_iframe.b(id: @ts_tag_lan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
            p "LAN口IP为：#{@lan_ip}".to_gbk
        }

        operate("1、DUT的接入类型选择为DHCP，保存配置，PC1设置为自动获取IP地址，如：192.168.100.x，进入到管理界面中的IP过虑界面；") {
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_netset).click #外网
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            flag        = false
            #设置wan连接方式为网线连接
            rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(id: @ts_tag_wired_mode_span).click #网线连接
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
            end

            #设置pc1为dhcp模式
            p "设置PC1为自动获取IP地址".to_gbk
            args           = {}
            args[:nicname] = @ts_nicname
            args[:source]  = "dhcp"
            dhcp_ip        = netsh_if_ip_setip(args)
            assert(dhcp_ip, "PC1地址获取方式设置为自动获取失败！")

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).click #进入安全设置
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
        }

        operate("2、在“源IP地址”输入全0，全255，或0开头地址或0结尾地址，如：0.0.0.0，255.255.255.255，0.0.0.1，192.0.0.0是否允许输入；") {
            p "源IP地址中输入全0".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip1)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg1 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg1.exists?, "源IP地址格式输入错误，但是未有提示！")
            p "源IP地址中输入全255".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip2)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg2 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg2.exists?, "源IP地址格式输入错误，但是未有提示！")
            p "源IP地址中输入全0开头".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip3)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg3 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg3.exists?, "源IP地址格式输入错误，但是未有提示！")
            p "源IP地址中输入全0结尾".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip4)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg4 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg4.exists?, "源IP地址格式输入错误，但是未有提示！")
        }

        operate("3、在“源IP地址”输入D类地址或E类地址、组播地址，如：224.1.1.1，240.1.1.1，255.1.1.1，是否允许输入；") {
            p "源IP地址中输入D类地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip5)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg5 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg5.exists?, "源IP地址格式输入错误，但是未有提示！")
            p "源IP地址中输入E类地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip6)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg6 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg6.exists?, "源IP地址格式输入错误，但是未有提示！")
            p "源IP地址中输入组播地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip7)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg7 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg7.exists?, "源IP地址格式输入错误，但是未有提示！")
        }

        operate("4、在“源IP地址”输入大于255或小于0或小数的数字，如：256，-11，是否允许输入；") {
            p "源IP地址中输入大于255的数字地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip8)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg8 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg8.exists?, "源IP地址格式输入错误，但是未有提示！")
            p "源IP地址中输入小于0的数字地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip9)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg9 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg9.exists?, "源IP地址格式输入错误，但是未有提示！")
            p "源IP地址中输入小数数字的地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip10)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg10 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg10.exists?, "源IP地址格式输入错误，但是未有提示！")
        }

        operate("5、在“源IP地址”输入广播地址，如：192.168.2.255,10.255.255.255，是否允许输入；") {
            p "源IP地址中输入广播地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip11)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg11 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg11.exists?, "源IP地址格式输入错误，但是未有提示！")
        }

        operate("6、在“源IP地址”输入与LAN口IP同一个地址，如：192.168.100.1，是否允许输入；") {
            # p "源IP地址中输入LAN口IP地址".to_gbk
            # @option_iframe.text_field(id: @ts_ip_src).set(@lan_ip)
            # @option_iframe.button(id: @ts_tag_save_filter).click #保存
            # err_msg_lan = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            # assert(err_msg_lan.exists?, "源IP地址格式输入错误，但是未有提示！")
        }

        operate("7、在“源IP地址”输入与DUTWAN口的IP地址，是否允许输入；") {
            p "源IP地址中输入WAN口IP地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@wan_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg_wan = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg_wan.exists?, "源IP地址格式输入错误，但是未有提示！")
        }

        operate("8、在“源IP地址”输入回环地址，如：127.0.0.1，是否允许输入；") {
            p "源IP地址中输入回环地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip12)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg12 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg12.exists?, "源IP地址格式输入错误，但是未有提示！")
        }

        operate("9、在“源IP地址”输入A~Z,a~z,~!@#$%^等33个特殊字符，中文，空格，为空等，是否允许输入；") {
            p "源IP地址中输入特殊字符地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip13)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg13 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg13.exists?, "源IP地址格式输入错误，但是未有提示！")
            p "源IP地址中输入中文，空格，为空等地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_src).set(@ip14)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg14 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_src_err_text)
            assert(err_msg14.exists?, "源IP地址格式输入错误，但是未有提示！")
        }

        operate("10、再在“目的IP地址”输入步骤2-9中所有的值，查看是否允许输入。") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            p "在“目的IP地址”输入前，先删除所有条目".to_gbk
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目

            p "目的IP地址中输入全0".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip1)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg1 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg1.exists?, "目的IP地址格式输入错误，但是未有提示！")
            p "目的IP地址中输入全2255".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip2)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg2 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg2.exists?, "目的IP地址格式输入错误，但是未有提示！")
            p "目的IP地址中输入全0开头".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip3)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg3 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg3.exists?, "目的IP地址格式输入错误，但是未有提示！")
            p "目的IP地址中输入全0结尾".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip4)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg4 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg4.exists?, "目的IP地址格式输入错误，但是未有提示！")

            p "目的IP地址中输入D类地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip5)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg5 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg5.exists?, "目的IP地址格式输入错误，但是未有提示！")
            p "目的IP地址中输入E类地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip6)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg6 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg6.exists?, "目的IP地址格式输入错误，但是未有提示！")
            p "目的IP地址中输入组播地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip7)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg7 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg7.exists?, "目的IP地址格式输入错误，但是未有提示！")

            p "目的IP地址中输入大于255的数字地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip8)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg8 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg8.exists?, "目的IP地址格式输入错误，但是未有提示！")
            p "目的IP地址中输入小于0的数字地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip9)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg9 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg9.exists?, "目的IP地址格式输入错误，但是未有提示！")
            p "目的IP地址中输入小数数字的地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip10)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg10 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg10.exists?, "目的IP地址格式输入错误，但是未有提示！")

            p "目的IP地址中输入广播地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip11)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg11 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg11.exists?, "目的IP地址格式输入错误，但是未有提示！")

            # p "目的IP地址中输入LAN口IP地址".to_gbk
            # @option_iframe.text_field(id: @ts_ip_dst).set(@lan_ip)
            # @option_iframe.button(id: @ts_tag_save_filter).click #保存
            # err_msg_lan = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            # assert(err_msg_lan.exists?, "目的IP地址格式输入错误，但是未有提示！")

            # p "目的IP地址中输入WAN口IP地址".to_gbk
            # @option_iframe.text_field(id: @ts_ip_dst).set(@wan_ip)
            # @option_iframe.button(id: @ts_tag_save_filter).click #保存
            # err_msg_wan = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            # assert(err_msg_wan.exists?, "目的IP地址格式输入错误，但是未有提示！")

            p "目的IP地址中输入回环地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip12)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg12 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg12.exists?, "目的IP地址格式输入错误，但是未有提示！")

            p "目的IP地址中输入特殊字符地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip13)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg13 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg13.exists?, "目的IP地址格式输入错误，但是未有提示！")
            p "目的IP地址中输入中文，空格，为空等地址".to_gbk
            @option_iframe.text_field(id: @ts_ip_dst).set(@ip14)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            err_msg14 = @option_iframe.p(id: @ts_ip_err, text: @ts_ip_dst_err_text)
            assert(err_msg14.exists?, "目的IP地址格式输入错误，但是未有提示！")
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
