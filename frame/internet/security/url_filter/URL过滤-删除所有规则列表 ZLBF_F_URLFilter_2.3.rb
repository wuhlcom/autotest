#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.6", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_url_type_b = "黑名单"
        @tc_url_arr    = []
        @tc_url_arr << "www.sohu.com"
        @tc_url_arr << "www.tudou.com"
        @tc_url_arr << "www.huanqiu.com"
        @tc_url_arr << "www.qq.com"
        @tc_url_arr << "www.ifeng.com"
    end

    def process

        operate("1、登录到URL过滤设置页面；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #开启防火墙和URL总开关
        }

        operate("2、在黑名单中添加3条以上URL过滤规则，保存配置；") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_b) #选择黑名单
            url_text = @options_page.url_text_b_element.text
            @tc_url_arr.each do |url|
                @options_page.url_filter_input(url) unless url_text.include?(url) #已添加则不再重复添加
                sleep 1
            end
            @options_page.url_filter_save

            p "验证已添加到黑名单的规则是否生效".to_gbk #可能出现保存不成功，所以需要验证一次
            @tc_url_arr.each do |url|
                p "PC1有线连接验证已添加规则的外网：#{url}".to_gbk
                response = send_http_request(url)
                refute(response, "URL过滤失败，#{url}已添加到黑名单，PC1仍能访问外网")
            end
        }

        operate("3、清除URL过滤列表，保存，是否删除所有的URL过滤规则。") {
            @options_page.urlfilter_click #产品问题，进行多次保存时必须重新进入url界面
            @options_page.urlfilter_del_all #删除列表中所有规则
            url_text = @options_page.url_text_b_element.text
            assert(url_text.empty?, "过滤列表删除规则失败！")
            p "删除过滤列表中所有规则后再次访问外网".to_gbk
            @tc_url_arr.each do |url|
                p "PC1有线连接访问外网：#{url}".to_gbk
                response = send_http_request(url)
                assert(response, "URL过滤失败，未添加#{url}到黑名单，但是PC1无法访问！")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

    def clearup
        operate("1 关闭防火墙总开关和URL过滤开关并删除所有过滤规则") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.urlfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
