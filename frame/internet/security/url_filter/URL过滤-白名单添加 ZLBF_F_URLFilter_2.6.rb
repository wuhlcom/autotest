#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.8", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2      = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time        = 3
        @tc_url_type_w       = "白名单"
        @tc_tag_url_baidu    = "www.baidu.com"
        @tc_url_arr_17       = "www.youku.com"
        @tc_url_warning_text = "名单最多设置16个!"
        @tc_default_ssid     = "Wireless0"
        @tc_url_arr          = []
        @tc_url_arr << "www.sohu.com"
        @tc_url_arr << "www.tudou.com"
        @tc_url_arr << "www.huanqiu.com"
        @tc_url_arr << "www.qq.com"
        @tc_url_arr << "www.ifeng.com"
        @tc_url_arr << "www.sina.com.cn"
        @tc_url_arr << "www.weibo.com"
        @tc_url_arr << "www.mop.com"
        @tc_url_arr << "www.163.com"
        @tc_url_arr << "www.hupu.com"
        @tc_url_arr << "www.tieba.com"
        @tc_url_arr << "www.bilibili.com"
        @tc_url_arr << "www.tmall.com"
        @tc_url_arr << "www.taobao.com"
        @tc_url_arr << "www.zhihu.com"
    end

    def process
        operate("0、获取ssid跟密码") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            mac_last   = @wifi_page.get_mac_last
            @wifi_page.open_wifi_page(@browser.url)
            @tc_ssid1_name = @wifi_page.ssid1
            puts "当前SSID1名为#{@tc_ssid1_name}".to_gbk
            puts "当前SSID1 加密方式为#{@wifi_page.ssid1_pwmode}".to_gbk
            #判断加密方式是否为WPA,如果不是则设置为WPA
            flag = false
            unless @wifi_page.ssid1_pwmode == @ts_sec_mode_wpa
                @wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                @wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                    = true
            end
            unless @tc_ssid1_name=~/#{mac_last}/i
                @tc_ssid1_name   = "#{@tc_ssid1_name}_#{mac_last}"
                @wifi_page.ssid1 = @tc_ssid1_name
                puts "修改SSID1名为#{@tc_ssid1_name}".to_gbk
                flag = true
            end
            @wifi_page.save_wifi_config if flag
            puts "Dut ssid: #{@tc_ssid1_name},passwd:#{@ts_default_wlan_pw}"
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @ts_default_wlan_pw, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败")
        }

        operate("1、先进入到安全设置的防火墙设置界面，开启防火墙总开关和URL过虑开关，保存；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #开启防火墙和URL总开关
        }

        operate("2、进入到URL过滤设置页面；") {
            @options_page.urlfilter_click
        }

        operate("3、选择白名单，过滤域名添加www.baidu.com,点后面的添加“+”符号，保存；") {
            @options_page.select_urlfilter_type(@tc_url_type_w) #选择白名单
            url_text = @options_page.url_text_b_element.text
            unless url_text.include?(@tc_tag_url_baidu) #已添加则不再重复添加
                @options_page.url_filter_input(@tc_tag_url_baidu)
                @options_page.url_filter_save
            end
        }

        operate("4、在PC1和PC2上是否可以访问www.baidu.com；") {
            puts "设置白名单后验证PC1和PC2能否访问外网".to_gbk
            response     = send_http_request(@tc_tag_url_baidu)
            assert(response, "URL过滤失败，#{@tc_tag_url_baidu}已添加到白名单，PC1不能访问外网")
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
            assert(response_pc2, "URL过滤失败，#{@tc_tag_url_baidu}已添加到白名单，PC2不能访问外网")
        }

        operate("5、不断添加URL过滤规则，添加到16个的时候，再次添加，是否有提示信息，已添加的规则和超出数量而未添加成功的规则是否都生效。") {
            @options_page.urlfilter_click #必须再进入url过滤界面，否则无法保存，具体原因未知
            @options_page.select_urlfilter_type(@tc_url_type_w) #选择白名单
            url_text = @options_page.url_text_b_element.text
            @tc_url_arr.each do |url|
                @options_page.url_filter_input(url) unless url_text.include?(url) #已添加则不再重复添加
                sleep 1
            end
            @options_page.url_filter_save
            #添加16条后再次添加一条，是否有提示
            @options_page.url_filter_input(@tc_url_arr_17) unless url_text.include?(@tc_url_arr_17) #已添加则不再重复添加
            assert_equal(@tc_url_warning_text, @options_page.url_items_max, "添加超过16条规则后，系统无提示或者添加规则异常！")

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "验证已添加的16条规则和未添加成功的规则是否都生效".to_gbk
            @tc_url_arr.each_with_index do |url, index|
                p "PC1有线连接验证已添加规则的外网：#{url}".to_gbk
                response = send_http_request(url)
                assert(response, "URL过滤失败，#{url}已添加到白名单，PC1不能访问外网")
                p "PC2无线连接验证已添加规则的外网：#{url}".to_gbk
                response_pc2 = @tc_dumpcap_pc2.send_http_request(url)
                assert(response_pc2, "URL过滤失败，#{url}已添加到白名单，PC2不能访问外网")
                break if index == 15 #不打印最后一行“========”
                p "=================================================="
            end
            p "PC1有线连接验证未添加成功的规则：#{@tc_url_arr_17}".to_gbk
            response = send_http_request(@url_arr_other)
            refute(response, "URL过滤失败，#{@url_arr_other}未添加到白名单，PC1仍能访问外网")
            p "PC2无线连接验证已添加规则的外网：#{@url_arr_other}".to_gbk
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@url_arr_other)
            refute(response_pc2, "URL过滤失败，#{@url_arr_other}未添加到白名单，PC2仍能访问外网")
        }


    end

    def clearup
        operate("1 关闭防火墙总开关和URL过滤开关并删除所有过滤规则") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time

            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.urlfilter_close_sw_del_all_step(@browser.url)
        }
        operate("2 恢复默认ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.open_wifi_page(@browser.url)
            current_ssid   = wifi_page.ssid1
            current_pwmode = wifi_page.ssid1_pwmode
            flag           = false
            unless current_ssid == @tc_default_ssid
                wifi_page.ssid1 = @tc_default_ssid
                flag            = true
            end
            unless current_pwmode == @ts_sec_mode_wpa
                wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                   = true
            end
            wifi_page.save_wifi_config if flag
        }
    end

}
