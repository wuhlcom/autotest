#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.23.1", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_err_pppoe_usr = 'pppoe@err'
        @tc_err_pppoe_pw  = 'PPPOEPWERR'
    end

    def process

        operate("1、不插入3G上网卡，配置WAN口为PPPOE，但输入错误的账号和密码") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@tc_err_pppoe_usr, @tc_err_pppoe_pw, @browser.url)
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
            @diagnose_page.advdiag
            loss = @diagnose_page.gw_loss
            @diagnose_page.advdiag if loss =~ /gw\s*.+：%/i #如果丢包率出现%时，重新诊断一次

            tc_net_type = @diagnose_page.wan_type_element.element.span.text
            puts "上网连接类型：#{tc_net_type}".to_gbk
            assert_equal(@ts_wan_mode_pppoe, tc_net_type, "上网连接类型错误")
            tc_net_status = @diagnose_page.net_status_element.element.span.text
            puts "WAN口连接状态：#{tc_net_status}".to_gbk
            assert_equal(@ts_net_link, tc_net_status, "WAN连接状态显示错误")
            tc_net_domain_ip = @diagnose_page.domain_ip_element.element.span.text
            puts "域名：#{@ts_diag_web}，解析结果：#{tc_net_domain_ip}".to_gbk
            assert_match(@ts_domina_ip_fail, tc_net_domain_ip, "域名解析成功")
            tc_loss_rate = @diagnose_page.gw_loss_element.element.span.text
            puts "诊断过程丢包率为：#{tc_loss_rate}".to_gbk
            assert_equal(@ts_loss_rate_all, tc_loss_rate, "诊断过程丢包应为100%")
            tc_dns_status = @diagnose_page.dns_parse_element.element.span.text
            puts "DNS解析状态：#{tc_dns_status}".to_gbk
            assert_equal(@ts_dns_status_fail, tc_dns_status, "DNS解析结果应该为失败")
            tc_http_code = @diagnose_page.http_code_element.element.span.text
            puts "HTTP响应码：#{tc_http_code}".to_gbk
            assert_equal(@ts_http_status_fail, tc_http_code, "HTTP响应码不正确")
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
