#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.12", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dst_port_begin = "1"
        @tc_dst_port_end   = "65535"
        @dut_ip            = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置。再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "on", "off", "off")
        }

        operate("2、添加一条过滤规则，其它设置为默认，目的端口设置为1-65535，协议为TCP/UDP，保存配置。") {
            @options_page.ipfilter_click
            @options_page.ip_add_item_element.click
            @options_page.ip_filter_src_ip_input(@dut_ip)
            @options_page.ip_filter_dst_port_input(@tc_dst_port_begin, @tc_dst_port_end)
            @options_page.ip_filter_save
        }

        operate("3、在PC1上用数据包生成器（如：科来数据包生成器，IPTEST）构建，目的端口为1的TCP，UDP的数据包，数据包的IP地址相关信息任意设置，由LAN到WAN发送数据包，PC2上是否能抓到PC1上发出的数据包；") {
            begin
                flag = false
                HtmlTag::TestHttpClient.new(@ts_wan_client_ip).get #默认端口80
            rescue => ex
                flag = true #无法得到http响应
            end
            assert(flag, "在将全部端口过滤掉后，还是能获取http响应！")
        }

        operate("4、重启DUT，执行步骤3，查看测试结果。") {
            @options_page.refresh
            sleep 2
            @options_page.reboot
            login_ui    = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "重启后未跳转到登录界面~")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

            begin
                flag = false
                HtmlTag::TestHttpClient.new(@ts_wan_client_ip).get #默认端口80
            rescue => ex
                flag = true #无法得到http响应
            end
            assert(flag, "在将全部端口过滤掉后，还是能获取http响应！")
        }


    end

    def clearup
        operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
