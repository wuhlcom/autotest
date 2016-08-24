#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.13", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_url_type_b = "黑名单"
        @tc_err_msg    = "名单重复！！"
    end

    def process

        operate("1、登录到URL过滤设置页面；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #开启防火墙和URL总开关
        }

        operate("2、设置黑名单，添加过滤域名添加www.sina.com,是否能添加成功；") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_b) #选择黑名单
            @options_page.url_filter_input(@ts_web) #添加www.baidu.com
            url_text = @options_page.url_text_b_element.text
            assert(url_text.include?(@ts_web), "添加过滤域名#{@ts_web}失败!")
        }

        operate("3、再在黑名单界面中添加过滤域名添加www.sina.com,是否能添加成功；") {
            @options_page.url_filter_input(@ts_web) #添加www.baidu.com
            assert_equal(@tc_err_msg, @options_page.url_err_msg, "重复添加url时，未出现提示！")
        }
    end

    def clearup
        operate("关闭总开关！") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.open_security_setting(@browser.url)
            options_page.firewall_click
            options_page.close_switch
        }
    end

}
