#
# description:
# author:liluping
# date:2015-09-21
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.5", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time     = 5
        @tc_tag_url_baidu = 'www.baidu.com'
        @tc_tag_url_yahoo = 'www.yahoo.com'
        @tc_ping_num      = 5
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置；") {
            #连接方式设置为DHCP
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、先进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
        }

        operate("3、添加一条IP过滤规则，设置目的IP为10.10.10.1，端口为1~65535，协议为TCP/UDP，其它不填，保存配置；") {
            require 'socket'
            ns              = Addrinfo.ip(@tc_tag_url_baidu) #查询该url对应的ip
            @destination_ip = ns.ip_address

            rs        = Addrinfo.ip(@tc_tag_url_yahoo) #查询该url对应的ip
            @yahoo_ip = rs.ip_address

            @options_page.ipfilter_click #打开IP过滤页面
            @options_page.ip_add_item_element.click #添加新条目
            @options_page.ip_filter_dst_ip_input(@destination_ip, @destination_ip)
            @options_page.ip_save #保存
            sleep @tc_wait_time
        }

        operate("4、从PC向服务器作ping操作，ping的IP为过滤网段内的地址，然后在服务器查看是否能抓到数据包；") {
            #验证ip是否过滤
            puts "PC1上ping #{@tc_tag_url_baidu}".to_gbk
            rs = ping(@destination_ip, @tc_ping_num)
            refute(rs, "ip过滤失败，#{@destination_ip}添加到过滤规则中还能ping通!")

            puts "PC1上ping #{@tc_tag_url_yahoo}".to_gbk
            rss = ping(@yahoo_ip, @tc_ping_num)
            assert(rss, "ip过滤失败，#{@yahoo_ip}未添加到过滤规则中但不能ping通!")
        }

        operate("7、重启DUT，重复步骤3、4、5，查看测试结果。") {
            @options_page.refresh
            sleep 2
            @options_page.reboot
            login_ui    = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "重启后未跳转到登录页面！")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关

            @options_page.ipfilter_click #打开IP过滤页面
            @options_page.ip_all_del_element.click #添加新条目之前先删除所有的条目
            sleep @tc_wait_time
            @options_page.ip_add_item_element.click #添加新条目
            @options_page.ip_filter_dst_ip_input(@destination_ip, @destination_ip)
            @options_page.ip_save #保存
            sleep @tc_wait_time

            #验证ip是否过滤
            puts "PC1上ping #{@tc_tag_url_baidu}".to_gbk
            rs = ping(@destination_ip, @tc_ping_num)
            refute(rs, "ip过滤失败，#{@destination_ip}添加到过滤规则中还能ping通!")

            puts "PC1上ping #{@tc_tag_url_yahoo}".to_gbk
            rss = ping(@yahoo_ip, @tc_ping_num)
            assert(rss, "ip过滤失败，#{@yahoo_ip}未添加到过滤规则中但不能ping通!")
        }


    end

    def clearup
        operate("恢复默认配置") {
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }

    end

}
