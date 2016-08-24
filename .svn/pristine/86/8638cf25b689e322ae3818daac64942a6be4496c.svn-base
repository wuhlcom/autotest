#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.11", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time   = 5
        @lose_efficacy  = "失效"
        @take_effect    = "生效"
    end

    def process

        operate("0、准备步骤：获取DUT的ssid跟pwd，PC2无线连接该ssid。获取PC1和PC2的网卡IP地址") {
            @browser.span(id: @ts_tag_lan).click #进入内网设置
            @lan_frame = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_frame.exists?, "打开内网设置失败！")
            @lan_frame.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_frame.button(id: @ts_wifi_switch).class_name == "off"
                @lan_frame.button(id: @ts_wifi_switch).click #打开无线开关
            end
            wifi_ssid = @lan_frame.text_field(id: @ts_tag_ssid)
            wifi_ssid.wait_until_present(@tc_wait_time)
            @ssid     = wifi_ssid.value
            wifi_safe = @lan_frame.select_list(id: @ts_tag_sec_select_list)
            wifi_safe.wait_until_present(@tc_wait_time)
            wifi_safe.select(@ts_sec_mode_wpa) #选择安全模式
            wifi_pwd = @lan_frame.text_field(id: @ts_tag_pppoe_pw)
            wifi_pwd.wait_until_present(@tc_wait_time)
            @pwd = wifi_pwd.value
            p "ssid->#{@ssid}".to_gbk
            p "pwd->#{@pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)
            @dut_ip      = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
            @wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
        }

        operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_netset).click #外网
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            flag        = false
            #设置wan连接方式为网线连接
            rs1         = @wan_iframe.link(id: @ts_tag_wired_mode_link).class_name
            unless rs1 =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(id: @ts_tag_wired_mode_span).click #网线连接
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
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "off"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "off"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #保存
        }

        operate("2、添加两条过滤规则，一条源IP为192.168.100.100,另外一条是192.168.100.101；PC1和PC2能否访问外网") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).clear
            @option_iframe.text_field(id: @ts_ip_src).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_ip_src).set(@wireless_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            # @option_iframe.table(id: @ts_iptable).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses == 1
                assert(false, "生成新条目失败")
            end

            response = send_http_request(@ts_web)
            if response == true
                sleep @tc_wait_time
                response = send_http_request(@ts_web)
            end
            assert(!response, "可以访问#{@ts_web}".to_gbk)
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            if response_pc2 == true
                sleep @tc_wait_time
                response_pc2 = send_http_request(@ts_web)
            end
            assert(!response_pc2, "可以访问#{@ts_web}".to_gbk)
        }

        operate("3、在IP过滤界面，点击使所有条目失效，PC1和PC2能否访问外网") {
            @option_iframe.span(id: @ts_ip_invalid).click #所有规则失效
            sleep @tc_wait_time

            response = send_http_request(@ts_web)
            if response == true
                sleep @tc_wait_time
                response = send_http_request(@ts_web)
            end
            assert(response, "不可以访问#{@ts_web}".to_gbk)
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            if response_pc2 == true
                sleep @tc_wait_time
                response_pc2 = send_http_request(@ts_web)
            end
            assert(response_pc2, "不可以访问#{@ts_web}".to_gbk)
        }

        operate("4、在IP过滤界面，点击使所有条目生效，PC1和PC2能否访问外网") {
            @option_iframe.span(id: @ts_ip_valid).click #所有规则生效
            sleep @tc_wait_time

            response = send_http_request(@ts_web)
            if response == true
                sleep @tc_wait_time
                response = send_http_request(@ts_web)
            end
            assert(!response, "可以访问#{@ts_web}".to_gbk)
            response_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            if response_pc2 == true
                sleep @tc_wait_time
                response_pc2 = send_http_request(@ts_web)
            end
            assert(!response_pc2, "可以访问#{@ts_web}".to_gbk)
        }


    end

    def clearup
        operate("1、关闭防火墙总开关和IP过滤开关") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接

            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            fire_wall = @option_iframe.link(id: @ts_tag_fwset)
            fire_wall.wait_until_present(@tc_wait_time)
            unless @option_iframe.button(id: @ts_tag_security_sw).exists?
                fire_wall.click
            end
            fire_wall_btn = @option_iframe.button(id: @ts_tag_security_sw)
            if fire_wall_btn.class_name == "on"
                fire_wall_btn.click
            end
            ip_btn = @option_iframe.button(id: @ts_tag_security_ip)
            if ip_btn.class_name == "on"
                ip_btn.click
            end
            @option_iframe.button(id: @ts_tag_security_save).click #保存
        }

        operate("2、删除所有条目") {
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #进入IP过滤设置
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            if ip_clauses > 1 #如果有条目就删除
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click #删除所有条目
            end
        }
    end

}
