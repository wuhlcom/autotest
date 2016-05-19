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

        operate("1������APͨ��WAN���ӵ�����������Ӷ�̨���ߣ�����PC���ʼǱ����ֻ���ipad���豸�����ն���ʾ�б����Ƿ�������ʾ���е��豸") {
            #��ȡdut����ssid
            @browser.span(id: @ts_tag_lan).click #������
            @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "����������ʧ�ܣ�")
            @lan_iframe.button(id: @ts_wifi_switch).wait_until_present(@tc_wait_time)
            if @lan_iframe.button(id: @ts_wifi_switch).class_name == "off"
                @lan_iframe.button(id: @ts_wifi_switch).click
            end
            p @ssid = @lan_iframe.text_field(id: @ts_tag_ssid).value
            p @ssid_pwd = @lan_iframe.text_field(id: @ts_tag_ssid_pwd).value
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            #pc2����dut����
            flag ="1"
            rs   = @tc_dumpcap.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi����ʧ��".to_gbk)

            # �������豸����̨PC�����Ȼ�ȡ����PC����ز�����mac��ip���豸����
            @actual_dutip        = ipconfig("all")["dut"][:ip][0]
            @actual_dutmac       = ipconfig("all")["dut"][:mac].downcase
            # @actual_dut_hostname = ipconfig("all")["host_name"]
            @actual_dut_hostname = get_host_name

            @actual_wirelessip        = @tc_dumpcap.ipconfig("all")["wireless"][:ip][0]
            @actual_wirelessmac       = @tc_dumpcap.ipconfig("all")["wireless"][:mac].downcase
            # @actual_wireless_hostname = @tc_dumpcap.ipconfig("all")["host_name"]
            @actual_wireless_hostname = @tc_dumpcap.get_host_name

            @browser.span(id: @ts_tag_netset).wait_until_present(@tc_wait_time) #�ȴ�2s
            @browser.span(id: @ts_tag_netset).click

            @wan_iframe = @browser.iframe(src: @ts_tag_netset_src) #����壬�¶���
            assert(@wan_iframe.exists?, "����������ʧ�ܣ�")

            @wan_iframe.link(:id => @tc_tag_wan_mode_link).click #ѡ����������
            dhcp_radio = @wan_iframe.radio(id: @tc_tag_wire_mode_radio)

            unless dhcp_radio.checked?
                dhcp_radio.click
                #����
                @wan_iframe.button(:id, @ts_tag_sbm).click
                sleep @tc_wait_time
                net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
                Watir::Wait.while(@tc_net_wait_time, "����������������".to_gbk) {
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
            assert_match /#{@tc_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "���豸�б�ʧ�ܣ�"

            trs_name = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs
            dev_name = []
            trs_name.each do |item|
                next if item[3].text == "\u8BBE\u5907\u540D\u79F0" # "\u8BBE\u5907\u540D\u79F0" == "�豸����"
                dev_name << item[3].text
            end
            p "�豸�б��У��豸�����У� #{dev_name.join(',')}".to_gbk
            #����豸���ֹ�������·���������б�����ʾ���豸���᲻����
            dev_size = dev_name.size
            dev_name.each_with_index do |item, index|
                break if @actual_dut_hostname =~ /#{item}/
                assert(false, "PC1���豸���Ʋ���ȷ,�����豸�б���û���豸#{@actual_dut_hostname}") if dev_size == index+1 #���ƥ�����˾Ͳ���������һ��
            end
            dev_name.each_with_index do |item, index|
                break if @actual_wireless_hostname =~ /#{item}/
                assert(false, "PC2���豸���Ʋ���ȷ,�����豸�б���û���豸#{@actual_wireless_hostname}") if dev_size == index+1 #���ƥ�����˾Ͳ���������һ��
            end
            trs_name.each do |item| #�����ߵ������ʾ�豸�б��п϶��и��豸��������������ʧ��
                if @actual_dut_hostname =~ /#{item[3].text}/ #�ҵ�Ҫ���бȶԵ��豸
                    dut_ip = item[2].text
                    assert_equal(dut_ip, @actual_dutip, "PC1��IP��ַ����ȷ����ʾΪ:#{dut_ip},ʵ��Ϊ:#{@actual_dutip}")
                    dut_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(dut_mac, @actual_dutmac, "PC1��mac��ַ����ȷ����ʾΪ:#{dut_mac},ʵ��Ϊ:#{@actual_dutmac}")
                    dut_devicelist_obj = item[0]
                    assert(dut_devicelist_obj.image(src: @tc_device_type).exists?, "PC1�豸���Ͳ���ȷ��")
                elsif @actual_wireless_hostname =~ /#{item[3].text}/
                    wireless_ip = item[2].text
                    assert_equal(wireless_ip, @actual_wirelessip, "PC2��IP��ַ����ȷ����ʾΪ:#{wireless_ip},ʵ��Ϊ:#{@actual_wirelessip}")
                    wireless_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(wireless_mac, @actual_wirelessmac, "PC2��mac��ַ����ȷ����ʾΪ:#{wireless_mac},ʵ��Ϊ:#{@actual_wirelessmac}")
                    wire_devicelist_obj = item[0]
                    assert(wire_devicelist_obj.image(src: @tc_device_type).exists?, "PC2�豸���Ͳ���ȷ��")
                end
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2���������豸�Ͽ����Ӻ������ն���ʾ�б����Ƿ�������ʾ��ǰ���µ��豸") {
            # @tc_dumpcap.netsh_if_setif_admin(@ts_wlan_nicname, @tc_net_state_dis) #����wireless����
            @tc_dumpcap.netsh_disc_all #�Ͽ�wifi����
            sleep @tc_wait_device_list

            tc_devices_list = @browser.element(tag_name: @tc_tag_customtag, id: @tc_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            @browser.iframe(src: @tc_tag_devices_iframe_src).wait_until_present(@tc_wait_device_list)
            @tc_devices_iframe = @browser.iframe(src: @tc_tag_devices_iframe_src)
            assert_match /#{@tc_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "���豸�б�ʧ�ܣ�"

            table_size = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs.size #������������豸���ơ���Ӧ��ȥ��
            assert_equal(2, table_size, "�ն���ʾ����ʧ��,��ǰֻ��1̨�豸����·���������ն���ʾ��#{table_size-1}̨�豸����·������")

            trs_name = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs
            dev_name = []
            trs_name.each do |item|
                dev_name << item[3].text
            end
            #����豸���ֹ�������·���������б�����ʾ���豸���᲻����
            dev_size = dev_name.size
            dev_name.each_with_index do |item, index|
                break if @actual_dut_hostname =~ /#{item}/
                assert(false, "PC1���豸���Ʋ���ȷ,�����豸�б���û���豸#{@actual_dut_hostname}") if dev_size == index+1 #���ƥ�����˾Ͳ���������һ��
            end
            trs_name.each do |item|
                if item[3].text =~ /@actual_dut_hostname/i #�ҵ�Ҫ���бȶԵ��豸
                    dut_ip = item[2].text
                    assert_equal(dut_ip, @actual_dutip, "PC1��IP��ַ����ȷ����ʾΪ:#{dut_ip},ʵ��Ϊ:#{@actual_dutip}")
                    dut_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(dut_mac, @actual_dutmac, "PC1��mac��ַ����ȷ����ʾΪ:#{dut_mac},ʵ��Ϊ:#{@actual_dutmac}")
                    dut_devicelist_obj = item[0]
                    assert(dut_devicelist_obj.image(src: @tc_device_type).exists?, "PC1�豸���Ͳ���ȷ��")
                end
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("3���ٽ��Ͽ����豸���Ϻ����ն���ʾ�б����Ƿ�������ʾ�����ĵ�ǰ���µ��豸") {
            # @tc_dumpcap.netsh_if_setif_admin(@ts_wlan_nicname, @tc_net_state_en) #�ָ�����wireless����
            #pc2����dut����
            flag ="1"
            rs   = @tc_dumpcap.connect(@ssid, flag, @ssid_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi����ʧ��".to_gbk)
            sleep @tc_wait_device_list

            tc_devices_list = @browser.element(tag_name: @tc_tag_customtag, id: @tc_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            @browser.iframe(src: @tc_tag_devices_iframe_src).wait_until_present(@tc_wait_device_list)
            @tc_devices_iframe = @browser.iframe(src: @tc_tag_devices_iframe_src)
            assert_match /#{@tc_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "���豸�б�ʧ�ܣ�"

            table_size = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs.size
            assert_equal(3, table_size, "�ն���ʾ����ʧ��,��ǰֻ��2̨�豸����·���������ն���ʾ��#{table_size-1}̨�豸����·������")

            trs_name = @tc_devices_iframe.table(id: @tc_device_list_id, class_name: @tc_device_list_cls_name).trs
            dev_name = []
            trs_name.each do |item|
                next if item[3].text == "\u8BBE\u5907\u540D\u79F0" # "\u8BBE\u5907\u540D\u79F0" == "�豸����"
                dev_name << item[3].text
            end
            #����豸���ֹ�������·���������б�����ʾ���豸���᲻����
            dev_size = dev_name.size
            dev_name.each_with_index do |item, index|
                break if @actual_dut_hostname =~ /#{item}/
                assert(false, "PC1���豸���Ʋ���ȷ,�����豸�б���û���豸#{@actual_dut_hostname}") if dev_size == index+1 #���ƥ�����˾Ͳ���������һ��
            end
            dev_name.each_with_index do |item, index|
                break if @actual_wireless_hostname =~ /#{item}/
                assert(false, "PC2���豸���Ʋ���ȷ,�����豸�б���û���豸#{@actual_wireless_hostname}") if dev_size == index+1 #���ƥ�����˾Ͳ���������һ��
            end
            trs_name.each do |item|
                if item[3].text =~ /@actual_dut_hostname/i #�ҵ�Ҫ���бȶԵ��豸
                    dut_ip = item[2].text
                    assert_equal(dut_ip, @actual_dutip, "PC1��IP��ַ����ȷ����ʾΪ:#{dut_ip},ʵ��Ϊ:#{@actual_dutip}")
                    dut_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(dut_mac, @actual_dutmac, "PC1��mac��ַ����ȷ����ʾΪ:#{dut_mac},ʵ��Ϊ:#{@actual_dutmac}")
                    dut_devicelist_obj = item[0]
                    assert(dut_devicelist_obj.image(src: @tc_device_type).exists?, "PC1�豸���Ͳ���ȷ��")
                elsif item[3].text =~ /@actual_wireless_hostname/i
                    wireless_ip = item[2].text
                    assert_equal(wireless_ip, @actual_wirelessip, "PC2��IP��ַ����ȷ����ʾΪ:#{wireless_ip},ʵ��Ϊ:#{@actual_wirelessip}")
                    wireless_mac = item[1].text.downcase.gsub!(":", "-")
                    assert_equal(wireless_mac, @actual_wirelessmac, "PC2��mac��ַ����ȷ����ʾΪ:#{wireless_mac},ʵ��Ϊ:#{@actual_wirelessmac}")
                    wire_devicelist_obj = item[0]
                    assert(wire_devicelist_obj.image(src: @tc_device_type).exists?, "PC2�豸���Ͳ���ȷ��")
                end
            end

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        # operate("4���޸������ն��豸������Ϊ�������ַ��ģ������ĵ����ƣ����ն���ʾ�б����Ƿ���������ʾ") {
        #
        # }


    end

    def clearup
        operate("�Ͽ�wifi����") {
            # @tc_dumpcap.netsh_if_setif_admin(@ts_wlan_nicname, @tc_net_state_en) #����wireless����
            @tc_dumpcap.netsh_disc_all #�Ͽ�wifi����
        }
    end

}
