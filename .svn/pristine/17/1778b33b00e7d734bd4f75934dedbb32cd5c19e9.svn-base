#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.20", "level" => "P2", "auto" => "n"}

    def prepare
        @dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }

        operate("2、进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，在IP过虑界面添加规则，添加一条IP过滤，设置源IP为192.168.100.100，端口为5000，协议为TCP，保存配置；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "on", "off", "off")
            @options_page.ipfilter_click
            @options_page.ip_add_item_element.click
            @options_page.ip_filter_src_ip_input(@dut_ip, @dut_ip)
            @options_page.ip_filter_save
        }

        operate("3、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，端口为5000，源IP地址为:192.168.100.100，PC2上是否能抓到PC1上发出的数据包；") {
            response = send_http_request(@ts_web)
            refute(response, "IP过滤失败，有线客户端ip已被过滤，但仍可以访问外网")
        }

        operate("4、编辑步骤2，删除过滤规则，保存；") {
            @options_page.ip_all_del_element.click
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("5、重复步骤3，查看测试结果；") {
            response = send_http_request(@ts_web)
            assert(response, "IP过滤失败，未添加任何过滤规则，有线客户端不能访问外网~")
        }

        operate("6、重启DUT，重复步骤3，查看测试结果。") {
            @options_page.refresh
            sleep 2
            @options_page.reboot
            login_ui    = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "重启后未跳转到登录界面~")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

            puts "重启后验证测试结果".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "验证失败，未添加任何过滤规则，重启后有线客户端不能访问外网~")
        }
    end

    def clearup
        operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
