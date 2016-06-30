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

        operate("1����Կ����Ϊ�գ�������棬�Ƿ���Ա���ɹ���") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            @wifi_page.select_2g_basic(@browser.url)
            puts "�޸ĵ�һ��SSID����Ϊ��".to_gbk
            @wifi_page.modify_ssid1_pw(@tc_wpa_pw)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "��������뱣��ʧ�ܣ���ʾ:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "����Ϊ�ղ�Ӧ�ñ���ɹ�")
            end

            puts "�޸ĵڶ���SSID����Ϊ��".to_gbk
            @wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid2_pw(@tc_wpa_pw)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "��������뱣��ʧ�ܣ���ʾ:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "����Ϊ�ղ�Ӧ�ñ���ɹ�")
            end

            puts "�޸ĵ�����SSID����Ϊ��".to_gbk
            @wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid3_pw(@tc_wpa_pw)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "��������뱣��ʧ�ܣ���ʾ:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "����Ϊ�ղ�Ӧ�ñ���ɹ�")
            end

            puts "�޸ĵ��ĸ�SSID����Ϊ��".to_gbk
            @wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid4_pw(@tc_wpa_pw)
            @wifi_page.save_wifi
            error_tip = @wifi_page.wifi_error
            puts "ERROR TIP #{error_tip}".to_gbk
            if error_tip == @ts_wifi_pw_err
                puts "��������뱣��ʧ�ܣ���ʾ:#{error_tip}".to_gbk
            else
                @tc_flag = true
                assert(false, "����Ϊ�ղ�Ӧ�ñ���ɹ�")
            end
        }
    end

    def clearup
        operate("1 �ָ�Ĭ������") {
            #����������ʽҲ�ܱ���Ļ�������Ҫ�ȴ��䱣�����
            if @tc_flag
                sleep @tc_wifi_time
            end
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            @wifi_page.select_2g_basic(@browser.url)
            #�޸ĵ�һ��SSID����
            @wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid2_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid3_pw(@ts_default_wlan_pw)
            @wifi_page.modify_ssid4_pw(@ts_default_wlan_pw)
            @wifi_page.save_wifi_config
        }
    end

}
