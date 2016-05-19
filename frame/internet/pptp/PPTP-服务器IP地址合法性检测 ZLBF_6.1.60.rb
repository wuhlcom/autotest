#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.60", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_ip1 = "0.0.0.0"
        @tc_ip2 = "10.0.0.0"
        @tc_ip3 = "239.1.1.1"
        @tc_ip4 = "240.1.1.1"
        @tc_ip5 = "127.0.0.1"
        @tc_ip6 = "192.168.10"
        @tc_ip7 = "192.168.10.256"
        @tc_ip8 = "a.a.a.a"
    end

    def process

        operate("1、选择PPTP拨号方式；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.select_pptp(@browser.url)
        }

        operate("2、在IP地址输入0开头地址、或0结尾地址，如：0.0.0.0，10.0.0.0是否允许输入；") {
            @options_page.pptp_input(@tc_ip1, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
            @options_page.pptp_input(@tc_ip2, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }

        operate("3、IP地址输入组播地址，如239.1.1.1，是否允许输入；") {
            @options_page.pptp_input(@tc_ip3, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }

        operate("4、IP地址输入E类地址，如240.1.1.1，是否允许输入；") {
            @options_page.pptp_input(@tc_ip4, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }

        operate("5、IP地址输入环回地址，即127开头的地址，如127.0.0.1，是否允许输入；") {
            @options_page.pptp_input(@tc_ip5, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }

        operate("6、IP地址输入错误格式地址，如192.168.10，192.168.10.256，a.a.a.a等；") {
            @options_page.pptp_input(@tc_ip6, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
            @options_page.pptp_input(@tc_ip7, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
            @options_page.pptp_input(@tc_ip8, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "允许输入错误地址，且没有错误提示")
        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
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
