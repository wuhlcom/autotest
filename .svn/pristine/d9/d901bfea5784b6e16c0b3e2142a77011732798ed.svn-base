#
# description:
# author:liluping
# date:2015-09-24
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.10", "level" => "P1", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_dumpcap                = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_wait_time              = 2
        @tc_wait_device_list       = 5
        @tc_net_wait_time          = 60
        @tc_tag_custom_id          = "terminalnum2"
        @tc_tag_customtag          = "zl"
        @tc_tag_image              = "img"
        @tc_tag_devices_iframe_src = "dhcpclient.asp"
        @tc_device_type            = "images/lm222_3.jpg"
        @tc_device_list_id         = "device_list"
        @tc_device_list_cls_name   = "routers-table"
        @tc_net_state_dis          = "disabled"
        @tc_net_state_en           = "enabled"
        @tc_tag_wan_mode_link      = "tab_ip"
        @tc_tag_wire_mode_radio    = "ip_type_dhcp"
        @tc_net_status             = "setstatus"
    end

    def process

        operate("1、被测AP通过WAN连接到外网，下面接多台有线，无线PC，笔记本，手机，ipad等设备。在终端显示列表中是否正常显示所有的设备") {
            #获取dut无线ssid
            @browser.span(id: @ts_tag_lan).click #打开内网
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "打开内网设置失败！")
            @lan_iframe.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_iframe.button(id: @ts_wifi_switch).class_name == "off"
                @lan_iframe.button(id: @ts_wifi_switch).click
            end
            p @ssid = @lan_iframe.text_field(id: @ts_tag_ssid).value
            p @ssid_pwd = @lan_iframe.text_field(id: @ts_tag_ssid_pwd).value
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2连接dut无线
            flag ="1"
            rs   = @tc_dumpcap.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)

            # 测试用设备有两台PC，首先获取各个PC的相关参数：mac、ip、设备名称
            @actual_dutip        = ipconfig("all")["dut"][:ip][0]
            @actual_dutmac       = ipconfig("all")["dut"][:mac].downcase
            # @actual_dut_hostname = ipconfig("all")["host_name"]
            @actual_dut_hostname = get_host_name

            @actual_wirelessip        = @tc_dumpcap.ipconfig("all")["wireless"][:ip][0]
            @actual_wirelessmac       = @tc_dumpcap.ipconfig("all")["wireless"][:mac].downcase
            # @actual_wireless_hostname = @tc_dumpcap.ipconfig("all")["host_name"]
            @actual_wireless_hostname = @tc_dumpcap.get_host_name

            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time) #等待2s
            @browser.span(id: @ts_tag_netset).click

            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src) #新面板，新对象
            assert(@wan_iframe.exists?, "打开外网设置失败！")

            @wan_iframe.link(:id => @tc_tag_wan_mode_link).click #选择网线连接
            dhcp_radio = @wan_iframe.radio(id: @tc_tag_wire_mode_radio)

            unless dhcp_radio.checked?
                dhcp_radio.click
                #保存
                @wan_iframe.button(:id, @ts_tag_sbm).click
                sleep @tc_wait_time
                net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "正在重启网络配置".to_gbk) {
                    net_reset_div.present?
                }
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            tc_devices_list = @browser.element(tag_name: @tc_tag_customtag, id: @tc_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            sleep @tc_wait_device_list
            @browser.iframe(src: @tc_tag_devices_iframe_src)
            @tc_devices_iframe = @browser.iframe(src: @tc_tag_devices_iframe_src)
            assert_match /#{@tc_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "打开设备列表失败！"

            trs_name = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs
            dev_name = []
            trs_name.each do |item|
                next if item[3].text == "\u8BBE\u5907\u540D\u79F0" # "\u8BBE\u5907\u540D\u79F0" == "设备名称"
                dev_name << item[3].text
            end
            p "设备列表中，设备名称有： #{dev_name.join(',')}".to_gbk
            #如果设备名字过长，在路由器连接列表上显示的设备名会不完整
            dev_size = dev_name.size
            dev_name.each_with_index do |item, index|
                break if @actual_dut_hostname =~ /#{item}/
                assert(false, "PC1的设备名称不正确,或者设备列表中没有设备#{@actual_dut_hostname}") if dev_size == index+1 #如果匹配上了就不会来到这一步
            end
            dev_name.each_with_index do |item, index|
                break if @actual_wireless_hostname =~ /#{item}/
                assert(false, "PC2的设备名称不正确,或者设备列表中没有设备#{@actual_wireless_hostname}") if dev_size == index+1 #如果匹配上了就不会来到这一步
            end
            trs_name.each do |item| #代码走到这里表示设备列表中肯定有该设备，否则上面会断言失败
                if @actual_dut_hostname =~ /#{item[3].text}/ #找到要进行比对的设备
                    dut_ip = item[2].text
                    assert_equal(dut_ip, @actual_dutip, "PC1的IP地址不正确！显示为:#{dut_ip},实际为:#{@actual_dutip}")
                    dut_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(dut_mac, @actual_dutmac, "PC1的mac地址不正确！显示为:#{dut_mac},实际为:#{@actual_dutmac}")
                    dut_devicelist_obj = item[0]
                    assert(dut_devicelist_obj.image(src: @tc_device_type).exists?, "PC1设备类型不正确！")
                elsif @actual_wireless_hostname =~ /#{item[3].text}/
                    wireless_ip = item[2].text
                    assert_equal(wireless_ip, @actual_wirelessip, "PC2的IP地址不正确！显示为:#{wireless_ip},实际为:#{@actual_wirelessip}")
                    wireless_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(wireless_mac, @actual_wirelessmac, "PC2的mac地址不正确！显示为:#{wireless_mac},实际为:#{@actual_wirelessmac}")
                    wire_devicelist_obj = item[0]
                    assert(wire_devicelist_obj.image(src: @tc_device_type).exists?, "PC2设备类型不正确！")
                end
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、将部分设备断开连接后，再在终端显示列表中是否正常显示当前最新的设备") {
            # @tc_dumpcap.netsh_if_setif_admin(@ts_wlan_nicname, @tc_net_state_dis) #禁用wireless网卡
            @tc_dumpcap.netsh_disc_all #断开wifi连接
            sleep @tc_wait_device_list

            tc_devices_list = @browser.element(tag_name: @tc_tag_customtag, id: @tc_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            @browser.iframe(src: @tc_tag_devices_iframe_src).wait_until_present(@tc_wait_device_list)
            @tc_devices_iframe = @browser.iframe(src: @tc_tag_devices_iframe_src)
            assert_match /#{@tc_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "打开设备列表失败！"

            table_size = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs.size #总数会包括”设备名称“，应该去掉
            assert_equal(2, table_size, "终端显示更新失败,当前只有1台设备连接路由器，但终端显示有#{table_size-1}台设备连接路由器！")

            trs_name = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs
            dev_name = []
            trs_name.each do |item|
                dev_name << item[3].text
            end
            #如果设备名字过长，在路由器连接列表上显示的设备名会不完整
            dev_size = dev_name.size
            dev_name.each_with_index do |item, index|
                break if @actual_dut_hostname =~ /#{item}/
                assert(false, "PC1的设备名称不正确,或者设备列表中没有设备#{@actual_dut_hostname}") if dev_size == index+1 #如果匹配上了就不会来到这一步
            end
            trs_name.each do |item|
                if item[3].text =~ /@actual_dut_hostname/i #找到要进行比对的设备
                    dut_ip = item[2].text
                    assert_equal(dut_ip, @actual_dutip, "PC1的IP地址不正确！显示为:#{dut_ip},实际为:#{@actual_dutip}")
                    dut_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(dut_mac, @actual_dutmac, "PC1的mac地址不正确！显示为:#{dut_mac},实际为:#{@actual_dutmac}")
                    dut_devicelist_obj = item[0]
                    assert(dut_devicelist_obj.image(src: @tc_device_type).exists?, "PC1设备类型不正确！")
                end
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("3、再将断开的设备连上后，在终端显示列表中是否正常显示完整的当前最新的设备") {
            # @tc_dumpcap.netsh_if_setif_admin(@ts_wlan_nicname, @tc_net_state_en) #恢复连接wireless网卡
            #pc2连接dut无线
            flag ="1"
            rs   = @tc_dumpcap.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败".to_gbk)
            sleep @tc_wait_device_list

            tc_devices_list = @browser.element(tag_name: @tc_tag_customtag, id: @tc_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            @browser.iframe(src: @tc_tag_devices_iframe_src).wait_until_present(@tc_wait_device_list)
            @tc_devices_iframe = @browser.iframe(src: @tc_tag_devices_iframe_src)
            assert_match /#{@tc_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "打开设备列表失败！"

            table_size = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs.size
            assert_equal(3, table_size, "终端显示更新失败,当前只有2台设备连接路由器，但终端显示有#{table_size-1}台设备连接路由器！")

            trs_name = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs
            dev_name = []
            trs_name.each do |item|
                next if item[3].text == "\u8BBE\u5907\u540D\u79F0" # "\u8BBE\u5907\u540D\u79F0" == "设备名称"
                dev_name << item[3].text
            end
            #如果设备名字过长，在路由器连接列表上显示的设备名会不完整
            dev_size = dev_name.size
            dev_name.each_with_index do |item, index|
                break if @actual_dut_hostname =~ /#{item}/
                assert(false, "PC1的设备名称不正确,或者设备列表中没有设备#{@actual_dut_hostname}") if dev_size == index+1 #如果匹配上了就不会来到这一步
            end
            dev_name.each_with_index do |item, index|
                break if @actual_wireless_hostname =~ /#{item}/
                assert(false, "PC2的设备名称不正确,或者设备列表中没有设备#{@actual_wireless_hostname}") if dev_size == index+1 #如果匹配上了就不会来到这一步
            end
            trs_name.each do |item|
                if item[3].text =~ /@actual_dut_hostname/i #找到要进行比对的设备
                    dut_ip = item[2].text
                    assert_equal(dut_ip, @actual_dutip, "PC1的IP地址不正确！显示为:#{dut_ip},实际为:#{@actual_dutip}")
                    dut_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(dut_mac, @actual_dutmac, "PC1的mac地址不正确！显示为:#{dut_mac},实际为:#{@actual_dutmac}")
                    dut_devicelist_obj = item[0]
                    assert(dut_devicelist_obj.image(src: @tc_device_type).exists?, "PC1设备类型不正确！")
                elsif item[3].text =~ /@actual_wireless_hostname/i
                    wireless_ip = item[2].text
                    assert_equal(wireless_ip, @actual_wirelessip, "PC2的IP地址不正确！显示为:#{wireless_ip},实际为:#{@actual_wirelessip}")
                    wireless_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(wireless_mac, @actual_wirelessmac, "PC2的mac地址不正确！显示为:#{wireless_mac},实际为:#{@actual_wirelessmac}")
                    wire_devicelist_obj = item[0]
                    assert(wire_devicelist_obj.image(src: @tc_device_type).exists?, "PC2设备类型不正确！")
                end
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        # operate("4、修改连接终端设备的名称为带特殊字符的，带中文的名称，在终端显示列表中是否能正常显示") {
        #
        # }


    end

    def clearup
        operate("断开wifi连接") {
            # @tc_dumpcap.netsh_if_setif_admin(@ts_wlan_nicname, @tc_net_state_en) #开启wireless网卡
            @tc_dumpcap.netsh_disc_all #断开wifi连接
        }
    end

}
