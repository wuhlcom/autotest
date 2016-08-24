#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.6", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time         = 3
        @tc_net_wait_time     = 60
        @tc_select_type       = "黑名单"
        @tc_intset_list_black = "black"
        @tc_intset_list       = "intset_list"
        @tc_intset_list_cls   = "text"
        @url_arr              = ["www.sohu.com", "www.tudou.com", "www.huanqiu.com", "www.qq.com", "www.ifeng.com"]
        @tc_url_warning_text  = "名单最多设置16个!"
        @tc_url_b_save_text   = "设置黑名单成功，白名单失效！"
    end

    def process

        operate("1、登录到URL过滤设置页面；") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).click #进入安全设置
            @option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
            # @option_iframe.link(id: @ts_tag_fwset).click #防火墙设置
            switch_flag = false
            @option_iframe.button(id: @ts_tag_security_sw).wait_until_present(@tc_wait_time)
            if @option_iframe.button(id: @ts_tag_security_sw).class_name == "off"
                @option_iframe.button(id: @ts_tag_security_sw).click
                switch_flag = true
            end
            if @option_iframe.button(id: @ts_tag_security_url).class_name == "off"
                @option_iframe.button(id: @ts_tag_security_url).click
                switch_flag = true
            end
            if switch_flag
                @option_iframe.button(id: @ts_tag_security_save).click #保存
                sleep @tc_wait_time
            end
            p "进入到URL过滤设置页面".to_gbk
            @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_url_set).click
        }

        operate("2、在黑名单中添加3条以上URL过滤规则，保存配置；") {
            b_select = @option_iframe.select_list(id: @ts_url_black) #选择黑名单
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)
            url_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            @url_arr.each do |url| #添加5个url
                next if url_arr.include?(url)
                @option_iframe.text_field(id: @ts_web_url).set(url)
                @option_iframe.link(class_name: @ts_tag_addvir).click #新增url
                sleep @tc_wait_time
            end
            @option_iframe.button(id: @ts_tag_security_save).click #保存
            url_save_div = @option_iframe.div(class_name: @ts_tag_net_reset, text: @tc_url_b_save_text)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                url_save_div.present?
            }
            p "验证新增过滤项是否生效".to_gbk  #可能出现保存不成功，所以需要验证一次
            @url_arr.each do |url|
                p "PC1有线连接验证已添加规则的外网：#{url}".to_gbk
                response = send_http_request(url)
                assert(!response, "在添加#{url}到黑名单过滤规则后，PC1还能访问外网#{url}".to_gbk)
            end
        }

        operate("3、清除URL过滤列表，保存，是否删除所有的URL过滤规则。") {
            url_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            p url_arr = url_str.split("\n")
            # assert(url_arr, @url_arr, "添加过滤规则数目不正确！")
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
            @option_iframe.button(id: @ts_tag_security_save).click #保存
            url_save_div = @option_iframe.div(class_name: @ts_tag_net_reset, text: @tc_url_b_save_text)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                url_save_div.present?
            }
            url_str_new = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            url_arr_new = url_str_new.split("\n")
            assert(url_arr_new.empty?, "未完全清除完过滤列表!")
            p "验证清除过滤项是否生效".to_gbk  #可能出现保存不成功，所以需要验证一次
            @url_arr.each do |url|
                p "PC1有线连接验证已清除过滤规则的外网：#{url}".to_gbk
                response = send_http_request(url)
                assert(response, "#{url}未添加到到黑名单过滤规则，但PC1不能访问外网#{url}".to_gbk)
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }


    end

    def clearup
        operate("恢复默认配置") {
            p "关闭防火墙总开关和url过滤总开关".to_gbk
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser) #重新登录
            end
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_security).click #进入安全设置
            @option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
            # @option_iframe.link(id: @ts_tag_fwset).click #防火墙设置
            switch_flag = false
            @option_iframe.button(id: @ts_tag_security_sw).wait_until_present(@tc_wait_time)
            if @option_iframe.button(id: @ts_tag_security_sw).class_name == "on"
                @option_iframe.button(id: @ts_tag_security_sw).click
                switch_flag = true
            end
            if @option_iframe.button(id: @ts_tag_security_url).class_name == "on"
                @option_iframe.button(id: @ts_tag_security_url).click
                switch_flag = true
            end
            if switch_flag
                @option_iframe.button(id: @ts_tag_security_save).click #保存
                sleep @tc_wait_time
            end
            p "删除所有添加规则".to_gbk
            @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_url_set).click
            b_select = @option_iframe.select_list(id: @ts_url_black) #选择黑名单
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)
            url_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            #需要模拟鼠标移动到该条目上(在该条目上做点击操作)，才能实施删除操作
            begin
                unless url_arr.empty?
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
            ensure
                @option_iframe.button(id: @ts_tag_security_save).click #保存
                sleep @tc_wait_time
            end
        }
    end

}
