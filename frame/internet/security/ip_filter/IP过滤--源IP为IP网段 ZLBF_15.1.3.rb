#
# description:
# author:liluping
# date:2015-09-19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.3", "level" => "P2", "auto" => "n"}

    def prepare

        DRb.start_service
        @tc_dumpcap_pc2           = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wifi_flag             = "1"
        @tc_wait_time             = 3
        @tc_ping_num              = 5
        @tc_wifi_time             = 30
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
            rs = ping(@ts_web)
            assert(rs, "设置源IP过滤前有线客户端无法ping通#{@ts_web}")

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            #连接无线网卡
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            mac_last   = @wifi_page.get_mac_last
            @wifi_page.open_wifi_page(@browser.url)
            @tc_ssid1_name = @wifi_page.ssid1
            puts "当前SSID1名为#{@tc_ssid1_name}".to_gbk
            puts "当前SSID1 加密方式为#{@wifi_page.ssid1_pwmode}".to_gbk
            #判断加密方式是否为WPA,如果不是则设置为WPA
            flag = false
            if @wifi_page.ssid1_pwmode != @ts_sec_mode_wpa
                @wifi_page.modify_ssid1_pw(@ts_default_wlan_pw)
                flag                    = true
            end
            unless @tc_ssid1_name=~/#{mac_last}/i
                @tc_ssid1_name   = "#{@tc_ssid1_name}_#{mac_last}"
                @wifi_page.ssid1 = @tc_ssid1_name
                puts "修改SSID1名为#{@tc_ssid1_name}".to_gbk
                flag = true
            end
            if flag
                @wifi_page.save_wifi
                puts "sleep #{@tc_wifi_time} second for wifi config changing..."
                sleep @tc_wifi_time
            end
            puts "Dut ssid: #{@tc_ssid1_name},passwd:#{@ts_default_wlan_pw}"
            p "PC2连接DUT".to_gbk
            rs1 = @tc_dumpcap_pc2.connect(@tc_ssid1_name, @tc_wifi_flag, @ts_default_wlan_pw, @ts_wlan_nicname)
            assert rs1, 'wifi连接失败'
            rs2 =@tc_dumpcap_pc2.ping(@ts_web)
            assert(rs2, "设置源IP过滤前WIFI客户端无法ping#{@ts_web}")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、启用IP过滤功能，设置源IP为一地址段（如192.168.100.100~192.168.100.102），端口为1-65535，协议为TCP/UDP，保存配置，从PC向服务器作ping操作，ping的IP为过滤网段内的地址，然后在服务器查看是否能抓到数据包。") {
            ipinfo     = ipconfig("all")[@ts_nicname]
            @tc_pc_ip  = ipinfo[:ip][0] #获取dut网卡ip
            @tc_pc_gw  = ipinfo[:gateway][0]
            @tc_pc_dns = ipinfo[:dns_server][0]
            #生成IP地址结束范围
            @tc_pc_ip =~ /(\d+\.\d+\.\d+\.)(\d+)/
            start_ipnumber = $2.to_i - 10
            start_ipnumber = 1 if start_ipnumber.to_i < 1
            source_startip = $1 + start_ipnumber.to_s
            p "设置过滤源IP起始IP：#{source_startip}".to_gbk
            last_ipnumber = $2.to_i + 10
            last_ipnumber = 254 if last_ipnumber.to_i > 254
            source_endip  = $1 + last_ipnumber.to_s
            p "设置过滤源IP结束IP：#{source_endip}".to_gbk

            #生成静态IP地址，在过滤范围之外
            static_ipnum = $2.to_i - 11
            if static_ipnum <= 0
                static_ip = $1 + "11"
            else
                static_ip = $1 + static_ipnum.to_s
            end
            p "设置静态IP地址：#{static_ip}".to_gbk

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
            #打开IP过滤界面
            @options_page.ipfilter_click #打开IP过滤页面
            @options_page.ip_add_item_element.click #添加新条目
            @options_page.ip_filter_src_ip_input(source_startip, source_endip)
            @options_page.ip_filter_save

            #验证ip是否过滤
            p "获取#{@ts_web}对应的网络IP".to_gbk
            ns     = Addrinfo.ip(@ts_web) #查询该url对应的ip
            net_ip = ns.ip_address
            p "#{@ts_web}的网络IP是：#{net_ip}".to_gbk

            rs = ping(net_ip, @tc_ping_num)
            refute(rs, "IP过滤失败，本机IP在过滤网段之内仍能ping通外网！")

            p "PC2上配置静态IP，要求IP在过滤网段:#{source_startip}-#{source_endip}之外".to_gbk
            puts "配置静态IP信息如下:".to_gbk
            wireless_ip = static_ip
            p "静态ip:#{wireless_ip}".encode("GBK")
            wireless_mask       = "255.255.255.0"
            wireless_gw         = @tc_pc_gw
            wireless_dns        = @tc_pc_dns

            #设置静态IP
            args                = {}
            args[:ip]           = wireless_ip
            args[:mask]         = wireless_mask
            args[:gateway]      = wireless_gw
            args[:nicname]      = @ts_wlan_nicname
            args[:source]       = "static"
            #DNS参数
            dns_args            ={}
            dns_args[:nicname]  = @ts_wlan_nicname
            dns_args[:source]   = "static"
            dns_args[:dns_addr] = wireless_dns
            #设置静态IP
            rs                  = @tc_dumpcap_pc2.netsh_if_ip_setip(args)
            #设置静态DNS
            @tc_dumpcap_pc2.netsh_if_ip_setdns(dns_args)
            #查询静态IP配置
            puts "查询静态IP配置".to_gbk
            p @tc_dumpcap_pc2.ipconfig("all")[@ts_wlan_nicname]
            if rs
                ts = @tc_dumpcap_pc2.ping(net_ip, @tc_ping_num)
                assert(ts, "IP过滤失败，本机IP在过滤网段之外，不能ping通外网！")
            else
                assert(false, "PC2配置静态IP失败！")
            end
        }
    end

    def clearup
        operate("1 恢复默认配置") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            p "PC2恢复DHCP模式".to_gbk
            args           = {}
            args[:nicname] = @ts_wlan_nicname
            args[:source]  = "dhcp"
            rs             = @tc_dumpcap_pc2.netsh_if_ip_setip(args)
            unless rs
                p "PC2恢复DHCP连接模式失败！".to_gbk
                ts = @tc_dumpcap_pc2.netsh_if_ip_setip(args)
                p "再次尝试修改后，PC2恢复DHCP模式".to_gbk if ts
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end

            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
