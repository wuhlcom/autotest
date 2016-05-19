#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.18", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_wait_time  = 2
        @tc_product_id = "product-mode"
    end

    def process

        operate("1、点击系统状态的页面，查看页面上显示的产品型号是否正确") {
            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            sys_iframe.b(id: @tc_product_id).wait_until_present(@tc_wait_time)
            product_model = sys_iframe.b(id: @tc_product_id).text
            assert(product_model, "产品型号显示不正确！")
        }


    end

    def clearup

    end

}
