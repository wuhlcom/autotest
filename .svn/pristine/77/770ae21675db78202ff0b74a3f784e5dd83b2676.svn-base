#
# description:
# author:liluping
# date:2015-10-10 11:38:55
# modify:
#
testcase {
    attr = {"id" => "ZLRM_1.1.21", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_connect_time        = 60
        @tc_reboot_time              = 90
        @tc_wait_time                = 3
        @tc_search_ssid_wait_time    = 10
        @tc_wait_web_respond_time    = 10
        @tc_net_start_wait_time      = 20
        @tc_net_wait_time            = 60
        @tc_ap_login_btn      = "loginBtn"
        @tc_ap_wireless       = "d_wlan_basic.asp"
        @tc_wireless_id       = "wireless"
        @tc_relay_id          = "mode-relay"
        @tc_search_net        = "ssid_reflash"
        @tc_ssid_list         = "ssid_list"
        @tc_net_status        = "setstatus"
        @tc_ap_maintain       = "d_reboot.asp"
        @tc_net_pwd           = "input_password3"
        @tc_ap_status         = "d_status.asp"
        @tc_main_content      = "maincontent"
        @tc_ap_reboot         = "reboot"
        @tc_ap_status         = "d_status.asp"
        @tc_main_content      = "maincontent"

        @tc_tag_wan_mode_link        = "tab_ip"
        @tc_select_state             = "selected"
        @tc_tag_wan_mode_span        = "wire"
        @tc_tag_wire_mode_radio_dhcp = "ip_type_dhcp"
        @tc_dut_ssid                 = "WIFI_039E99"
        @default_ssid_pwd            = "12345678"
    end

    def process
        operate("0、获取dut的ssid及密码") {
            @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_lan).click
            @wan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@wan_iframe.exists?, "打开内网设置失败！")
            @dut_ssid = @wan_iframe.text_field(id: @ts_tag_ssid).value
            p "DUT的ssid -> #{@dut_ssid}".to_gbk
            @dut_ssid_pwd = @wan_iframe.text_field(id: @ts_tag_ssid_pwd).value
            p "DUT的无线密码 -> #{@dut_ssid_pwd}".to_gbk
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("1、扫描上行AP后，连接到其中一个AP") {
            @browser1 = Watir::Browser.new :ff, :profile => "default"
            @browser1.goto(@ts_tag_ap_url) #进入到登录界面

            @browser1.button(id: @tc_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @tc_ap_status).click #进入状态模块
            sleep @tc_wait_time
            @ap_lan_ip = @ap_frame.div(id: @tc_main_content).tables[3].trs[1][0].tables[0].trs[0][1].text
            p "AP的LAN侧ip：#{@ap_lan_ip}".to_gbk
            assert(!@ap_lan_ip.nil?, "AP的LAN侧ip读取失败！")
            @ap_frame.link(href: @tc_ap_wireless).click #进入无线2.4G模块
            #获取ssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            # #获取ssid密码
            if @ap_frame.text_field(name: "pskValue").exists?
                @ssid_pwd = @ap_frame.text_field(name: "pskValue").value
                p "APssid_pwd --> #{@ssid_pwd}"
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #登录后刷新浏览器
            end
            5.times do #循环5次打开外网界面
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @tc_wireless_id).exists?
                @browser.refresh #刷新浏览器
            end
            @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @tc_wireless_id).click #无线连接
            @wan_iframe.label(id: @ts_bridge_id).click #选择桥接模式
            @dut_ssid = @wan_iframe.text_field(id: @tc_dut_wifi_ssid).value
            p "DUTssid --> #{@dut_ssid}".to_gbk
            @dut_ssid_pwd = @wan_iframe.text_field(id: @tc_dut_wifi_ssid_pwd).value
            p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
            ssid_flag = false
            n         = 0
            until ssid_flag == true
                arr_option = []
                begin
                    @wan_iframe.button(id: @ts_search_net).wait_until_present(@tc_search_ssid_wait_time)
                    @wan_iframe.button(id: @ts_search_net).click #点击扫描网络
                rescue #扫描ssid时出现异常，如扫描网络时一直在转圈圈，刷新浏览器重试
                    @browser.refresh #刷新浏览器
                    @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                    @browser.span(id: @ts_tag_netset).click
                    @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                    @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
                    @wan_iframe.span(id: @tc_wireless_id).click #无线连接
                    @wan_iframe.label(id: @ts_relay_id).click #选择中继模式
                    @wan_iframe.button(id: @ts_search_net).wait_until_present(@tc_search_ssid_wait_time)
                    @wan_iframe.button(id: @ts_search_net).click #点击扫描网络
                end
                sleep @tc_wait_time
                select_click = @wan_iframe.select_list(id: @ts_ssid_list)
                options      = select_click.options #下拉框里面的值的对象
                options.each do |item|
                    arr_option << item.value #下拉框里面的值
                end
                n         += 1
                ssid_flag = true if arr_option.include?(@ssid)
                break if n == 5 #最多只查询5次ssid
            end
            assert(ssid_flag, "未扫描到ap的ssid->#{@ssid}")
            select_click.select(@ssid) #选择ap的ssid
            select_pwd_click = @wan_iframe.text_field(id: @tc_net_pwd)
            if select_pwd_click.exists?
                select_pwd_click.set(@ssid_pwd) #输入ap的ssid密码
                @wan_iframe.checkbox(id: @ts_pwdshow2).click #显示密码
            end
            @wan_iframe.button(id: @ts_tag_sbm).click #保存
            sleep @tc_wait_time
            net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                net_reset_div.present?
            }
            sleep @tc_net_start_wait_time #桥接上后，等待一段时间再查看跟陪测AP是否关联成功
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "查看状态".to_gbk
            5.times do
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @status_iframe.b(id: @tag_wan_ip).wait_until_present(@tc_net_wait_time)
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                    @browser.refresh #刷新浏览器
                else #如果出现白板
                    @dut_wan_ip #定义
                    @browser.refresh #刷新浏览器
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，关联失败！".to_gbk)

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、重启上行AP，检查重启后DUT是否能再次自动连接到上行AP") {
            require 'selenium-webdriver' #处理重启时弹出的alert框，需要模拟点击确定按钮
            @browser1.goto(@ts_tag_ap_url) #进入到登录界面
            @browser1.button(id: @tc_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @tc_ap_maintain).click #进入维护模块
            sleep @tc_wait_time
            @ap_frame.button(name: @tc_ap_reboot).click #点击重启
            #在alert弹出框中，模拟点击确定按钮
            key_obj = @ap_frame.driver.switch_to.alert
            key_obj.accept

            assert(@ap_frame.text_field(name: "time").exists?, "重启失败！")
            sleep @tc_reboot_time
            p "重启完毕，等待60s后，查看DUT是否能再次自动连接到上行AP...".to_gbk
            sleep @tc_wait_connect_time

            5.times do
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @status_iframe.b(id: @tag_wan_ip).wait_until_present(@tc_net_wait_time)
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                    @browser.refresh #刷新浏览器
                else #如果出现白板
                    @dut_wan_ip #定义
                    @browser.refresh #刷新浏览器
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，关联失败！".to_gbk)
        }


    end

    def clearup
        operate("恢复默认配置") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end

            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe

            flag = false
            #设置wan连接方式为网线连接
            rs1  = @wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
            unless rs1 =~/ #{@tc_select_state}/
                @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
                flag = true
            end

            #查询是否为为dhcp模式
            dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio_dhcp)
            dhcp_radio_state = dhcp_radio.checked?

            #设置WIRE WAN为DHCP模式
            unless dhcp_radio_state
                dhcp_radio.click
                flag = true
            end

            if flag
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "Waiting for net reset..."
                sleep @tc_net_wait_time
            end

            #恢复dut路由器的ssid
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            sleep @tc_wait_time
            unless @lan_iframe.text_field(id: @ts_tag_ssid, name: @ts_tag_ssid).value == @dut_ssid
                @lan_iframe.text_field(id: @ts_tag_ssid, name: @ts_tag_ssid).set(@dut_ssid)
                @lan_iframe.select_list(id: @ts_tag_sec_select_list).select(@ts_sec_mode_wpa)
                @lan_iframe.text_field(id: @ts_tag_input_pw).set(@dut_ssid_pwd)
                @lan_iframe.button(id: @ts_tag_sbm).click #保存
                sleep @tc_net_wait_time
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @browser1.close
        }
    end

}
