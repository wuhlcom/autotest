#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.11", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_url_type_w = "������"
        @tc_url_arr    = []
        @tc_url_arr << "www.sohu.com"
        @tc_url_arr << "www.tudou.com"
        @tc_url_arr << "www.huanqiu.com"
        @tc_url_arr << "www.qq.com"
        @tc_url_arr << "www.ifeng.com"
    end

    def process

        operate("1����¼��URL��������ҳ�棻") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "off", "on") #��������ǽ��URL�ܿ���
        }

        operate("2���ڰ����������3������URL���˹��򣬱������ã�") {
            @options_page.urlfilter_click
            @options_page.select_urlfilter_type(@tc_url_type_w) #ѡ�������
            url_text = @options_page.url_text_b_element.text
            @tc_url_arr.each do |url|
                @options_page.url_filter_input(url) unless url_text.include?(url) #����������ظ����
                sleep 1
            end
            @options_page.url_filter_save

            p "��֤����ӵ��������Ĺ����Ƿ���Ч".to_gbk #���ܳ��ֱ��治�ɹ���������Ҫ��֤һ��
            @tc_url_arr.each do |url|
                p "PC1����������֤����ӹ����������#{url}".to_gbk
                response = send_http_request(url)
                assert(response, "URL����ʧ�ܣ�#{url}����ӵ���������PC1���ܷ�������")
            end
        }

        operate("3�����URL�����б����棬�Ƿ�ɾ�����е�URL���˹���") {
            @options_page.urlfilter_click #��Ʒ���⣬���ж�α���ʱ�������½���url����
            @options_page.urlfilter_del_all #ɾ���б������й���
            url_text = @options_page.url_text_b_element.text
            assert(url_text.empty?, "�����б�ɾ������ʧ�ܣ�")
            p "ɾ�������б������й�����ٴη�������".to_gbk
            @tc_url_arr.each do |url|
                p "PC1�������ӷ���������#{url}".to_gbk
                response = send_http_request(url)
                refute(response, "URL����ʧ�ܣ�δ���#{url}��������������PC1���ܷ��ʣ�")
            end
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }


    end

    def clearup
        operate("1 �رշ���ǽ�ܿ��غ�URL���˿��ز�ɾ�����й��˹���") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.urlfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
