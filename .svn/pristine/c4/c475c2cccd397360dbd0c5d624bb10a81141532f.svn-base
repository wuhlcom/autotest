#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.44", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_server    = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_pptp_chap         = "chap"
        @tc_pptp_usr_err      = "err"
        @tc_pptp_pw_err       = "err"
        @tc_wait_time         = 3
        @tc_pptp_setting_time = 60
        @tc_net_time          = 50
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
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_op_pptp).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_pptp).click #pptp设置
            @option_iframe.text_field(id: @ts_tag_pptp_server).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_tag_pptp_server).set(@ts_pptp_server_ip) #服务器IP
            @option_iframe.text_field(id: @ts_tag_pptp_usr).set(@ts_pptp_usr) #用户名
            @option_iframe.text_field(id: @ts_tag_pptp_pw).set(@ts_pptp_pw) #口令
            @option_iframe.button(id: @ts_tag_sbm).click #保存
            sleep @tc_pptp_setting_time
        }

        operate("3、抓包确认在PPP LCP过程中，BAS与DUT协商是否采用CHAP-MD5认证(协议码：0xc223)，拨号是否成功，查看WAN连接，IP，路由，DNS等信息统计页面显示信息是否正确；") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

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
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_op_pptp).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_pptp).click #pptp设置
            @option_iframe.text_field(id: @ts_tag_pptp_server).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_tag_pptp_server).set(@ts_pptp_server_ip) #服务器IP
            @option_iframe.text_field(id: @ts_tag_pptp_usr).set(@tc_pptp_usr_err) #用户名
            @option_iframe.text_field(id: @ts_tag_pptp_pw).set(@tc_pptp_pw_err) #口令
            @option_iframe.button(id: @ts_tag_sbm).click #保存
            sleep @tc_pptp_setting_time

            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            p "#{wan_addr}".to_gbk
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            p "#{wan_type}".to_gbk
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            p "#{mask}".to_gbk
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            p "#{gateway_addr}".to_gbk
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            p "#{dns_addr}".to_gbk

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
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            flag        = false
            #设置wan连接方式为网线连接
            rs1         = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
            unless rs1.class_name =~/ #{@tc_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
                flag = true
            end

            #查询是否为为dhcp模式
            dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
            dhcp_radio_state = dhcp_radio.checked?
            #设置WIRE WAN为DHCP模式
            unless dhcp_radio_state
                dhcp_radio.click
                flag = true
            end

            if flag
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "Waiting for net reset..."
                sleep @tc_net_time
            end
        }
    end

}
