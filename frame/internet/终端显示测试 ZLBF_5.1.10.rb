#
# description:
# author:liluping
# date:2015-09-24
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.10", "level" => "P1", "auto" => "n"}

    def prepare
        @wifi_drb          = DRbObject.new_with_uri(@ts_drb_pc2)
        # @tc_wait_time      = 180
        @dut_con_type      = "有线"
        @wireless_con_type = "无线"
    end

    def process

        operate("1、被测AP通过WAN连接到外网，下面接多台有线，无线PC，笔记本，手机，ipad等设备。在终端显示列表中是否正常显示所有的设备") {
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi    = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @dut_ssid  = rs_wifi[:ssid]
            @dut_pwd   = rs_wifi[:pwd]
            #pc2连接dut无线
            flag       ="1"
            rs         = @wifi_drb.connect(@dut_ssid, flag, @dut_pwd, @ts_wlan_nicname)
            assert(rs, "PC2无线连接wifi失败".to_gbk)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            # 测试用设备有两台PC，首先获取各个PC的相关参数：mac、ip、设备名称
            dut_net   = ipconfig("all")[@ts_nicname]
            @dut_ip   = dut_net[:ip][0]
            @dut_mac  = dut_net[:mac].downcase
            @dut_name = get_host_name

            wireless_net   = @wifi_drb.ipconfig("all")[@ts_wlan_nicname]
            @wireless_ip   = wireless_net[:ip][0]
            @wireless_mac  = wireless_net[:mac].downcase
            @wireless_name = @wifi_drb.get_host_name

            # p "等待#{@tc_wait_time}s用于系统后台刷新。。。".to_gbk
            # sleep @tc_wait_time #等待系统后台刷新
            @browser.refresh
            sleep 1
            @browser.refresh
            sleep 1
            @devlist_page = RouterPageObject::DevlistPage.new(@browser)
            dev_size      = @devlist_page.get_dev_size #连接设备数
            assert_equal(2, dev_size, "已连接列表连接设备数目不正确！")
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            p "设备列表中MAC地址为#{@dut_mac}所对应的数据是：#{dev_data}".to_gbk
            dev_ip       = dev_data[:ip]
            dev_name     = dev_data[:dev_name]
            dev_con_type = dev_data[:connect_type]
            assert_equal(@dut_ip, dev_ip, "已连接设备列表中MAC地址为#{@dut_mac}的设备ip信息显示不正确！")
            assert_match(dev_name, @dut_name, "已连接设备列表中MAC地址为#{@dut_mac}的设备设备名称信息显示不正确！")
            assert_match(@dut_con_type, dev_con_type, "已连接设备列表中MAC地址为#{@dut_mac}的设备连接方式信息显示不正确！")
            wireless_data = @devlist_page.get_data(dev_size, @wireless_mac)
            p "设备列表中MAC地址为#{@wireless_mac}所对应的数据是：#{wireless_data}".to_gbk
            wireless_ip       = wireless_data[:ip]
            wireless_name     = wireless_data[:dev_name]
            wireless_con_type = wireless_data[:connect_type]
            assert_equal(@wireless_ip, wireless_ip, "已连接设备列表中MAC地址为#{@wireless_mac}的设备ip信息显示不正确！")
            assert_match(wireless_name, @wireless_name, "已连接设备列表中MAC地址为#{@wireless_mac}的设备设备名称信息显示不正确！")
            assert_match(@wireless_con_type, wireless_con_type, "已连接设备列表中MAC地址为#{@wireless_mac}的设备连接方式信息显示不正确！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、将部分设备断开连接后，再在终端显示列表中是否正常显示当前最新的设备") {
            p "断开wifi连接".to_gbk
            @wifi_drb.netsh_disc_all #断开wifi连接
            # sleep @tc_wait_time #等待系统后台刷新
            @browser.refresh
            sleep 1
            @browser.refresh
            sleep 1
            dev_size = @devlist_page.get_dev_size #连接设备数
            assert_equal(1, dev_size, "已连接列表连接设备数目显示不正确!")
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            p "设备列表中MAC地址为#{@dut_mac}所对应的数据是：#{dev_data}".to_gbk
            dev_ip       = dev_data[:ip]
            dev_name     = dev_data[:dev_name]
            dev_con_type = dev_data[:connect_type]
            assert_equal(@dut_ip, dev_ip, "已连接设备列表中MAC地址为#{@dut_mac}的设备ip信息显示不正确！")
            assert_match(dev_name, @dut_name, "已连接设备列表中MAC地址为#{@dut_mac}的设备设备名称信息显示不正确！")
            assert_match(@dut_con_type, dev_con_type, "已连接设备列表中MAC地址为#{@dut_mac}的设备连接方式信息显示不正确！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("3、再将断开的设备连上后，在终端显示列表中是否正常显示完整的当前最新的设备") {
            #pc2连接dut无线
            flag ="1"
            rs   = @wifi_drb.connect(@dut_ssid, flag, @dut_pwd, @ts_wlan_nicname)
            assert(rs, "PC2无线连接wifi失败".to_gbk)
            wireless_net   = @wifi_drb.ipconfig("all")[@ts_wlan_nicname]
            @wireless_ip   = wireless_net[:ip][0]
            @wireless_mac  = wireless_net[:mac].downcase
            @wireless_name = @wifi_drb.get_host_name
            # sleep @tc_wait_time #等待系统后台刷新
            @browser.refresh
            sleep 1
            @browser.refresh
            sleep 1
            @devlist_page = RouterPageObject::DevlistPage.new(@browser)
            dev_size      = @devlist_page.get_dev_size #连接设备数
            assert_equal(2, dev_size, "已连接列表连接设备数目不正确！")
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            p "设备列表中MAC地址为#{@dut_mac}所对应的数据是：#{dev_data}".to_gbk
            dev_ip       = dev_data[:ip]
            dev_name     = dev_data[:dev_name]
            dev_con_type = dev_data[:connect_type]
            assert_equal(@dut_ip, dev_ip, "已连接设备列表中MAC地址为#{@dut_mac}的设备ip信息显示不正确！")
            assert_match(dev_name, @dut_name, "已连接设备列表中MAC地址为#{@dut_mac}的设备设备名称信息显示不正确！")
            assert_match(@dut_con_type, dev_con_type, "已连接设备列表中MAC地址为#{@dut_mac}的设备连接方式信息显示不正确！")
            wireless_data = @devlist_page.get_data(dev_size, @wireless_mac)
            p "设备列表中MAC地址为#{@wireless_mac}所对应的数据是：#{wireless_data}".to_gbk
            wireless_ip       = wireless_data[:ip]
            wireless_name     = wireless_data[:dev_name]
            wireless_con_type = wireless_data[:connect_type]
            assert_equal(@wireless_ip, wireless_ip, "已连接设备列表中MAC地址为#{@wireless_mac}的设备ip信息显示不正确！")
            assert_match(wireless_name, @wireless_name, "已连接设备列表中MAC地址为#{@wireless_mac}的设备设备名称信息显示不正确！")
            assert_match(@wireless_con_type, wireless_con_type, "已连接设备列表中MAC地址为#{@wireless_mac}的设备连接方式信息显示不正确！")
        }

        # operate("4、修改连接终端设备的名称为带特殊字符的，带中文的名称，在终端显示列表中是否能正常显示") {
        #
        # }


    end

    def clearup
        operate("1.断开wifi连接") {
            @wifi_drb.netsh_disc_all #断开wifi连接
        }
        operate("2.恢复默认ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end

}
