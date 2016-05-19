#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.25", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time             = 3
        @tc_repeater_time         = 10
        @tc_ap_step_time          = 10
        @tc_net_wait_time         = 60
        @tc_diagnose_time         = 120
        @tc_net_time              = 120
        @tc_search_ssid_wait_time = 10
        @tc_net_start_wait_time   = 20
        @tc_wan_status            = "异常"
        @tc_ip_addr               = "失败"
        @tc_loss_rate             = "100%"
        @tc_loss_rate_f           = "0%"
        @tc_dns_status            = "失败"
        @tc_http_status           = "404"
        @tc_ap_wan_type_static    = "静态IP"
        @tc_ap_wan_type_dhcp      = "DHCP客户端"
        @tc_ap_id                 = "10.10.11.89"
        @tc_ap_mask               = "255.255.255.0"
        @tc_ap_gateway            = "10.11.11.1"
        @tc_ap_dns1               = "1.1.1.1"
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

        operate("1、不插入3G上网卡，将网口配置为LAN口，无线WIFI配置为中继模式，中继的时候输入错误的ROOTAP密码，进行高级诊断") {
            @browser1 = Watir::Browser.new :ff, :profile => "default"
            @browser1.goto(@ts_tag_ap_url) #进入到登录界面

            @browser1.button(id: @ts_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @ts_ap_wireless).click #进入无线2.4G模块
            #获取ssid
            @ssid = @ap_frame.text_field(name: "ssid").value
            p "APssid --> #{@ssid}"
            #获取ssid密码
            @ssid_pwd     = @ap_frame.text_field(name: "pskValue").value
            @ssid_pwd_err = @ssid_pwd + "_err"
            p "APssid_pwd --> #{@ssid_pwd}"
            p "APssid_pwd_err --> #{@ssid_pwd_err}"

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
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.link(id: @ts_tag_diagnose).click #系统诊断
            sleep @tc_wait_time
            #获取@browser对象下各个窗口对象的句柄对象
            @tc_handles = @browser.driver.window_handles
            assert(@tc_handles.size==2, "未打开诊断窗口")
            #通过句柄来切换不同的windows窗口
            @browser.driver.switch_to.window(@tc_handles[1])
            # 打开高级诊断
            @browser.link(id: @ts_tag_ad_diagnose).click
            @browser.text_field(id: @ts_tag_url).wait_until_present(@tc_wait_time)
            @browser.text_field(id: @ts_tag_url).set(@ts_diag_web)
            @browser.button(id: @ts_tag_diag_btn).click
            Watir::Wait::until(@tc_diagnose_time, "高级诊断完成") {
                @browser.p(text: /#{@ts_tag_diag_nettype}/).present?
            }

            tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
            puts "上网连接类型：#{tc_net_type}".to_gbk
            assert_match(/#{@tc_wan_dial_reg}/, tc_net_type, "上网连接类型错误")
            if @browser.p(text: /#{@ts_tag_net_status}/).exists?
                tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
                puts "WAN口连接状态：#{tc_net_status}".to_gbk
                assert_equal(@tc_wan_status, tc_net_status, "上网连接状态正常")
            end
            tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
            puts "域名：#{@ts_diag_web}，解析为：#{tc_net_domain_ip}".to_gbk
            assert_equal(@tc_ip_addr, tc_net_domain_ip, "域名解析成功")
            tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
            puts "诊断过程丢包率为：#{tc_loss_rate}".to_gbk
            assert_equal(@tc_loss_rate, tc_loss_rate, "诊断过程丢包率未达到100%")
            tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
            puts "DNS解析状态：#{tc_dns_status}".to_gbk
            assert_equal(@tc_dns_status, tc_dns_status, "DNS解析成功")
            tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
            puts "HTTP响应码：#{tc_http_code}".to_gbk
            assert_equal(tc_http_code, @tc_http_status, "HTTP响应错误")
        }

        operate("2、输入正确的ROOTAP密码，但是ROOTAP不接入Internet，进行高级诊断") {
            p "设置上行AP不接入Internet，采用的方法是配置静态IP，乱配置使该IP不能上网模拟不接入Internet".to_gbk
            @browser1.goto(@ts_tag_ap_url) #进入到登录界面
            @browser1.button(id: @ts_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @ts_ap_setting).click
            @ap_frame.button(name: @ts_manual_step_name).wait_until_present(@tc_wait_time)
            @ap_frame.button(name: @ts_manual_step_name).click
            select_wan_type = @ap_frame.select_list(name: @ts_ap_wan_type)
            select_wan_type.wait_until_present(@tc_wait_time)
            select_wan_type.select(@tc_ap_wan_type_static)
            @ap_frame.text_field(name: @ts_ap_ip_addr_static).wait_until_present(@tc_wait_time)
            @ap_frame.text_field(name: @ts_ap_ip_addr_static).set(@tc_ap_id)
            @ap_frame.text_field(name: @ts_ap_mask_static).set(@tc_ap_mask)
            @ap_frame.text_field(name: @ts_ap_gateway_static).set(@tc_ap_gateway)
            @ap_frame.text_field(name: @ts_ap_dns1_static).set(@tc_ap_dns1)
            @ap_frame.button(name: @ts_tag_ap_save).click
            sleep @tc_ap_step_time
            p "上行AP设置完毕！".to_gbk

            unless @tc_handles.nil?
                @browser.driver.switch_to.window(@tc_handles[0])
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
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.driver.switch_to.window(@tc_handles[1])
            # 打开高级诊断
            @browser.text_field(id: @ts_tag_url).set(@ts_diag_web)
            @browser.button(id: @ts_tag_diag_btn).click
            Watir::Wait::until(@tc_diagnose_time, "高级诊断完成") {
                @browser.p(text: /#{@ts_tag_diag_nettype}/).present?
            }

            tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
            puts "上网连接类型：#{tc_net_type}".to_gbk
            assert_match(/#{@tc_wan_dial_reg}/, tc_net_type, "上网连接类型错误")
            if @browser.p(text: /#{@ts_tag_net_status}/).exists?
                tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
                puts "WAN口连接状态：#{tc_net_status}".to_gbk
                assert_equal(@tc_wan_status, tc_net_status, "上网连接状态正常")
            end
            tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
            puts "域名：#{@ts_diag_web}，解析为：#{tc_net_domain_ip}".to_gbk
            assert_equal(@tc_ip_addr, tc_net_domain_ip, "域名解析成功")
            tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
            puts "诊断过程丢包率为：#{tc_loss_rate}".to_gbk
            assert_equal(@tc_loss_rate_f, tc_loss_rate, "诊断过程丢包率未达到100%")
            tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
            puts "DNS解析状态：#{tc_dns_status}".to_gbk
            assert_equal(@tc_dns_status, tc_dns_status, "DNS解析成功")
            tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
            puts "HTTP响应码：#{tc_http_code}".to_gbk
            assert_equal(tc_http_code, @tc_http_status, "HTTP响应成功")
        }


    end

    def clearup
        operate("恢复上行AP接入方式为DHCP") {
            @browser1.goto(@ts_tag_ap_url) #进入到登录界面
            @browser1.button(id: @ts_ap_login_btn).click #登录
            sleep @tc_wait_time
            @ap_frame = @browser1.frame(src: @ts_tag_ap_src)
            @ap_frame.link(href: @ts_ap_setting).click
            @ap_frame.button(name: @ts_manual_step_name).wait_until_present(@tc_wait_time)
            @ap_frame.button(name: @ts_manual_step_name).click
            select_wan_type = @ap_frame.select_list(name: @ts_ap_wan_type)
            select_wan_type.wait_until_present(@tc_wait_time)
            select_wan_type.select(@tc_ap_wan_type_dhcp)
            @ap_frame.button(name: @ts_tag_ap_save).click
            sleep @tc_ap_step_time
            @browser1.close #关闭浏览器
        }

        operate("恢复默认DHCP接入") {
            unless @tc_handles.nil?
                @browser.driver.switch_to.window(@tc_handles[0])
            end

            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            flag        = false
            #设置wan连接方式为网线连接
            rs1         = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
            rs1.wait_until_present(@tc_wait_time)
            unless rs1.class_name =~/ #{@ts_tag_select_state}/
                @wan_iframe.span(:id => @ts_tag_wired_mode_span).click
                flag = true
            end

            #查询是否为为dhcp模式
            dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
            dhcp_radio_state = dhcp_radio.checked?
            #设置WIRE WAN为DHCP模式
            unless dhcp_radio_state
                dhcp_radio.click
                flag = true
            end

            if flag
                @wan_iframe.button(:id, @ts_tag_sbm).click
                puts "Waiting for net reset..."
                sleep @tc_net_time
            end
        }

        operate("3、恢复默认ssid") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            wifi_ssid   = @lan_iframe.text_field(id: @ts_tag_ssid).value
            unless wifi_ssid == @dut_ssid
                wifi_ssid.set(@dut_ssid)
                @lan_iframe.text_field(id: @ts_tag_ssid_pwd).set(@dut_ssid_pwd)
                @lan_iframe.button(id: @ts_tag_sbm).click
                net_reset_div = @wan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                    net_reset_div.present?
                }
            end
        }
    end

}
