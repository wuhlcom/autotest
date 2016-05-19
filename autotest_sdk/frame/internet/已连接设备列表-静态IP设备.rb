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

        operate("1������AP�½�����PC,�豸PCΪ��̬IP��ַ�󣬲鿴�����豸��Ϣ�Ƿ񻹰�����PC") {
            dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
            dut_ip =~ /(\d+\.\d+\.\d+\.)(\d+)/
            pc_ip          = $1 + ($2.to_i+10).to_s
            pc_gw          = $1 + "1"
            pc_mask        = "255.255.255.0"
            #���þ�̬IP
            args           = {}
            args[:ip]      = pc_ip
            args[:mask]    = pc_mask
            args[:gateway] = pc_gw
            args[:nicname] = @ts_nicname
            args[:source]  = "static"
            static_ip      = netsh_if_ip_setip(args)
            assert(static_ip, "PC1���ù̶���̬IPʧ�ܣ�")
            #����һ�β��ܽ�����ܷ����ı�
            @browser.span(id: @ts_tag_reboot).click
            @browser.button(class_name: @ts_tag_reboot_confirm).click
            sleep @reboot_time
            login_default(@browser) #���µ�¼

            # @actual_dut_hostname = get_host_name.to_utf8 #"\u77E5\u8DEF\u6D4B\u8BD5"
            @actual_dutip        = ipconfig("all")[@ts_nicname][:ip][0] #"192.168.100.110"

            tc_devices_list = @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            @browser.iframe(src: @ts_tag_devices_iframe_src).wait_until_present(10)
            @tc_devices_iframe = @browser.iframe(src: @ts_tag_devices_iframe_src)
            assert_match(/#{@ts_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "���豸�б�ʧ�ܣ�")

            trs = @tc_devices_iframe.table(id: @ts_device_list_id, class_name: @ts_device_list_cls_name).trs
            trs.each do |item|
                next if item[2].text == "IP"
                # next if item[3].text !~ /@actual_dut_hostname/i #�ҵ�Ҫ���бȶԵ��豸
                assert_equal(item[2].text, @actual_dutip, "PC1��IP��ַ��ʾ����ȷ")
                # assert_equal(item[3].text, @actual_dut_hostname, "PC1���豸����ʾ����ȷ")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2����PC�ľ�̬��ַ�޸�Ϊͬ����������ַ���鿴�����豸��Ϣ�Ƿ񻹰�����PC") {
            dut_ip = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
            dut_ip =~ /(\d+\.\d+\.\d+\.)(\d+)/
            pc_ip          = $1 + ($2.to_i+20).to_s
            pc_gw          = $1 + "1"
            pc_mask        = "255.255.255.0"
            #���þ�̬IP
            args           = {}
            args[:ip]      = pc_ip
            args[:mask]    = pc_mask
            args[:gateway] = pc_gw
            args[:nicname] = @ts_nicname
            args[:source]  = "static"
            static_ip      = netsh_if_ip_setip(args)
            assert(static_ip, "PC1���ù̶���̬IPʧ�ܣ�")

            # @actual_dut_hostname = get_host_name.to_utf8 #"\u77E5\u8DEF\u6D4B\u8BD5"
            @actual_dutip        = ipconfig("all")[@ts_nicname][:ip][0] #"192.168.100.110"

            tc_devices_list = @browser.element(tag_name: @ts_tag_customtag, id: @ts_tag_custom_id)
            tc_devices_list.wait_until_present(@tc_wait_time)
            tc_devices_list.click
            @browser.iframe(src: @ts_tag_devices_iframe_src).wait_until_present(10)
            @tc_devices_iframe = @browser.iframe(src: @ts_tag_devices_iframe_src)
            assert_match(/#{@ts_tag_devices_iframe_src}/i, @tc_devices_iframe.src, "���豸�б�ʧ�ܣ�")

            trs = @tc_devices_iframe.table(id: @ts_device_list_id, class_name: @ts_device_list_cls_name).trs
            trs.each do |item|
                next if item[2].text == "IP"
                # next if item[3].text !~ /@actual_dut_hostname/i #�ҵ�Ҫ���бȶԵ��豸
                assert_equal(item[2].text, @actual_dutip, "PC1��IP��ַ��ʾ����ȷ")
                # assert_equal(item[3].text, @actual_dut_hostname, "PC1���豸����ʾ����ȷ")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }
    end

    def clearup
        operate("�ָ�Ĭ������") {
            args           = {}
            args[:nicname] = @ts_nicname
            args[:source]  = "dhcp"
            dhcp_ip        = netsh_if_ip_setip(args)
        }
    end

}
