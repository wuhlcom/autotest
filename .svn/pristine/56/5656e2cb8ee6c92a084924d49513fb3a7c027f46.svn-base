#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.28", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time              = 3
        @tc_wait_change            = 60
        @tc_net_wait_time          = 60
        @tc_dhcp_start_ip          = "192.168.100.50"
        @tc_dhcp_end_ip            = "192.168.100.99"
        @tc_default_dhcp_start_ip  = "192.168.100.100"
        @tc_default_dhcp_end_ip    = "192.168.100.200"
        @tc_tag_custom_id          = "terminalnum2"
        @tc_tag_customtag          = "zl"
        @tc_tag_devices_iframe_src = "dhcpclient.asp"
        @tc_device_list_id         = "device_list"
        @tc_device_list_cls_name   = "routers-table"
    end

    def process

        operate("1、被测AP下接有线PC,使设备重新获取一个其他IP地址(可以通过修改地址池实现)，是否能正确显示") {
            @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "打开内网失败")
            @lan_iframe.text_field(id: @ts_tag_lanstart).set(@tc_dhcp_start_ip)
            @lan_iframe.text_field(id: @ts_tag_lanend).set(@tc_dhcp_end_ip)
            @lan_iframe.button(id: @ts_tag_sbm).click
            lan_reset_div = @lan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                lan_reset_div.present?
            }
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            sleep @tc_wait_change
            @actual_dut_hostname = get_host_name.to_utf8
            @actual_dutip        = ipconfig("all")[@ts_nicname][:ip][0]

            tc_devices_list = @browser.element(tag_name: @tc_tag_customtag, id: @tc_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            @browser.iframe(src: @tc_tag_devices_iframe_src).wait_until_present(@tc_net_wait_time)
            @tc_devices_iframe = @browser.iframe(src: @tc_tag_devices_iframe_src)
            assert_match(/#{@tc_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "打开设备列表失败！")

            trs = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs
            trs.each do |item|
                next if item[3].text !~ /@actual_dut_hostname/i #找到要进行比对的设备
                assert_equal(item[2].text, @actual_dutip, "PC1的IP地址显示不正确")
            end
        }


    end

    def clearup
        operate("恢复默认地址池") {
            @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time)
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "打开内网失败")
            @lan_iframe.text_field(id: @ts_tag_lanstart).set(@tc_default_dhcp_start_ip)
            @lan_iframe.text_field(id: @ts_tag_lanend).set(@tc_default_dhcp_end_ip)
            @lan_iframe.button(id: @ts_tag_sbm).click
            lan_reset_div = @lan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text)
            Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                lan_reset_div.present?
            }
        }
    end

}
