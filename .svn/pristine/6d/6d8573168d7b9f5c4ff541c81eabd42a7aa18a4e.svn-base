#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_7.1.36", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time             = 3
        @tc_search_ssid_wait_time = 10
        @tc_net_start_wait_time   = 20
        @tc_net_wait_time         = 60
        @tc_net_time              = 120
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

        operate("1、被测AP中插入中国移动4G卡") {
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
            @ssid_pwd = @ap_frame.text_field(name: "pskValue").value
            p "APssid_pwd --> #{@ssid_pwd}"
        }

        operate("2、配置被测AP为通过中继方式上网。PC1上网成功") {
            5.times do #循环5次打开外网界面
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @tc_wireless_id).exists?
                @browser.refresh #刷新浏览器
            end
            @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @ts_wireless_id).click #无线连接
            @wan_iframe.label(id: @ts_relay_id).click #选择中继模式
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
                    @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
                    @wan_iframe.span(id: @ts_wireless_id).click #无线连接
                    @wan_iframe.label(id: @ts_bridge_id).click #选择桥接模式
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
            select_pwd_click = @wan_iframe.text_field(id: @ts_net_pwd)
            if select_pwd_click.exists?
                select_pwd_click.clear
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

            p "验证中继是否连接成功".to_gbk
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

            assert_match(@ip_regxp, wan_addr, 'Repeater获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_repeater}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'Repeater获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'Repeater获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'Repeater获取dns ip地址失败！')
            p "判断是否上网成功".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "不可以访问#{@ts_web}".to_gbk)
        }

        operate("3、然后手动切换为3/4G上网，查看切换是否成功，PC1切换后是否能上网，状态页面显示是否正确") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_netset).click
            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
            assert(@wan_iframe.exists?, "打开外网设置失败")
            @wan_iframe.link(id: @ts_tag_3g_mode_link).click
            @wan_iframe.radio(id: @ts_tag_3g_auto).click
            @wan_iframe.button(id: @ts_tag_sbm).click
            sleep @tc_net_time
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            p "验证3G/4G是否拨号成功".to_gbk
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            sleep @tc_wait_time

            sim_status      = @status_iframe.b(:id => @ts_tag_sim_status).parent.img.src
            wifi_signal     = @status_iframe.b(:id => @ts_tag_signal_strenth).parent.img.src
            register_status = @status_iframe.b(:id => @ts_tag_reg_status).parent.img.src
            net_status      = @status_iframe.b(:id => @ts_tag_3g_net_status).parent.img.src
            net_type        = @status_iframe.b(:id => @ts_tag_3g_net_type).parent.text
            ispname         = @status_iframe.b(:id => @ts_tag_3g_ispname).parent.text
            assert_match(@ts_tag_img_normal, sim_status, '3G/4G SIM卡状态异常')
            assert_match(@ts_tag_signal_normal, wifi_signal, '3G/4G 信号强度状态异常')
            assert_match(@ts_tag_img_normal, register_status, '3G/4G 注册状态异常')
            assert_match(@ts_tag_img_normal, net_status, '3G/4G 联网状态异常')
            assert_match(@ts_tag_4g_nettype_text, net_type, '3G/4G 网络类型异常')
            assert_match(@ts_tag_3g_ispname_text, ispname, '3G/4G 运营商名称异常')
            wan_addr     = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type     = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask         = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr     = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            assert_match(@ip_regxp, wan_addr, '3G/4G获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_3g_4g}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, '3G/4G获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, '3G/4G获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, '3G/4G获取dns ip地址失败！')

            p "判断是否上网成功".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "不可以访问#{@ts_web}".to_gbk)
        }

        operate("4、手动切换为有线上网，WAN配置为中继，PC1切换后是否能上网，状态页面显示是否正确") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            5.times do #循环5次打开外网界面
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @tc_wireless_id).exists?
                @browser.refresh #刷新浏览器
            end
            @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @ts_wireless_id).click #无线连接
            @wan_iframe.label(id: @ts_relay_id).click #选择中继模式
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
                    @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
                    @wan_iframe.span(id: @ts_wireless_id).click #无线连接
                    @wan_iframe.label(id: @ts_bridge_id).click #选择桥接模式
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
            select_pwd_click = @wan_iframe.text_field(id: @ts_net_pwd)
            if select_pwd_click.exists?
                select_pwd_click.clear
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

            p "验证中继是否连接成功".to_gbk
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text

            assert_match(@ip_regxp, wan_addr, 'Repeater获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_repeater}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, 'Repeater获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, 'Repeater获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, 'Repeater获取dns ip地址失败！')
            p "判断是否上网成功".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "不可以访问#{@ts_web}".to_gbk)
        }


    end

    def clearup
        operate("恢复默认DHCP接入") {
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


            p "恢复默认ssid".to_gbk
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

            @browser1.close #关闭浏览器
        }

    end

}
