#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_17.1.3", "level" => "P4", "auto" => "n"}

    def prepare

        @tc_normal_port  = 4002
        @tc_pub_srvport  = 9000
        @tc_port_err_tip = "端口范围1-65535"
        DRb.start_service
        @tc_wan_drb     = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_remote_time = 10
    end

    def process

        operate("1、在“端口”输入全-11，0，65536，是否允许输入") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            puts "设置接入方式为DHCP".to_gbk
            @wan_page.set_dhcp(@browser, @browser.url)

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            ip_info       = ipconfig
            @tc_srv_ip    = ip_info[@ts_nicname][:ip][0]
            @options_page.open_vps_step(@browser.url)
            @options_page.add_vps
            p "输入虚拟服务器IP地址为:#{@tc_srv_ip}".encode("GBK")
            port1 = 0
            p "输入公共端口为#{port1}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port1, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
            p "输入私有端口为#{port1}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port1, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")

            port2 = 65536
            p "输入公共端口为#{port2}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port2, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
            p "输入私有端口为#{port2}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port2, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
        }

        operate("2、在“端口”输入A~Z,a~z,~!@#$%^等33个特殊字符，中文，空格，为空等，是否允许输入；") {
            port1 = "a"
            p "输入公共端口为#{port1}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port1, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
            p "输入私有端口为#{port1}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port1, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")

            port2 = "@@@@"
            p "输入公共端口为#{port2}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port2, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
            p "输入私有端口为#{port2}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port2, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")

            port3 = ""
            p "公共端口为空".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port3, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
            p "私有端口为空".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port3, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")

            port4 = "中文"
            p "输入公共端口为#{port4}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, port4, @tc_normal_port, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
            p "输入私有端口为#{port4}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_normal_port, port4, 1)
            @options_page.save_vps
            error_tip = @options_page.vps_error_msg_element
            assert(error_tip.exists?, "未提示输入端口错误")
            error_info=@options_page.vps_error_msg
            assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
        }

        operate("3、输入远程连接的端口，是否允许输入。如果允许输入，需要验证远程连接和虚拟服务器的优先级") {
            p "输入公共端口为#{@tc_pub_srvport}".encode("GBK")
            p "输入私有端口为#{@tc_normal_port}".encode("GBK")
            @options_page.vps_input(@tc_srv_ip, @tc_pub_srvport, @tc_normal_port, 1)
            @options_page.save_vps
            sleep @tc_remote_time
            #查看Wan ip地址
            @sys_page = RouterPageObject::SystatusPage.new(@browser)
            @sys_page.open_systatus_page(@browser.url)
            @tc_wan_ipaddr = @sys_page.get_wan_ip
            puts "WAN状态显示获取的IP地址为：#{@tc_wan_ipaddr}".to_gbk

            #启动tcp_server
            tcp_multi_server(@tc_srv_ip, @tc_normal_port)
            #WAN口用户连接虚拟服务器
            rs      = @tc_wan_drb.tcp_client(@tc_wan_ipaddr, @tc_pub_srvport)
            tcp_msg = rs.tcp_message
            puts "=================Message from TCP server==============="
            print tcp_msg
            assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")

            #设置远程访问WEB,远程连接与虚拟服务器设置为同一端口
            @options_page.open_web_access_btn(@browser.url) #打开外网访问开关
            @options_page.web_access_port_input(@tc_pub_srvport)
            @options_page.save_web_access
            remote_url = "#{@tc_wan_ipaddr}:#{@tc_pub_srvport}"
            puts "Remote Web Login :#{remote_url}"
            rs=@tc_wan_drb.login_router(remote_url, @ts_default_usr, @ts_default_pw)
            assert(rs, "远程WEB访问失败!")

            #远程连接与虚拟服务器设置为同一端口后，连接虚拟服务器失败
            rs      = @tc_wan_drb.tcp_client(@tc_wan_ipaddr, @tc_pub_srvport)
            tcp_msg = rs.tcp_message
            puts "=================Message from TCP server==============="
            print tcp_msg
            refute(rs.tcp_state, "开启远程访问后同端的虚拟服务器应该不能访问")
        }

    end

    def clearup

        operate("1 删除虚拟服务器配置") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.delete_allvps_close_switch_step(@browser.url)
        }
        operate("2 关闭外网访问WEB功能") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.close_web_access(@browser.url)
        }
    end

}
