#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.19", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
        @tc_port      = 80
        @tc_port_new  = 90
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置；") {
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
        }

        operate("2、进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，在IP过虑界面添加规则，添加一条IP过滤，设置源IP为192.168.100.100，端口为80，协议为TCP，保存配置；") {
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

            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_dst_port).set(@tc_port)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            dst_port   = @option_iframe.table(id: @ts_iptable).trs[1][4].text.slice(/(\d+)-/i, 1).to_i
            if (ip_clauses == 1 || dst_port != @tc_port)
                assert(false, "生成新条目失败")
            end
        }

        operate("3、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，端口为80，源IP地址为：192.168.100.100，PC2上是否能抓到PC1上发出的数据包；") {
            begin
                rs = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip, '/', @ts_wan_pppoe_httpport).get
            rescue => ex
                p "向#{@ts_wan_pppoe_httpip}的#{@ts_wan_pppoe_httpport}端口发送请求时出现异常，因为该端口被过滤所致，rs的返回值为nil".to_gbk
                p "具体异常信息是：#{ex.message}".to_gbk
                assert(false,"发送请求时出现异常")
            end
            assert(rs.nil?, "端口过滤规则无效，#{@ts_wan_pppoe_httpport}端口被过滤后，依然能向该端口发送http请求！")
        }

        operate("4、编辑步骤2，修改过滤规则，修改过滤端口为90，保存；") {
            @option_iframe.table(id: @ts_iptable).trs[1][7].link(class_name: @ts_tag_edit).click #单条目编辑
            @option_iframe.text_field(id: @ts_ip_dst_port1).set(@tc_port_new)
            @option_iframe.button(id: @ts_tag_save_filter1).click #保存
            sleep @tc_wait_time
        }

        operate("5、重复步骤3，查看测试结果；") {
            begin
                rs = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip, '/', @ts_wan_pppoe_httpport).get
            rescue => ex
                p "向#{@ts_wan_pppoe_httpip}的#{@tc_port}端口发送请求时出现异常，可能是该端口被过滤所致".to_gbk
                p "具体异常信息是：#{ex.message}".to_gbk
                assert(false,"发送请求时出现异常")
            end
            assert_match("succeed", rs, "端口过滤规则无效，#{@tc_port_new}端口被过滤后，向#{@tc_port}端口发送http请求时无法获得响应！")
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
