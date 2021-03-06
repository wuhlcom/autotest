#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.11", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_upload_file_current = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_current/i }
        puts "Current version file:#{@tc_upload_file_current}"

        @tc_upload_file_same = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_same/i }
        puts "Same version file:#{@tc_upload_file_same}"
    end

    def process

        operate("1、登录到DUT管理页面，进行到升级页面；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @login_page   = RouterPageObject::LoginPage.new(@browser)
            @status_page  = RouterPageObject::SystatusPage.new(@browser)
            @options_page.update_step(@browser.url, @tc_upload_file_same)
        }

        operate("2、选择一相同版本号的软件，点击升级，查看升级是否成功") {
            rs = @login_page.login_with_exists(@browser.url)
            assert(rs, "跳转到登录页面失败!")
            #重新登录路由器
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            @status_page.open_systatus_page(@browser.url)
            sysversion = @status_page.get_current_software_ver
            actual_version  = @tc_upload_file_same.slice(/V\d+R\d+C\d+/i)
            assert_equal(sysversion, actual_version, "升级失败！")
        }
    end

    def clearup
        operate("1、恢复到当前版本；") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.update_step(@browser.url, @tc_upload_file_current)
        }
    end

}
