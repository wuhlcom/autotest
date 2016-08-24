#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.28", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_wait_time = 180 #路由器后台没三分钟刷新一次设备列表
    end

    def process

        operate("1、被测AP下接有线PC,设备PC为静态IP地址后，查看接入设备信息是否还包含此PC") {
            dut_net   = ipconfig("all")[@ts_nicname]
            @dut_mac  = dut_net[:mac].downcase
            @dut_ip   = dut_net[:ip][0]
            @dut_gw   = dut_net[:gateway][0]
            @dut_mask = dut_net[:mask]
            @dut_ip =~ /(\d+\.\d+\.\d+\.)(\d+)/
            if $2.to_i - 10 < 2
                @same_segment_ip = $1 + ($2.to_i+10).to_s
            else
                @same_segment_ip = $1 + ($2.to_i-10).to_s
            end
            @static_ip     = @dut_ip

            p "设置静态IP地址：#{@static_ip}".to_gbk
            args           = {}
            args[:ip]      = @static_ip
            args[:mask]    = @dut_mask
            args[:gateway] = @dut_gw
            args[:nicname] = @ts_nicname
            args[:source]  = "static"
            static_ip      = netsh_if_ip_setip(args)
            assert(static_ip, "PC1设置固定静态IP失败！")
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
            p "设备列表中MAC地址为#{@dut_mac}所对应的数据是：#{dev_data}".to_gbk
            dev_ip   = dev_data[:ip]
            assert_equal(@static_ip, dev_ip, "设备PC为静态IP地址后,已连接设备列表中设备ip信息显示不正确！")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、将PC的静态地址修改为同网段其他地址，查看接入设备信息是否还包含此PC") {
            p "设置PC地址为同网段其他IP地址：#{@same_segment_ip}".to_gbk
            args            = {}
            args[:ip]       = @same_segment_ip
            args[:mask]     = @dut_mask
            args[:gateway]  = @dut_gw
            args[:nicname]  = @ts_nicname
            args[:source]   = "static"
            same_segment_ip = netsh_if_ip_setip(args)
            assert(same_segment_ip, "PC1设置同网段其他IP失败！")
            sleep @tc_wait_time #等待系统后台刷新
            5.times do
                break if @devlist_page.dev_list_element.parent.em_element.exists? && !(@devlist_page.dev_list_element.parent.em_element.text.nil?)
                @devlist_page.refresh
                sleep 1
            end
            dev_size = @devlist_page.get_dev_size #连接设备数
            @devlist_page.open_devlist_page
            dev_data = @devlist_page.get_data(dev_size, @dut_mac)
            p "设备列表中MAC地址为#{@dut_mac}所对应的数据是：#{dev_data}".to_gbk
            dev_ip   = dev_data[:ip]
            assert_equal(@same_segment_ip, dev_ip, "设备PC设置为同网段其他IP地址后,已连接设备列表中设备ip信息显示不正确！")
        }
    end

    def clearup
        operate("恢复默认配置") {
            args           = {}
            args[:nicname] = @ts_nicname
            args[:source]  = "dhcp"
            dhcp_ip        = netsh_if_ip_setip(args)
            netsh_if_ip_setip(args) unless dhcp_ip #如果恢复失败再恢复一次
        }
    end

}
