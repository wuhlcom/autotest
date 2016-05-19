#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.8", "level" => "P2", "auto" => "n"}

    def prepare
        require 'net/http'
        DRb.start_service
        @tc_dumpcap_pc2       = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_hint_time         = 2
        @tc_wait_time         = 3
        @tc_net_wait_time     = 90
        @tc_select_type       = "白名单"
        @url                  = "www.baidu.com"
        @tc_intset_list_white = "white"
        @tc_intset_list       = "intset_list"
        @tc_intset_list_cls   = "text"
        @url_arr              = ["www.sohu.com", "www.tudou.com", "www.huanqiu.com", "www.qq.com", "www.ifeng.com", "www.sina.com.cn", "www.weibo.com", "www.mop.com", "www.163.com", "www.hupu.com", "www.tieba.com", "www.bilibili.com", "www.yahoo.com", "www.tmall.com", "www.taobao.com"]
        @url_arr_other        = "www.youku.com"
        @tc_url_warning_text  = "名单最多设置16个!"
        @tc_url_b_save_text   = "设置白名单成功，黑名单失效！"
    end

    def process
        operate("0、获取ssid跟密码") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            @ssid     = wifi_ssid.value
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #选择安全模式
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            @pwd = wifi_pwd.value
            p "ssid->#{@ssid}".to_gbk
            p "pwd->#{@pwd}".to_gbk
        }

        operate("1、先进入到安全设置的防火墙设置界面，开启防火墙总开关和URL过虑开关，保存；") {
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
        }

        operate("2、进入到URL过滤设置页面；") {
            @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_url_set).click
        }

        operate("3、选择白名单，过滤域名添加www.baidu.com,点后面的添加“+”符号，保存；") {
            b_select = @option_iframe.select_list(id: @ts_url_black) #选择白名单
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)
            # @option_iframe.text_field(id: @ts_web_url).set(@url)
            #名单中有则不添加
            url_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            unless url_arr.include?(@url)
                @option_iframe.text_field(id: @ts_web_url).set(@url)
                @option_iframe.link(class_name: @ts_tag_addvir).click
                @option_iframe.button(id: @ts_tag_security_save).click
                url_save_div = @option_iframe.div(class_name: @ts_tag_net_reset, text: @tc_url_b_save_text)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    url_save_div.present?
                }

                urlnew_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
                urlnew_arr = urlnew_str.split("\n")

                sleep @tc_wait_time
                assert(urlnew_arr.include?(@url), "error-->添加关键字#{@tc_tag_select_url}不成功！")
            end
        }

        operate("4、在PC1和PC2上是否可以访问www.baidu.com；") {
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)

            p "PC1对外网#{@url}发送http请求".to_gbk
            response = send_http_request(@url)
            assert(response, "添加#{@url}到白名单过滤规则后，PC1不能访问外网#{@url}".to_gbk)

            p "PC2对外网#{@url}发送http请求".to_gbk
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@url)
            unless response_pc2
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
                sleep @tc_wait_time
                response_pc2 = @tc_dumpcap_pc2.send_http_request(@url)
            end
            assert(response_pc2, "添加#{@url}到白名单过滤规则后，PC2不能访问外网#{@url}".to_gbk)
        }

        operate("5、不断添加URL过滤规则，添加到16个的时候，再次添加，是否有提示信息，已添加的规则和超出数量而未添加成功的规则是否都生效。") {
            url_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
            url_arr = url_str.split("\n")
            @url_arr.each do |url| #添加16个url
                next if url_arr.include?(url)
                @option_iframe.text_field(id: @ts_web_url).set(url)
                @option_iframe.link(class_name: @ts_tag_addvir).click #新增url
                sleep @tc_wait_time
            end
            @option_iframe.text_field(id: @ts_web_url).set(@url_arr_other)
            @option_iframe.link(class_name: @ts_tag_addvir).click #新增17个url
            sleep @tc_hint_time
            url_msg = @option_iframe.div(class_name: @ts_tag_net_reset, text: @tc_url_warning_text)
            assert(url_msg.exists?, "过滤规则超过16后，没有出现提示信息！")
            @option_iframe.button(id: @ts_tag_security_save).click #保存
            url_save_div = @option_iframe.div(class_name: @ts_tag_net_reset, text: @tc_url_b_save_text)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                url_save_div.present?
            }
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            p "验证已添加的规则和超出数量而未添加成功的规则是否都生效".to_gbk
            @url_arr.each_with_index do |url, index|
                p "PC1有线连接验证已添加白名单规则的外网：#{url}".to_gbk
                response = send_http_request(url)
                assert(response, "在添加#{url}到白名单过滤规则后，PC1不能访问外网#{url}".to_gbk)
                p "PC2无线连接验证已添加白名单规则的外网：#{url}".to_gbk
                response_pc2 = @tc_dumpcap_pc2.send_http_request(url)
                unless response_pc2
                    flag = "1"
                    @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                    @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
                    sleep @tc_wait_time
                    response_pc2 = @tc_dumpcap_pc2.send_http_request(@url)
                end
                assert(response_pc2, "在添加#{url}到白名单过滤规则后，PC2不能访问外网#{url}".to_gbk)
                break if index == 14 #不打印最后一行“========”
                p "=================================================="
            end
            p "PC1有线连接验证未添加规则的外网：#{@url_arr_other}".to_gbk
            response = send_http_request(@url_arr_other)
            assert(!response, "PC1可以访问未添加白名单规则的外网#{@url_arr_other}".to_gbk)
            p "PC2无线连接验证已添加规则的外网：#{@url_arr_other}".to_gbk
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@url_arr_other)
            assert(!response_pc2, "PC2可以访问未添加白名单规则的外网#{@url_arr_other}".to_gbk)
        }


    end

    def clearup
        operate("恢复默认配置") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time

            p "url删除时有可能会出异常，为了不影响其他脚本执行，该脚本采用直接恢复默认配置的形式".to_gbk
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser) #重新登录
            end
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_op_system).wait_until_present(@tc_wait_time) #进入系统设置
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_tag_recover).wait_until_present(@tc_wait_time) #进入恢复出厂设置
            @option_iframe.link(id: @ts_tag_recover).click
            @option_iframe.button(id: @ts_tag_reset_factory).wait_until_present(@tc_wait_time) #恢复出厂
            @option_iframe.button(id: @ts_tag_reset_factory).click
            @option_iframe.button(class_name: @ts_tag_reboot_confirm).wait_until_present(@tc_wait_time) #确认
            @option_iframe.button(class_name: @ts_tag_reboot_confirm).click
            sleep @tc_net_wait_time
            # p "关闭防火墙总开关和url过滤总开关".to_gbk
            # unless @browser.span(:id => @ts_tag_netset).exists?
            #     login_no_default_ip(@browser) #重新登录
            # end
            # @browser.link(id: @ts_tag_options).click
            # @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            # @option_iframe.link(id: @ts_tag_security).click #进入安全设置
            # @option_iframe.link(id: @ts_tag_fwset).wait_until_present(@tc_wait_time)
            # # @option_iframe.link(id: @ts_tag_fwset).click #防火墙设置
            # switch_flag = false
            # @option_iframe.button(id: @ts_tag_security_sw).wait_until_present(@tc_wait_time)
            # if @option_iframe.button(id: @ts_tag_security_sw).class_name == "on"
            #     @option_iframe.button(id: @ts_tag_security_sw).click
            #     switch_flag = true
            # end
            # if @option_iframe.button(id: @ts_tag_security_url).class_name == "on"
            #     @option_iframe.button(id: @ts_tag_security_url).click
            #     switch_flag = true
            # end
            # if switch_flag
            #     @option_iframe.button(id: @ts_tag_security_save).click #保存
            #     sleep @tc_wait_time
            # end
            # p "删除所有添加规则".to_gbk
            # @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            # @option_iframe.link(id: @ts_url_set).click
            # b_select = @option_iframe.select_list(id: @ts_url_black) #选择白名单
            # b_select.wait_until_present(@tc_wait_time)
            # b_select.select(@tc_select_type)
            # url_str = @option_iframe.div(id: @tc_intset_list_white, class_name: @tc_intset_list).text
            # url_arr = url_str.split("\n")
            # #需要模拟鼠标移动到该条目上(在该条目上做点击操作)，才能实施删除操作
            # begin
            #     unless url_arr.empty?
            #         url_arr.each do |url|
            #             puts "删除黑名单:#{url}".to_gbk
            #             @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
            #             delete_btn = @option_iframe.span(text: url, class_name: @tc_intset_list_cls).parent.link(class_name: "delete")
            #             sleep 1 #延迟1s
            #             for n in 0..3
            #                 if delete_btn.exists?
            #                     delete_btn.click
            #                     break
            #                 end
            #                 @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
            #                 sleep 1 #延迟1s
            #             end
            #             # delete_btn.click
            #             sleep @tc_wait_time
            #         end
            #     end
            # ensure
            #     @option_iframe.button(id: @ts_tag_security_save).click #保存
            #     sleep @tc_wait_time
            # end
        }
    end

}
