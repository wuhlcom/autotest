#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_14.1.13", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time         = 3
        @tc_select_type       = "������"
        @url                  = "www.baidu.com"
        @url_http             = "http://www.baidu.com"
        @tc_intset_list_black = "black"
        @tc_intset_list       = "intset_list"
    end

    def process

        operate("1����¼��URL��������ҳ�棻") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
            @option_iframe.link(id: @ts_tag_security).click #���밲ȫ����
            @option_iframe.link(id: @ts_url_set).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_url_set).click
        }

        operate("2�����ú���������ӹ����������www.sina.com,�Ƿ�����ӳɹ���") {
            b_select = @option_iframe.select_list(id: @ts_url_black) #ѡ�������
            b_select.wait_until_present(@tc_wait_time)
            b_select.select(@tc_select_type)

            @option_iframe.text_field(id: @ts_web_url).set(@url) #���www.sina.com.cn
            @option_iframe.link(class_name: @ts_tag_addvir).click
            urlnew_str = @option_iframe.div(id: @tc_intset_list_black, class_name: @tc_intset_list).text
            urlnew_arr = urlnew_str.split("\n")
            assert(urlnew_arr.include?(@url), "��ӹ�������#{@url}ʧ��!")
        }

        operate("3�����ں�������������ӹ����������www.sina.com,�Ƿ�����ӳɹ���") {
            @option_iframe.text_field(id: @ts_web_url).set(@url) #���www.sina.com.cn
            @option_iframe.link(class_name: @ts_tag_addvir).click
            add_present = @option_iframe.div(class_name: @ts_url_add, text: @ts_url_add_text)
            assert(add_present.exists?, "�����ͬ��������ʱ��δ������ʾ��")
        }

        # operate("4�����ں�������������ӹ����������http://www.sina.com,�Ƿ�����ӳɹ���") {
        #     @option_iframe.text_field(id: @ts_web_url).set(@url_http) #���http://www.sina.com.cn
        #     @option_iframe.link(class_name: @ts_tag_addvir).click
        #     add_present = @option_iframe.div(class_name: @ts_url_add, text: @ts_url_add_text)
        #     assert(add_present.exists?, "��Ӵ���httpǰ׺����ʱ��δ������ʾ��")
        # }


    end

    def clearup

    end

}
