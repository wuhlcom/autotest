#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.1", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_lan_ip     = "192.168.22.1"

    end

    def process

        operate("1 打开外网连接设置") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
        }

        operate("2 设置外网连接方式") {

        }
        operate("3 设置外网DHCP接入") {
            @wan_page.set_dhcp(@browser, @browser.url)
        }
        operate("4 查看WAN状态") {
            #关闭WAN设置
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page    = RouterPageObject::SystatusPage.new(@browser)
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns

            assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
            assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'dhcp获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'dhcp获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'dhcp获取dns ip地址失败！'
        }

        operate("5 验证业务") {
            rs = ping(@ts_web)
            assert(rs, '无法连接网络')
        }

        operate("6 打开内网设置") {
            @lan_page = RouterPageObject::LanPage.new(@browser)
        }

        operate("7 修改lan ip") {
            @lan_page.lan_ip_config(@tc_lan_ip, @browser.url)
            @login_page = RouterPageObject::LoginPage.new(@browser)
            login_ui    = @login_page.login_with_exists(@browser.url)
            assert(login_ui, "重启后未跳转到登录页面！")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("8 修改lan设置后重新验证业务") {
            rs1 = ping(@tc_lan_ip)
            assert(rs1, '路由器无法登录')
            rs2 = ping(@web)
            assert(rs2, '无法连接网络')
        }

    end

    def clearup

        operate("1 恢复路由器默认配置") {
            rs1 = ping(@ts_default_ip)
            if rs1 == true
                puts "路由器已是默认配置".to_gbk
            else
                options_page = RouterPageObject::OptionsPage.new(@browser)
                options_page.recover_factory(@browser.url)

                ## 采用命令方式回复出厂设置，防止路由器登录失败以至无法恢复默认配置
                # lan_ip = ipconfig[@ts_nicname][:gateway][0]
                # telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
                # exp_ralink_init
            end
        }

    end

}