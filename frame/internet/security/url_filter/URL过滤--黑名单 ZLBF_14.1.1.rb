#
# description:
# author:liluping
# date:2015-09-16
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.1", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_url_type_b    = "������"
        @tc_tag_url_yahoo = 'www.yahoo.com'
        @tc_tag_url_baidu = 'www.baidu.com'
        @tc_tag_url_sina  = 'www.sina.com.cn'
    end

    def process

        operate("1����½DUT��WAN��������ΪPPPoE��ʽ��") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("2���Ƚ��뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�URL���ǿ��أ����棻") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on")
        }

        operate("3������URL��������ҳ�棬ѡ�����������ӹ��˹ؼ���www.yahoo.com�����棻") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_b) #ѡ�������
            url_text = @options_page.url_text_w_element.text
            unless url_text.include?(@tc_tag_url_yahoo) #����������ظ����
                @options_page.url_filter_input(@tc_tag_url_yahoo)
                @options_page.url_filter_save
            end
        }

        operate("4��PC1,PC2�Ƿ���Է���www.sina.com.cn��www.yahoo.cn��www.baidu.com��վ�㡣") {
            puts "���ù��˹������֤�Ƿ�ɷ���#{@tc_tag_url_baidu}վ��...".to_gbk
            response = send_http_request(@tc_tag_url_baidu)
            assert(response, "URL����ʧ�ܣ�#{@tc_tag_url_baidu}δ��ӵ����������������Է���")

            puts "���ڷ���#{@tc_tag_url_sina}վ��...".to_gbk
            response = send_http_request(@tc_tag_url_sina)
            assert(response, "URL����ʧ�ܣ�#{@tc_tag_url_sina}δ��ӵ����������������Է���")

            puts "���ڷ���#{@tc_tag_url_yahoo}վ��...".to_gbk
            response = send_http_request(@tc_tag_url_yahoo)
            refute(response, "URL����ʧ�ܣ�#{@tc_tag_url_yahoo}����ӵ��������������Է���")
        }

    end

    def clearup
        operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }

        operate("2 �رշ���ǽ�ܿ��غ�URL���˿��ز�ɾ�����й��˹���") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.urlfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
