#
# description:
# author:liluping
# date:2015-09-21
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.5", "level" => "P1", "auto" => "n"}

    def prepare

        DRb.start_service
        @tc_dumpcap             = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_dumpcap_pc2         = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time           = 3
        @tc_net_wait_time       = 60
        @tc_reboot_wait_time    = 120
        @tc_tag_wire_mode_radio = "ip_type_dhcp"
        @tc_tag_wan_mode_link   = "tab_ip"
        @tc_tag_ip_setting      = "IP-Filter"
        @tc_tag_status_id       = "setstatus"
        @tc_wan_ip_id           = "WAN-IP"

        @tc_tag_options              = "options"
        @tc_tag_secseting            = "securitysetting"
        @tc_tag_fw_seting            = "Firewall-Settings"
        @tc_tag_save_button          = "save_btn"
        @tc_tag_save_button_ipfilter = "save_btniptb"
        @tc_tag_add_ipfilter         = "additem"

        @tc_tag_fw_button         = "switch1"
        @tc_tag_ip_button         = "switch2"
        @tc_tag_button_switch_off = "off"
        @tc_tag_button_switch_on  = "on"

        @tc_tag_destination_fip_text   = "gip"
        @tc_tag_source_port_text       = "gport"
        @tc_tag_destination_port_text  = "gendport"
        @tc_tag_agreement_select       = "protocol"
        @tc_tag_ipfilter_list_id       = "iptable"
        @tc_tag_ipfilter_list_cls_name = "macguolv"
        @tc_tag_destination_ip         = "10.10.10.1"
        @tc_tag_source_port            = "1"
        @tc_tag_destination_port       = "65535"

        @tc_tag_url_baidu = 'www.baidu.com'
        @tc_tag_url_yahoo = 'www.yahoo.com'
        @tc_ping_num      = 5

        @ssid_pwd             = "12345678"
        @tc_net_status        = "setstatus"
        @tc_dut_wifi_ssid     = "ssid"
        @tc_dut_wifi_ssid_pwd = "input_password1"
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置；") {
            @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time) #等待2s
            @browser.span(id: @ts_tag_lan).click

            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "打开内网设置失败！")
            p "获取DUT的ssid".to_gbk
            @dut_ssid = @lan_iframe.text_field(id: @tc_dut_wifi_ssid).value
            p "DUTssid --> #{@dut_ssid}".to_gbk
            @dut_ssid_pwd = @lan_iframe.text_field(id: @tc_dut_wifi_ssid_pwd).value
            p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@dut_ssid, flag, @dut_ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)

            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time) #等待2s
            @browser.span(id: @ts_tag_netset).click

            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src) #新面板，新对象
            assert(@wan_iframe.exists?, "打开外网设置失败！")

            @wan_iframe.link(:id => @tc_tag_wan_mode_link).click #选择网线连接
            dhcp_radio = @wan_iframe.radio(id: @tc_tag_wire_mode_radio)
            unless dhcp_radio.checked?
                dhcp_radio.click
                #保存
                @wan_iframe.button(:id, @ts_tag_sbm).click

                sleep @tc_wait_time
                net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
                Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
                    net_reset_div.visible?
                }
                Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                    net_reset_div.present?
                }
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

        }

        operate("2、先进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            @browser.link(id: @tc_tag_options).click

            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            option_link = @option_iframe.link(id: @tc_tag_secseting)
            option_link.click

            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "开启防火墙总开关IP过滤开关".to_gbk
            btn_fw_off = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_off)
            if btn_fw_off.exists? #关闭状态就不再操作了
                btn_fw_off.click
            end
            btn_url_off = @option_iframe.button(id: @tc_tag_ip_button, class_name: @tc_tag_button_switch_off)
            if btn_url_off.exists?
                btn_url_off.click
            end

            @option_iframe.button(id: @tc_tag_save_button).click
        }

        operate("3、添加一条IP过滤规则，设置目的IP为10.10.10.1，端口为1~65535，协议为TCP/UDP，其它不填，保存配置；") {
            @option_iframe.link(id: @tc_tag_ip_setting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_ip_setting)
            option_fw_iframe.click

            # dut_ip =  ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
            require 'socket'
            ns              = Addrinfo.ip(@tc_tag_url_baidu) #查询该url对应的ip
            @destination_ip = ns.ip_address

            rs        = Addrinfo.ip(@tc_tag_url_yahoo) #查询该url对应的ip
            @yahoo_ip = rs.ip_address

            @option_iframe.span(id: @tc_tag_add_ipfilter).click #添加新条目
            @option_iframe.text_field(id: @tc_tag_destination_fip_text).set(@destination_ip) #设置目的IP
            @option_iframe.button(id: @tc_tag_save_button_ipfilter).click #保存

            #判断是否生成了新条目
            #获取条目中的源ip
            sleep @tc_wait_time
            @source_ip = @option_iframe.table(id: @tc_tag_ipfilter_list_id, class_name: @tc_tag_ipfilter_list_cls_name).trs[1][3].text.to_gbk
            # source_ip = @option_iframe.td(text: /#{dut_ip}/).parent[1].text
            @source_ip =~ /(\d+\.\d+\.\d+\.\d+)\-/i
            assert_equal($1, @destination_ip, "添加IP过滤失败!")
        }

        operate("4、从PC向服务器作ping操作，ping的IP为过滤网段内的地址，然后在服务器查看是否能抓到数据包；") {

            #验证ip是否过滤
            puts "验证ip是否过滤".to_gbk
            rs = ping(@destination_ip, @tc_ping_num)
            assert(!rs, "ip过滤失败，在过滤网段为#{@source_ip.slice(/(\d+\.\d+\.\d+\.\d+)\-/i, 1)}，ping #{@destination_ip}能ping通!")

            puts "在pc2上再次ping #{@tc_tag_url_baidu}".to_gbk
            # wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
            ts = @tc_dumpcap_pc2.ping(@destination_ip, @tc_ping_num)
            assert(!ts, "ip过滤失败，在过滤网段为#{@source_ip.slice(/(\d+\.\d+\.\d+\.\d+)\-/i, 1)}，ping #{@destination_ip}能ping通!")

            puts "PC1上验证ping #{@tc_tag_url_yahoo}".to_gbk
            rss = ping(@yahoo_ip, @tc_ping_num)
            assert(rss, "ip过滤失败，在过滤网段为#{@source_ip.slice(/(\d+\.\d+\.\d+\.\d+)\-/i, 1)}，ping #{@yahoo_ip}不能ping通!")

            puts "在pc2上再次ping #{@tc_tag_url_yahoo}".to_gbk
            # wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
            tss = @tc_dumpcap_pc2.ping(@yahoo_ip, @tc_ping_num)
            assert(tss, "ip过滤失败，在过滤网段为#{@source_ip.slice(/(\d+\.\d+\.\d+\.\d+)\-/i, 1)}，ping  #{@yahoo_ip}不能ping通!")

        }

        operate("7、重启DUT，重复步骤3、4、5，查看测试结果。") {
            @browser.span(id: "reboottxt").parent.click #点击重启按钮
            @browser.button(class_name: "aui_state_highlight").click

            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_reboot_wait_time
            # reboot_div = @browser.div(text: @ts_tag_reboot_text)
            # reboot_div.wait_until_present(@tc_net_wait_time) #等待，直到对象消失


            #重新登录
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "重启成功，再次登录！".to_gbk
            else
                assert(login_ui, "重启失败，请定位后重试！")
            end
            @browser.text_field(name: @usr_text_id).set(@usr)
            @browser.text_field(name: @pw_text_id).set(@pw)
            @browser.button(id: @ts_tag_sbm).click


            # wan_ip = @status_iframe.b(id: @tc_wan_ip_id).parent.text.slice(/\d+\.\d+\.\d+\.\d+/)
            # @tc_wan_ip = wan_ip
            @browser.link(id: @tc_tag_options).wait_until_present(@tc_wait_time)
            @browser.link(id: @tc_tag_options).click

            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置失败！")
            option_link = @option_iframe.link(id: @tc_tag_secseting)
            option_link.click

            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "开启防火墙总开关IP过滤开关".to_gbk
            btn_fw_off = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_off)
            if btn_fw_off.exists? #关闭状态就不再操作了
                btn_fw_off.click
            end
            btn_url_off = @option_iframe.button(id: @tc_tag_ip_button, class_name: @tc_tag_button_switch_off)
            if btn_url_off.exists?
                btn_url_off.click
            end

            @option_iframe.button(id: @tc_tag_save_button).click

            @option_iframe.link(id: @tc_tag_ip_setting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_ip_setting)
            option_fw_iframe.click

            # dut_ip =  ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
            require 'socket'
            ns              = Addrinfo.ip(@tc_tag_url_baidu) #查询该url对应的ip
            @destination_ip = ns.ip_address

            rs        = Addrinfo.ip(@tc_tag_url_yahoo) #查询该url对应的ip
            @yahoo_ip = rs.ip_address

            #添加新条目之前先删除所有的条目
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click

            @option_iframe.span(id: @tc_tag_add_ipfilter).wait_until_present(@tc_wait_time) #等待2s
            @option_iframe.span(id: @tc_tag_add_ipfilter).click #添加新条目
            @option_iframe.text_field(id: @tc_tag_destination_fip_text).set(@destination_ip) #设置目的IP
            @option_iframe.button(id: @tc_tag_save_button_ipfilter).click #保存

            #判断是否生成了新条目
            #获取条目中的源ip
            sleep @tc_wait_time
            source_ip = @option_iframe.table(id: @tc_tag_ipfilter_list_id, class_name: @tc_tag_ipfilter_list_cls_name).trs[1][3].text.to_gbk
            # source_ip = @option_iframe.td(text: /#{dut_ip}/).parent[1].text
            source_ip =~ /(\d+\.\d+\.\d+\.\d+)\-/i
            assert_equal($1, @destination_ip, "添加IP过滤失败!")

            #验证ip是否过滤
            puts "验证ip是否过滤".to_gbk
            rs = ping(@destination_ip, @tc_ping_num)
            assert(!rs, "ip过滤失败，在过滤网段为#{source_ip.slice(/(\d+\.\d+\.\d+\.\d+)\-/i, 1)}，ping #{@destination_ip}能ping通!")

            puts "在pc2上再次ping #{@tc_tag_url_baidu}".to_gbk
            # wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
            ts = @tc_dumpcap_pc2.ping(@destination_ip, @tc_ping_num)
            assert(!ts, "ip过滤失败，在过滤网段为#{source_ip.slice(/(\d+\.\d+\.\d+\.\d+)\-/i, 1)}，ping #{@destination_ip}能ping通!")

            puts "PC1上验证ping #{@tc_tag_url_yahoo}".to_gbk
            rss = ping(@yahoo_ip, @tc_ping_num)
            assert(rss, "ip过滤失败，在过滤网段为#{source_ip.slice(/(\d+\.\d+\.\d+\.\d+)\-/i, 1)}，ping  #{@yahoo_ip}不能ping通!")

            puts "在pc2上再次ping #{@tc_tag_url_yahoo}".to_gbk
            # wireless_ip = @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname][:ip][0]
            tss = @tc_dumpcap_pc2.ping(@yahoo_ip, @tc_ping_num)
            assert(tss, "ip过滤失败，在过滤网段为#{source_ip.slice(/(\d+\.\d+\.\d+\.\d+)\-/i, 1)}，ping  #{@yahoo_ip}不能ping通!")
        }


    end

    def clearup
        operate("恢复默认配置") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            p "1 关闭防火墙总开关和URL过滤开关".to_gbk
            @browser.link(id: @ts_tag_options).click

            @option_iframe    = @browser.iframe(src: @ts_tag_advance_src)
            # assert(@option_iframe.exists?, "打开高级设置失败！")
            option_link       = @option_iframe.link(id: @tc_tag_secseting)
            option_link_state = option_link.attribute_value(:checked)
            unless option_link_state == "true"
                option_link.click
            end

            @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
            option_fw_iframe.click

            sleep @tc_wait_time
            puts "关闭防火墙总开关和IP过滤开关".to_gbk
            btn_fw_on = @option_iframe.button(id: @tc_tag_fw_button, class_name: @tc_tag_button_switch_on)

            if btn_fw_on.exists? #关闭状态就不再操作了
                btn_fw_on.click
            end
            btn_ip_on = @option_iframe.button(id: @tc_tag_ip_button, class_name: @tc_tag_button_switch_on)
            if btn_ip_on.exists?
                btn_ip_on.click
            end

            @option_iframe.button(id: @tc_tag_save_button).click


            p "2 删除所有的过滤规则".to_gbk
            @option_iframe.link(id: @tc_tag_ip_setting).wait_until_present(@tc_wait_time)
            option_fw_iframe = @option_iframe.link(id: @tc_tag_ip_setting)
            option_fw_iframe.click
            @option_iframe.span(id: @ts_tag_del_ipfilter_btn).click

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

    end

}
