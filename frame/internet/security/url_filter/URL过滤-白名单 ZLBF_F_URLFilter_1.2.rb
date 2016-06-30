#
# description:
# author:liluping
# date:2015-09-16
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.2", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_url_type_w    = "白名单"
        @tc_tag_url_yahoo = 'www.yahoo.com'
        @tc_tag_url_baidu = 'www.baidu.com'
        @tc_tag_url_sina  = 'www.sina.com.cn'
    end

    def process

        operate("1、登陆DUT，WAN接入设置为DHCP方式；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }

        operate("2、先进入到安全设置的防火墙设置界面，开启防火墙总开关和URL过虑开关，保存；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on")
        }

        operate("3、在URL过滤设置界面选择白名单，添加过滤关键字www.yahoo.com,保存；") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_w) #选择白名单
            url_text = @options_page.url_text_w_element.text
            unless url_text.include?(@tc_tag_url_yahoo) #已添加则不再重复添加
                @options_page.url_filter_input(@tc_tag_url_yahoo)
                @options_page.url_filter_save
            end
        }

        operate("4、PC1,PC2是否可以访问www.sina.com.cn，www.yahoo.cn，www.baidu.com等站点；") {
            puts "设置过滤规则后验证是否可访问#{@tc_tag_url_baidu}站点...".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            refute(response, "URL过滤失败，#{@tc_tag_url_baidu}未添加到白名单，但可以访问")

            puts "设置过滤规则后验证是否可访问#{@tc_tag_url_sina}站点...".to_gbk
            response = send_http_request(@tc_tag_url_sina)
            refute(response, "URL过滤失败，#{@tc_tag_url_sina}未添加到白名单，但可以访问")

            puts "设置过滤规则后验证是否可访问#{@tc_tag_url_yahoo}站点...".to_gbk
            response = send_http_request(@tc_tag_url_yahoo)
            assert(response, "URL过滤失败，#{@tc_tag_url_yahoo}添加到白名单后，不可以访问")
        }
    end

    def clearup
        operate("1 关闭防火墙总开关和URL过滤开关并删除所有过滤规则") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.urlfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
