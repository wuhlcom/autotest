#
# description:
# author:liluping
# date:2015-09-28
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.11", "level" => "P1", "auto" => "n"}
    def prepare
        DRb.start_service
        @tc_drb                         = "druby://50.50.50.56:8787"
        @tc_dumpcap                     = DRbObject.new_with_uri(@tc_drb)
        @tc_wait_time                   = 2
        @tc_net_wait_time               = 60
        @tc_tag_wan_mode_link           = "tab_ip"
        @tc_tag_wire_mode_radio         = "ip_type_dhcp"
        @tc_tag_vedio_url               = "www.iqiyi.com"
        @tc_tag_traffic_info            = "traffic_info"
        @tc_terminal_traffic_statistics = "terminal-titile"
        @tc_chart_color1                = "chart_color color1"
        @tc_chart_color2                = "chart_color color2"
        @tc_traffic_titile              = "traffic-titile"
        @tc_tag_link_error              = "errorTitleText"
        @tc_traffic_cls                 = "box setup_box"
        @tc_tag_wan_mode_link           = "tab_ip"
        @tc_select_state                = "selected"
        @tc_tag_wan_mode_span           = "wire"
        @tc_tag_wire_mode_radio_dhcp    = "ip_type_dhcp"

        @ssid_pwd             = "12345678"
        @tc_net_status        = "setstatus"
        @tc_dut_wifi_ssid     = "ssid"
        @tc_dut_wifi_ssid_pwd = "input_password1"
    end

    def process
        puts "【请知】该脚本只判断终端流量统计信息是否准确，未判断总流量比例图显示是否正确".to_gbk
        puts "【2016/02/01，统一平台上该功已暂时取消，所以该脚本暂时不执行】".to_gbk
        # operate("1、被测AP通过WAN连接到外网，下面接多台有线，无线PC，笔记本，手机，ipad等设备。") {
        #     @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time) #等待2s
        #     @browser.span(id: @ts_tag_lan).click
        #
        #     @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
        #     assert(@lan_iframe.exists?, "打开内网设置失败！")
        #     p "获取DUT的ssid".to_gbk
        #     @dut_ssid = @lan_iframe.text_field(id: @tc_dut_wifi_ssid).value
        #     p "DUTssid --> #{@dut_ssid}".to_gbk
        #     @dut_ssid_pwd = @lan_iframe.text_field(id: @tc_dut_wifi_ssid_pwd).value
        #     p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
        #     if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
        #         @browser.execute_script(@ts_close_div)
        #     end
        #
        #     #pc2连接dut无线
        #     p "PC2连接wifi".to_gbk
        #     flag ="1"
        #     rs   = @tc_dumpcap.connect(@dut_ssid, flag, @dut_ssid_pwd, @ts_wlan_nicname)
        #     assert(rs, "PC2 wifi连接失败".to_gbk)
        #
        #     @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time) #等待2s
        #     @browser.span(id: @ts_tag_netset).click
        #
        #     @wan_iframe = @browser.iframe(src: @ts_tag_netset_src) #新面板，新对象
        #     assert(@wan_iframe.exists?, "打开外网设置失败！")
        #
        #     @wan_iframe.link(:id => @tc_tag_wan_mode_link).click #选择网线连接
        #     dhcp_radio = @wan_iframe.radio(id: @tc_tag_wire_mode_radio)
        #
        #     unless dhcp_radio.checked?
        #         dhcp_radio.click
        #     end
        #
        #     #保存
        #     @wan_iframe.button(:id, @ts_tag_sbm).click
        #     sleep @tc_net_wait_time
        #
        #     if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
        #         @browser.execute_script(@ts_close_div)
        #     end
        # }
        #
        # operate("2、将有线PC和ipad进行视频点播，其他连接终端只连接不上网，查看终端流量统计信息是否准确，包括每个终端的上传和下载流量、各个终端上传和下载总流量比例图是否显示正确；") {
        #     #查看实时流量变化
        #     @browser.refresh
        #     @browser.link(id: @ts_tag_options).click
        #     @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
        #     assert(@option_iframe.exists?, "打开高级设置失败！")
        #     option_link = @option_iframe.link(id: @tc_traffic_titile)
        #     option_link.click
        #
        #
        #     @option_iframe.link(id: @tc_terminal_traffic_statistics).wait_until_present(@tc_wait_time)
        #     option_tra_iframe = @option_iframe.link(id: @tc_terminal_traffic_statistics)
        #     option_tra_iframe.click #终端流量统计
        #
        #     @option_iframe.div(class_name: @tc_traffic_cls).wait_until_present(@tc_wait_time)
        #     assert(@option_iframe.div(class_name: @tc_traffic_cls).exists?, "打开终端流量统计失败")
        #
        #     c1_start_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[0].text
        #     c1_start_traffic_inf =~ /\u4E0B\u8F7D: (.+[MB|KB|B]) \u4E0A\u4F20: (.+[MB|KB|B])/i
        #     c1_start_uploading = $1
        #     c1_start_download  = $2
        #     puts "设备1点播前的实时流量为，上传：#{c1_start_uploading}，下载：#{c1_start_download}".to_gbk
        #     c2_start_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[1].text
        #     c2_start_traffic_inf =~ /\u4E0B\u8F7D: (.+[MB|KB|B]) \u4E0A\u4F20: (.+[MB|KB|B])/i
        #     c2_start_uploading = $1
        #     c2_start_download  = $2
        #     puts "设备2点播前的实时流量为，上传：#{c2_start_uploading}，下载：#{c2_start_download}".to_gbk
        #
        #     if c1_start_uploading.include?("MB")
        #         c1_start_uploading = (c1_start_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c1_start_uploading = c1_start_uploading.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c1_start_download.include?("MB")
        #         c1_start_download = (c1_start_download.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c1_start_download = c1_start_download.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c2_start_uploading.include?("MB")
        #         c2_start_uploading = (c2_start_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c2_start_uploading = c2_start_uploading.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c2_start_download.include?("MB")
        #         c2_start_download = (c2_start_download.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c2_start_download = c2_start_download.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #
        #     #点击系统诊断弹出一个新窗口，用来进行视频点播
        #     sleep @tc_wait_time
        #
        #     #open diagnose
        #     @browser.link(id: @ts_tag_diagnose).click()
        #     sleep @tc_wait_time
        #     #获取@browser对象下各个窗口对象的句柄对象
        #     @tc_handles = @browser.driver.window_handles
        #     assert(@tc_handles.size==2, "未打开诊断窗口")
        #     #通过句柄来切换不同的windows窗口
        #     @browser.driver.switch_to.window(@tc_handles[1]) #切换到系统诊断窗口
        #
        #     @browser.goto(@tc_tag_vedio_url)
        #     judge = @browser.h1(id: @tc_tag_link_error).exists?
        #     assert(!judge, "无法登陆#{@tc_tag_vedio_url}启动点播")
        #
        #     @browser.ul(class_name: "txt-item fl").lis[0].span(class_name: "txt").click
        #     sleep @tc_wait_time
        #     assert(@browser.driver.window_handles.size==3, "未打开点播窗口")
        #
        #     sleep @tc_net_wait_time
        #     @browser.driver.switch_to.window(@tc_handles[0]) #切换到实时流量统计窗口
        #
        #     @option_iframe.link(id: @tc_terminal_traffic_statistics).wait_until_present(@tc_wait_time)
        #     option_tra_iframe = @option_iframe.link(id: @tc_terminal_traffic_statistics)
        #     option_tra_iframe.click #点击终端流量统计用来刷新数据
        #     @option_iframe.div(class_name: @tc_traffic_cls).wait_until_present(@tc_wait_time)
        #     assert(@option_iframe.div(class_name: @tc_traffic_cls).exists?, "打开终端流量统计失败")
        #
        #     c1_end_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[0].text
        #     c1_end_traffic_inf =~ /\u4E0B\u8F7D: (.+[MB|KB|B]) \u4E0A\u4F20: (.+[MB|KB|B])/i
        #     c1_end_uploading = $1
        #     c1_end_download  = $2
        #     puts "设备1点播后的实时流量为，上传：#{c1_end_uploading}，下载：#{c1_end_download}".to_gbk
        #     c2_end_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[1].text
        #     c2_end_traffic_inf =~ /\u4E0B\u8F7D: (.+[MB|KB|B]) \u4E0A\u4F20: (.+[MB|KB|B])/i
        #     c2_end_uploading = $1
        #     c2_end_download  = $2
        #     puts "设备2只连接不点播后的实时流量为，上传：#{c2_end_uploading}，下载：#{c2_end_download}".to_gbk
        #     if c1_end_uploading.include?("MB")
        #         c1_end_uploading = (c1_end_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c1_end_uploading = c1_end_uploading.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c1_end_download.include?("MB")
        #         c1_end_download = (c1_end_download.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c1_end_download = c1_end_download.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c2_end_uploading.include?("MB")
        #         c2_end_uploading = (c2_end_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c2_end_uploading = c2_end_uploading.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c2_end_download.include?("MB")
        #         c2_end_download = (c2_end_download.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c2_end_download = c2_end_download.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #
        #     # p c1_end_uploading
        #     # p c1_start_uploading
        #     c1up_d_value   = c1_end_uploading - c1_start_uploading
        #     c1down_d_value = c1_end_download - c1_start_download
        #     #点播后上传流量波动较小，可能不变，在[0,100)KB范围内认为是正常的
        #     assert(c1up_d_value>=0 && c1up_d_value<100, "设备1进行点播后，实时上传流量未在[0,100)范围，点播前#{c1_start_uploading},点播后#{c1_end_uploading}")
        #     assert(c1down_d_value > 0, "设备1进行点播后，实时下载流量无变化，点播前#{c1_start_download},点播后#{c1_end_download}")
        #
        #     c2up_d_value   = c2_end_uploading - c2_start_uploading
        #     c2down_d_value = c2_end_download - c2_start_download
        #     #只连接不上网时，也会有小范围的流量波动，这里控制在一定范围内就算无流量变化
        #     assert((c2up_d_value>=0 && c2up_d_value<100), "设备2只连接不进行点播，实时上传流量有变化，变化前#{c2_start_uploading},变化后#{c2_end_uploading}")
        #     assert((c2down_d_value>=0 && c2down_d_value<100), "设备2只连接不进行点播，实时下载流量有变化，变化前#{c2_start_download},变化后#{c2_end_download}")
        # }
        #
        # operate("3、在每个终端上都进行上网下载业务，查看终端流量统计信息是否准确，包括每个终端的上传和下载流量、各个终端上传和下载总流量比例图是否显示正确；") {
        #     sleep @tc_wait_time
        #     @browser.driver.switch_to.window(@tc_handles[0]) #切换到实时流量统计窗口
        #     @option_iframe.link(id: @tc_terminal_traffic_statistics).wait_until_present(@tc_wait_time)
        #     option_tra_iframe = @option_iframe.link(id: @tc_terminal_traffic_statistics)
        #     option_tra_iframe.click #点击终端流量统计用来刷新数据
        #     @option_iframe.div(class_name: @tc_traffic_cls).wait_until_present(@tc_wait_time)
        #     assert(@option_iframe.div(class_name: @tc_traffic_cls).exists?, "打开终端流量统计失败")
        #
        #     c1_start_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[0].text
        #     c1_start_traffic_inf =~ /\u4E0B\u8F7D: (.+[MB|KB|B]) \u4E0A\u4F20: (.+[MB|KB|B])/i
        #     c1_start_uploading = $1
        #     c1_start_download  = $2
        #     puts "设备1点播前的实时流量为，上传：#{c1_start_uploading}，下载：#{c1_start_download}".to_gbk
        #     c2_start_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[1].text
        #     c2_start_traffic_inf =~ /\u4E0B\u8F7D: (.+[MB|KB|B]) \u4E0A\u4F20: (.+[MB|KB|B])/i
        #     c2_start_uploading = $1
        #     c2_start_download  = $2
        #     puts "设备2点播前的实时流量为，上传：#{c2_start_uploading}，下载：#{c2_start_download}".to_gbk
        #
        #     if c1_start_uploading.include?("MB")
        #         c1_start_uploading = (c1_start_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c1_start_uploading = c1_start_uploading.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c1_start_download.include?("MB")
        #         c1_start_download = (c1_start_download.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c1_start_download = c1_start_download.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c2_start_uploading.include?("MB")
        #         c2_start_uploading = (c2_start_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c2_start_uploading = c2_start_uploading.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c2_start_download.include?("MB")
        #         c2_start_download = (c2_start_download.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c2_start_download = c2_start_download.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #
        #
        #     @browser.driver.switch_to.window(@tc_handles[1]) #切换到点播窗口
        #     @browser.ul(class_name: "txt-item fl").lis[0].span(class_name: "txt").click #设备1启动点播
        #     sleep @tc_wait_time
        #     @tc_dumpcap.login_vedio(@tc_tag_vedio_url) #设备2启动点播
        #
        #
        #     sleep @tc_net_wait_time
        #     @browser.driver.switch_to.window(@tc_handles[0]) #切换到实时流量统计窗口
        #
        #     @option_iframe.link(id: @tc_terminal_traffic_statistics).wait_until_present(@tc_wait_time)
        #     option_tra_iframe = @option_iframe.link(id: @tc_terminal_traffic_statistics)
        #     option_tra_iframe.click #点击终端流量统计用来刷新数据
        #     @option_iframe.div(class_name: @tc_traffic_cls).wait_until_present(@tc_wait_time)
        #     assert(@option_iframe.div(class_name: @tc_traffic_cls).exists?, "打开终端流量统计失败")
        #
        #     c1_end_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[0].text
        #     c1_end_traffic_inf =~ /\u4E0B\u8F7D: (.+[MB|KB|B]) \u4E0A\u4F20: (.+[MB|KB|B])/i
        #     c1_end_uploading = $1
        #     c1_end_download  = $2
        #     puts "设备1点播后的实时流量为，上传：#{c1_end_uploading}，下载：#{c1_end_download}".to_gbk
        #     c2_end_traffic_inf = @option_iframe.div(class_name: "columnthreeright").lis[1].text
        #     c2_end_traffic_inf =~ /\u4E0B\u8F7D: (.+[MB|KB|B]) \u4E0A\u4F20: (.+[MB|KB|B])/i
        #     c2_end_uploading = $1
        #     c2_end_download  = $2
        #     puts "设备2点播后的实时流量为，上传：#{c2_end_uploading}，下载：#{c2_end_download}".to_gbk
        #     if c1_end_uploading.include?("MB")
        #         c1_end_uploading = (c1_end_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c1_end_uploading = c1_end_uploading.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c1_end_download.include?("MB")
        #         c1_end_download = (c1_end_download.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c1_end_download = c1_end_download.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c2_end_uploading.include?("MB")
        #         c2_end_uploading = (c2_end_uploading.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c2_end_uploading = c2_end_uploading.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #     if c2_end_download.include?("MB")
        #         c2_end_download = (c2_end_download.slice(/\d+\.\d+|\d+/).to_f)*1024
        #     else
        #         c2_end_download = c2_end_download.slice(/\d+\.\d+|\d+/).to_f
        #     end
        #
        #     c1up_d_value   = c1_end_uploading - c1_start_uploading
        #     c1down_d_value = c1_end_download - c1_start_download
        #     #点播后上传流量波动较小，可能不变，在[0,100)KB范围内认为是正常的
        #     assert(c1up_d_value>=0 && c1up_d_value<100, "设备1进行点播后，实时上传流量未在[0,100)范围，点播前#{c1_start_uploading},点播后#{c1_end_uploading}")
        #     assert(c1down_d_value > 0, "设备1进行点播后，实时下载流量无变化，点播前#{c1_start_download},点播后#{c1_end_download}")
        #
        #     c2up_d_value   = c2_end_uploading - c2_start_uploading
        #     c2down_d_value = c2_end_download - c2_start_download
        #     #点播后上传流量波动较小，可能不变，在[0,100)KB范围内认为是正常的
        #     assert(c2up_d_value>=0 && c2up_d_value<100, "设备2进行点播后，实时上传流量未在[0,100)范围，点播前#{c2_start_uploading},点播后#{c2_end_uploading}")
        #     assert(c2down_d_value>0, "设备2进行点播后，实时下载流量无变化，点播前#{c2_start_download},点播后#{c2_end_download}")
        # }


    end

    def clearup
        # operate("1 恢复为默认的接入方式，DHCP接入") {
        #     if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
        #         @browser.execute_script(@ts_close_div)
        #     end
        #
        #     unless @browser.span(:id => @ts_tag_netset).exists?
        #         login_recover(@browser, @ts_default_ip)
        #     end
        #
        #     @browser.span(:id => @ts_tag_netset).click
        #     @wan_iframe = @browser.iframe
        #     sleep @tc_wait_time
        #
        #     flag = false
        #     #设置wan连接方式为网线连接
        #     rs1  = @wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
        #     unless rs1 =~/ #{@tc_select_state}/
        #         @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
        #         flag = true
        #     end
        #
        #     #查询是否为为dhcp模式
        #     dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio_dhcp)
        #     dhcp_radio_state = dhcp_radio.checked?
        #
        #     #设置WIRE WAN为DHCP模式
        #     unless dhcp_radio_state
        #         dhcp_radio.click
        #         flag = true
        #     end
        #
        #     if flag
        #         @wan_iframe.button(:id, @ts_tag_sbm).click
        #         puts "Waiting for net reset..."
        #         sleep @tc_net_wait_time
        #     end
        #
        #     p "断开wifi连接".to_gbk
        #     @tc_dumpcap.netsh_disc_all #断开wifi连接
        # }
    end

}
