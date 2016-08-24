#
#description:
# 这里测试基本状态不包括信道
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.24", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time       = 3
        @tc_ssid1           = "zhilu_autossid1"
        @tc_ssid2           = "zhilu_autossid2"
        @tc_none_value      = "OPEN"
        @tc_tag_on          = "ON"
        @tc_channel_value   = "9"
        @tc_channel         = "2452MHz(Channel 9)"
        @tc_sec_mode_none   = "OPEN"
        @tc_default_ssid    = "Wireless0"
        @tc_default_channel = "自动选择"
    end

    def process

        operate("1 打开网络连接设置") {
            @wifi_page       = RouterPageObject::WIFIPage.new(@browser)
            @status_page     = RouterPageObject::SystatusPage.new(@browser)
            @wifidetail_page = RouterPageObject::WIFIDetail.new(@browser)
        }

        operate("2 修改WIFI加密码方式为#{@tc_sec_mode_none}") {
            @wifi_page.open_wifi_page(@browser.url)
            @tc_ssid1_name = @wifi_page.ssid1
            pwmode         = @wifi_page.ssid1_pwmode
            puts "当前SSID1名为#{@tc_ssid1_name}".to_gbk
            puts "当前SSID1 加密方式为#{pwmode}".to_gbk
            flag = false
            unless pwmode == @tc_sec_mode_none
                puts "修改加密方式为：#{@tc_sec_mode_none}".to_gbk
                @wifi_page.ssid1_pwmode = @tc_sec_mode_none
                flag                    = true
            end
            unless @tc_ssid1_name == @tc_ssid1
                @wifi_page.ssid1 = @tc_ssid1
                puts "修改SSID1名为#{@tc_ssid1}".to_gbk
                flag = true
            end
            @wifi_page.save_wifi_config if flag
        }

        operate("3 修改加密方式为#{@tc_sec_mode_none}后查看无线网络状态") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            wifi_on_off = @status_page.get_wifi_switch
            puts "状态页面显示无线状态为：#{wifi_on_off}".to_gbk
            wifi_channel = @status_page.get_wifi_channel
            puts "状态页面显示无线信道为：#{wifi_channel}".to_gbk

            @wifidetail_page.more_obj #点击更多
            sleep @tc_wait_time
            wifi_ssid = @wifidetail_page.ssid1_name
            puts "状态页面显示无线SSID为：#{wifi_ssid}".to_gbk
            wifi_encryption = @wifidetail_page.ssid1_pwmode
            puts "状态页面显示无线加密方式为：#{wifi_encryption}".to_gbk

            assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI状态不正确!")
            assert_match(/#{@tc_ssid1}$/, wifi_ssid, "SSID显示不正确")
            assert_match(/#{@tc_none_value}$/, wifi_encryption, "加密方式显示错误")
            # assert_match(/\p{Han}+/, wifi_channel, "信道显示错误")
        }

        operate("4 修改WIFI加密码方式为#{@ts_sec_mode_wpa}") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            flag = false
            @wifi_page.open_wifi_page(@browser.url)
            @tc_ssid1_name = @wifi_page.ssid1
            puts "修改SSID1名为#{@tc_ssid2}".to_gbk
            unless @tc_ssid1_name == @tc_ssid2
                @wifi_page.ssid1 = @tc_ssid2
                flag             = true
            end
            puts "修改加密方式为：#{@ts_sec_mode_wpa}".to_gbk
            pwmode = @wifi_page.ssid1_pwmode
            unless pwmode == @ts_sec_mode_wpa
                @wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                @wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                    = true
            end
            @wifi_page.save_wifi_config if flag
        }

        operate("5  修改信道") {
            @browser.refresh
            sleep 1
            @browser.refresh
            puts "修改信道为：#{@tc_channel}".to_gbk
            @wifi_page.open_wifi_page(@browser.url)
            @wifi_page.select_wifi_adv #wifi高级设置
            unless @wifi_page.wifi_channel == @tc_channel
                @wifi_page.wifi_channel = @tc_channel
                @wifi_page.save_wifi_config
            end
        }

        operate("6 修改加密方式为#{@ts_sec_mode_wpa}后查看无线网络状态") {
            @status_page.open_systatus_page(@browser.url)
            wifi_on_off = @status_page.get_wifi_switch
            puts "状态页面显示无线状态为：#{wifi_on_off}".to_gbk
            wifi_channel = @status_page.get_wifi_channel
            puts "状态页面显示无线信道为：#{wifi_channel}".to_gbk

            @wifidetail_page.more_obj #点击更多
            sleep @tc_wait_time
            wifi_ssid = @wifidetail_page.ssid1_name
            puts "状态页面显示无线SSID为：#{wifi_ssid}".to_gbk
            wifi_encryption = @wifidetail_page.ssid1_pwmode
            puts "状态页面显示无线加密方式为：#{wifi_encryption}".to_gbk

            assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI状态不正确!")
            assert_match(/#{@tc_ssid2}$/, wifi_ssid, "SSID显示不正确")
            assert_match(/#{@ts_sec_mode_wpa}$/, wifi_encryption, "加密方式显示错误")
            assert_match(/#{@tc_channel_value}$/, wifi_channel, "信道显示错误")
        }

    end

    def clearup

        operate("1 恢复默认加密方式和默认SSID") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            @wifi_page.open_wifi_page(@browser.url)
            flag  = false
            ssid1 = @wifi_page.ssid1
            unless ssid1 == @tc_default_ssid
                puts "修改SSID为默认SSID：#{@tc_default_ssid}".to_gbk
                @wifi_page.ssid1 = @tc_default_ssid
                flag             = true
            end

            pw_mode = @wifi_page.ssid1_pwmode
            unless pw_mode == @ts_sec_mode_wpa
                puts "修改加密方式为默认加密方式：#{@ts_sec_mode_wpa}".to_gbk
                @wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                @wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                    = true
            end
            @wifi_page.save_wifi_config if flag
        }

        operate("2 恢复默认信道") {
            @browser.refresh
            sleep 1
            @browser.refresh
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
