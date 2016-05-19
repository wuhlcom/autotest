#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
    attr = {"id" => "ZLBF_8.1.28", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_lease_time1 = "��Լ"
        @tc_lease_time2 = "FF"
        @tc_lease_error = "����ʱ��ֻ����������"#"��Լʱ�䷶ΧΪ60-43200"
    end

    def process

        operate("1����½·����������������") {
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "�������ô�ʧ��!")
        }

        operate("2��������Լʱ���������Ļ�Ӣ�ģ�") {
            puts "�޸�����Ϊ#{@tc_lease_time1}".encode("GBK")
            @lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time1)
            @lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time1) unless @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value == @tc_lease_time1
            @lan_iframe.button(id: @ts_tag_sbm).click
            error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
            puts "ERROR TIP:#{error_info}".encode("GBK")
            assert_equal(@tc_lease_error, error_info, "δ��ʾ��Լʱ�䷶Χ")

            puts "�޸�����Ϊ#{@tc_lease_time2}".encode("GBK")
            @lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time2)
            @lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time2) unless @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value == @tc_lease_time2
            @lan_iframe.button(id: @ts_tag_sbm).click
            error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
            puts "ERROR TIP:#{error_info}".encode("GBK")
            assert_equal(@tc_lease_error, error_info, "δ��ʾ��Լʱ�䷶Χ")
        }

        operate("3���������") {

        }


    end

    def clearup

    end

}
