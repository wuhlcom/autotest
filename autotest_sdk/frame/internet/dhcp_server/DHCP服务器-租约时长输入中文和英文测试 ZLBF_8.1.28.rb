#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
    attr = {"id" => "ZLBF_8.1.28", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_lease_time1 = "租约"
        @tc_lease_time2 = "FF"
        @tc_lease_error = "租用时间只能是正整数"#"租约时间范围为60-43200"
    end

    def process

        operate("1、登陆路由器进入内网设置") {
            @browser.span(id: @ts_tag_lan).click
            @lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
            assert(@lan_iframe.exists?, "内网设置打开失败!")
        }

        operate("2、更改租约时长输入中文或英文；") {
            puts "修改租期为#{@tc_lease_time1}".encode("GBK")
            @lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time1)
            @lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time1) unless @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value == @tc_lease_time1
            @lan_iframe.button(id: @ts_tag_sbm).click
            error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
            puts "ERROR TIP:#{error_info}".encode("GBK")
            assert_equal(@tc_lease_error, error_info, "未提示租约时间范围")

            puts "修改租期为#{@tc_lease_time2}".encode("GBK")
            @lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time2)
            @lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time2) unless @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value == @tc_lease_time2
            @lan_iframe.button(id: @ts_tag_sbm).click
            error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
            puts "ERROR TIP:#{error_info}".encode("GBK")
            assert_equal(@tc_lease_error, error_info, "未提示租约时间范围")
        }

        operate("3、点击保存") {

        }


    end

    def clearup

    end

}
