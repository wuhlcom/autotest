#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.14", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time           = 3
        @tc_rebooting_wait_time = 120
        @tc_src_port            = 1
        @tc_src_port_end        = 65535
        @dut_ip                 = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置。再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
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
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

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
        }

        operate("2、添加一条过滤规则，其它设置为默认，源端口设置为1-65535，协议为TCP/UDP，保存配置。") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src_port).set(@tc_src_port)
            @option_iframe.text_field(id: @ts_ip_src_port_end).set(@tc_src_port_end)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert(false, "生成新条目失败") if ip_clauses == 1
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("3、在PC1上用数据包生成器（如：科来数据包生成器，IPTEST）构建，目的端口为1的TCP，UDP的数据包，数据包的IP地址相关信息任意设置，由LAN到WAN发送数据包，PC2上是否能抓到PC1上发出的数据包；") {
            begin
                rs = HtmlTag::TestUdpClient.new(@dut_ip, 1, "192.168.0.57", 15801)
            rescue => ex
                p ex.message.to_s
                p "发送请求时出现异常".to_gbk
                assert(false,"发送请求时出现异常")
            end
            assert_equal("", rs.udp_message, "端口过滤失败！")
        }

        operate("4、编辑步骤2，数据包生成器更改源端口更改为65535，80，21，1024，60000等数据包，查看测试结果；") {
            begin
                rs = HtmlTag::TestUdpClient.new(@dut_ip, 65535, "192.168.0.57", 15801)
            rescue => ex
                p ex.message.to_s
                p "发送请求时出现异常".to_gbk
                assert(false,"发送请求时出现异常")
            end
            assert_equal("", rs.udp_message, "端口过滤失败！")

            begin
                rs = HtmlTag::TestUdpClient.new(@dut_ip, 1024, @ts_tcp_server, 15801)
            rescue => ex
                p ex.message.to_s
                p "发送请求时出现异常".to_gbk
                assert(false,"发送请求时出现异常")
            end
            assert_equal("", rs.udp_message, "端口过滤失败！")
        }

        operate("5、重启DUT，执行步骤3，查看测试结果。") {
            @browser.span(id: @ts_tag_reboot).parent.click #点击重启按钮
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_rebooting_wait_time
            #重新登录
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "重启成功，再次登录！".to_gbk
                login_no_default_ip(@browser)
                sleep @tc_wait_time #等待配置生效
            else
                assert(login_ui, "重启失败！")
            end

            begin
                rs = HtmlTag::TestUdpClient.new(@dut_ip, 1, "192.168.0.57", 15801)
            rescue => ex
                p ex.message.to_s
                p "发送请求时出现异常".to_gbk
                assert(false,"发送请求时出现异常")
            end
            assert_equal("", rs.udp_message, "端口过滤失败！")
        }


    end

    def clearup
        operate("1、关闭防火墙总开关和IP过滤开关") {
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

        operate("2、删除所有条目") {
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
