#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.14", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time         = 3
        @tc_select_type       = "白名单"
        @tc_select_type_value = "white"
        @url                  = "www.baidu.com"
        @url_http             = "http://www.baidu.com"
        @tc_intset_list_white = "white"
        @tc_intset_list       = "intset_list"
    end

    def process

        operate("1、登录到URL过滤设置页面；") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).click #进入安全设置
            @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_url_set).click
        }

        operate("2、设置白名单，添加过滤域名添加www.sina.com,是否能添加成功；") {
            b_select = @option_iframe.select_list(id: @ts_url_black) #选择白名单
            b_select.wait_until_present(@tc_wait_time)
            b_select.select_value(@tc_select_type_value)

            @option_iframe.text_field(id: @ts_web_url).set(@url) #添加www.sina.com.cn
            @option_iframe.link(class_name: @ts_tag_addvir).click
            urlnew_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
            urlnew_arr = urlnew_str.split("\n")
            assert(urlnew_arr.include?(@url), "添加过滤域名#{@url}失败!")
        }

        operate("3、再在白名单界面中添加过滤域名添加www.sina.com,是否能添加成功；") {
            @option_iframe.text_field(id: @ts_web_url).set(@url) #添加www.sina.com.cn
            @option_iframe.link(class_name: @ts_tag_addvir).click
            add_present = @option_iframe.div(class_name: @ts_url_add, text: @ts_url_add_text)
            assert(add_present.exists?, "添加相同过滤域名时，未出现提示！")
        }

        # operate("4、再在白名单界面中添加过滤域名添加http://www.sina.com,是否能添加成功。") {
        #     @option_iframe.text_field(id: @ts_web_url).set(@url_http) #添加http://www.sina.com.cn
        #     @option_iframe.link(class_name: @ts_tag_addvir).click
        #     add_present = @option_iframe.div(class_name: @ts_url_add, text: @ts_url_add_text)
        #     assert(add_present.exists?, "添加带有http前缀域名时，未出现提示！")
        # }


    end

    def clearup

    end

}
