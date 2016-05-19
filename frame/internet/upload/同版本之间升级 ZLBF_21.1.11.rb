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

        operate("1����¼��DUT����ҳ�棬���е�����ҳ�棻") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @login_page   = RouterPageObject::LoginPage.new(@browser)
            @status_page  = RouterPageObject::SystatusPage.new(@browser)
            @options_page.update_step(@browser.url, @tc_upload_file_same)
        }

        operate("2��ѡ��һ��ͬ�汾�ŵ����������������鿴�����Ƿ�ɹ�") {
            rs = @login_page.login_with_exists(@browser.url)
            assert(rs, "��ת����¼ҳ��ʧ��!")
            #���µ�¼·����
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
            @status_page.open_systatus_page(@browser.url)
            sysversion = @status_page.get_current_software_ver
            actual_version  = @tc_upload_file_same.slice(/V\d+R\d+C\d+/i)
            assert_equal(sysversion, actual_version, "����ʧ�ܣ�")
        }
    end

    def clearup
        operate("1���ָ�����ǰ�汾��") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.update_step(@browser.url, @tc_upload_file_current)
        }
    end

}
