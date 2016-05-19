#encoding:utf-8
#
# 陪测路由(上行AP)
# author:liluping
# date:2016-04-06
# modify:
#
file_path1 =File.expand_path('../router_tag_value', __FILE__)
require file_path1
module RouterPageObject
    module Accompany_Router
        include PageObject

        in_frame(:src => @@ts_tag_ap_src) do |frame|
            button(:login_btn, id: @@ts_ap_login_btn) #登录
            #无线2.4G
            link(:ap_wireless_24g, href: @@ts_ap_wireless, frame: frame)
            select_list(:ap_wireless_mode, name: @@ts_ap_wireless_pattern, frame: frame) #无线模式
            select_list(:ap_wireless_channel, name: @@ts_ap_channel, frame: frame) #无线信道
            select_list(:ap_wireless_bandwidth, name: @@ts_ap_bandwidth, frame: frame) #无线带宽
            select_list(:ap_wireless_safe_option, id: @@ts_ap_safe_option, frame: frame) #安全选项
            text_field(:ap_ssid, name: @@ts_tag_ap_ssid_name, frame: frame) #ssid
            text_field(:ap_pwd, name: @@ts_tag_ap_ssid_pwd, frame: frame) #pwd
            button(:ap_save, name: @@ts_tag_ap_save, frame: frame) #保存

            #状态
            link(:ap_status, href: @@ts_ap_status, frame: frame)
            div(:main_content, id: @@ts_main_content, frame: frame)

            #维护
            link(:ap_maintain, href: @@ts_ap_maintain, frame: frame)
            button(:ap_reboot_btn, name: @@ts_ap_maintain_reboot, frame: frame) #重启
        end
    end

    class AccompanyRouter
        include Accompany_Router

        #登录AP
       def login_accompany_router(url)
           self.navigate_to url
           # browser.refresh
           sleep 1
           login_btn
           sleep 2
       end

        #进入状态界面
        def open_status_page
            ap_status
            sleep 1
        end

        #进入无线2.4G界面
        def open_wireless_24g_page
            ap_wireless_24g
            sleep 1
        end

        #进入状态界面
        def open_maintain_page
            ap_maintain
            sleep 1
        end

        #保存
        def ap_save_config(time=15)
            ap_save
            puts "sleep #{time} seconds for saving..."
            sleep time
        end

        #无线2.4G配置输入
        def input_24g_options(mode, channel, bandwidth, safe)
            self.ap_wireless_mode = mode
            self.ap_wireless_channel = channel
            self.ap_wireless_bandwidth = bandwidth
            self.ap_wireless_safe_option = safe
        end

        #无线2.4G配置
        def wireless_24g_options(mode="802.11b/g/n", channel="6", bandwidth="Auto 20/40M", safe="WPA-PSK(TKIP)")
            open_wireless_24g_page
            input_24g_options(mode, channel, bandwidth, safe)
            sleep 1
            ap_save_config
        end

        #获取AP局域网IP地址
        def get_lan_ip
            open_status_page
            main_content_element.element.tables[3].trs[1][0].tables[0].trs[0][1].text
        end

        #修改信道步骤
        def modify_channel(channel)
            open_wireless_24g_page
            sleep 1
            self.ap_wireless_channel = channel
            sleep 1
            ap_save_config
        end

        #浏览器alter弹窗，点击确定按钮
        def alter_btn(browserobj, src_name=@@ts_tag_ap_src)
            require 'selenium-webdriver'
            frame   = browserobj.frame(src: src_name)
            key_obj = frame.driver.switch_to.alert
            key_obj.accept
        end

        #AP重启步骤
        def ap_reboot(browserobj, url, time=90)
            login_accompany_router(url)
            open_maintain_page
            # ap_reboot_btn #不知为何不能直接使用
            ap_reboot_btn_element.click
            sleep 1
            alter_btn(browserobj)
            p "sleep #{time} seconds for rebooting..."
            sleep time
        end
    end
end