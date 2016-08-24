#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.11", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_diagnose_time                  = 120
        @tc_wait_time                      = 3
        @tc_search_ssid_wait_time          = 10
        @tc_net_start_wait_time            = 20
        @tc_net_wait_time                  = 60
        @tc_ap_wireless_pattern_value      = "802.11b/g/n"
        @tc_ap_channel_value               = "11"
        @tc_ap_bandwidth_value             = "Auto 20/40M"
        @tc_ap_safe_option_value           = "WPA-PSK/WPA2-PSK AES"
        @tc_tag_wan_mode_link              = "tab_ip"
        @tc_select_state                   = "selected"
        @tc_tag_wan_mode_span              = "wire"
        @tc_tag_wire_mode_radio_dhcp       = "ip_type_dhcp"
        @ap_wireless_pattern_default_value = "802.11b/g/n"
        @ap_channel_auto                   = "11"
        @ap_bandwidth_default_value        = "Auto 20/40M"
        @ap_safe_option_default_value      = "无"
    end

    def process
        operate("-1、获取dut的ssid及密码") {
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

        operate("0、陪测AP使用Atheros方案并接入Internet，无线模式为b/g/n，信道指定为CH11，频宽设置为40M频宽，加密为WPA-AES.") {
            @browser1 = Watir::Browser.new :ff, :profile => "default"
            @browser1.goto(@ts_tag_ap_url) #进入到登录界面

            @browser1.button(id: @ts_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)

            @ap_frame.link(href: @ts_ap_status).click #进入状态模块
            sleep @tc_wait_time
            @ap_lan_ip = @ap_frame.div(id: @ts_main_content).tables[3].trs[1][0].tables[0].trs[0][1].text
            p "AP的LAN侧ip：#{@ap_lan_ip}".to_gbk
            assert(!@ap_lan_ip.nil?, "AP的LAN侧ip读取失败！")
            @ap_frame.link(href: @ts_ap_wireless).click #进入无线2.4G模块

            select_pattern = @ap_frame.select_list(name: @ts_ap_wireless_pattern) #选择无线模式
            select_pattern.wait_until_present(@tc_wait_time)
            select_pattern.select(@tc_ap_wireless_pattern_value)

            select_channel = @ap_frame.select_list(name: @ts_ap_channel) #选择信道
            select_channel.wait_until_present(@tc_wait_time)
            select_channel.select(@tc_ap_channel_value)

            select_bandwidth = @ap_frame.select_list(name: @ts_ap_bandwidth) #选择带宽
            select_bandwidth.wait_until_present(@tc_wait_time)
            select_bandwidth.select(@tc_ap_bandwidth_value)

            select_safe_option = @ap_frame.select_list(id: @ts_ap_safe_option) #选择安全选项
            select_safe_option.wait_until_present(@tc_wait_time)
            select_safe_option.select(@tc_ap_safe_option_value)

            #获取ssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            #获取ssid密码
            @ssid_pwd = @ap_frame.text_field(name: "pskValue").value
            p "APssid_pwd --> #{@ssid_pwd}"
            @ap_frame.button(name: @ts_tag_ap_save).click #应用按钮

            loading_div = @ap_frame.div(id: @ts_ap_save_hint)
            Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                loading_div.present?
            }
        }

        operate("1、配置外网设置为中继模式，扫描一个可以上网的上行AP进行连接，输入正确的密码连接成功；") {
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #登录后刷新浏览器
            end
            5.times do #循环5次打开外网界面
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
                @browser.refresh #刷新浏览器
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
            sleep @tc_net_start_wait_time #中继上后，等待一段时间再查看跟陪测AP是否关联成功
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、点击系统诊断，查看诊断结果；") {
            @browser.link(id: @ts_tag_diagnose).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_tag_diagnose).click
            #获取@browser对象下各个窗口对象的句柄对象
            @tc_handles = @browser.driver.window_handles
            assert(@tc_handles.size==2, "未打开诊断窗口")
            #通过句柄来切换不同的windows窗口
            @browser.driver.switch_to.window(@tc_handles[1]) #切换到系统诊断窗口
            Watir::Wait::until(@tc_diagnose_time, "系统诊断完成") {
                @browser.h1(text: /#{@ts_tag_diag_fini_success}|#{@ts_tag_diag_fini_fail}/).present?
            }

            @browser.span(id: @ts_tag_diag_internet_status).wait_until_present(@tc_wait_time)
            net_status = @browser.span(id: @ts_tag_diag_internet_status).text
            assert_equal(net_status, "\u6B63\u5E38", "外网连接状态不正常!")
            @browser.span(id: @ts_tag_diag_netspeed_status).wait_until_present(@tc_wait_time)
            net_speed_status = @browser.span(id: @ts_tag_diag_netspeed_status).text
            assert_equal(net_speed_status, "\u6B63\u5E38", "外网连接速率不正常!")
        }

        operate("3、扫描一个上行AP进行连接，输入错误的密码进行连接，使连接不成功；") {
            @browser.driver.switch_to.window(@tc_handles[0]) #切换到dut窗口
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_no_default_ip(@browser)
                @browser.refresh #登录后刷新浏览器
            end
            5.times do #循环5次打开外网界面
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
                @browser.refresh #刷新浏览器
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
                break if n == 5 #最多只查询5次ssid
            end
            assert(ssid_flag, "未扫描到ap的ssid->#{@ssid}")
            select_click.select(@ssid) #选择ap的ssid
            select_pwd_click = @wan_iframe.text_field(id: @tc_net_pwd)
            if select_pwd_click.exists?
                select_pwd_click.set(@ssid_pwd+"1") #输入错误的ap  ssid密码
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
        }

        operate("4、点击系统诊断，查看诊断结果；") {
            @browser.link(id: @ts_tag_diagnose).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_tag_diagnose).click
            #获取@browser对象下各个窗口对象的句柄对象
            @tc_handles = @browser.driver.window_handles
            assert(@tc_handles.size==3, "未打开诊断窗口")
            #通过句柄来切换不同的windows窗口
            @browser.driver.switch_to.window(@tc_handles[2]) #切换到系统诊断窗口
            Watir::Wait::until(@tc_diagnose_time, "系统诊断完成") {
                @browser.h1(text: /#{@ts_tag_diag_fini_success}|#{@ts_tag_diag_fini_fail}/).present?
            }

            @browser.span(id: @ts_tag_diag_internet_status).wait_until_present(@tc_wait_time)
            net_status = @browser.span(id: @ts_tag_diag_internet_status).text
            assert_equal(net_status, "\u5F02\u5E38", "外网连接状态正常!")
            p @browser.span(id: @ts_tag_diag_internet_status).parent.parent.text.to_gbk
            @browser.span(id: @ts_tag_diag_netspeed_status).wait_until_present(@tc_wait_time)
            net_speed_status = @browser.span(id: @ts_tag_diag_netspeed_status).text
            p @browser.span(id: @ts_tag_diag_netspeed_status).parent.parent.text.to_gbk
            assert_equal(net_speed_status, "\u5F02\u5E38", "外网连接速率正常!")
        }

        # operate("5、扫描并连接一个不能上网的AP，连接成功后进行系统诊断，查看诊断结果；") {
        #
        # }


    end

    def clearup
        operate("恢复默认配置") {
            begin
                p "恢复为默认的接入方式，DHCP接入".to_gbk
                @tc_handles = @browser.driver.window_handles
                if @tc_handles.size > 1
                    @browser.driver.switch_to.window(@tc_handles[0])
                end
                unless @browser.span(:id => @ts_tag_netset).exists?
                    login_no_default_ip(@browser)
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

                if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                    @browser.execute_script(@ts_close_div)
                end

                p "恢复dut的ssid".to_gbk
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


                p "恢复AP路由器无线默认设置".to_gbk
                @browser1.goto(@ts_tag_ap_url) #进入到登录界面
                @browser1.button(id: @ts_ap_login_btn).click #登录
                sleep @tc_wait_time
                @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
                @ap_frame.link(href: @ts_ap_wireless).wait_until_present(@tc_net_wait_time)
                @ap_frame.link(href: @ts_ap_wireless).click #进入无线2.4G模块
                @ap_frame.select_list(name: @ts_ap_wireless_pattern).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(name: @ts_ap_wireless_pattern).select(@ap_wireless_pattern_default_value) #选择无线模式
                @ap_frame.select_list(name: @ts_ap_channel).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(name: @ts_ap_channel).select(@ap_channel_auto) #选择信道
                @ap_frame.select_list(name: @ts_ap_bandwidth).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(name: @ts_ap_bandwidth).select(@ap_bandwidth_default_value) #选择带宽
                @ap_frame.select_list(id: @ts_ap_safe_option).wait_until_present(@tc_wait_time)
                @ap_frame.select_list(id: @ts_ap_safe_option).select(@ap_safe_option_default_value) #选择安全选项
                @ap_frame.button(name: @ts_tag_ap_save).click #应用按钮

                loading_div = @ap_frame.div(id: @ts_ap_save_hint)
                Watir::Wait.while(@tc_net_wait_time, "正在保存配置".to_gbk) {
                    loading_div.present?
                }
            ensure
                @browser1.close
            end
        }
    end

}
