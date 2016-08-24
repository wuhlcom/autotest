#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.5", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time  = 2
        @tc_url_type_b = "黑名单"
        @url_nil       = " "
        @url_num       = "11111ccccc"
        @url_Chinese   = "www.百度.com"
        @tc_err_msg    = "url格式错误"
    end

    def process

        operate("1、登录到URL过滤设置页面；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #开启防火墙和URL总开关
        }

        operate("2、设置为黑名单，添加过滤域名为空，是否能添加成功；") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_b) #选择黑名单
            @options_page.url_filter_input(@url_nil) #添加空值" "
            assert_equal(@tc_err_msg, @options_page.url_err_msg, "添加url为空时，未出现错误提示！")
            sleep @tc_wait_time
        }

        operate("3、设置为黑名单，添加过滤域名为一整串字母数字，不带.，是否能添加成功。例如输入11111,222ccc等；") {
            @options_page.url_filter_input(@url_num) #添加一整串字母数字
            assert_equal(@tc_err_msg, @options_page.url_err_msg, "添加url为一整串字母数字，不带.时，未出现错误提示！")
            sleep @tc_wait_time
        }

        operate("4、设置为黑名单，添加过滤域名为中文汉字，是否能添加成功。例如输入：www.百度.com；") {
            @options_page.url_filter_input(@url_Chinese) #添加中文汉字
            assert_equal(@tc_err_msg, @options_page.url_err_msg, "添加url为中文汉字时，未出现错误提示！")
            sleep @tc_wait_time
        }
    end

    def clearup
        operate("关闭总开关！") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.open_options_page(@browser.url)
            options_page.security_settings #安全设置
            options_page.firewall_click
            options_page.close_switch
        }
    end

}
