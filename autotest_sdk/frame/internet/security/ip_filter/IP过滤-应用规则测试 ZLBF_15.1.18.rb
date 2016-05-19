#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.18", "level" => "P3", "auto" => "n"}

    def prepare
        # @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time           = 5
        @tc_rebooting_wait_time = 120
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

            # flag ="1"
            # rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @pwd, @ts_wlan_nicname)
            # assert(rs, "PC2 wifi连接失败".to_gbk)
            @dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
            # @wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
        }

        operate("1、DUT的接入类型选择为DHCP，保存配置；") {
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
        }

        operate("2、进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，在IP过虑界面添加规则，直到不能添加为止，查看是否添加成功，添加数目与最大允许数目是否一致；") {
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

            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            rs = @dut_ip.slice(/(\d+\.\d+\.\d+\.)\d+/i, 1)

            @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
            @option_iframe.span(id: @ts_tag_additem).click #添加新条目
            @option_iframe.text_field(id: @ts_ip_src).wait_until_present(@tc_wait_time)
            @option_iframe.text_field(id: @ts_ip_src).clear
            @option_iframe.text_field(id: @ts_ip_src).set(@dut_ip)
            @option_iframe.button(id: @ts_tag_save_filter).click #保存
            for n in 1..31
                rule_ip = rs + n.to_s
                @option_iframe.span(id: @ts_tag_additem).wait_until_present(@tc_wait_time)
                @option_iframe.span(id: @ts_tag_additem).click #添加新条目
                @option_iframe.text_field(id: @ts_ip_src).wait_until_present(@tc_wait_time)
                @option_iframe.text_field(id: @ts_ip_src).clear
                @option_iframe.text_field(id: @ts_ip_src).set(rule_ip)
                @option_iframe.button(id: @ts_tag_save_filter).click #保存
            end
        }


        operate("3、使用iptables-nvx-L命令查看所有规则添加与服务限制规则表显示规则数目、端口等是否正确；") {
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 33, "规则添加数目不一致")
        }

        operate("4、使用数据包模拟器模拟匹配第一条，最后一条，及中间若干条规则数据包，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包。") {
            rs = ping(@ts_web)
            assert(!rs, "过滤规则无效。过滤规则中有一条为：过滤源IP为dut网卡ip#{@dut_ip},仍然能够ping通外网！")
        }

        operate("5、DUT重启后，所有添加规则是否都存在无丢失。") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_reboot).click
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_rebooting_wait_time
            login_no_default_ip(@browser) #重新登录
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 33, "重启后，所添加规则数有变化！")
        }

        operate("6、非顺序删除添加的所有规则，查看删除是否成功，iptables-nvx-L命令查看是否删除成功。") {
            @option_iframe.table(id: @ts_iptable).wait_until_present(@tc_wait_time)
            ip_trs = @option_iframe.table(id: @ts_iptable).trs
            ip_trs[3][7].link(class_name: @ts_tag_del).click #删除第3条记录
            ip_trs[1][7].link(class_name: @ts_tag_del).click #删除第1条记录
            sleep @tc_wait_time
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 31, "删除规则后，总规则数不一致！")
        }

        operate("7、DUT重启后，添加规则是否还存在。") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_reboot).click
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_rebooting_wait_time
            login_no_default_ip(@browser) #重新登录
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            @option_iframe.link(id: @ts_tag_security).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_security).click
            @option_iframe.link(id: @ts_ip_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_ip_set).click #IP过滤
            ip_clauses = @option_iframe.table(id: @ts_iptable).trs.size
            assert_equal(ip_clauses, 31, "重启后，总规则数有变化！")
        }


    end

    def clearup
        operate("关闭防火墙开关") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
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

        operate("删除所有配置") {
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
