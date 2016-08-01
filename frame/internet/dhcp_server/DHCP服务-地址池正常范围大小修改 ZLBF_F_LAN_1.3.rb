#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_8.1.3", "level" => "P1", "auto" => "n"}

    def prepare
        DRb.start_service
        @wifi                = DRbObject.new_with_uri(@ts_drb_server)
        @tc_wait_time        = 2
        @tc_wireless_client  = 5
        @tc_default_lan_start= "100"
        @tc_default_lan_end  = "200"
        @tc_lan_start1       = "80"
        @tc_lan_end1         = "90"
    end

    def process

        operate("1 打开内网设置") {
        }

        operate("2 连接路由器wifi") {
            @wifi_page  = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi     = @wifi_page.modify_ssid_mode_pwd(@browser.url, @ts_wifi_ssid1)
            @wifi_ssid1 = rs_wifi[:ssid]
            @wifi_pw    = rs_wifi[:pwd]
            puts "当前SSID1名为#{@wifi_ssid1}".to_gbk
            puts "当前SSID1 加密方式为#{@wifi_page.ssid1_pwmode}".to_gbk
            puts "WIFI密码为：#{@wifi_pw}".to_gbk
            rs1 = @wifi.connect(@wifi_ssid1, @ts_wifi_flag, @wifi_pw)
            assert rs1, 'WIFI连接失败'
            rs2 = @wifi.ping(@ts_default_ip)
            assert rs2, 'WIFI客户端无法ping通路由器'
        }

        operate("3 修改DHCP地址池范围") {
            @lan_page = RouterPageObject::LanPage.new(@browser)
            @lan_page.open_lan_page(@browser.url)
            @tc_lan_start_pre = @lan_page.lan_startip_pre
            @tc_lan_startip1  = @tc_lan_start_pre+@tc_lan_start1
            @tc_lan_end_pre   = @lan_page.lan_endip_pre
            @tc_lan_endip1    =@tc_lan_end_pre+@tc_lan_end1
            puts "修改地址池范围为 #{@tc_lan_startip1}-#{@tc_lan_endip1}".to_gbk
            @lan_page.lan_startip_set(@tc_lan_start1)
            @lan_page.lan_endip_set(@tc_lan_end1)
            @lan_page.btn_save_lanset
        }

        operate("4 修改地址池后重新获取IP地址") {
            ip_flag=false
            ip_release(@ts_nicname)
            ip_renew(@ts_nicname)
            3.times do |i|
                ip_info = ipconfig()
                sleep @tc_wireless_client
                ipaddr =ip_info[@ts_nicname][:ip]
                p "修改地址池后第#{i+1}次查询#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
                unless ipaddr.empty?
                    ip_flag = ipaddr[0]>=@tc_lan_startip1 && ipaddr[0]<=@tc_lan_endip1
                end
                break if ip_flag
            end
            assert ip_flag, "修改地址池后,路由器重启,客户端未获得新地址池地址"

            @wifi.ip_release(@ts_wlan_nicname)
            @wifi.ip_renew(@ts_wlan_nicname)
            wip_flag=false
            3.times do |i|
                wip_info =@wifi.ipconfig()
                sleep @tc_wireless_client
                wipaddr =wip_info[@ts_wlan_nicname][:ip]
                p "修改地址池后第#{i+1}次查询#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
                unless wipaddr.empty?
                    wip_flag = wipaddr[0]>=@tc_lan_startip1 && wipaddr[0]<=@tc_lan_endip1
                end
                break if wip_flag
            end
            assert wip_flag, "修改地址池后,路由器重启后,wifi客户端未获得新地址池地址"
        }

        operate("5 重启路由器") {
            @lan_page.reboot
            @login_page = RouterPageObject::LoginPage.new(@browser)
            login_ui    = @login_page.login_with_exists(@browser.url)
            assert(login_ui, "重启后未跳转到登录页面！")
        }

        operate("6,路由器重启后验证客户端是否获取ip地址") {
            ip_flag=false
            3.times do |i|
                ip_info = ipconfig()
                sleep @tc_wireless_client
                ipaddr =ip_info[@ts_nicname][:ip]
                p "路由器重启后第#{i+1}次查询#{@ts_nicname} ip: #{ipaddr.join(",")}".to_gbk
                unless ipaddr.empty?
                    ip_flag = ipaddr[0]>=@tc_lan_startip1 && ipaddr[0]<=@tc_lan_endip1
                end
                break if ip_flag
            end
            assert ip_flag, "修改地址池后,路由器重启,客户端未获得新地址池地址"

            wip_flag=false
            3.times do |i|
                wip_info =@wifi.ipconfig()
                sleep @tc_wireless_client
                wipaddr =wip_info[@ts_wlan_nicname][:ip]
                p "路由器重启后第#{i+1}次查询#{@ts_wlan_nicname} ip: #{wipaddr.join(",")}".to_gbk
                unless wipaddr.empty?
                    wip_flag = wipaddr[0]>=@tc_lan_startip1 && wipaddr[0]<=@tc_lan_endip1
                end
                break if wip_flag
            end
            assert wip_flag, "修改地址池后,路由器重启后,wifi客户端未获得新地址池地址"
        }
    end

    def clearup

        operate("1 恢复默认地址池") {
            @wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
            sleep @tc_wireless_client
            p "断开WIFI连接".to_gbk
            @wifi.netsh_disc_all #断开wifi连接
            sleep @tc_wait_time
            ping_test = ping(@ts_default_ip)
            unless ping_test
                netsh_if_ip_setip(@tc_static_args)
            end

            @browser.refresh
            @lan_page = RouterPageObject::LanPage.new(@browser)
            if @lan_page.login_with_exists(@browser.url)
                @lan_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)
            end

            @lan_page.open_lan_page(@browser.url)
            @tc_lan_startnum = @lan_page.lan_startip
            @tc_lan_endnum   = @lan_page.lan_endip
            flag_start       = @tc_lan_startnum==@tc_default_lan_start
            flag_end         = @tc_lan_endnum==@tc_default_lan_end

            unless flag_start&&flag_end
                puts "DHCP地址池恢复默认值".to_gbk if flag_start&&flag_end
                @lan_page.lan_startip_set(@tc_default_lan_start)
                @lan_page.lan_endip_set(@tc_default_lan_end)
                @lan_page.btn_save_lanset
            end
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            @wifi_page.modify_default_ssid(@browser.url, @ts_wifi_ssid1)
        }

        operate("2 恢复网卡状态") {
            rs = @wifi.netsh_if_shif(@ts_wlan_nicname)
            if rs[:admin_state]=="disabled"
                @wifi.netsh_if_setif_admin(@ts_wlan_nicname, "enabled")
            end
        }

    end

}
