#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.21", "level" => "P1", "auto" => "n"}

    def prepare
        DRb.start_service
        @wifi              = DRbObject.new_with_uri(@ts_drb_server)
        @tc_wait_time      = 3
        @tc_wifi_flag      = "1"
        @tc_channel_change = 60

        @tc_default_ssid = "Wireless0"
        puts "Default SSID:#{@tc_default_ssid}"
        @tc_channel_value_arr =[]
        @tc_channel_arr       =[]

        "1".upto("13") do |channel|
            frequance        = (2407+5*channel.to_i)
            frequance_channel="#{frequance}MHz(Channel #{channel})"
            @tc_channel_value_arr<<channel
            @tc_channel_arr<<frequance_channel
        end
        print "信道列表:\n#{@tc_channel_arr.join("\n")}\n".to_gbk
        @tc_default_channel = "自动选择"

    end

    def process

        operate("1 打开网络连接设置") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
        }

        operate("2 修改WIFI SSID") {
            rs_wifi        = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @tc_ssid1_name = rs_wifi[:ssid]
        }

        operate("3 无线网卡连接路由器") {
            rs = @wifi.connect(@tc_ssid1_name, @tc_wifi_flag, @ts_default_wlan_pw)
            assert rs, "WIFI连接失败"
            sleep 10 #等待无线连接稳定
        }

        operate("4  修改信道") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @tc_channel_arr.each_with_index do |channel, index|
                rs_login = @wifi_page.login_with_exists(@browser.url)
                if rs_login
                    rs_login = login_no_default_ip(@browser) #重新登录
                    assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
                end
                @wifi_page.open_wifi_page(@browser.url)
                puts "路由器设置信道为：#{channel}".to_gbk
                @wifi_page.select_wifi_adv #wifi高级设置
                unless @wifi_page.wifi_channel == channel
                    @wifi_page.wifi_channel = channel
                    @wifi_page.save_wifi_config
                end
                puts "等待信道切换。。。".to_gbk
                sleep @tc_channel_change #等待信道切换
                #查询网卡扫描到的信道
                wifi_itf_info = @wifi.show_interfaces
                wifi_channel  = wifi_itf_info[@ts_wlan_nicname][:channel]
                puts "网卡扫描到信道为:#{wifi_channel}".to_gbk
                assert_equal(@tc_channel_value_arr[index], wifi_channel, "网卡扫描到信道与路由器设置不一致！")
                sleep @tc_wait_time
                rs = @wifi.ping(@ts_default_ip)
                assert(rs, "修改信道后网卡与路由器断开连接！")
            end
        }
    end

    def clearup

        operate("1 恢复默认SSID") {
            @wifi.netsh_disc_all #断开wifi连接
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }

        operate("2 恢复信道为自动信道") {
            if @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
                login_recover(@browser, @ts_default_ip)
            end

            @wifi_page.open_wifi_page(@browser.url)
            @wifi_page.select_wifi_adv #wifi高级设置
            unless @wifi_page.wifi_channel == @tc_default_channel
                puts "恢复为默认信道：#{@tc_default_channel}".to_gbk
                @wifi_page.wifi_channel = @tc_default_channel
                @wifi_page.save_wifi_config
            end
        }

    end

}
