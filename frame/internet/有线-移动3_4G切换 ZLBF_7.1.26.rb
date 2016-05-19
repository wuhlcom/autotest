#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_7.1.26", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1 ��������������") {
            @wan_page    = RouterPageObject::WanPage.new(@browser)
            @status_page = RouterPageObject::SystatusPage.new(@browser)
        }

        operate("2 ��������PPPOE����") {
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("3 ���PPPOE�������繦��") {
            rs = ping(@ts_web)
            assert(rs, "�޷���������")
        }

        operate("4 �鿴WAN״̬") {
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            puts "WAN IP:#{wan_addr}"
            puts "WAN TYEP:#{wan_type}"
            puts "WAN Mask:#{mask}"
            puts "WAN Gateway:#{gateway_addr}"
            puts "WAN DNS:#{dns_addr}"
            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�'
        }

        operate("5 �ش�������������,����3/4G���ӷ�ʽ") {
            @wan_page.set_3g_auto_dial(@browser.url)
        }

        operate("6 ��֤ҵ��") {
            rs = ping(@ts_web)
            assert(rs, '�޷���������')
        }

        operate("7 �鿴WAN״̬") {
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            puts "WAN IP:#{wan_addr}"
            puts "WAN TYEP:#{wan_type}"
            puts "WAN Mask:#{mask}"
            puts "WAN Gateway:#{gateway_addr}"
            puts "WAN DNS:#{dns_addr}"
            assert_match @ts_tag_ip_regxp, wan_addr, '3G��ȡip��ַʧ�ܣ�'
            assert_match /#{@ts_wan_mode_3g_4g}/, wan_type, '�������ʹ���'
            assert_match @ip_regxp, gateway_addr, '3G��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, mask, '3G��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, '3G��ȡdns ip��ַʧ�ܣ�'

            sim = @status_page.sim_status_element.element.image(src: @ts_tag_img_normal)
            reg = @status_page.reg_status_element.element.image(src: @ts_tag_img_normal)
            assert(sim.exists?, "sim��״̬�쳣")
            assert(reg.exists?, "sim��ע��ʧ��")
        }


    end

    def clearup

        operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
            @browser.refresh #ˢ�������
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }

    end

}
