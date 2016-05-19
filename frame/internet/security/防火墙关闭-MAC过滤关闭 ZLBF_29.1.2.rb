#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
    attr = {"id" => "ZLBF_29.1.2", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time    = 3
        @tc_dumpcap_pc2  = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_default_ssid = "Wireless0"
    end

    def process

        operate("1、AP工作在路由模式下,可以访问外网；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)

            rs = ping(@ts_web)
            assert(rs, "过滤前PC无法上网")
            puts "PC1 TCP server connect"
            client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            assert(client.tcp_state, "过滤前PC不能进行tcp连接")
        }

        operate("2 无线客户端连接路由器，并ping外网") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            mac_last   = @wifi_page.get_mac_last
            @wifi_page.open_wifi_page(@browser.url)
            @tc_ssid1_name = @wifi_page.ssid1
            puts "当前SSID1名为#{@tc_ssid1_name}".to_gbk
            puts "当前SSID1 加密方式为#{@wifi_page.ssid1_pwmode}".to_gbk
            #判断加密方式是否为WPA,如果不是则设置为WPA
            flag = false
            unless @wifi_page.ssid1_pwmode == @ts_sec_mode_wpa
                @wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                @wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                    = true
            end
            unless @tc_ssid1_name=~/#{mac_last}/i
                @tc_ssid1_name   = "#{@tc_ssid1_name}_#{mac_last}"
                @wifi_page.ssid1 = @tc_ssid1_name
                puts "修改SSID1名为#{@tc_ssid1_name}".to_gbk
                flag = true
            end
            @wifi_page.save_wifi_config if flag
            puts "Dut ssid: #{@tc_ssid1_name},passwd:#{@ts_default_wlan_pw}"
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @ts_default_wlan_pw, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            assert wifi_rs, "WIFI客户端无法连接外网"
        }

        operate("3、AP工作在路由方式下，添加两条规则，分别是PC1和PC2的MAC地址；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "on", "off")
            @options_page.macfilter_click
            @options_page.mac_add_item_element.click #新增条目
            puts "PC MAC address : #{@ts_pc_mac}"
            @options_page.mac_filter_input(@ts_pc_mac, @ts_nicname) #输入，状态默认为生效
            @options_page.mac_filter_save
            #添加无线客户端过滤条件
            wifi           = @tc_dumpcap_pc2.ipconfig(@ts_ipconf_all)
            wifi_mac       = wifi[@ts_wlan_nicname][:mac]
            @wifi_mac_addr = wifi_mac.gsub("-", ":")
            puts "Wireless PC MAC address : #{@wifi_mac_addr}"
            @options_page.mac_add_item_element.click #新增条目
            @options_page.mac_filter_input(@wifi_mac_addr, @ts_wlan_nicname, @ts_tag_filter_nouse) #状态为不生效
            @options_page.mac_filter_save
        }

        operate("4、再进入到防火墙界面，将防火墙总开关关闭，MAC过滤关闭，保存，PC1和PC2能否访问外网。") {
            @options_page.firewall_click
            @options_page.open_switch("off", "off", "off", "off")
            rs = ping(@ts_web)
            assert(rs, "总开关关闭客户端不能连接外网")
            puts "总开关关闭PC1 TCP server connect".encode("GBK")
            client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            assert(client.tcp_state, "总开关关闭PC不能进行tcp连接")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            assert wifi_rs, "总开关关闭WIFI客户端无法连接外网"
        }


    end

    def clearup
        operate("1、恢复防火墙默认设置：关闭总开关并删除所有规则") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.macfilter_close_sw_del_all(@browser.url)
        }

        operate("2 恢复默认ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.open_wifi_page(@browser.url)
            current_ssid   = wifi_page.ssid1
            current_pwmode = wifi_page.ssid1_pwmode
            flag = false
            unless current_ssid == @tc_default_ssid
                wifi_page.ssid1 = @tc_default_ssid
                flag = true
            end
            unless current_pwmode == @ts_sec_mode_wpa
                wifi_page.ssid1_pwmode = @ts_sec_mode_wpa
                wifi_page.ssid1_pw     = @ts_default_wlan_pw
                flag                    = true
            end
            wifi_page.save_wifi_config if flag
        }
    end

}
