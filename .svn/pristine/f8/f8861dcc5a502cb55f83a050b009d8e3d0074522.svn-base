#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.4", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_upload_file_other = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_other/i }
        p "脚本要使用的升级文件是：#{@tc_upload_file_other}".to_gbk
        @tc_errupload_msg = "很抱歉，请重新选择升级包再执行升级操作！"
    end

    def process

        operate("1、WAN接入设置为PPPoE拨号，正确设置PPPoE拨号参数，保存，LAN PC浏览网页是否正常；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
            rs = ping(@ts_web)
            assert(rs, "pppoe拨号失败，PC1无法访问外网!")
        }

        operate("2、登录DUT，进入升级页面；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_options_page(@browser.url)
            @options_page.select_update #进入固件升级页面
            @options_page.set_update_file(@tc_upload_file_other)
            sleep 1
            @options_page.update_btn
            sleep 2
            assert(@options_page.update_err_msg?, "使用错误的升级文件升级时未出现异常提示！")
            assert_equal(@tc_errupload_msg, @options_page.update_err_msg, "使用错误的升级文件升级时，出现的异常提示信息错误！")
        }

        operate("3、在升级页面中，选择其它方案的升级文件,点击升级，查看升级是否成功，PC浏览网页是否正常；") {
            rs = ping(@ts_web)
            assert(rs, "异常，在使用错误的升级文件进行升级操作后，PC1无法访问外网！")
        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
