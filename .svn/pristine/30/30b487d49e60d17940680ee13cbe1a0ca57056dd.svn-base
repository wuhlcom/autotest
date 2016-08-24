#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.43", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time             = 5
        @tc_net_wait_time         = 60
        @tc_net_time              = 60
        @tc_reset_to_default_time = 120
        @tc_search_ssid_wait_time = 10
        @tc_net_start_wait_time   = 20
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

        operate("1、修改当前AP为中继模式，且中继成功，导出配置文件") {
            5.times do #循环5次打开外网界面
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
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
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            assert_match(@ip_regxp, wan_addr, '中继获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_repeater}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, '中继获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, '中继获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, '中继获取dns ip地址失败！')

            p "导出配置文件".to_gbk
            set_info = export_configuration_file(@ts_default_ip, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_tag_export)
            assert(!set_info.empty?, "导出配置文件出现异常")
            match = set_info =~ /wanConnectionMode=#{@ts_wan_mode_repeater}/i
            if match
                assert(true, "备份成功") #msg无关紧要
            else
                assert(false, "备份失败") #msg无关紧要
            end
        }

        operate("2、修改AP为桥模式，且桥接成功。然后导入步骤1中的配置文件，导入成功后，查看AP的连接模式") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            5.times do #循环5次打开外网界面
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
                @browser.refresh #刷新浏览器
            end
            @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @ts_wireless_id).click #无线连接
            @wan_iframe.label(id: @ts_bridge_id).click #选择桥接模式
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
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            assert_match(@ip_regxp, wan_addr, '桥接获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_bridge}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, '桥接获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, '桥接获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, '桥接获取dns ip地址失败！')

            p "导入配置文件".to_gbk
            export_info = import_configuration_file(@ts_default_ip, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_reset_default_fname, @ts_tag_update_btn, @ts_tag_import, @ts_tag_import_text)
            assert(export_info, "导入配置文件出现异常")
            sleep @tc_reset_to_default_time
            p "查看配置是否恢复！".to_gbk
            login_default(@browser) #重新登录
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, @ts_wan_mode_repeater, "恢复出厂设置后，网络连接状态未恢复成#{@ts_wan_mode_repeater}类型")
            p "判断能否上网".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "上网失败，不可以访问#{@ts_web}".to_gbk)
        }

        operate("3、修改AP为桥模式，且桥接成功，然后导出配置文件") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            5.times do #循环5次打开外网界面
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
                @browser.refresh #刷新浏览器
            end
            @wan_iframe.span(id: @ts_wireless_id).wait_until_present(@tc_wait_time)
            @wan_iframe.span(id: @ts_wireless_id).click #无线连接
            @wan_iframe.label(id: @ts_bridge_id).click #选择桥接模式
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
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            assert_match(@ip_regxp, wan_addr, '桥接获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_bridge}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, '桥接获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, '桥接获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, '桥接获取dns ip地址失败！')

            p "导出配置文件".to_gbk
            set_info = export_configuration_file(@ts_default_ip, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_tag_export)
            assert(!set_info.empty?, "导出配置文件出现异常")
            match = set_info =~ /wanConnectionMode=#{@ts_wan_mode_bridge}/i
            if match
                assert(true, "备份成功") #msg无关紧要
            else
                assert(false, "备份失败") #msg无关紧要
            end
        }

        operate("4、修改AP为中继模式，且中继成功，然后导入步骤3中的配置文件，导入成功后，查看AP的连接模式") {
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            5.times do #循环5次打开外网界面
                @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time)
                @browser.span(id: @ts_tag_netset).click
                @wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
                break if @wan_iframe.span(id: @ts_wireless_id).exists?
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
            @browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
            @browser.span(:id => @ts_tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
            wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
            wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
            mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
            gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
            dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
            assert_match(@ip_regxp, wan_addr, '中继获取ip地址失败！')
            assert_match(/#{@ts_wan_mode_repeater}/, wan_type, '接入类型错误！')
            assert_match(@ip_regxp, mask, '中继获取ip地址掩码失败！')
            assert_match(@ip_regxp, gateway_addr, '中继获取网关ip地址失败！')
            assert_match(@ip_regxp, dns_addr, '中继获取dns ip地址失败！')

            p "导入配置文件".to_gbk
            export_info = import_configuration_file(@ts_default_ip, @ts_tag_options, @ts_tag_advance_src, @ts_tag_op_system, @ts_tag_recover, @ts_reset_default_fname, @ts_tag_update_btn, @ts_tag_import, @ts_tag_import_text)
            assert(export_info, "导入配置文件出现异常")
            sleep @tc_reset_to_default_time
            p "查看配置是否恢复！".to_gbk
            login_default(@browser) #重新登录
            @browser.span(id: @tag_status).click #打开状态
            @status_iframe = @browser.iframe(src: @tag_status_iframe_src)
            connect_type   = @status_iframe.b(id: @tag_wan_type).parent.text.slice(/\u8FDE\u63A5\u7C7B\u578B\n(.+)/i, 1)
            assert_equal(connect_type, @ts_wan_mode_bridge, "恢复出厂设置后，网络连接状态未恢复成#{@ts_wan_mode_bridge}类型")
            p "判断能否上网".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "上网失败，不可以访问#{@ts_web}".to_gbk)
        }


    end

    def clearup
        operate("恢复默认配置") {
            p "1、恢复默认DHCP接入".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
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
            unless rs1.class_name =~/ #{@tc_tag_select_state}/
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

            p "2、恢复默认ssid".to_gbk
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            @lan_iframe.text_field(id: @ts_tag_ssid).wait_until_present(@tc_wait_time)
            if @lan_iframe.text_field(id: @ts_tag_ssid).value == @dut_ssid
                @lan_iframe.text_field(id: @ts_tag_ssid).set(@dut_ssid)
                @lan_iframe.text_field(id: @ts_tag_ssid_pwd).set(@dut_ssid_pwd)
                @lan_iframe.button(id: @ts_tag_sbm).click
                sleep @tc_net_time
            end
        }
    end

}
