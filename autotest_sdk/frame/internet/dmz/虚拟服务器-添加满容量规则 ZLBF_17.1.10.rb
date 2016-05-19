#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_17.1.10", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time   = 5
        @tc_set_time    = 1 #配置下发间隔
        @tc_srv_time    = 5
        @tc_net_time    = 50
        @tc_relogin_time= 80
        @tc_reboot_time = 120
        @tc_pub_port1   = 11001
        @tc_pub_port2   = 11002
        @tc_pub_port3   = 11003
        @tc_pub_port4   = 11004
        @tc_pub_port5   = 11005
        @tc_pub_port6   = 11006

        @tc_srv_port1 = 12001
        @tc_srv_port2 = 12002
        @tc_srv_port3 = 12003
        @tc_srv_port4 = 12004
        @tc_srv_port5 = 12005
        @tc_srv_port6 = 12006

        @tc_error_info = "最多允许6个条目"
    end

    def process

        operate("1、在AP上配置一条PPPoE内置拨号，自动获取IP地址和网关，启用虚拟服务器功能；") {
#与测试点无关这里不做设置
        }

        operate("2、添加一条虚拟服务器的规则,协议选择TCP/UDP,起始端口设置为10000，终止端口设置为10000，服务IP地址设置为PC2地址，保存；") {
            @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_tag_options).click
            @advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@advance_iframe.exists?, "打开高级设置失败")

            #选择‘应用设置’
            application      = @advance_iframe.link(id: @ts_tag_application)
            application_name = application.class_name
            unless application_name == @ts_tag_select_state
                application.click
                sleep @tc_wait_time
            end

            #查询PC IP地址
            ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
            @tc_pc_ip = ip_info[:ip][0]
            puts "pc ip addr:#{@tc_pc_ip}"
            puts "Virtual Server IP #{@tc_pc_ip}"

            #选择“虚拟服务器”标签
            virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
            virtualsrv_state = virtualsrv.parent.class_name
            virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
            sleep @tc_wait_time
            #打开虚拟服务器开关
            @advance_iframe.button(id: @ts_tag_virtualsrv_sw).click if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_off).exists?
            #添加一条单端口映射
            unless @advance_iframe.text_field(name: @ts_tag_virip1).exists?
                @advance_iframe.button(id: @ts_tag_addvir).click
            end
            3.times do #输入多次，防止输入项未输入成功
                @advance_iframe.text_field(name: @ts_tag_virip1).set(@tc_pc_ip)
                @advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_port1)
                @advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_srv_port1)
            end
            sleep @tc_set_time #增加配置下发间隔，以防配置失败
        }

        operate("3、继续添加不同的规则，直到满容量为止；") {
            #添加第二条单端口映射
            unless @advance_iframe.text_field(name: @ts_tag_virip2).exists?
                @advance_iframe.button(id: @ts_tag_addvir).click
            end
            3.times do #输入多次，防止输入项未输入成功
                @advance_iframe.text_field(name: @ts_tag_virip2).set(@tc_pc_ip)
                @advance_iframe.text_field(name: @ts_tag_virpub_port2).set(@tc_pub_port2)
                @advance_iframe.text_field(name: @ts_tag_virpri_port2).set(@tc_srv_port2)
            end
            sleep @tc_set_time #增加配置下发间隔，以防配置失败
            #添加第三条单端口映射
            unless @advance_iframe.text_field(name: @ts_tag_virip3).exists?
                @advance_iframe.button(id: @ts_tag_addvir).click
            end
            3.times do #输入多次，防止输入项未输入成功
                @advance_iframe.text_field(name: @ts_tag_virip3).set(@tc_pc_ip)
                @advance_iframe.text_field(name: @ts_tag_virpub_port3).set(@tc_pub_port3)
                @advance_iframe.text_field(name: @ts_tag_virpri_port3).set(@tc_srv_port3)
            end
            sleep @tc_set_time #增加配置下发间隔，以防配置失败
            #添加第四条单端口映射
            unless @advance_iframe.text_field(name: @ts_tag_virip4).exists?
                @advance_iframe.button(id: @ts_tag_addvir).click
            end
            3.times do #输入多次，防止输入项未输入成功
                @advance_iframe.text_field(name: @ts_tag_virip4).set(@tc_pc_ip)
                @advance_iframe.text_field(name: @ts_tag_virpub_port4).set(@tc_pub_port4)
                @advance_iframe.text_field(name: @ts_tag_virpri_port4).set(@tc_srv_port4)
            end
            sleep @tc_set_time #增加配置下发间隔，以防配置失败
            #添加第五条单端口映射
            unless @advance_iframe.text_field(name: @ts_tag_virip5).exists?
                @advance_iframe.button(id: @ts_tag_addvir).click
            end
            3.times do #输入多次，防止输入项未输入成功
                @advance_iframe.text_field(name: @ts_tag_virip5).set(@tc_pc_ip)
                @advance_iframe.text_field(name: @ts_tag_virpub_port5).set(@tc_pub_port5)
                @advance_iframe.text_field(name: @ts_tag_virpri_port5).set(@tc_srv_port5)
            end
            sleep @tc_set_time #增加配置下发间隔，以防配置失败
            #添加第六条单端口映射
            unless @advance_iframe.text_field(name: @ts_tag_virip6).exists?
                @advance_iframe.button(id: @ts_tag_addvir).click
            end
            3.times do #输入多次，防止输入项未输入成功
                @advance_iframe.text_field(name: @ts_tag_virip6).set(@tc_pc_ip)
                @advance_iframe.text_field(name: @ts_tag_virpub_port6).set(@tc_pub_port6)
                @advance_iframe.text_field(name: @ts_tag_virpri_port6).set(@tc_srv_port6)
            end
            sleep @tc_set_time
            #添加第7条单端口映射
            @advance_iframe.button(id: @ts_tag_addvir).click
            error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
            assert(error_tip.exists?, "弹出错误提示")
            puts "ERROR TIP :#{error_tip.text}".encode("GBK")
            assert_equal(@tc_error_info, error_tip.text, "弹出错误提示")

            #保存已经添加的规则
            puts "保存已经添加规则".encode("GBK")
            @advance_iframe.button(id: @ts_tag_save_btn).click
            sleep @tc_srv_time

            #删除按不连续的顺序删除，按5,2,1,3,4来删除
            #查询路由器port_forward规则，即为路由器虚拟服务器规则
            puts "telnet router"
            init_router_obj(@ts_default_ip, @ts_default_usr, @ts_default_pw)
            puts "query port_forward chain"
            rs = router_nat_port_forward
            assert(rs[:rules].size==12, "规则条数不正确")
            all_srv_configs = rs[:srv_configs]
            puts "telnet router query rules:"
            pp all_srv_configs
            puts "预期配置的规则如下:".encode("GBK")
            p rule1_tcp = "tcp dpt:#{@tc_pub_port1} to:#{@tc_pc_ip}:#{@tc_srv_port1}"
            p rule1_udp = "udp dpt:#{@tc_pub_port1} to:#{@tc_pc_ip}:#{@tc_srv_port1}"
            p rule2_tcp = "tcp dpt:#{@tc_pub_port2} to:#{@tc_pc_ip}:#{@tc_srv_port2}"
            p rule2_udp = "udp dpt:#{@tc_pub_port2} to:#{@tc_pc_ip}:#{@tc_srv_port2}"
            p rule3_tcp = "tcp dpt:#{@tc_pub_port3} to:#{@tc_pc_ip}:#{@tc_srv_port3}"
            p rule3_udp = "udp dpt:#{@tc_pub_port3} to:#{@tc_pc_ip}:#{@tc_srv_port3}"
            p rule4_tcp = "tcp dpt:#{@tc_pub_port4} to:#{@tc_pc_ip}:#{@tc_srv_port4}"
            p rule4_udp = "udp dpt:#{@tc_pub_port4} to:#{@tc_pc_ip}:#{@tc_srv_port4}"
            p rule5_tcp = "tcp dpt:#{@tc_pub_port5} to:#{@tc_pc_ip}:#{@tc_srv_port5}"
            p rule5_udp = "udp dpt:#{@tc_pub_port5} to:#{@tc_pc_ip}:#{@tc_srv_port5}"
            p rule6_tcp = "tcp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
            p rule6_udp = "udp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
            rs_rule1_tcp = all_srv_configs.any? { |item| item=~/#{rule1_tcp}/ }
            rs_rule1_udp = all_srv_configs.any? { |item| item=~/#{rule1_udp}/ }
            assert(rs_rule1_tcp&&rs_rule1_udp, "规则1两条配置异常")

            rs_rule2_tcp = all_srv_configs.any? { |item| item=~/#{rule2_tcp}/ }
            rs_rule2_udp = all_srv_configs.any? { |item| item=~/#{rule2_udp}/ }
            assert(rs_rule2_tcp&&rs_rule2_udp, "规则2两条配置异常")

            rs_rule3_tcp = all_srv_configs.any? { |item| item=~/#{rule3_tcp}/ }
            rs_rule3_udp = all_srv_configs.any? { |item| item=~/#{rule3_udp}/ }
            assert(rs_rule3_tcp&&rs_rule3_udp, "规则3两条配置异常")

            rs_rule4_tcp = all_srv_configs.any? { |item| item=~/#{rule4_tcp}/ }
            rs_rule4_udp = all_srv_configs.any? { |item| item=~/#{rule4_udp}/ }
            assert(rs_rule4_tcp&&rs_rule4_udp, "规则4两条配置异常")

            rs_rule5_tcp = all_srv_configs.any? { |item| item=~/#{rule5_tcp}/ }
            rs_rule5_udp = all_srv_configs.any? { |item| item=~/#{rule5_udp}/ }
            assert(rs_rule5_tcp&&rs_rule5_udp, "规则5两条配置异常")

            rs_rule6_tcp = all_srv_configs.any? { |item| item=~/#{rule6_tcp}/ }
            rs_rule6_udp = all_srv_configs.any? { |item| item=~/#{rule6_udp}/ }
            assert(rs_rule6_tcp&&rs_rule6_udp, "规则6两条配置异常")

            #关闭高级设置
            file_div         = @browser.div(class_name: @ts_tag_file_div)
            zindex_value     = file_div.style(@ts_tag_style_zindex)
            #找到背景根DIV
            background_zindex=(zindex_value.to_i-1).to_s
            background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

            #隐藏共享目录页面根DIV
            @browser.execute_script("$(arguments[0]).hide();", file_div)
            #隐藏背景根DIV
            @browser.execute_script("$(arguments[0]).hide();", background_div)
        }

        operate("4、重启AP查看规则有没有丢失。") {
            @browser.span(id: @ts_tag_reboot).click
            reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
            assert reboot_confirm.exists?, "未提示重启路由器要确认!"
            reboot_confirm.click

            puts "Waitfing for system reboot...."
            sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
            rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
            assert rs, "重启路由器失败未跳转到登录页面!"
            #重新登录路由器
            rs = login_no_default_ip(@browser)
            assert(rs, "重新登录路由器失败!")

            #删除按不连续的顺序删除，按5,2,1,3,4来删除
            #查询路由器port_forward规则，即为路由器虚拟服务器规则
            puts "after reboot telnet router"
            init_router_obj(@ts_default_ip, @ts_default_usr, @ts_default_pw)
            puts "after reboot query port_forward chain"
            rs = router_nat_port_forward
            assert(rs[:rules].size==12, "规则条数不正确")
            all_srv_configs = rs[:srv_configs]
            puts "after reboot telnet router query rules:"
            pp all_srv_configs
            puts "预期配置的规则如下:".encode("GBK")
            p rule1_tcp = "tcp dpt:#{@tc_pub_port1} to:#{@tc_pc_ip}:#{@tc_srv_port1}"
            p rule1_udp = "udp dpt:#{@tc_pub_port1} to:#{@tc_pc_ip}:#{@tc_srv_port1}"
            p rule2_tcp = "tcp dpt:#{@tc_pub_port2} to:#{@tc_pc_ip}:#{@tc_srv_port2}"
            p rule2_udp = "udp dpt:#{@tc_pub_port2} to:#{@tc_pc_ip}:#{@tc_srv_port2}"
            p rule3_tcp = "tcp dpt:#{@tc_pub_port3} to:#{@tc_pc_ip}:#{@tc_srv_port3}"
            p rule3_udp = "udp dpt:#{@tc_pub_port3} to:#{@tc_pc_ip}:#{@tc_srv_port3}"
            p rule4_tcp = "tcp dpt:#{@tc_pub_port4} to:#{@tc_pc_ip}:#{@tc_srv_port4}"
            p rule4_udp = "udp dpt:#{@tc_pub_port4} to:#{@tc_pc_ip}:#{@tc_srv_port4}"
            p rule5_tcp = "tcp dpt:#{@tc_pub_port5} to:#{@tc_pc_ip}:#{@tc_srv_port5}"
            p rule5_udp = "udp dpt:#{@tc_pub_port5} to:#{@tc_pc_ip}:#{@tc_srv_port5}"
            p rule6_tcp = "tcp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
            p rule6_udp = "udp dpt:#{@tc_pub_port6} to:#{@tc_pc_ip}:#{@tc_srv_port6}"
            rs_rule1_tcp = all_srv_configs.any? { |item| item=~/#{rule1_tcp}/ }
            rs_rule1_udp = all_srv_configs.any? { |item| item=~/#{rule1_udp}/ }
            assert(rs_rule1_tcp&&rs_rule1_udp, "规则1两条配置异常")

            rs_rule2_tcp = all_srv_configs.any? { |item| item=~/#{rule2_tcp}/ }
            rs_rule2_udp = all_srv_configs.any? { |item| item=~/#{rule2_udp}/ }
            assert(rs_rule2_tcp&&rs_rule2_udp, "规则2两条配置异常")

            rs_rule3_tcp = all_srv_configs.any? { |item| item=~/#{rule3_tcp}/ }
            rs_rule3_udp = all_srv_configs.any? { |item| item=~/#{rule3_udp}/ }
            assert(rs_rule3_tcp&&rs_rule3_udp, "规则3两条配置异常")

            rs_rule4_tcp = all_srv_configs.any? { |item| item=~/#{rule4_tcp}/ }
            rs_rule4_udp = all_srv_configs.any? { |item| item=~/#{rule4_udp}/ }
            assert(rs_rule4_tcp&&rs_rule4_udp, "规则4两条配置异常")

            rs_rule5_tcp = all_srv_configs.any? { |item| item=~/#{rule5_tcp}/ }
            rs_rule5_udp = all_srv_configs.any? { |item| item=~/#{rule5_udp}/ }
            assert(rs_rule5_tcp&&rs_rule5_udp, "规则5两条配置异常")

            rs_rule6_tcp = all_srv_configs.any? { |item| item=~/#{rule6_tcp}/ }
            rs_rule6_udp = all_srv_configs.any? { |item| item=~/#{rule6_udp}/ }
            assert(rs_rule6_tcp&&rs_rule6_udp, "规则6两条配置异常")
            #断开telnet 连接
            logout_router unless @router.nil?
        }


    end

    def clearup
        operate("1 删除虚拟服务器配置") {
            #断开telnet 连接
            # logout_router unless @router.nil?
            if @browser.link(id: @ts_tag_options).exists?
                @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
                @browser.link(id: @ts_tag_options).click
                @advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
            else
                login_recover(@browser, @ts_default_ip)
                @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
                @browser.link(id: @ts_tag_options).click
                @advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
            end

            #选择‘应用设置’
            application      = @advance_iframe.link(id: @ts_tag_application)
            application_name = application.class_name
            unless application_name == @ts_tag_select_state
                application.click
                sleep @tc_wait_time
            end

            #选择“虚拟服务器”标签
            virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
            virtualsrv_state = virtualsrv.parent.class_name
            virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
            sleep @tc_wait_time
            flag=false
            if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
                #关闭虚拟服务器开关
                @advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
                flag=true
            end
            if @advance_iframe.text_field(name: @ts_tag_virip1).exists?
                #删除端口映射
                @advance_iframe.button(id: @ts_tag_delvir).click
                flag=true
            end
            if flag
                #保存
                @advance_iframe.button(id: @ts_tag_save_btn).click
                sleep @tc_wait_time
            end
        }
    end

}
