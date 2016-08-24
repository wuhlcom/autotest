#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.44", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_server = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_pptp_chap      = "chap"
        @tc_pptp_usr_err   = "err"
        @tc_pptp_pw_err    = "err"
    end

    def process

        operate("1、BAS开启抓包；") {
            #设置ppptp服务的加密为chap
            @tc_dumpcap_server.init_routeros_obj(@ts_pptp_server_ip)
            @tc_dumpcap_server.routeros_send_cmd(@ts_pptp_chap_set)
            rs = @tc_dumpcap_server.pptp_srv_pri(@pptp_pri)
            p "修改服务器PPTP认证方式为:#{rs["authentication"]}".to_gbk
            assert_equal(@tc_pptp_chap, rs["authentication"], "修改认证方式失败")
        }

        operate("2、设置DUT的WAN拨号方式为PPTP，DNS为自动获取方式，BAS认证强制设置为CHAP-MD5，设置PPTP服务器的IP地址为192.168.25.9，网关地址为192.168.25.9,IP地址设置与服务器同一网段，例如：192.168.25.100，mask填写为255.255.255.0，并填写正确的拨号用户名和密码，提交并保存设置；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @sys_page     = RouterPageObject::SystatusPage.new(@browser)
            @options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
        }

        operate("3、抓包确认在PPP LCP过程中，BAS与DUT协商是否采用CHAP-MD5认证(协议码：0xc223)，拨号是否成功，查看WAN连接，IP，路由，DNS等信息统计页面显示信息是否正确；") {
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

        operate("4、LAN PC与STA PC上网业务是否正常；") {
            rs = ping(@ts_web)
            assert(rs, "PPTP拨号成功但业务异常")
        }

        operate("5、设置错误的用户名或密码，查看WAN连接，路由，DNS等信息统计页面，是否可以上网。") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @options_page.set_pptp(@ts_pptp_server_ip, @tc_pptp_usr_err, @tc_pptp_pw_err, @browser.url)
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            p "WAN状态显示获取的IP地址为：#{wan_addr}".to_gbk
            p "WAN状态显示获取的连接类型为：#{wan_type}".to_gbk
            p "WAN状态显示获取的子网掩码为：#{mask}".to_gbk
            p "WAN状态显示获取的网关地址为：#{gateway_addr}".to_gbk
            p "WAN状态显示获取的DNS地址为：#{dns_addr}".to_gbk

            rs = ping(@ts_web)
            p "能否访问外网：#{rs}".to_gbk
            if ((wan_addr =~ @ip_regxp) || (wan_type !~ /#{@ts_wan_mode_pptp}/) || (mask =~ @ip_regxp) || (gateway_addr =~ @ip_regxp) || (dns_addr =~ @ip_regxp) || rs)
                assert(false, "在输入错误用户名和密码后，PPTP拨号或业务正常！")
            end
        }


    end

    def clearup
        operate("恢复服务器默认配置") {
            @tc_dumpcap_server.routeros_send_cmd(@ts_pptp_default_set)
            rs = @tc_dumpcap_server.pptp_srv_pri(@pptp_pri)
            p "恢复服务器PPTP认证方式为:#{rs["authentication"]}".to_gbk
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
