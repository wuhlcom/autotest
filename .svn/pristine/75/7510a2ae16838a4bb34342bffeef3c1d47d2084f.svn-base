#
# description:
#产品有bug
# 未限制MAC过滤条数
# 规则无法真正删除
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_28.1.5", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_server)
        @ts_download_directory.gsub!("\\", "\/")
        @tc_file_name    = "config.tgz"
        @tc_wait_time    = 3
        @tc_mac_error    = "规则最多16条"
        @tc_firewall_on  = "on"
        @tc_firewall_off = "off"
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

            @wifi_page     = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi        = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @tc_ssid1_name = rs_wifi[:ssid]
            @tc_pwd1_name  = rs_wifi[:pwd]
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2连接dut无线
            p "PC2连接wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@tc_ssid1_name, flag, @tc_pwd1_name, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败")
            wifi_rs = @tc_dumpcap_pc2.ping(@ts_web)
            assert(wifi_rs, "WIFI客户端无法连接外网")
        }

        operate("2、添加基于的MAC地址过滤规则，32条规则都添加完（运行设置的规则总数目），其中有两条是PC1、PC2的MAC地址，保存配置；") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch(@tc_firewall_on, @tc_firewall_off, @tc_firewall_on, @tc_firewall_off)
            @options_page.macfilter_click
            @options_page.mac_filter_add #新增条目
            puts "PC MAC address : #{@ts_pc_mac}"
            @options_page.mac_filter_input(@ts_pc_mac, @ts_nicname) #输入，状态默认为生效
            @options_page.mac_filter_save
            #添加无线客户端过滤条件
            wifi           = @tc_dumpcap_pc2.ipconfig(@ts_ipconf_all)
            wifi_mac       = wifi[@ts_wlan_nicname][:mac]
            @wifi_mac_addr = wifi_mac.gsub("-", ":")
            puts "Wireless PC MAC address : #{@wifi_mac_addr}"
            @options_page.mac_filter_add #新增条目
            @options_page.mac_filter_input(@wifi_mac_addr, @ts_wlan_nicname)
            @options_page.mac_filter_save

            #添加无线客户端过滤条件
            tc_mac  = "00:11:22:33:44:00"
            tc_desc = "00"
            i       = 3
            14.times do
                puts "添加第#{i}条MAC地址规则，MAC地址为#{tc_mac}".encode("GBK")
                @options_page.mac_filter_add #新增条目
                @options_page.mac_filter_input(tc_mac, tc_desc)
                @options_page.mac_filter_save
                tc_mac = tc_mac.succ
                tc_desc=tc_desc.succ
                i      +=1
                sleep 1
            end
            puts "添加第17条MAC地址规则".encode("GBK")
            @options_page.mac_filter_add #新增条目
            error_tip = @options_page.mac_items_max_element
            assert(error_tip.exists?, "未出现异常提示~")
            error_text = @options_page.mac_items_max
            puts "ERROR TIP:#{error_text}".encode("GBK")
            assert_equal(@tc_mac_error, error_text, "提示内容错误~")
            @options_page.mac_hint_close #关闭提示框

            puts "PC1 TCP server connect"
            wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(wired_client.tcp_state, "过滤PC1 #{@ts_pc_mac}，PC1进行TCP连接成功")
            puts "PC2 TCP server connect"
            wireless_client = @tc_dumpcap_pc2.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(wireless_client.tcp_state, "过滤PC2 #{@tc_wifi_mac}，PC2进行TCP连接成功")
        }

        operate("3、重启AP，查看设备有无丢配置等异常现象；") {
            @options_page.reboot
            login_ui = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "重启后未跳转到登录界面~")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("4、PC1和PC2能否访问PC3的FTP或访问外网是否成功；") {
            puts "PC1 TCP server connect"
            wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(wired_client.tcp_state, "过滤PC1 #{@ts_pc_mac}，PC1进行TCP连接成功")
            puts "PC2 TCP server connect"
            wireless_client = @tc_dumpcap_pc2.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(wireless_client.tcp_state, "过滤PC2 #{@tc_wifi_mac}，PC2进行TCP连接成功")
        }

        operate("5、将配置文件保存为文件1，进行复位操作，再将配置文件1导入设备，检查导入是否正确，PC1和PC2能否访问PC3的FTP或访问外网是否成功。") {
            #判断当前下载目录是否有配置文件，如果有则将其重命名
            config_file_old = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
            unless config_file_old.nil?
                puts "删除旧的配置文件:#{config_file_old}".encode("GBK")
                File.delete(config_file_old)
            end

            #导出配置文件
            @options_page.export_file_step(@browser, @browser.url)
            config_download = Dir.glob(@ts_download_directory+"/*").any? { |file| file=~/#{@tc_file_name}$/ }
            assert(config_download, "MAC过滤配置文件下载失败！")
        }

        operate("6、导出配置文件后恢复路由器为出厂设置") {
            @options_page.recover_click
            login_ui = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "恢复出厂设置后未跳转到路由器登录页面~")
        }

        operate("7、恢复出厂设置后重新登录,查看MAC过滤规则是否被删除") {
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            fwstatus = @options_page.firewall_switch_element.class_name
            assert_equal(@tc_firewall_off, fwstatus, "恢复出厂设置后防火墙总未关闭")
            mac_status = @options_page.mac_filter_switch_element.class_name
            assert_equal(@tc_firewall_off, mac_status, "恢复出厂设置后MAC过滤开关未关闭")
            #查看有线客户端mac过滤设置是否成功
            #表格如果只有一行标题行tr则表示所有规则被删除
            @options_page.macfilter_click
            table_tr = @options_page.mac_filter_table_element.element.trs.size
            assert_equal(1, table_tr, "恢复出厂设置后MAC过滤规则未删除")
        }

        operate("8、导入配置文件") {
            config_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
            #如果找不到升级文件
            refute(config_file.nil?, "配置文件不存")
            #导入配置文件
            @options_page.import_file_step(@browser.url, config_file)
            login_ui = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "导入配置文件后未跳转到路由器登录页面~")
            #重新登录路由器
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("9、导入配置文件后PC1和PC2访问外网是否成功；") {
            puts "PC1 TCP server connect"
            wired_client = HtmlTag::TestTcpClient.new(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(wired_client.tcp_state, "过滤PC1 #{@ts_pc_mac}，PC1进行TCP连接成功")
            puts "PC2 TCP server connect"
            wireless_client = @tc_dumpcap_pc2.tcp_client(@ts_tcp_server, @ts_tcp_port_dhcp)
            refute(wireless_client.tcp_state, "过滤PC2 #{@tc_wifi_mac}，PC2进行TCP连接成功")
        }

        operate("10 导入配置文件后查看防火墙开关和MAC过滤配置是否正常") {
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            fwstatus = @options_page.firewall_switch_element.class_name
            assert_equal(@tc_firewall_on, fwstatus, "导入配置后防火墙总开关被关闭")
            mac_status = @options_page.mac_filter_switch_element.class_name
            assert_equal(@tc_firewall_on, mac_status, "导入配置后MAC过滤开关被关闭")
            #查看有线客户端mac过滤设置是否成功
            @options_page.macfilter_click
            table_tr = @options_page.mac_filter_table_element.element.trs.size
            assert_equal(17, table_tr, "导入配置文件后MAC过滤规则未恢复~")
        }

    end

    def clearup

        operate("1、恢复防火墙默认设置：关闭总开关并删除所有规则") {
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
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
