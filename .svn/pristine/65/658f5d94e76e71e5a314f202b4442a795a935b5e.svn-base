#
# description:
# author:liluping
# date:2015-11-2 11:09:38
# modify:
#
testcase {
    attr = {"id" => "ZLBF_11.1.12", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wifi_time      = 40
        @tc_wifi_pw1       = "zhilu 2031"
        @tc_wifi_pw2       = " zhilu2031"
        @tc_wifi_pw3       = "zhilu2031 "
    end

    def process

        operate("1、秘钥输入#{@tc_wifi_pw1}，是否可以输入成功，STA是否可以连接成功；") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            @wifi_page.open_wifi_page(@browser.url)
            @wifi_page.select_2g_set
            puts "修改第一个SSID密码为#{@tc_wifi_pw1}".to_gbk
            @wifi_page.modify_ssid1_pw(@tc_wifi_pw1)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw1}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw1}保存后出现异常")
            end

            puts "修改第二个SSID密码为#{@tc_wifi_pw1}".to_gbk
            @wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid2_pw(@tc_wifi_pw1)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw1}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw1}保存后出现异常")
            end

            puts "修改第三个SSID密码为#{@tc_wifi_pw1}".to_gbk
            @wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid3_pw(@tc_wifi_pw1)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw1}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw1}保存后出现异常")
            end

            puts "修改第四个SSID密码为#{@tc_wifi_pw1}".to_gbk
            @wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid4_pw(@tc_wifi_pw1)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw1}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw1}保存后出现异常")
            end
        }

        operate("2、秘钥输入#{@tc_wifi_pw2}，也就是密钥的第一位是空格，是否可以输入成功，STA是否可以连接成功；") {
            puts "修改第一个SSID密码为'#{@tc_wifi_pw2}'".to_gbk
            @wifi_page.modify_ssid1_pw(@tc_wifi_pw2)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw2}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw2}保存后出现异常")
            end

            puts "修改第二个SSID密码为'#{@tc_wifi_pw2}'".to_gbk
            @wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid2_pw(@tc_wifi_pw2)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw2}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw2}保存后出现异常")
            end

            puts "修改第三个SSID密码为'#{@tc_wifi_pw2}'".to_gbk
            @wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid3_pw(@tc_wifi_pw2)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw2}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw2}保存后出现异常")
            end

            puts "修改第四个SSID密码为'#{@tc_wifi_pw2}'".to_gbk
            @wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid4_pw(@tc_wifi_pw2)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw2}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw2}保存后出现异常")
            end
        }

        operate("3、秘钥输入#{@tc_wifi_pw3}，也就是密钥的最后一位是空格，是否可以输入成功，STA是否可以连接成功；") {
            puts "修改第一个SSID密码为'#{@tc_wifi_pw3}'".to_gbk
            @wifi_page.modify_ssid1_pw(@tc_wifi_pw3)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw3}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw3}保存后出现异常")
            end

            puts "修改第二个SSID密码为'#{@tc_wifi_pw3}'".to_gbk
            @wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid2_pw(@tc_wifi_pw3)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw3}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw3}保存后出现异常")
            end

            puts "修改第三个SSID密码为'#{@tc_wifi_pw3}'".to_gbk
            @wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid3_pw(@tc_wifi_pw3)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw3}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw3}保存后出现异常")
            end

            puts "修改第四个SSID密码为'#{@tc_wifi_pw3}'".to_gbk
            @wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid4_pw(@tc_wifi_pw3)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "输入密码#{@tc_wifi_pw3}保存失败，提示:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "输入密码#{@tc_wifi_pw3}保存后出现异常")
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
            @wifi_page.open_wifi_page(@browser.url)
            @wifi_page.select_2g_set
            #修改第一个SSID密码
            @wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
            @wifi_page.save_wifi
            sleep @tc_wifi_time
        }
    end

}
