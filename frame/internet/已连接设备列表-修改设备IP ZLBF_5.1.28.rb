#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.28", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time          = 180 #路由器后台没三分钟刷新一次设备列表
        @tc_dhcp_start         = "50"
        @tc_dhcp_end           = "99"
        @tc_default_dhcp_start = "100"
        @tc_default_dhcp_end   = "200"
    end

    def process

        operate("1、被测AP下接有线PC,使设备重新获取一个其他IP地址(可以通过修改地址池实现)，是否能正确显示") {
            @lan_page = RouterPageObject::LanPage.new(@browser)
            @lan_page.open_lan_page(@browser.url)
            @lan_page.lan_startip_set(@tc_dhcp_start)
            @lan_page.lan_endip_set(@tc_dhcp_end)
            @lan_page.btn_save_lanset
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
            dut_net  = ipconfig("all")[@ts_nicname]
            @dut_mac = dut_net[:mac].downcase
            @dut_ip  = dut_net[:ip][0]
            puts "网卡#{@ts_nicname}对应的mac地址为：#{@dut_mac}，对应的ip地址为：#{@dut_ip}".to_gbk
            sleep @tc_wait_time #等待系统后台刷新
            @devlist_page = RouterPageObject::DevlistPage.new(@browser)
            5.times do
                break if @devlist_page.dev_list_element.parent.em_element.exists? && !(@devlist_page.dev_list_element.parent.em_element.text.nil?)
                @devlist_page.refresh
                sleep 1
            end
            dev_size      = @devlist_page.get_dev_size #连接设备数
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            dev_ip   = dev_data[:ip]
            assert_equal(@dut_ip, dev_ip, "已连接设备列表中设备ip信息显示不正确！")
        }


    end

    def clearup
        operate("恢复默认地址池") {
            lan_page = RouterPageObject::LanPage.new(@browser)
            lan_page.open_lan_page(@browser.url)
            lan_page.lan_startip_set(@tc_default_dhcp_start)
            lan_page.lan_endip_set(@tc_default_dhcp_end)
            lan_page.btn_save_lanset
        }
    end

}
