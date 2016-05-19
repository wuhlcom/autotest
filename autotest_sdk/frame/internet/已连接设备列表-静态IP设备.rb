#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.28", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
        @reboot_time  = 120
    end

    def process

        operate("1、被测AP下接有线PC,设备PC为静态IP地址后，查看接入设备信息是否还包含此PC") {
            dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
            dut_ip =~ /(\d+\.\d+\.\d+\.)(\d+)/
            pc_ip          = $1 + ($2.to_i+10).to_s
            pc_gw          = $1 + "1"
            pc_mask        = "255.255.255.0"
            #设置静态IP
            args           = {}
            args[:ip]      = pc_ip
            args[:mask]    = pc_mask
            args[:gateway] = pc_gw
            args[:nicname] = @ts_nicname
            args[:source]  = "static"
            static_ip      = netsh_if_ip_setip(args)
            assert(static_ip, "PC1设置固定静态IP失败！")
            #重启一次才能界面才能发生改变
            @browser.span(id: @ts_tag_reboot).click
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            sleep @reboot_time
            login_default(@browser) #重新登录

            # @actual_dut_hostname = get_host_name.to_utf8 #"\u77E5\u8DEF\u6D4B\u8BD5"
            @actual_dutip        = ipconfig("all")[@ts_nicname][:ip][0] #"192.168.100.110"

            tc_devices_list = @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            @browser.iframe(src: @ts_tag_devices_iframe_src).wait_until_present(10)
            @tc_devices_iframe = @browser.iframe(src: @ts_tag_devices_iframe_src)
            assert_match(/#{@ts_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "打开设备列表失败！")

            trs = @tc_devices_iframe.table(id: @ts_device_list_id, class_name: @ts_device_list_cls_name).trs
            trs.each do |item|
                next if item[2].text == "IP"
                # next if item[3].text !~ /@actual_dut_hostname/i #找到要进行比对的设备
                assert_equal(item[2].text, @actual_dutip, "PC1的IP地址显示不正确")
                # assert_equal(item[3].text, @actual_dut_hostname, "PC1的设备名显示不正确")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、将PC的静态地址修改为同网段其他地址，查看接入设备信息是否还包含此PC") {
            dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
            dut_ip =~ /(\d+\.\d+\.\d+\.)(\d+)/
            pc_ip          = $1 + ($2.to_i+20).to_s
            pc_gw          = $1 + "1"
            pc_mask        = "255.255.255.0"
            #设置静态IP
            args           = {}
            args[:ip]      = pc_ip
            args[:mask]    = pc_mask
            args[:gateway] = pc_gw
            args[:nicname] = @ts_nicname
            args[:source]  = "static"
            static_ip      = netsh_if_ip_setip(args)
            assert(static_ip, "PC1设置固定静态IP失败！")

            # @actual_dut_hostname = get_host_name.to_utf8 #"\u77E5\u8DEF\u6D4B\u8BD5"
            @actual_dutip        = ipconfig("all")[@ts_nicname][:ip][0] #"192.168.100.110"

            tc_devices_list = @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            @browser.iframe(src: @ts_tag_devices_iframe_src).wait_until_present(10)
            @tc_devices_iframe = @browser.iframe(src: @ts_tag_devices_iframe_src)
            assert_match(/#{@ts_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "打开设备列表失败！")

            trs = @tc_devices_iframe.table(id: @ts_device_list_id, class_name: @ts_device_list_cls_name).trs
            trs.each do |item|
                next if item[2].text == "IP"
                # next if item[3].text !~ /@actual_dut_hostname/i #找到要进行比对的设备
                assert_equal(item[2].text, @actual_dutip, "PC1的IP地址显示不正确")
                # assert_equal(item[3].text, @actual_dut_hostname, "PC1的设备名显示不正确")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

    def clearup
        operate("恢复默认配置") {
            args           = {}
            args[:nicname] = @ts_nicname
            args[:source]  = "dhcp"
            dhcp_ip        = netsh_if_ip_setip(args)
        }
    end

}
