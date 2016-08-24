#
# description:
# 该用例只测试反复重启多次(五次)，每次重启后PPPOE业务正常
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.30", "level" => "P3", "auto" => "n"}

    def prepare
    end

    def process

        operate("1、设置DUT的WAN拨号方式为PPPoE,，DNS为自动获取方式，认证方法设为自动，并填写正确的拨号用户名和密码，提交；") {
            @wan_page   = RouterPageObject::WanPage.new(@browser)
            @sys_page   = RouterPageObject::SystatusPage.new(@browser)
            @main_page  = RouterPageObject::MainPage.new(@browser)
            @login_page = RouterPageObject::LoginPage.new(@browser)
            puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("2、查看DUT是否拨号成功；") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            @sys_page.open_systatus_page(@browser.url)
            wan_addr = @sys_page.get_wan_ip
            wan_type = @sys_page.get_wan_type
            assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

            rs = ping(@ts_web)
            assert(rs, "PPPOE方式路由器无法连接外网")
        }

        operate("4、软件重启DUT 5次，查看DUT拨号是否成功，DUT是否出现异常。") {
            5.times do |i|
                puts "第#{i+1}次重启路由器".encode("GBK")
                @browser.refresh
                @main_page.reboot
                rs = @login_page.login_with_exists(@browser.url)
                assert rs, "重启路由器失败未跳转到登录页面!"
                #重新登录路由器
                rs_login = login_no_default_ip(@browser) #重新登录
                assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")

                @sys_page.open_systatus_page(@browser.url)
                wan_addr = @sys_page.get_wan_ip
                wan_type = @sys_page.get_wan_type
                puts "重启后接入类型为#{wan_type}".encode("GBK")
                assert_match @ip_regxp, wan_addr, '重启后PPPOE获取ip地址失败！'
                assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '重启后接入类型错误！'

                rs = ping(@ts_web)
                assert(rs, "重启后PPPOE方式路由器无法连接外网")
            end
        }


    end

    def clearup

        operate("1 恢复默认DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
