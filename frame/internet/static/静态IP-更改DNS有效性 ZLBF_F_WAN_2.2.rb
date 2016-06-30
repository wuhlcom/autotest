#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.14", "level" => "P2", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_server_obj            = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_staticBackupDns       = "202.96.128.86"
        @tc_error_staticBackupDns = "192.168.168.1"

        @tc_staticPriDns       = "202.96.134.133"
        @tc_error_staticPriDns = "192.168.168.2"
        @tc_wait_time          = 2
        @tc_cap_time           = 20
        @tc_net_time           = 50
        @tc_cap_fields         = "-e frame.number -e eth.dst -e eth.src -e ip.src -e ip.dst -e dns.qry.name"
    end

    def process

        operate("1����¼DUT����ҳ�棬��BAS����ץ����") {
            puts "������DNSΪ#{@tc_staticPriDns}".encode("GBK")
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @tc_staticPriDns, @browser.url)
        }

        operate("2���ֶ����þ�̬IP��ʽ���룬������IP��ַ��192.168.25.111���������룺255.255.255.0�����أ�192.168.25.9������DNSΪ������Ч��DNS��ַ���磺202.96.134.133�����棻����״̬������ҳ����ʾ��DNS��Ϣ��ʾ�Ƿ�������") {
            @systatus_page = RouterPageObject::SystatusPage.new(@browser)
            @systatus_page.open_systatus_page(@browser.url)
            wan_type = @systatus_page.get_wan_type
            wan_ip   = @systatus_page.get_wan_ip
            wan_mask = @systatus_page.get_wan_mask
            wan_gw   = @systatus_page.get_wan_gw
            wan_dns  = @systatus_page.get_wan_dns
            puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
            puts "��ѯ��WAN IPΪ#{wan_ip}".to_gbk
            puts "��ѯ��WAN��������Ϊ#{wan_mask}".to_gbk
            puts "��ѯ��WAN����Ϊ#{wan_gw}".to_gbk
            puts "��ѯ��WAN DNSΪ#{wan_dns}".to_gbk
            assert_equal(@ts_wan_mode_static, wan_type, '�������ʹ���')
            assert_equal(@ts_staticIp, wan_ip, '��̬IP����ʧ�ܣ�')
            assert_equal(@ts_staticNetmask, wan_mask, '��̬��������ʧ�ܣ�')
            assert_equal(@ts_staticGateway, wan_gw, '��̬��������ʧ�ܣ�')
            assert_equal(@tc_staticPriDns, wan_dns, '��̬DNS����ʧ�ܣ�')
        }

        operate("3��LAN PC����DOS������:ipconfig/flushdns�����PC��DNS����,ִ��ping www.sohu.com����BASץ��ȷ�ϣ�DUT�Ƿ���202.96.134.133���ͳ�DNS����") {
            @tc_main_filter = "dns && ip.dst==#{@tc_staticPriDns}"
            @tc_main_args   ={nic: @ts_server_lannic, filter: @tc_main_filter, duration: @tc_cap_time, fields: @tc_cap_fields}
            puts "Capture filter: #{@tc_main_filter}"
            capture_rs = []
            begin
                thr = Thread.new do
                    capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_args)
                end
                ipconfig_flushdns
                rs = ping(@ts_web)
                thr.join if thr.alive?
            rescue => ex
                p ex.messge.to_s
                assert(false, "Capture DNS Packets ERROR")
            end
            assert(rs, "�޷���������")
            #���capture_rs��Ϊ��˵��ץ���˱���
            puts "Capture Result: #{capture_rs}".to_gbk
            refute(capture_rs.empty?, "δץ��DNS����")
        }

        operate("4���ڲ���2�и���DNSΪ��202.96.134.134���ظ�����3���鿴���Խ����") {
            #������Ч��DNS��Ч
            puts "Set main DNS #{@tc_error_staticPriDns}"
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @tc_error_staticPriDns, @browser.url)

            #������Ч��DNS��ֻ�ж��ܷ�ping����
            rs = ping(@ts_web)
            #DNS���������Ӧ��ping��ͨ
            refute(rs, "�����DNSҲ����������")
        }

        operate("5����������DNS�������ϣ��鿴���Խ����") {
            #��һ������������ȷ��DNS
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @tc_staticPriDns, @browser.url)
            puts "Capture filter: #{@tc_main_filter}"
            capture_rs = []
            begin
                thr = Thread.new do
                    capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_args)
                end
                ipconfig_flushdns
                rs = ping(@ts_web)
                thr.join if thr.alive?
            rescue => ex
                p ex.messge.to_s
                assert(false, "Capture DNS Packets ERROR")
            end
            assert(rs, "�޷���������")
            #���capture_rs��Ϊ��˵��ץ���˱���
            puts "Capture Result:#{capture_rs}"
            refute(capture_rs.empty?, "δץ��DNS����")

            #��DNS�ٴ�һ����������DNS
            puts "Set main DNS #{@tc_error_staticPriDns}"
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @tc_error_staticPriDns, @browser.url)
            rs = ping(@ts_web)
            #DNS���������Ӧ��ping��ͨ
            refute(rs, "�����DNSҲ����������")

        }
    end

    def clearup
        operate("1 �ָ�Ĭ�Ϸ�ʽ:DHCP") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
