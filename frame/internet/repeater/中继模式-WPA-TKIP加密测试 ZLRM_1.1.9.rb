#
# description:
# author:liluping
# date:2015-10-10 11:38:55
# modify:
#
testcase {
    attr = {"id" => "ZLRM_1.1.9", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2                    = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time                      = 3
        @tc_search_ssid_wait_time          = 10
        @tc_wait_web_respond_time          = 10
        @tc_net_start_wait_time            = 20
        @tc_net_wait_time                  = 60
        @tc_reboot_wait_time               = 120
        @tc_ap_login_btn                   = "loginBtn"
        @tc_ap_wireless                    = "d_wlan_basic.asp"
        @tc_ap_wireless_pattern            = "band"
        @tc_ap_wireless_pattern_value      = "802.11b/g/n"
        @tc_ap_wireless_pattern_b_g        = "802.11b/g"
        @tc_ap_wireless_pattern_b          = "802.11b"
        @tc_ap_channel                     = "chan"
        @tc_ap_channel_value               = "1"
        @tc_ap_channel_value_6             = "6"
        @tc_ap_channel_value_11            = "11"
        @tc_ap_bandwidth                   = "chanwid"
        @tc_ap_bandwidth_value             = "Auto 20/40M"
        @tc_ap_bandwidth_value_other       = "20M"
        @tc_ap_safe_option                 = "methodSel"
        @tc_ap_safe_option_value           = "WPA-PSK(TKIP)"
        @tc_ap_save_hint                   = "loading"
        @tc_ap_status                      = "d_status.asp"
        @tc_main_content                   = "maincontent"
        @tc_tag_link_error                 = "errorTitleText"
        @tc_wireless_id                    = "wireless"
        @tc_relay_id                       = "mode-relay"
        @tc_search_net                     = "ssid_reflash"
        @tc_network_name                   = "network-name"
        @tc_ssid_list                      = "ssid_list"
        @tc_net_pwd                        = "input_password3"
        @tc_net_status                     = "setstatus"
        @tc_tag_wan_mode_link              = "tab_ip"
        @tc_select_state                   = "selected"
        @tc_tag_wan_mode_span              = "wire"
        @tc_tag_wire_mode_radio_dhcp       = "ip_type_dhcp"
        @ap_channel_auto                   = "6"
        @ap_safe_option_default_value      = "无"
        @ap_wireless_pattern_default_value = "802.11b/g/n"
        @ap_bandwidth_default_value        = "Auto 20/40M"


    end

    def process
        operate("0、获取dut的ssid及密码，恢复默认ssid用") {
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

        operate("1、陪测AP使用Atheros方案并接入Internet，无线模式为b/g/n，信道指定为CH1，频宽设置为40M频宽，加密为WPA-TKIP；") {
            @browser1 = Watir::Browser.new :ff, :profile => "default"
            @browser1.goto(@ts_tag_ap_url) #进入到登录界面

            @browser1.button(id: @ts_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)

            @ap_frame.link(href: @tc_ap_status).click #进入状态模块
            sleep @tc_wait_time
            @ap_lan_ip = @ap_frame.div(id: @tc_main_content).tables[3].trs[1][0].tables[0].trs[0][1].text
            p "AP的LAN侧ip：#{@ap_lan_ip}".to_gbk
            assert(!@ap_lan_ip.nil?, "AP的LAN侧ip读取失败！")
            @ap_frame.link(href: @tc_ap_wireless).click #进入无线2.4G模块

            select_pattern = @ap_frame.select_list(name: @tc_ap_wireless_pattern) #选择无线模式
            select_pattern.wait_until_present(@tc_wait_time)
            select_pattern.select(@tc_ap_wireless_pattern_value)

            select_channel = @ap_frame.select_list(name: @tc_ap_channel) #选择信道
            select_channel.wait_until_present(@tc_wait_time)
            select_channel.select(@tc_ap_channel_value)

            select_bandwidth = @ap_frame.select_list(name: @tc_ap_bandwidth) #选择带宽
            select_bandwidth.wait_until_present(@tc_wait_time)
            select_bandwidth.select(@tc_ap_bandwidth_value)

            select_safe_option = @ap_frame.select_list(id: @tc_ap_safe_option) #选择安全选项
            select_safe_option.wait_until_present(@tc_wait_time)
            select_safe_option.select(@tc_ap_safe_option_value)

            #获取ssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            #获取ssid密码
            @ssid_pwd = @ap_frame.text_field(name: "pskValue").value
            p "APssid_pwd --> #{@ssid_pwd}"
            @ap_frame.button(name: @ts_tag_ap_save).click #应用按钮

            loading_div = @ap_frame.div(id: @tc_ap_save_hint)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                loading_div.present?
            }
        }

        operate("2、PC1设置与DUT同一网段的固定IP，登录DUT扫描到陪测AP的SSID并进行连接，检查DUT是否能与陪测AP关联成功；") {
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #登录后刷新浏览器
            end
            5.times do #循环5次打开外网界面
                @browser.refresh #刷新浏览器
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @tc_wireless_id).exists?
            end
            @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @tc_wireless_id).click #无线连接
            @wan_iframe.label(id: @tc_relay_id).click #选择中继模式
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
                    @wan_iframe.label(id: @tc_relay_id).click #选择中继模式
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
                break if n == 10 #最多只查询5次ssid
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
            sleep @tc_net_start_wait_time #中继上后，等待一段时间再查看跟陪测AP是否关联成功
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "查看状态".to_gbk
            5.times do
                @browser.refresh #刷新浏览器
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #如果出现白板
                    @dut_wan_ip #定义
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，关联失败！".to_gbk)
        }

        operate("3、PC1地址获取方式设置为自动获取，检查PC1是否能通过DUT获取到陪测AP派发的地址，是否能访问外网，PC2通过无线连接到DUT，检查是否能成功获取地址，是否能正常访问外网；") {
            sleep @tc_net_start_wait_time #更改dhcp后等待获取到地址
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "PC1访问外网#{@ts_web}...".to_gbk
            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网#{@ts_web}".to_gbk)
            #pc2连接dut无线
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)
            p "PC2访问外网#{@ts_web}...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            unless judge_link_pc2
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                rs = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
                assert(rs, "PC2 wifi连接失败".to_gbk)
                judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            end
            assert(judge_link_pc2, "PC2无法访问外网#{@ts_web}".to_gbk)
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
        }

        operate("4、断电重启DUT，检查PC1、PC2是否依然能成功获取地址，是否能正常访问外网；") {
            @browser.span(id: @ts_tag_reboot).parent.click #点击重启按钮
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_reboot_wait_time
            #重新登录
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "重启成功，再次登录！".to_gbk
            else
                assert(login_ui, "重启失败，请定位后重试！")
            end
            login_no_default_ip(@browser) #登录
            5.times do
                @browser.refresh #刷新浏览器
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #如果出现白板
                    @dut_wan_ip #定义
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "重启后DUT与陪测AP不在同一网段，关联失败！".to_gbk)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            sleep @tc_net_start_wait_time
            p "PC1访问外网...".to_gbk
            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "重启后PC1无法访问外网#{@ts_web}".to_gbk)
            #pc2连接dut无线
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "重启后PC2 wifi连接失败".to_gbk)
            p "PC2访问外网...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            unless judge_link_pc2
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                rs = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
                assert(rs, "PC2 wifi连接失败".to_gbk)
                judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            end
            assert(judge_link_pc2, "重启后PC2无法访问外网#{@ts_web}".to_gbk)
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
        }

        operate("5、在步骤1的基础上将陪测AP的频宽设置为20M，重复步骤2~4；") {
            @browser1.goto(@ts_tag_ap_url) #进入到AP登录界面
            @browser1.button(id: @tc_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @tc_ap_wireless).click #进入无线2.4G模块
            select_bandwidth = @ap_frame.select_list(name: @tc_ap_bandwidth) #选择带宽
            select_bandwidth.wait_until_present(@tc_wait_time)
            select_bandwidth.select(@tc_ap_bandwidth_value_other)
            #获取ssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            #获取ssid密码
            @ssid_pwd = @ap_frame.text_field(name: "pskValue").value
            p "APssid_pwd --> #{@ssid_pwd}"
            @ap_frame.button(name: @ts_tag_ap_save).click #应用按钮
            loading_div = @ap_frame.div(id: @tc_ap_save_hint)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                loading_div.present?
            }
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #登录后刷新浏览器
            end
            5.times do #循环5次打开外网界面
                @browser.refresh #刷新浏览器
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @tc_wireless_id).exists?
            end
            @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @tc_wireless_id).click #无线连接
            @wan_iframe.label(id: @tc_relay_id).click #选择中继模式

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
                    @wan_iframe.label(id: @tc_relay_id).click #选择中继模式
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
                break if n == 10 #最多只查询5次ssid
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
            sleep @tc_net_start_wait_time #中继上后，等待一段时间再查看跟陪测AP是否关联成功
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "查看状态".to_gbk
            5.times do
                @browser.refresh #刷新浏览器
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #如果出现白板
                    @dut_wan_ip #定义
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，关联失败！".to_gbk)
            sleep @tc_net_start_wait_time #更改dhcp后等待获取到地址
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "PC1访问外网#{@ts_web}...".to_gbk
            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网#{@ts_web}".to_gbk)
            #pc2连接dut无线
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)
            p "PC2访问外网#{@ts_web}...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            unless judge_link_pc2
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                rs = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
                assert(rs, "PC2 wifi连接失败".to_gbk)
                judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            end
            assert(judge_link_pc2, "PC2无法访问外网#{@ts_web}".to_gbk)
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接

            @browser.span(id: @ts_tag_reboot).parent.click #点击重启按钮
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_reboot_wait_time
            #重新登录
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "重启成功，再次登录！".to_gbk
            else
                assert(login_ui, "重启失败，请定位后重试！")
            end
            login_no_default_ip(@browser) #登录
            5.times do
                @browser.refresh #刷新浏览器
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #如果出现白板
                    @dut_wan_ip #定义
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "重启后DUT与陪测AP不在同一网段，关联失败！".to_gbk)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            sleep @tc_net_start_wait_time
            p "PC1访问外网...".to_gbk
            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "重启后PC1无法访问外网#{@ts_web}".to_gbk)
            #pc2连接dut无线
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "重启后PC2 wifi连接失败".to_gbk)
            p "PC2访问外网...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            unless judge_link_pc2
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                rs = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
                assert(rs, "PC2 wifi连接失败".to_gbk)
                judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            end
            assert(judge_link_pc2, "重启后PC2无法访问外网#{@ts_web}".to_gbk)
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
        }

        operate("6、将陪测AP的无线模式设置为b/g模式，信道设置为CH6重复步骤2~4；") {
            @browser1.goto(@ts_tag_ap_url) #进入到AP登录界面
            @browser1.button(id: @tc_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @tc_ap_wireless).click #进入无线2.4G模块
            select_pattern = @ap_frame.select_list(name: @tc_ap_wireless_pattern) #选择无线模式
            select_pattern.wait_until_present(@tc_wait_time)
            select_pattern.select(@tc_ap_wireless_pattern_b_g)
            select_channel = @ap_frame.select_list(name: @tc_ap_channel) #选择信道
            select_channel.wait_until_present(@tc_wait_time)
            select_channel.select(@tc_ap_channel_value_6)
            #获取ssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            #获取ssid密码
            @ssid_pwd = @ap_frame.text_field(name: "pskValue").value
            p "APssid_pwd --> #{@ssid_pwd}"
            @ap_frame.button(name: @ts_tag_ap_save).click #应用按钮
            loading_div = @ap_frame.div(id: @tc_ap_save_hint)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                loading_div.present?
            }
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #登录后刷新浏览器
            end
            5.times do #循环5次打开外网界面
                @browser.refresh #刷新浏览器
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @tc_wireless_id).exists?
            end
            @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @tc_wireless_id).click #无线连接
            @wan_iframe.label(id: @tc_relay_id).click #选择中继模式

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
                    @wan_iframe.label(id: @tc_relay_id).click #选择中继模式
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
                break if n == 10 #最多只查询5次ssid
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
            sleep @tc_net_start_wait_time #中继上后，等待一段时间再查看跟陪测AP是否关联成功
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "查看状态".to_gbk
            5.times do
                @browser.refresh #刷新浏览器
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #如果出现白板
                    @dut_wan_ip #定义
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，关联失败！".to_gbk)
            sleep @tc_net_start_wait_time #更改dhcp后等待获取到地址
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "PC1访问外网#{@ts_web}...".to_gbk
            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网#{@ts_web}".to_gbk)
            #pc2连接dut无线
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)
            p "PC2访问外网#{@ts_web}...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            unless judge_link_pc2
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                rs = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
                assert(rs, "PC2 wifi连接失败".to_gbk)
                judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            end
            assert(judge_link_pc2, "PC2无法访问外网#{@ts_web}".to_gbk)
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接

            @browser.span(id: @ts_tag_reboot).parent.click #点击重启按钮
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_reboot_wait_time
            #重新登录
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "重启成功，再次登录！".to_gbk
            else
                assert(login_ui, "重启失败，请定位后重试！")
            end
            login_no_default_ip(@browser) #登录
            5.times do
                @browser.refresh #刷新浏览器
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #如果出现白板
                    @dut_wan_ip #定义
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "重启后DUT与陪测AP不在同一网段，关联失败！".to_gbk)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            sleep @tc_net_start_wait_time
            p "PC1访问外网...".to_gbk
            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "重启后PC1无法访问外网#{@ts_web}".to_gbk)
            #pc2连接dut无线
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "重启后PC2 wifi连接失败".to_gbk)
            p "PC2访问外网...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            unless judge_link_pc2
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                rs = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
                assert(rs, "PC2 wifi连接失败".to_gbk)
                judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            end
            assert(judge_link_pc2, "重启后PC2无法访问外网#{@ts_web}".to_gbk)
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
        }

        operate("7、将陪测AP的无线模式设置为b模式，信道设置为CH11重复步骤2~4") {
            @browser1.goto(@ts_tag_ap_url) #进入到AP登录界面
            @browser1.button(id: @tc_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @tc_ap_wireless).click #进入无线2.4G模块
            select_pattern = @ap_frame.select_list(name: @tc_ap_wireless_pattern) #选择无线模式
            select_pattern.wait_until_present(@tc_wait_time)
            select_pattern.select(@tc_ap_wireless_pattern_b)
            select_channel = @ap_frame.select_list(name: @tc_ap_channel) #选择信道
            select_channel.wait_until_present(@tc_wait_time)
            select_channel.select(@tc_ap_channel_value_11)
            #获取ssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            #获取ssid密码
            @ssid_pwd = @ap_frame.text_field(name: "pskValue").value
            p "APssid_pwd --> #{@ssid_pwd}"
            @ap_frame.button(name: @ts_tag_ap_save).click #应用按钮
            loading_div = @ap_frame.div(id: @tc_ap_save_hint)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                loading_div.present?
            }
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #登录后刷新浏览器
            end
            5.times do #循环5次打开外网界面
                @browser.refresh #刷新浏览器
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @tc_wireless_id).exists?
            end
            @wan_iframe.span(id: @tc_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @tc_wireless_id).click #无线连接
            @wan_iframe.label(id: @tc_relay_id).click #选择中继模式

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
                    @wan_iframe.label(id: @tc_relay_id).click #选择中继模式
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
                break if n == 10 #最多只查询5次ssid
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
            sleep @tc_net_start_wait_time #中继上后，等待一段时间再查看跟陪测AP是否关联成功
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "查看状态".to_gbk
            5.times do
                @browser.refresh #刷新浏览器
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #如果出现白板
                    @dut_wan_ip #定义
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT与陪测AP不在同一网段，关联失败！".to_gbk)
            sleep @tc_net_start_wait_time #更改dhcp后等待获取到地址
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "PC1访问外网#{@ts_web}...".to_gbk
            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "PC1无法访问外网#{@ts_web}".to_gbk)
            #pc2连接dut无线
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)
            p "PC2访问外网#{@ts_web}...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            unless judge_link_pc2
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                rs = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
                assert(rs, "PC2 wifi连接失败".to_gbk)
                judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            end
            assert(judge_link_pc2, "PC2无法访问外网#{@ts_web}".to_gbk)
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接

            @browser.span(id: @ts_tag_reboot).parent.click #点击重启按钮
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            puts "路由器重启中，请稍后...".to_gbk
            sleep @tc_reboot_wait_time
            #重新登录
            login_ui = @browser.text_field(name: @usr_text_id).exists?
            if login_ui
                puts "重启成功，再次登录！".to_gbk
            else
                assert(login_ui, "重启失败，请定位后重试！")
            end
            login_no_default_ip(@browser) #登录
            5.times do
                @browser.refresh #刷新浏览器
                @browser.span(id: @tc_net_status).wait_until_present(@tc_wait_time)
                @browser.span(id: @tc_net_status).click #查看状态
                @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
                if @status_iframe.b(id: @tag_wan_ip).exists? #没出现白板
                    @dut_wan_ip = @status_iframe.b(id: @tag_wan_ip).parent.text.slice(/\d+\.\d+\.\d+\.\d+/i)
                    break unless @dut_wan_ip.nil?
                    sleep @tc_wait_web_respond_time
                else #如果出现白板
                    @dut_wan_ip #定义
                    sleep @tc_wait_time
                end
            end
            p "dut的wan侧ip：#{@dut_wan_ip}".to_gbk
            assert(!@dut_wan_ip.nil?, "DUT未获取到陪测AP的地址！")
            dut_network = @dut_wan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/\d+\.\d+\.(\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "重启后DUT与陪测AP不在同一网段，关联失败！".to_gbk)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            sleep @tc_net_start_wait_time
            p "PC1访问外网...".to_gbk
            judge_link_baidu = send_http_request(@ts_web)
            assert(judge_link_baidu, "重启后PC1无法访问外网#{@ts_web}".to_gbk)
            #pc2连接dut无线
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "重启后PC2 wifi连接失败".to_gbk)
            p "PC2访问外网...".to_gbk
            judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            unless judge_link_pc2
                @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
                rs = @tc_dumpcap_pc2.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
                assert(rs, "PC2 wifi连接失败".to_gbk)
                judge_link_pc2 = @tc_dumpcap_pc2.send_http_request(@ts_web)
            end
            assert(judge_link_pc2, "重启后PC2无法访问外网#{@ts_web}".to_gbk)
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接
        }

    end

    def clearup
        begin
            operate("1 恢复为默认的接入方式，DHCP接入") {
                if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                    @browser.execute_script(@ts_close_div)
                end
                unless @browser.span(:id => @ts_tag_netset).exists?
                    login_no_default_ip(@browser)
                    @browser.refresh #登录后刷新浏览器
                end
                @browser.span(:id => @ts_tag_netset).click
                sleep @tc_wait_time
                @wan_iframe = @browser.iframe
                @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
                #设置WIRE WAN为DHCP模式
                dhcp_radio.click
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "Waiting for net reset..."
                sleep @tc_net_wait_time
                if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                    @browser.execute_script(@ts_close_div)
                end
            }

            operate("2 恢复dut路由器的ssid") {
                @browser.span(id: @ts_tag_lan).click
                @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
                sleep @tc_wait_time
                unless @lan_iframe.text_field(id: @ts_tag_ssid, name: @ts_tag_ssid).value == @dut_ssid
                    @lan_iframe.text_field(id: @ts_tag_ssid, name: @ts_tag_ssid).set(@dut_ssid)
                    @lan_iframe.text_field(id: @ts_tag_input_pw).set(@dut_ssid_pwd)
                    @lan_iframe.button(id: @ts_tag_sbm).click #保存
                    sleep @tc_net_wait_time
                end
                if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                    @browser.execute_script(@ts_close_div)
                end
            }

            operate("3 恢复AP路由器无线默认设置") {
                @browser1.goto(@ts_tag_ap_url) #进入到登录界面
                @browser1.button(id: @tc_ap_login_btn).click #登录
                sleep @tc_wait_time
                @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
                @ap_frame.link(href: @tc_ap_wireless).wait_until_present(@tc_net_wait_time)
                @ap_frame.link(href: @tc_ap_wireless).click #进入无线2.4G模块
                @ap_frame.select_list(name: @tc_ap_wireless_pattern).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(name: @tc_ap_wireless_pattern).select(@ap_wireless_pattern_default_value) #选择无线模式
                @ap_frame.select_list(name: @tc_ap_channel).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(name: @tc_ap_channel).select(@ap_channel_auto) #选择信道
                @ap_frame.select_list(name: @tc_ap_bandwidth).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(name: @tc_ap_bandwidth).select(@ap_bandwidth_default_value) #选择带宽
                @ap_frame.select_list(id: @tc_ap_safe_option).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(id: @tc_ap_safe_option).select(@ap_safe_option_default_value) #选择安全选项
                @ap_frame.button(name: @ts_tag_ap_save).click #应用按钮
                loading_div = @ap_frame.div(id: @tc_ap_save_hint)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    loading_div.present?
                }
            }
        ensure
            @browser1.close #关闭浏览器
            p "断开wifi连接".to_gbk
            @tc_dumpcap_pc2.netsh_disc_all #断开wifi连接

            # args           = {}
            # args[:nicname] = @ts_nicname
            # args[:source]  = "dhcp"
            # netsh_if_ip_setip(args)
        end
    end

}
