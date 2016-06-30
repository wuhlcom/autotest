#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.20", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wan_status   = "正常"
        @tc_wan_dial_reg = /[34]G/
    end

    def process

        operate("1、插入3G上网卡，参数配置正确，进行高级诊断") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_3g_auto_dial(@browser.url)
        }

        operate("2、进行高级诊断") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @diagnose_page = RouterPageObject::DiagnoseAdvPage.new(@browser)
            @diagnose_page.initialize_diagadv(@browser)
            @diagnose_page.switch_page(1) #切换到诊断窗口
            @diagnose_page.url_addr = @ts_diag_web
            sleep 1
            @diagnose_page.advdiag(60)

            tc_net_type = @diagnose_page.wan_type
            puts "上网连接类型：#{tc_net_type}".to_gbk
            assert_match(/#{@tc_wan_dial_reg}/, tc_net_type, "上网连接类型错误")
            if @diagnose_page.net_status?
                tc_net_status = @diagnose_page.net_status_element.element.span.text
                puts "WAN口连接状态：#{tc_net_status}".to_gbk
                assert_equal(@tc_wan_status, tc_net_status, "上网连接状态异常")
            end
            tc_net_domain_ip = @diagnose_page.domain_ip_element.element.span.text
            puts "域名：#{@ts_diag_web}，解析为：#{tc_net_domain_ip}".to_gbk
            assert_match(@ts_ip_reg, tc_net_domain_ip, "域名解析失败")
            tc_loss_rate = @diagnose_page.gw_loss_element.element.span.text
            puts "诊断过程丢包率为：#{tc_loss_rate}".to_gbk
            assert_equal(@ts_loss_rate, tc_loss_rate, "诊断过程丢包过多")
            tc_dns_status = @diagnose_page.dns_parse_element.element.span.text
            puts "DNS解析状态：#{tc_dns_status}".to_gbk
            assert_equal(@ts_dns_status, tc_dns_status, "DNS解析失败")
            tc_http_code = @diagnose_page.http_code_element.element.span.text
            puts "HTTP响应码：#{tc_http_code}".to_gbk
            assert_equal(tc_http_code, @ts_http_status, "HTTP响应错误")
        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
            @tc_handles = @browser.driver.window_handles
            if @tc_handles.size > 1
                @browser.driver.switch_to.window(@tc_handles[0])
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
