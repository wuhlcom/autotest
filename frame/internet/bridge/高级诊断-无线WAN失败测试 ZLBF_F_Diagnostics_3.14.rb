#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.32", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wan_type    = "WISP"
        @tc_err         = "�쳣"
        @tc_fail        = "ʧ��"
        @tc_loss        = "100%"
        @tc_http_code   = "404"
    end

    def process

        operate("0����ȡ���AP��ssid������") {
            @browser1         = Watir::Browser.new :ff, :profile => "default"
            @accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
            @accompany_router.login_accompany_router(@ts_tag_ap_url)
            #���AP 2.4G����
            @accompany_router.open_wireless_24g_page
            #��ȡssid������
            @ap_ssid = @accompany_router.ap_ssid
            @ap_pwd  = @accompany_router.ap_pwd
            p "���AP��ssidΪ��#{@ap_ssid}������Ϊ��#{@ap_pwd}".to_gbk
        }

        operate("1��������3G������������������ΪLAN�ڣ�����WIFI����Ϊ����WAN���м̵�ʱ����������ROOTAP���룬���и߼����") {
            @tc_err_ap_pw = @ap_pwd + "err"
            @wan_page     = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_bridge_pattern(@browser.url, @ap_ssid, @tc_err_ap_pw)

            #�򿪸߼����
            @diagnose_advpage = RouterPageObject::DiagnoseAdvPage.new(@browser)
            @diagnose_advpage.initialize_diagadv(@browser)
            #�����ַ
            @diagnose_advpage.url_addr = @ts_diag_web
            #������
            @diagnose_advpage.advdiag
            loss = @diagnose_advpage.gw_loss
            @diagnose_advpage.advdiag if loss =~ /gw\s*.+��%/i #��������ʳ���%ʱ���������һ��
            wan_protocol = @diagnose_advpage.wan_type
            puts "#{wan_protocol}".encode("GBK")
            assert_match(/#{@tc_wan_type}/, wan_protocol, "�������ʹ���")

            wanlink = @diagnose_advpage.net_status
            puts "#{wanlink}".encode("GBK")
            assert_match(/#{@tc_err}/, wanlink, "WAN����״̬����")

            domain_ip = @diagnose_advpage.domain_ip
            puts "#{domain_ip}".encode("GBK")
            assert_match(/#{@tc_fail}/, domain_ip, "��������ʧ��")

            loss = @diagnose_advpage.gw_loss
            puts "#{loss}".encode("GBK")
            assert_match(/#{@tc_loss}/, loss, "�����ʴ���")

            dns = @diagnose_advpage.dns_parse
            puts "#{dns}".encode("GBK")
            assert_match(/#{@tc_fail}/, dns, "DNS����ʧ��")

            http_code = @diagnose_advpage.http_code
            puts "#{http_code}".encode("GBK")
            assert_match(/#{@tc_http_code}/, http_code, "״̬�����")
        }

        # operate("2��������ȷ��ROOTAP���룬����ROOTAP������Internet�����и߼����") {
        #
        # }


    end

    def clearup
        operate("1���ָ�Ĭ�Ͻ��뷽ʽDHCP") {
            @browser1.close
            tc_handles = @browser.driver.window_handles
            @browser.driver.switch_to.window(tc_handles[0])
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
