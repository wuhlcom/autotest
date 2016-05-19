#
# description:
# author:liluping
# date:2015-09-28
# modify:
#
testcase {
    attr = {"id" => "ZLBF_34.1.2", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
        @tc_ping_num  = 100
    end

    def process

        operate("1、登录AP，进入到定时任务页面") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
        }

        operate("2、配置一个定时时间，例如配置为当前时间的下一分钟，然后开启定时任务，点击保存。") {
            @options_page.restart_step(@browser.url)
        }

        operate("3，查看时间到后路由器是否重启") {
            sleep @tc_wait_time
            #启动ping 192.168.100.1，查看丢包率
            lost_pack = ping_lost_pack(@default_url, @tc_ping_num)
            if lost_pack >= 5 && lost_pack <= 30
                lost_flag = true
            else
                lost_flag = false
            end
            assert(lost_flag, "100个包中丢失#{lost_pack}个包，超过设定区间[5,30],判定为重启不成功！")
        }


    end

    def clearup
        operate("1.将计划任务时间清空") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.clear_all_time(@browser.url)
        }
    end

}
