#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.14", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_url_type_w = "白名单"
        @url           = "www.baidu.com"
        @tc_err_msg    = "名单重复！！"
    end

    def process

        operate("1、登录到URL过滤设置页面；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #开启防火墙和URL总开关
        }

        operate("2、设置白名单，添加过滤域名添加www.sina.com,是否能添加成功；") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_w) #选择白名单
            @options_page.url_filter_input(@url) #添加www.baidu.com
            p url_text = @options_page.url_text_w
            assert(url_text.include?(@url), "添加过滤域名#{@url}失败!")
        }

        operate("3、再在白名单界面中添加过滤域名添加www.sina.com,是否能添加成功；") {
            @options_page.url_filter_input(@url) #添加www.baidu.com
            assert_equal(@tc_err_msg, @options_page.url_err_msg, "重复添加url时，未出现提示！")
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
