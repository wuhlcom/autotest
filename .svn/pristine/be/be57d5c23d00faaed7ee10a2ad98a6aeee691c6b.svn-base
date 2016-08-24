#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.57", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_server = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_pptp_dfault    = "pap,chap,mschap1,mschap2"
    end

    def process

        operate("1、在BAS启动抓包；") {
            #设置ppptp服务的认证为默认配置
            @tc_dumpcap_server.init_routeros_obj(@ts_pptp_server_ip)
            @tc_dumpcap_server.routeros_send_cmd(@ts_pptp_default_set)
            rs = @tc_dumpcap_server.pptp_srv_pri(@pptp_pri)
            p "修改服务器PPTP认证方式为:#{rs["authentication"]}".to_gbk
            assert_equal(@tc_pptp_dfault, rs["authentication"], "修改认证方式失败")
        }

        operate("2、设置DUT的WAN拨号方式为PPTP，DUT上配置相应的PPTP方式接入配置，DNS为自动获取方式，认证方法设为自动，并填写正确的拨号用户名和密码，查看拨号是否成功；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @sys_page     = RouterPageObject::SystatusPage.new(@browser)
            @options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)

            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns

            assert_match(@ip_regxp, wan_addr, 'PPTP获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'PPTP获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'PPTP获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'PPTP获取dns ip地址失败！')
        }

        operate("3、切换DUT的WAN方式为DHCP方式后，BAS抓包确认切换成DHCP时，是否以当前的call ID发送Call-Clear-Request断开请求，再切换成PPTP方式后，是否能快速拨号成功；") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "切换WAN的方式为DHCP".to_gbk
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp_mode(@browser.url)
            # end
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'DHCP获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'DHCP获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'DHCP获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'DHCP获取dns ip地址失败！')
            p "切换WAN的方式为PPTP".to_gbk
            @options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'PPTP获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'PPTP获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'PPTP获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'PPTP获取dns ip地址失败！')
        }

        operate("4、切换DUT的WAN方式分别为STATIC、PPPoE、PPTP等其它接入方式，重复步骤3，确认结果；") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "切换WAN的方式为PPPOE".to_gbk
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'PPPOE获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'PPPOE获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！')
            p "切换WAN的方式为PPTP".to_gbk
            @options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            assert_match(@ip_regxp, wan_addr, 'PPTP获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'PPTP获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'PPTP获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'PPTP获取dns ip地址失败！')
        }
    end

    def clearup
        operate("断开服务器连接") {
            @tc_dumpcap_server.logout_routeros
        }

        operate("恢复默认DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
