#
# 路由器WAN设置
# author:liluping
# date:2016-02-24
# modify:
#
require './router_main_page'
module RouterPageObject
    ##定义WAN设置中的tag
    module Wan_Page
        include PageObject
        in_iframe(:src => @@ts_tag_netset_src) do |frame|
            span(:wire, :id => @@ts_tag_wired_mode_span, :frame => frame)                       ###网线连接
            link(:tab_ip, :id => @@ts_tag_wired_mode_link, :frame => frame)                         ##tab_name
            radio_button(:dhcp_dial, :id => @@ts_tag_wired_dhcp, :frame => frame)                   ##自动方式(DHCP)
            radio_button(:pppoe_dial, :id => @@ts_tag_wired_pppoe, :frame => frame)                 ##宽带拨号(PPPOE)
            text_field(:pppoe_user, :id => @@ts_tag_pppoe_usr, :frame => frame)                         #账号
            text_field(:pppoe_pwd, :id => @@ts_tag_pppoe_pw, :frame => frame)                           #密码
            checkbox(:show_pppoe_pwd, :id => @@ts_pwdshow, :frame => frame)                             #pppoe密码显示
            radio_button(:static_dial, :id => @@ts_tag_wired_static, :frame => frame)               ##手动方式(静态IP)
            text_field(:static_ip, :id => @@ts_wired_static_ip, :frame => frame)                        #IP地址
            text_field(:static_netmask, :id => @@ts_tag_staticNetmask, :frame => frame)                 #子网掩码
            text_field(:static_gateway, :id => @@ts_tag_staticGateway, :frame => frame)                 #网关地址
            text_field(:static_dns, :id => @@ts_tag_staticPriDns, :frame => frame)                      #DNS地址
            span(:wireless, :id => @@ts_wireless_id, :frame => frame)                           ###无线wifi
            radio_button(:repeater_pattern, :id => @@ts_tag_repeater_radio, :frame => frame)        ##中继模式
            radio_button(:bridge_pattern, :id => @@ts_tag_bridge_radio, :frame => frame)            ##桥接模式
            text_field(:wifi_name, :id => @@ts_dut_wifi_ssid, :frame => frame)                          #无线名称
            select_list(:security_type, :id => @@ts_tag_sec_select_list, :frame => frame)               #加密类型
            text_field(:wifi_pwd, :id => @@ts_dut_wifi_ssid_pwd, :frame => frame)                       #无线密码
            checkbox(:show_pwd, :id => @@ts_tag_showpwd, :frame => frame)                               #显示密码
            button(:scan_network, :id => @@ts_search_net, :frame => frame)                              #扫描网络
            select_list(:network_name, :id => @@ts_ssid_list, :frame => frame)                          #网络名称(ssid)
            text_field(:network_pwd, :id => @@ts_net_pwd, :frame => frame)                              #网络密码(ssid_pwd)
            checkbox(:show_network_pwd, :id => @@ts_pwdshow2, :frame => frame)                          #显示网络密码
            span(:dial_3g, :id => @@ts_tag_3g_mode_span, :frame => frame)                       ###3G/4G拨号
            radio_button(:dial_3g_auto, :id => @@ts_tag_3g_auto, :frame => frame)                   ##自动方式
            radio_button(:dial_3g_manual, :id => @@ts_tag_3g_hand_type, :frame => frame)            ##手动方式
            text_field(:dial_3g_manual_apn, :id => @@ts_tag_3g_handtype_apn, :frame => frame)           #APN
            text_field(:dial_3g_manual_pin, :id => @@ts_tag_3g_handtype_pin, :frame => frame)           #PIN
            text_field(:dial_3g_manual_num, :id => @@ts_tag_3g_handtype_num, :frame => frame)           #拨号号码
            text_field(:dial_3g_manual_user, :id => @@ts_tag_3g_handtype_user, :frame => frame)         #用户名
            text_field(:dial_3g_manual_pwd, :id => @@ts_tag_3g_handtype_pwd, :frame => frame)           #密码
            button(:save, :id => @@ts_remote_save_btn, :frame => frame)                         ###保存
            button(:cancel, :id => @@ts_tag_cancel, :frame => frame)                            ###取消
        end
    end

    class WanPage < MainPage
        include Wan_Page

        #pppoe连接输入
        def pppoe_input(user, pwd)
            self.pppoe_user = user
            self.pppoe_pwd  = pwd
        end

        #静态连接输入
        def static_input(ip, mask, gateway, dns)
            self.static_ip      = ip
            self.static_netmask = mask
            self.static_gateway = gateway
            self.static_dns     = dns
        end

        #3G/4G拨号输入
        def dial_3g_input(apn, pin, num, user, pwd)
            self.dial_3g_manual_apn = apn
            self.dial_3g_manual_pin = pin
            self.dial_3g_manual_num = num
            self.dial_3g_manual_user = user
            self.dial_3g_manual_pwd = pwd
        end

        #设置dhcp连接
        def set_dhcp
            wan_span_obj.click #点击WAN连接
            sleep 3
            flag = false
            unless tab_ip_element.class_name == @@ts_wire_mode_tab_cls_name #当前连接不是网线连接时
                wire_element.click #选择网线连接
                flag = true
            end
            unless dhcp_dial_element.selected? #当前网线连接方式不是DHCP时
                dhcp_dial_element.click #选择DHCP
                flag = true
            end
            if flag
                save #保存
                puts "Waiting for net reset..."
                sleep 30
            end
        end

        #设置pppoe连接
        def set_pppoe(user, pwd)
            wan_span_obj.click #点击WAN连接
            sleep 3
            wire_element.click #选择网线连接
            pppoe_dial_element.click #选择pppoe
            pppoe_input(user, pwd) #输入账号密码
            save #保存
            puts "Waiting for net reset..."
            sleep 30
        end

        #设置静态连接
        def set_static(ip, mask, gateway, dns)
            wan_span_obj.click #点击WAN连接
            sleep 3
            wire_element.click #选择网线连接
            static_dial_element.click #选择静态IP
            static_input(ip, mask, gateway, dns) #输入
            save #保存
            puts "Waiting for net reset..."
            sleep 30
        end

        #中继模式
        def set_repeater_pattern
            wan_span_obj.click #点击WAN连接
            sleep 3
            wireless_element.click #选择无线wifi连接
            repeater_pattern_element.click #选择中继模式
            #后续添加。。。
        end

        #桥接模式
        #参数ssid是上行AP的ssid, 参数pwd是上行AP的密码
        #返回值为false时表示未扫描到上行AP的ssid
        def set_bridge_pattern(ssid, pwd)
            # ssid_arr = []
            wan_span_obj.click #点击WAN连接
            sleep 3
            wireless_element.click #选择无线wifi连接
            bridge_pattern_element.click #选择桥接模式
            n         = 0
            ssid_flag = false
            until ssid_flag == true
                scan_network #扫描网络
                sleep 5
                ssid_arr  = network_name_options
                ssid_flag = true if ssid_arr.include?(ssid)
                n         += 1
                break if n == 10 #最多只查询10次
            end
            return false if ssid_flag == false #断言判断
            network_name_element.select(ssid) #选择上行AP的ssid
            if network_pwd?
                self.network_pwd = pwd #输入密码
                check_show_network_pwd #显示密码
            end
            save #保存
            puts "Waiting for net reset..."
            sleep 30
        end

        #设置3G/4G自动拨号
        def set_3g_auto_dial
            wan_span_obj.click #点击WAN连接
            sleep 3
            dial_3g_element.click #选择3G/4G拨号
            dial_3g_auto_element.click #选择自动方式
            save #保存
            puts "Waiting for net reset..."
            sleep 30
        end

        #设置3G/4G手动拨号
        def set_3g_hand_dial(apn, pin, num, user, pwd)
            wan_span_obj.click #点击WAN连接
            sleep 3
            dial_3g_element.click #选择3G/4G拨号
            dial_3g_manual_element.click #选择手动方式
            dial_3g_input(apn, pin, num, user, pwd) #输入
            save #保存
            puts "Waiting for net reset..."
            sleep 30
        end
    end


end

if __FILE__==$0
    url      = "192.168.100.1"
    user     = "admin"
    pwd      = "admin"
    @browser = Watir::Browser.new :firefox
    operate  = RouterPageObject::WanPage.new(@browser)
    operate.navigate_to(url)
    operate.login_with(user, pwd)
    # operate.wan_span_obj.click
    # operate.set_pppoe("pppoe", "pppoe")
    # operate.set_bridge_pattern("wifitest_autotest", "zhilutest")
    operate.set_3g_dial
end