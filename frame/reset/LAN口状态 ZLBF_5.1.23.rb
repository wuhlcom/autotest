#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.23", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_lan_ip = "192.168.121.1"
    end

    def process

        operate("1 打开状态界面") {
            @status_page = RouterPageObject::SystatusPage.new(@browser)
        }

        operate("2 查看lan状态") {
            @status_page.open_systatus_page(@browser.url)
            rs_mac  = @status_page.get_lan_mac
            rs_ip   = @status_page.get_lan_ip
            rs_mask = @status_page.get_lan_mask

            assert_match(@ts_wan_mac_pattern1, rs_mac, "显示mac地址错误!")
            assert_match(/#{@ts_default_ip}/, rs_ip, "显示ip地址错误!")
            assert_match(/#{@ts_lan_mask}/, rs_mask, "显示mask地址错误!")
        }

        operate("3 修改LAN IP地址") {
            @lan_page = RouterPageObject::LanPage.new(@browser)
            @lan_page.lan_ip_config(@tc_lan_ip, @browser.url)

            @login_page = RouterPageObject::LoginPage.new(@browser)
            rs          = @login_page.login_with_exists(@browser.url)
            assert rs, '跳转到登录页面失败！'
            #重新登录路由器
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("4 修改LAN IP后重新查看LAN状态") {
            @status_page.open_systatus_page(@browser.url)
            rs_mac = @status_page.get_lan_mac
            rs_ip  = @status_page.get_lan_ip
            rs_mask = @status_page.get_lan_mask

            assert_match(@ts_wan_mac_pattern1, rs_mac, "修改设置显示mac地址错误!")
            assert_match(/#{@tc_lan_ip}/, rs_ip, "修改设置显示ip地址错误!")
            assert_match(/#{@ts_lan_mask}/, rs_mask, "修改设置显示mask地址错误!")
        }

    end

    def clearup
        operate("1 恢复Lan默认配置") {
            rs1 = ping(@ts_default_ip)
            if rs1 == true
                puts "路由器已是默认配置".to_gbk
            else
                options_page = RouterPageObject::OptionsPage.new(@browser)
                options_page.recover_factory(@browser.url)

                ##采用命令方式回复出厂设置，防止路由器登录失败以至无法恢复默认配置
                # lan_ip = ipconfig[@ts_nicname][:gateway][0]
                # telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
                # exp_ralink_init
            end
        }
    end

}
