#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.42", "level" => "P4", "auto" => "n"}

    def prepare
        #判断当前下载目录是否有配置文件，如果有则将其重命名
        dl_file_path = Dir.glob(@ts_download_directory+"/*").find { |file|
            file=~/\.tgz/i
        }
        unless dl_file_path.nil?
            puts "删除下载目录中的旧文件:#{dl_file_path}".encode("GBK")
            File.delete(dl_file_path)
        end
    end

    def process

        operate("1、当前为AP为PPPOE拨号，导出配置文件") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pppoe, connect_type, "修改网络连接类型失败！")
            p "导出配置文件".to_gbk
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.export_file_step(@browser, @browser.url)
        }

        operate("2、修改WAN设置为DHCP，然后导入步骤1中的配置文件，导入成功后，查看AP的连接模式") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wan_page.set_dhcp(@browser, @browser.url)
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_dhcp, connect_type, "修改网络连接类型#{@ts_wan_mode_dhcp}失败！")

            p "导入配置文件".to_gbk
            configuration_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/\.tgz/i }
            puts "配置文件绝对路径：#{configuration_file}".encode("GBK")
            @options_page.import_file_step(@browser.url, configuration_file)

            p "查看配置是否恢复！".to_gbk
            @login_page = RouterPageObject::LoginPage.new(@browser)
            login_ui    = @login_page.login_with_exists(@browser.url)
            assert(login_ui, "导入配置系统重启后未跳转到登录界面")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pppoe, connect_type, "导入配置文件后，网络连接类型未恢复为#{@ts_wan_mode_pppoe}类型")
        }

        operate("3、修改WAN设置为静态IP，然后导入步骤1中的配置文件，导入成功后，查看AP的连接模式") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #设置为STATIC拨号
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_static, connect_type, "修改网络连接类型#{@ts_wan_mode_static}失败！")

            p "导入配置文件".to_gbk
            configuration_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/\.tgz/i }
            puts "配置文件绝对路径：#{configuration_file}".encode("GBK")
            @options_page.import_file_step(@browser.url, configuration_file)

            p "查看配置是否恢复！".to_gbk
            login_ui = @login_page.login_with_exists(@browser.url)
            assert(login_ui, "导入配置系统重启后未跳转到登录界面")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pppoe, connect_type, "导入配置文件后，网络连接类型未恢复为#{@ts_wan_mode_pppoe}类型")
        }

        operate("4、修改WAN设置为PPTP拨号，然后导入步骤1中的配置文件，导入成功后，查看AP的连接模式") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #设置为PPTP拨号
            @options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pptp, connect_type, "修改网络连接类型#{@ts_wan_mode_pptp}失败！")

            p "导入配置文件".to_gbk
            configuration_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/\.tgz/i }
            puts "配置文件绝对路径：#{configuration_file}".encode("GBK")
            @options_page.import_file_step(@browser.url, configuration_file)

            p "查看配置是否恢复！".to_gbk
            login_ui = @login_page.login_with_exists(@browser.url)
            assert(login_ui, "导入配置系统重启后未跳转到登录界面")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            @status_page.open_systatus_page(@browser.url)
            connect_type = @status_page.get_wan_type
            assert_equal(@ts_wan_mode_pppoe, connect_type, "导入配置文件后，网络连接类型未恢复为#{@ts_wan_mode_pppoe}类型")
        }


    end

    def clearup
        operate("恢复默认DHCP接入") {
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
