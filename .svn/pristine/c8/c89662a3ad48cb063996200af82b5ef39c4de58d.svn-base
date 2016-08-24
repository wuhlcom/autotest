#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.10", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time         = 3
        @tc_select_type       = "白名单"
        @tc_intset_list_white = "white"
        @tc_intset_list       = "intset_list"
        @tc_intset_list_cls   = "text"
        @url_nil              = " "
        @url_num              = "11111ccccc"
        @url_Chinese          = "www.百度.com"
        @url_unusual          = "ww.baidu.com"
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

        operate("2、设置为白名单，添加过滤域名为空，是否能添加成功；") {
            b_select = @option_iframe.select_list(id: @ts_url_black) #选择白名单
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)
            @option_iframe.text_field(id: @ts_web_url).set(@url_nil) #添加空值" "
            @option_iframe.link(class_name: @ts_tag_addvir).click
            sleep @tc_wait_time
            add_present = @option_iframe.span(id: @ts_tag_lanerr, text: @ts_url_add_unusual_text)
            assert(add_present.exists?, "添加域名为空时，未出现提示！")
        }

        operate("3、设置为白名单，添加过滤域名为一整串字母数字，不带.，是否能添加成功。例如输入11111,222ccc等；") {
            @option_iframe.text_field(id: @ts_web_url).set(@url_num) #添加数字
            @option_iframe.link(class_name: @ts_tag_addvir).click
            add_present = @option_iframe.span(id: @ts_tag_lanerr, text: @ts_url_add_unusual_text)
            assert(add_present.exists?, "添加域名为一整串字母数字，不带.时，未出现提示！")
        }

        operate("4、设置为白名单，添加过滤域名为中文汉字，是否能添加成功。例如输入：www.百度.com；") {
            @option_iframe.text_field(id: @ts_web_url).set(@url_Chinese) #添加中文汉字
            @option_iframe.link(class_name: @ts_tag_addvir).click
            add_present = @option_iframe.span(id: @ts_tag_lanerr, text: @ts_url_add_unusual_text)
            assert(add_present.exists?, "添加域名为中文汉字时，未出现提示！")
        }

        operate("5、设置为白名单，添加过滤域名为非正常可用域名，是否能添加成功。例如输入ww.baidu.com;wwww.sina.com。") {
            @option_iframe.text_field(id: @ts_web_url).set(@url_unusual) #添加非正常可用域名
            @option_iframe.link(class_name: @ts_tag_addvir).click
            add_present = @option_iframe.span(id: @ts_tag_lanerr, text: @ts_url_add_unusual_text)
            assert(add_present.exists?, "添加域名为非正常可用域名时，未出现提示！")
        }


    end

    def clearup
        operate("删除所有过滤名单") {
            b_select = @option_iframe.select_list(id: @ts_url_black) #选择白名单
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)
            url_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            unless url_arr.empty? #在添加之前如有过滤名单，先删除之
                url_arr.each do |url|
                    puts "删除黑名单:#{url}".to_gbk
                    @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
                    delete_btn = @option_iframe.span(text: url, class_name: @tc_intset_list_cls).parent.link(class_name: "delete")
                    sleep 1 #延迟1s
                    for n in 0..3
                        if delete_btn.exists?
                            delete_btn.click
                            break
                        end
                        @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
                        sleep 1 #延迟1s
                    end
                    # delete_btn.click
                    sleep @tc_wait_time
                end
            end
        }
    end

}
