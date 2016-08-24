#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_30.1.6", "level" => "P1", "auto" => "n"}

    def prepare
        # @dut_ip              = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
        @tc_dumpcap_server   = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_wait_time        = 3
        @tc_remote_wait_time = 10
        @tc_net_time         = 50
    end

    def process

        operate("1、DUT启动，设置WAN接入类型为DHCP，（假设获取到的地址为10.10.0.100）；") {
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

            #获取wan口哦IP
            @browser.span(id: @tag_status).wait_until_present(@tc_wait_time)
            @browser.span(id: @tag_status).click
            @state_iframe = @browser.iframe(src: @tag_status_iframe_src)
            assert(@state_iframe.exists?, "打开状态设置失败！")
            @wan_ip = @state_iframe.b(id: @tag_wan_ip).parent.text.slice(/IP\u5730\u5740\n(\d+\.\d+\.\d+\.\d+)/i, 1)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、启用远程访问管理功能，访问权限设置为任何人，端口为默认值，查看页面显示的远程管理地址信息是否准确；") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_op_system).click #系统设置
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click #远程管理
            remote_sw = @option_iframe.span(class_name: @ts_remote_sw)
            if remote_sw.button.class_name == "off"
                remote_sw.button.click
                @option_iframe.button(id: @ts_remote_save_btn).click
                sleep @tc_remote_wait_time
            end
            @remote_default_port = @option_iframe.text_field(id: @ts_remote_port_id, name: @ts_remote_port_name).value
            assert(@remote_default_port, "默认端口值异常！")
        }

        operate("3、PC2通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面；") {
            #发送http请求
            remote_html = @tc_dumpcap_server.http_client(@wan_ip, "/", @remote_default_port)
            assert(remote_html.include?("html"), "设置远程访问端口后，在外网不能访问管理页面!")
        }

        operate("4、修改WAN接入方式为PPPOE，静态接入，PPTP，L2TP，重复步骤2。") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            #设置wan连接方式为网线连接
            rs1        = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(id: @ts_tag_wired_mode_span).click #网线连接
            end
            @wan_iframe.radio(id: @ts_tag_wired_pppoe).click #pppoe接入
            @wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
            @wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
            @wan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_net_time
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #获取wan口哦IP
            @browser.span(id: @tag_status).wait_until_present(@tc_wait_time)
            @browser.span(id: @tag_status).click
            @state_iframe = @browser.iframe(src: @tag_status_iframe_src)
            assert(@state_iframe.exists?, "打开状态设置失败！")
            @wan_ip = @state_iframe.b(id: @tag_wan_ip).parent.text.slice(/IP\u5730\u5740\n(\d+\.\d+\.\d+\.\d+)/i, 1)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_op_system).click #系统设置
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click #远程管理
            remote_sw = @option_iframe.span(class_name: @ts_remote_sw)
            if remote_sw.button.class_name == "off"
                remote_sw.button.click
                @option_iframe.button(id: @ts_remote_save_btn).click
                sleep @tc_remote_wait_time
            end
            @remote_default_port = @option_iframe.text_field(id: @ts_remote_port_id, name: @ts_remote_port_name).value
            assert(@remote_default_port, "默认端口值异常！")

            #发送http请求
            remote_html = @tc_dumpcap_server.http_client(@wan_ip, "/", @remote_default_port)
            assert(remote_html.include?("html"), "设置远程访问端口后，在外网不能访问管理页面!")
        }


    end

    def clearup
        operate("1,关闭远程访问功能") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_op_system).click #系统设置
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click #远程管理
            remote_sw = @option_iframe.span(class_name: @ts_remote_sw)
            if remote_sw.button.class_name == "on"
                remote_sw.button.click
                @option_iframe.button(id: @ts_remote_save_btn).click
                sleep @tc_remote_wait_time
            end
        }

        operate("恢复默认DHCP接入") {
            if !@wan_iframe.exists? && @browser.span(:id => @ts_tag_netset).exists?
                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
                @browser.span(:id => @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            end

            flag = false
            #设置wan连接方式为网线连接
            rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
            unless rs1.class_name =~/ #{@tc_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
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
                puts "Waiting for net reset..."
                sleep @tc_net_time
            end
        }
    end

}
