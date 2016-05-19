#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.18", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time     = 2
        @tc_tag_mod_tip1  = "请输入要检查的网址！"
        @tc_tag_mod_tip2  = "请输入正确的网址，以http开头！如：http://www.zhilu.com"
    end

    def process

        operate("1、外网连接正常，进入高级诊断") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            @diagnose_page = RouterPageObject::DiagnoseAdvPage.new(@browser)
            @diagnose_page.initialize_diagadv(@browser)
            @diagnose_page.switch_page(1) #切换到诊断窗口
        }

        operate("2、输入非http开头的字符，例如直接输入www.baidu.com字符，点击检测") {
            tc_http1 = "www.baidu.com"
            puts "输入URL为#{tc_http1}".encode("GBK")
            @diagnose_page.url_addr = tc_http1
            sleep 1
            @diagnose_page.check
            error_tip_ex = @diagnose_page.diagnoseadv_err?
            error_tip = @diagnose_page.diagnoseadv_err
            assert(error_tip_ex, "未提示输入错误")
            puts "ERROR TIP:#{error_tip}".encode("GBK")
            assert_equal(@tc_tag_mod_tip2, error_tip, "输入URL为#{tc_http1},提示内容错误")
            sleep @tc_wait_time

            tc_http2 = "httptest://www.baidu.com"
            puts "输入URL为#{tc_http2}".encode("GBK")
            @diagnose_page.url_addr = tc_http2
            sleep 1
            @diagnose_page.check
            error_tip_ex = @diagnose_page.diagnoseadv_err?
            error_tip = @diagnose_page.diagnoseadv_err
            assert(error_tip_ex, "未提示输入错误")
            puts "ERROR TIP:#{error_tip}".encode("GBK")
            assert_equal(@tc_tag_mod_tip2, error_tip, "输入URL为#{tc_http2},提示内容错误")
            sleep @tc_wait_time

            tc_http3 = "httpt:www.baidu.com"
            puts "输入URL为#{tc_http3}".encode("GBK")
            @diagnose_page.url_addr = tc_http3
            sleep 1
            @diagnose_page.check
            error_tip_ex = @diagnose_page.diagnoseadv_err?
            error_tip = @diagnose_page.diagnoseadv_err
            assert(error_tip_ex, "未提示输入错误")
            puts "ERROR TIP:#{error_tip}".encode("GBK")
            assert_equal(@tc_tag_mod_tip2, error_tip, "输入URL为#{tc_http3},提示内容错误")
            sleep @tc_wait_time
        }

        operate("3、输入“http://“，后面不输入其他值，点击检测") {
            tc_http = "http://"
            puts "输入URL为#{tc_http}".encode("GBK")
            @diagnose_page.url_addr = tc_http
            sleep 1
            @diagnose_page.check
            error_tip_ex = @diagnose_page.diagnoseadv_err?
            error_tip = @diagnose_page.diagnoseadv_err
            assert(error_tip_ex, "未提示输入错误")
            puts "ERROR TIP:#{error_tip}".encode("GBK")
            assert_equal(@tc_tag_mod_tip2, error_tip, "输入URL为#{tc_http},提示内容错误")
            sleep @tc_wait_time
        }

        operate("4、输入值为空，点击检测") {
            tc_http = ""
            puts "输入URL为空".encode("GBK")
            @diagnose_page.url_addr = tc_http
            sleep 1
            @diagnose_page.check
            error_tip_ex = @diagnose_page.diagnoseadv_err?
            error_tip = @diagnose_page.diagnoseadv_err
            assert(error_tip_ex, "未提示输入错误")
            puts "ERROR TIP:#{error_tip}".encode("GBK")
            assert_equal(@tc_tag_mod_tip1, error_tip, "输入URL内容为空提示内容错误")
        }


    end

    def clearup

    end

}
