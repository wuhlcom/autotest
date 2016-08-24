#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_18.1.4", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
    end

    def process

        operate("1、进入DMZ配置页面，配置相关项；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @login_page   = RouterPageObject::LoginPage.new(@browser)
            ip_info       = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
            @pc_ip_addr   = ip_info[:ip][0]
            puts "DMZ Server IP #{@pc_ip_addr}"
            @options_page.set_dmz(@pc_ip_addr, @browser.url)
        }

        operate("2、把DUT复位到出厂默认状态，查看设置页面参数是否恢复成功。") {
            @options_page.recover_factory(@browser.url) #恢复出厂设置
            rs = @login_page.login_with_exists(@browser.url)
            assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
            #重新登录路由器
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

            @options_page.open_options_page(@browser.url)
            @options_page.open_apply_page
            @options_page.open_dmz_page
            dmz_switch_status = @options_page.dmz_switch_status #得到dmz开关状态
            assert_equal("off", dmz_switch_status, "恢复出厂设置后DMZ开关未关闭")
        }


    end

    def clearup
        operate("1 取消DMZ") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_options_page(@browser.url)
            @options_page.open_apply_page
            @options_page.open_dmz_page
            dmz_switch_status = @options_page.dmz_switch_status #得到dmz开关状态
            if dmz_switch_status == "on"
                @options_page.click_dmz_switch
                @options_page.save_dmz
                sleep @tc_wait_time
            end
        }
    end

}
