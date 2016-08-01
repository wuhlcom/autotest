#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.10", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_upload_file_current = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_current/i }
        puts "Current version file:#{@tc_upload_file_current}"

        @tc_upload_file_new = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_new/i }
        puts "New version file:#{@tc_upload_file_new}"
    end

    def process

        operate("1、登录到DUT管理页面，进行到升级页面；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @login_page   = RouterPageObject::LoginPage.new(@browser)
            @status_page  = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            sysversion     = @status_page.get_current_software_ver
            actual_version = @tc_upload_file_current.slice(/V\d+R\d+C\d+/i)
            unless sysversion == actual_version
                assert(false, "本地升级前，当前固件版本不是测试版本！")
            end
            @options_page.update_step(@browser.url, @tc_upload_file_new)
        }

        operate("2、选择一个高版本号的软件，点击升级，查看升级是否成功，升级后版本号是否正确；") {
            rs = @login_page.login_with_exists(@browser.url)
            assert(rs, "跳转到登录页面失败!")
            #重新登录路由器
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            @status_page.open_systatus_page(@browser.url)
            sysversion     = @status_page.get_current_software_ver
            actual_version = @tc_upload_file_new.slice(/V\d+R\d+C\d+/i)
            assert_equal(sysversion, actual_version, "升级失败！")
        }
    end

    def clearup
        operate("1、恢复到当前版本；") {
            @status_page.open_systatus_page(@browser.url)
            sysversion     = @status_page.get_current_software_ver
            actual_version = @tc_upload_file_current.slice(/V\d+R\d+C\d+/i)
            unless sysversion == actual_version
                options_page = RouterPageObject::OptionsPage.new(@browser)
                options_page.update_step(@browser.url, @tc_upload_file_current)
            end
        }
    end

}
