#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.60", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_ip1 = "0.0.0.0"
        @tc_ip2 = "10.0.0.0"
        @tc_ip3 = "239.1.1.1"
        @tc_ip4 = "240.1.1.1"
        @tc_ip5 = "127.0.0.1"
        @tc_ip6 = "192.168.10"
        @tc_ip7 = "192.168.10.256"
        @tc_ip8 = "a.a.a.a"
    end

    def process

        operate("1��ѡ��PPTP���ŷ�ʽ��") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.select_pptp(@browser.url)
        }

        operate("2����IP��ַ����0��ͷ��ַ����0��β��ַ���磺0.0.0.0��10.0.0.0�Ƿ��������룻") {
            @options_page.pptp_input(@tc_ip1, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "������������ַ����û�д�����ʾ")
            @options_page.pptp_input(@tc_ip2, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "������������ַ����û�д�����ʾ")
        }

        operate("3��IP��ַ�����鲥��ַ����239.1.1.1���Ƿ��������룻") {
            @options_page.pptp_input(@tc_ip3, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "������������ַ����û�д�����ʾ")
        }

        operate("4��IP��ַ����E���ַ����240.1.1.1���Ƿ��������룻") {
            @options_page.pptp_input(@tc_ip4, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "������������ַ����û�д�����ʾ")
        }

        operate("5��IP��ַ���뻷�ص�ַ����127��ͷ�ĵ�ַ����127.0.0.1���Ƿ��������룻") {
            @options_page.pptp_input(@tc_ip5, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "������������ַ����û�д�����ʾ")
        }

        operate("6��IP��ַ��������ʽ��ַ����192.168.10��192.168.10.256��a.a.a.a�ȣ�") {
            @options_page.pptp_input(@tc_ip6, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "������������ַ����û�д�����ʾ")
            @options_page.pptp_input(@tc_ip7, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "������������ַ����û�д�����ʾ")
            @options_page.pptp_input(@tc_ip8, @ts_pptp_usr, @ts_pptp_pw)
            @options_page.pptp_save
            err_msg = @options_page.pptp_err_msg_element
            assert(err_msg.exists?, "������������ַ����û�д�����ʾ")
        }


    end

    def clearup
        operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
