#
# description:
# author:liluping
# date:2015-10-%qos 17:05:05
# modify:
#
testcase {
    attr = {"id" => "ZLRM_1.1.21", "level" => "P3", "auto" => "n"}

    def prepare

        @tc_connect_time = 60
        @tc_ap_url       = "192.168.50.1"
    end

    def process

        operate("1��ɨ������AP�����ӵ�����һ��AP") {
            @browser1         = Watir::Browser.new :ff, :profile => "default"
            @accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
            @accompany_router.login_accompany_router(@tc_ap_url)
            @ap_lan_ip = @accompany_router.get_lan_ip
            p "AP��LAN��ipΪ��#{@ap_lan_ip}".to_gbk
            @accompany_router.open_wireless_24g_page #��������2.4G����
            #��ȡssid������
            @ap_ssid = @accompany_router.ap_ssid
            @ap_pwd  = @accompany_router.ap_pwd
            p "���AP��ssidΪ��#{@ap_ssid}������Ϊ��#{@ap_pwd}".to_gbk

            unless @browser.span(:id => @ts_tag_netset).exists?
                rs_login = login_no_default_ip(@browser) #���µ�¼
                assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
            end

            p "·�������ӷ�ʽ��Ϊ����WAN��(�Ž�)".to_gbk
            @wan_page = RouterPageObject::WanPage.new(@browser)
            ssid_flag = @wan_page.set_bridge_pattern(@browser.url, @ap_ssid, @ap_pwd)
            assert(ssid_flag, "����WAN���ӳ����쳣��")

            p "�鿴·���������AP�Ƿ�����ɹ�".to_gbk
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            dut_wan_ip = @status_page.get_wan_ip
            p "·����wan��ip��#{dut_wan_ip}".to_gbk
            refute(dut_wan_ip.nil?, "DUTδ��ȡ�����AP�ĵ�ַ��")
            dut_network = dut_wan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT�����AP����ͬһ���Σ�����ʧ�ܣ�")

            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2����������AP�����������DUT�Ƿ����ٴ��Զ����ӵ�����AP") {
            @accompany_router.ap_reboot(@browser1, @tc_ap_url) #����AP����

            #�ȴ�dut�Զ���������AP
            p "sleeping #{@tc_connect_time} seconds for connect AP..."
            sleep @tc_connect_time

            p "������鿴·�����Ƿ��Զ�����AP�ɹ�".to_gbk
            @status_page.open_systatus_page(@browser.url)
            dut_wan_ip = @status_page.get_wan_ip
            p "·����wan��ip��#{dut_wan_ip}".to_gbk
            refute(dut_wan_ip.nil?, "DUTδ��ȡ�����AP�ĵ�ַ��")
            dut_network = dut_wan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            ap_network  = @ap_lan_ip.slice(/(\d+\.\d+\.\d+)\.\d+/i, 1)
            assert_equal(dut_network, ap_network, "DUT�����AP����ͬһ���Σ��������Զ�����APʧ�ܣ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ��DHCP����") {
            begin
                if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                    @browser.execute_script(@ts_close_div)
                end
                unless @browser.span(:id => @ts_tag_netset).exists?
                    rs_login = login_no_default_ip(@browser) #���µ�¼
                    p rs_login[:flag]
                    p rs_login[:message]
                end

                wan_page = RouterPageObject::WanPage.new(@browser)
                wan_page.set_dhcp(@browser, @browser.url)
            ensure
                @browser1.close
            end
        }
    end

}
