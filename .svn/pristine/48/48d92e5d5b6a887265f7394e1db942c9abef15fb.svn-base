#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.13", "level" => "P3", "auto" => "n"}

    def prepare
       
        @tc_wpa_pw         = ""
        @tc_flag           = false
        @tc_wifi_time      = 40
    end

    def process

        operate("1、秘钥输入为空，点击保存，是否可以保存成功；") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            @wifi_page.select_2g_basic(@browser.url)
            puts "修改第一个SSID密码为空".to_gbk
            @wifi_page.modify_ssid1_pw(@tc_wpa_pw)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入空密码保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "密码为空不应该保存成功")
            end

            puts "修改第二个SSID密码为空".to_gbk
            @wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid2_pw(@tc_wpa_pw)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入空密码保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "密码为空不应该保存成功")
            end

            puts "修改第三个SSID密码为空".to_gbk
            @wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid3_pw(@tc_wpa_pw)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入空密码保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "密码为空不应该保存成功")
            end

            puts "修改第四个SSID密码为空".to_gbk
            @wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid4_pw(@tc_wpa_pw)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入空密码保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "密码为空不应该保存成功")
            end
        }
    end

    def clearup
        operate("1 恢复默认密码") {
            #错误的密码格式也能保存的话，这里要等待其保存完成
            if @tc_flag
                sleep @tc_wifi_time
            end
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            @wifi_page.select_2g_basic(@browser.url)
            #修改第一个SSID密码
            @wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
            @wifi_page.save_wifi_config
        }
    end

}
