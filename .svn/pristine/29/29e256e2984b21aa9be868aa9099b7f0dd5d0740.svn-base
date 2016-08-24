#
# description:
# 1.
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_30.1.3", "level" => "P2", "auto" => "n"}

    def prepare
        @dut_ip                     = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
        @tc_dumpcap_server          = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_wait_time               = 3
        @tc_virtual_server_set_time = 5
        @tc_remote_wait_time        = 10
        @tc_private_port            = "80"
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

        operate("2、启用远程访问管理功能，访问权限设置为任何人，端口为默认值") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_op_system).click #系统设置
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click #远程管理
            remote_sw = @option_iframe.span(class_name: @ts_remote_sw)
            if remote_sw.button.class_name == "off"
                remote_sw.button.click
            end
            @option_iframe.button(id: @ts_remote_save_btn).click
            sleep @tc_remote_wait_time
            @remote_default_port = @option_iframe.text_field(id: @ts_remote_port_id, name: @ts_remote_port_name).value
            assert(@remote_default_port, "默认端口值异常！")
        }

        operate("3、PC2通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面；") {
            #开启http服务
            http_server(@dut_ip)
            #发送http请求
            remote_html = @tc_dumpcap_server.http_client(@wan_ip, "/", @remote_default_port)
            assert(remote_html.include?("html"), "设置远程访问端口后，在外网不能访问管理页面!")
        }

        operate("4、启用虚拟服务器功能，添加规则，转发端口设置为2000-3000，保存配置；") {
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_virtualsrv).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_virtualsrv).click
            virtual_server_sw = @option_iframe.button(id: @ts_tag_virtualsrv_sw)
            if virtual_server_sw.class_name == "off"
                virtual_server_sw.click
            end
            @option_iframe.button(id: @ts_tag_addvir).click
            @option_iframe.text_field(name: @ts_tag_virip1).set(@dut_ip)
            @option_iframe.text_field(name: @ts_tag_virpub_port1).set(@remote_default_port)
            @option_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_private_port)
            @option_iframe.button(id: @ts_tag_save_btn).click
            sleep @tc_virtual_server_set_time

            remote_html = @tc_dumpcap_server.http_client(@wan_ip, "/", @remote_default_port)
            assert(remote_html.include?("html"), "开启远程访问端口和虚拟服务器后，访问优先级错误，远程访问端口优先级应该大于虚拟服务器端口")
        }

        operate("5、修改远程访问管理端口为2000-3000之间的任意端口，是否能设置成功；") {
            @option_iframe.link(id: @ts_tag_op_system).click #系统设置
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click #远程管理
            remote_sw = @option_iframe.span(class_name: @ts_remote_sw)
            if remote_sw.button.class_name == "on"
                remote_sw.button.click
            end
            @option_iframe.button(id: @ts_remote_save_btn).click
            sleep @tc_remote_wait_time

            remote_html = @tc_dumpcap_server.http_client(@wan_ip, "/", @remote_default_port)
            assert(remote_html.include?("succeed"), "关闭远程访问端口之后，虚拟服务器端口连接异常")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }



    end

    def clearup

        operate("1,关闭远程访问功能"){
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_op_system).click #系统设置
            @option_iframe.link(id: @ts_tag_op_remote).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_remote).click #远程管理
            remote_sw = @option_iframe.span(class_name: @ts_remote_sw)
            if remote_sw.button.class_name == "on"
                remote_sw.button.click
            end
            @option_iframe.button(id: @ts_remote_save_btn).click
            sleep @tc_remote_wait_time
        }

        operate("2,删除虚拟服务器配置"){
            @option_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_application).click
            @option_iframe.link(id: @ts_tag_virtualsrv).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_virtualsrv).click
            virtual_server_sw = @option_iframe.button(id: @ts_tag_virtualsrv_sw)
            if virtual_server_sw.class_name == "on"
                virtual_server_sw.click
            end
            @option_iframe.button(id: @ts_tag_delvir).click
            sleep @tc_wait_time
            @option_iframe.button(id: @ts_tag_save_btn).click
            sleep @tc_virtual_server_set_time
        }
    end

}
