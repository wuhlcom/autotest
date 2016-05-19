#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.1", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_current_software = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*current/ }
        @tc_upload_file      = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*new/ }
        @tc_upload_file =~ /(V\d+R\d+C\d+SPC\d+)/
        @tc_upload_vername = Regexp.last_match(1)
        puts "New version file:#{@tc_upload_file}"
        puts "New version name:#{@tc_upload_vername}"
        #默认SSID
        @tc_default_ssid = "WIFI_"+@ts_sub_mac
        puts "Default SSID:#{@tc_default_ssid}"

        #将要设置的SSID
        @tc_ssid = "zhilutest_#{@ts_sub_mac}"
        DRb.start_service
        @wifi         = DRbObject.new_with_uri(@ts_drb_server)
        @tc_wifi_flag = "1"
        @tc_wait_time = 2
        @tc_tag_on    = "ON"
    end

    def process

        operate("1 打开路由器WAN设置,设置PPPOE模式") {
            #首先先查询当前软件版本
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            @tc_current_ver = @status_page.get_current_software_ver
            puts "Current version: #{@tc_current_ver}"

            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("2 修改路由器SSID") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @tc_ssid = rs_wifi[:ssid]
            @tc_pwd = rs_wifi[:pwd]
        }

        operate("3 无线客户端连接路由器") {
            rs = @wifi.connect(@tc_ssid, @tc_wifi_flag, @tc_pwd)
            assert rs, "WIFI连接失败"
            sleep @tc_wait_time #等待无线连接稳定
        }

        operate("4 查看路由器配置信息") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            wifi_on_off  = @status_page.get_wifi_switch
            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@tc_wire_mode}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
            assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI状态不正确!")
        }

        operate("5 验证客户端网络业务") {
            rs1 = @wifi.ping(@ts_web)
            rs2 = ping(@ts_web)
            assert(rs1, "无线客户端无法连接网络")
            assert(rs2, "有线客户端无法连接网络")
        }

        operate("6 升级路由器软件") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.update_step(@browser.url, @tc_upload_file)
            @browser.refresh
            sleep @tc_wait_time
            @login_page = RouterPageObject::LoginPage.new(@browser)
            rs          = @login_page.login_with_exists(@browser.url)
            assert rs, "跳转到登录页面失败!"

            #重新登录路由器
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("7 升级后检查版本信息") {
            @status_page.open_systatus_page(@browser.url)
            @tc_vername_after = @status_page.get_current_software_ver
            puts "After updated, the version name is: #{@tc_vername_after}"
            refute_equal(@tc_current_ver, @tc_vername_after, "升级失败！")
        }

        operate("8 升级后检查配置信息") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            wifi_on_off  = @status_page.get_wifi_switch
            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@tc_wire_mode}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
            assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI状态不正确!")

        }

        operate("9 升级后检查验证客户端业务功能") {
            rs1 = @wifi.ping(@ts_web)
            rs2 = ping(@ts_web)
            assert(rs1, "无线客户端无法连接网络")
            assert(rs2, "有线客户端无法连接网络")
        }

    end

    def clearup

        operate("1 恢复默认版本") {
            @wifi.netsh_disc_all #断开wifi连接
            login_page = RouterPageObject::LoginPage.new(@browser)
            rs         = login_page.login_with_exists(@browser.url)
            if rs
                rs_login = login_no_default_ip(@browser) #重新登录
                assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            end
            status_page = RouterPageObject::SystatusPage.new(@browser)
            status_page.open_systatus_page(@browser.url)
            tc_current_ver = status_page.get_current_software_ver
            puts "The Testing Version #{@tc_current_ver}"
            puts "The cunrret version name is #{tc_current_ver}"
            unless tc_current_ver==@tc_current_ver
                options_page = RouterPageObject::OptionsPage.new(@browser)
                options_page.update_step(@browser.url, @tc_current_software)
                @browser.refresh
                sleep @tc_wait_time
                rs = login_page.login_with_exists(@browser.url)
                if rs
                    #重新登录路由器
                    rs_login = login_no_default_ip(@browser) #重新登录
                    p rs_login[:flag]
                    p rs_login[:message]
                    status_page.open_systatus_page(@browser.url)
                    tc_current_ver = status_page.get_current_software_ver
                    puts "After recover,the version name is #{tc_current_ver}"
                end
            end
        }

        operate("2 路由器配置恢复出厂设置") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.recover_factory(@browser.url)
        }

    end

}
