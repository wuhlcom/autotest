#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.1", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_current_software = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*current/ }
        @tc_upload_file      = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*new/ }
        @tc_upload_file =~ /(V\d+R\d+C\d+SPC\d+)/
        @tc_upload_vername = Regexp.last_match(1)
        puts "New version file:#{@tc_upload_file}"
        puts "New version name:#{@tc_upload_vername}"
        #Ĭ��SSID
        @tc_default_ssid = "WIFI_"+@ts_sub_mac
        puts "Default SSID:#{@tc_default_ssid}"

        #��Ҫ���õ�SSID
        @tc_ssid = "zhilutest_#{@ts_sub_mac}"
        DRb.start_service
        @wifi         = DRbObject.new_with_uri(@ts_drb_server)
        @tc_wifi_flag = "1"
        @tc_wait_time = 2
        @tc_tag_on    = "ON"
    end

    def process

        operate("1 ��·����WAN����,����PPPOEģʽ") {
            #�����Ȳ�ѯ��ǰ����汾
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            @tc_current_ver = @status_page.get_current_software_ver
            puts "Current version: #{@tc_current_ver}"

            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("2 �޸�·����SSID") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @tc_ssid = rs_wifi[:ssid]
            @tc_pwd = rs_wifi[:pwd]
        }

        operate("3 ���߿ͻ�������·����") {
            rs = @wifi.connect(@tc_ssid, @tc_wifi_flag, @tc_pwd)
            assert rs, "WIFI����ʧ��"
            sleep @tc_wait_time #�ȴ����������ȶ�
        }

        operate("4 �鿴·����������Ϣ") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            wifi_on_off  = @status_page.get_wifi_switch
            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
            assert_match /#{@tc_wire_mode}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�'
            assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI״̬����ȷ!")
        }

        operate("5 ��֤�ͻ�������ҵ��") {
            rs1 = @wifi.ping(@ts_web)
            rs2 = ping(@ts_web)
            assert(rs1, "���߿ͻ����޷���������")
            assert(rs2, "���߿ͻ����޷���������")
        }

        operate("6 ����·�������") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.update_step(@browser.url, @tc_upload_file)
            @browser.refresh
            sleep @tc_wait_time
            @login_page = RouterPageObject::LoginPage.new(@browser)
            rs          = @login_page.login_with_exists(@browser.url)
            assert rs, "��ת����¼ҳ��ʧ��!"

            #���µ�¼·����
            rs_login = login_no_default_ip(@browser) #���µ�¼
            assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
        }

        operate("7 ��������汾��Ϣ") {
            @status_page.open_systatus_page(@browser.url)
            @tc_vername_after = @status_page.get_current_software_ver
            puts "After updated, the version name is: #{@tc_vername_after}"
            refute_equal(@tc_current_ver, @tc_vername_after, "����ʧ�ܣ�")
        }

        operate("8 ��������������Ϣ") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            wifi_on_off  = @status_page.get_wifi_switch
            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
            assert_match /#{@tc_wire_mode}/, wan_type, '�������ʹ���'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE��ȡip��ַ����ʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE��ȡ����ip��ַʧ�ܣ�'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE��ȡdns ip��ַʧ�ܣ�'
            assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI״̬����ȷ!")

        }

        operate("9 ����������֤�ͻ���ҵ����") {
            rs1 = @wifi.ping(@ts_web)
            rs2 = ping(@ts_web)
            assert(rs1, "���߿ͻ����޷���������")
            assert(rs2, "���߿ͻ����޷���������")
        }

    end

    def clearup

        operate("1 �ָ�Ĭ�ϰ汾") {
            @wifi.netsh_disc_all #�Ͽ�wifi����
            login_page = RouterPageObject::LoginPage.new(@browser)
            rs         = login_page.login_with_exists(@browser.url)
            if rs
                rs_login = login_no_default_ip(@browser) #���µ�¼
                assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
            end
            status_page = RouterPageObject::SystatusPage.new(@browser)
            status_page.open_systatus_page(@browser.url)
            tc_current_ver = status_page.get_current_software_ver
            puts "The Testing Version #{@tc_current_ver}"
            puts "The cunrret version name is #{tc_current_ver}"
            unless tc_current_ver==@tc_current_ver
                options_page = RouterPageObject::OptionsPage.new(@browser)
                options_page.update_step(@browser.url, @tc_current_software)
                @browser.refresh
                sleep @tc_wait_time
                rs = login_page.login_with_exists(@browser.url)
                if rs
                    #���µ�¼·����
                    rs_login = login_no_default_ip(@browser) #���µ�¼
                    p rs_login[:flag]
                    p rs_login[:message]
                    status_page.open_systatus_page(@browser.url)
                    tc_current_ver = status_page.get_current_software_ver
                    puts "After recover,the version name is #{tc_current_ver}"
                end
            end
        }

        operate("2 ·�������ûָ���������") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.recover_factory(@browser.url)
        }

    end

}
