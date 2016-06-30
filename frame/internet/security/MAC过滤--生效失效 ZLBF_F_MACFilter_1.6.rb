#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
    attr = {"id" => "ZLBF_28.1.6", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time    = 3
        @tc_dumpcap_pc2  = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_default_ssid = "Wireless0"
    end

    def process

        operate("1、AP工作在路由方式下；") {
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
            rs_wifi    = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @dut_ssid  = rs_wifi[:ssid]
            @dut_pwd   = rs_wifi[:pwd]

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@dut_ssid, flag, @dut_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            assert(wifi_rs, "WIFI客户端无法连接外网")
        }

        operate("3、添加PC1的MAC地址过滤规则，状态设置为生效，保存配置，再添加PC2的MAC地址的过滤规则，状态设置为失效，查看PC1、PC2能否访问PC3上面的FTP或HTTP服务器；") {
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
            rs = ping(@ts_web)
            refute(rs, "过滤后客户端仍能连接外网")
            puts "过滤后PC1 TCP server connect".encode("GBK")
            client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(client.tcp_state, "过滤后PC仍能进行tcp连接")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            assert(wifi_rs, "过滤有线客户端导致WIFI客户端也无法连接外网")

        }

        operate("4、编辑PC2规则设置为生效，保存，查看PC1、PC2能否访问PC3上面的FTP或HTTP服务器；") {
            @options_page.mac_filter_table_element.element.trs[2][3].link(class_name: @ts_tag_edit).image.click #编辑PC2规则
            @options_page.mac_status1_element.select(/#{@ts_tag_filter_use}/) #修改状态为生效, 编辑状态select_list不使用原来的id
            @options_page.mac_save1 #编辑状态保存按钮不使用原来的id
            sleep @tc_wait_time
            rs = ping(@ts_web)
            refute(rs, "过滤后客户端仍能连接外网")
            puts "过滤后PC1 TCP server connect".encode("GBK")
            client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(client.tcp_state, "过滤后PC仍能进行tcp连接")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            refute(wifi_rs, "过滤后WIFI客户端能连接外网")
        }

        operate("5、点击下面按钮“使所有条目失效”，查看PC1、PC2能否访问PC3上面的FTP或HTTP服务器；") {
            @options_page.mac_all_invalid_element.click #使所有条目失效
            sleep @tc_wait_time
            rs = ping(@ts_web)
            assert(rs, "过滤失效后客户端不能连接外网")
            puts "过滤失效后PC1 TCP server connect".encode("GBK")
            client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            assert(client.tcp_state, "过滤失效后PC不能进行tcp连接")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            assert(wifi_rs, "过滤失效后WIFI客户端不能连接外网")
        }

        operate("6、点击下面按钮“使所有条目生效”，查看PC1、PC2能否访问PC3上面的FTP或HTTP服务器。") {
            @options_page.mac_all_valid_element.click #使所有条目生效
            sleep @tc_wait_time
            rs = ping(@ts_web)
            refute(rs, "过滤生效后客户端能连接外网")
            puts "过滤生效后PC1 TCP server connect".encode("GBK")
            client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(client.tcp_state, "过滤生效后PC能进行tcp连接")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            refute(wifi_rs, "过滤生效后WIFI客户端能连接外网")
        }

    end

    def clearup
        operate("1、恢复防火墙默认设置：关闭总开关并删除所有规则") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            options_page = RouterPageObject::OptionsPage.new(@browser)
            if options_page.login_with_exists(@browser.url)
                rs_login = login_no_default_ip(@browser) #重新登录
                p rs_login[:flag]
                p rs_login[:message]
            end
            options_page.macfilter_close_sw_del_all(@browser.url)
        }

        operate("2 恢复默认ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end

}
