#
#description:#
# 用例描述的测试点太多，太过复杂，自动化不好实现
# 实现了也会增加维护成本
# 将用例拆分后再实现
# 实现了dhcp,pppoe,static接入方式切换时wan状态显示
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.22", "level" => "P1", "auto" => "n"}

    def prepare
        
    end

    def process

        operate("1 打开外网连接设置") {
        }

        operate("2 设置外网接入方式为：DHCP") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }

        operate("3 查看DHCP接入时WAN状态") {
            @browser.refresh #刷新浏览器
            #关闭WAN设置
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            wan_addr = @status_page.get_wan_ip
            puts "WAN状态显示获取的IP地址为：#{wan_addr}".to_gbk

            wan_type = @status_page.get_wan_type
            puts "WAN状态显示接入类型为：#{wan_type}".to_gbk

            mask = @status_page.get_wan_mask
            puts "WAN状态显示的掩码地址为：#{mask}".to_gbk

            gateway_addr = @status_page.get_wan_gw
            puts "WAN状态显示的网关IP地址为：#{gateway_addr}".to_gbk

            dns_addr = @status_page.get_wan_dns
            puts "WAN状态显示的DNS IP地址为：#{dns_addr}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
            assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'dhcp获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'dhcp获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'dhcp获取dns ip地址失败！'
        }

        operate("4 修改接入方式为PPPOE") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("5 查看PPPOE接入时WAN状态") {
            @browser.refresh #刷新浏览器
            #关闭WAN设置
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            wan_addr = @status_page.get_wan_ip
            puts "WAN状态显示获取的IP地址为：#{wan_addr}".to_gbk

            wan_type = @status_page.get_wan_type
            puts "WAN状态显示接入类型为：#{wan_type}".to_gbk

            mask = @status_page.get_wan_mask
            puts "WAN状态显示的掩码地址为：#{mask}".to_gbk

            gateway_addr = @status_page.get_wan_gw
            puts "WAN状态显示的网关IP地址为：#{gateway_addr}".to_gbk

            dns_addr = @status_page.get_wan_dns
            puts "WAN状态显示的DNS IP地址为：#{dns_addr}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
        }

        operate("6 设置接入方式为Static") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)
        }

        operate("7 静态接入时查看WAN状态") {
            @browser.refresh #刷新浏览器
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            wan_addr = @status_page.get_wan_ip
            puts "WAN状态显示获取的IP地址为：#{wan_addr}".to_gbk

            wan_type = @status_page.get_wan_type
            puts "WAN状态显示接入类型为：#{wan_type}".to_gbk

            mask = @status_page.get_wan_mask
            puts "WAN状态显示的掩码地址为：#{mask}".to_gbk

            gateway_addr = @status_page.get_wan_gw
            puts "WAN状态显示的网关IP地址为：#{gateway_addr}".to_gbk

            dns_addr = @status_page.get_wan_dns
            puts "WAN状态显示的DNS IP地址为：#{dns_addr}".to_gbk

            assert_match @ts_tag_ip_regxp, wan_addr, '静态ip配置失败！'
            assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, '静态ip掩码配置失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, '静态配置网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, '静态配置dns ip地址失败！'
        }


    end

    def clearup

        operate("1 恢复默认的接入方式") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_powerip, @ts_default_ip)
            end

            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
