#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.8", "level" => "P2", "auto" => "n"}

    def prepare
        @dut_ip       = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
        @tc_wait_time = 3
    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
        }

        operate("2、在IP过虑界面添加一条规则，生效时间设置为0000-1200,源IP为192.168.100.100,其它设置为默认的。当前时间为上午10点，PC1能否访问外网") {
            @options_page.ipfilter_click
            @options_page.ip_add_item_element.click #新增条目
            #获取系统当前时间(小时)
            time_for_hour = Time.now.strftime("%H").to_i
            if (time_for_hour >= 0 && time_for_hour < 12)
                effective_time_start = "0000"
                effective_time_end   = "1200"
            else
                effective_time_start = "1200"
                effective_time_end   = "2359"
            end
            @options_page.eff_start_time = effective_time_start
            @options_page.eff_end_time = effective_time_end
            @options_page.ip_filter_src_ip_input(@dut_ip, @dut_ip)
            @options_page.ip_filter_save

            puts "验证是否可以访问外网！".to_gbk
            response = send_http_request(@ts_web)
            refute(response, "IP过滤失败，在生效时间内，本机IP已过滤，但仍可以访问外网~")
        }

        operate("3、更改生效时间设置为1200-2300，PC1能否访问外网") {
            #获取系统当前时间(小时)
            time_for_hour = Time.now.strftime("%H").to_i
            if (time_for_hour >= 0 && time_for_hour < 12)
                effective_time_start = "1200"
                effective_time_end   = "2359"
            else
                effective_time_start = "0000"
                effective_time_end   = "1200"
            end
            @options_page.ip_filter_table_element.element.trs[1][7].link(class_name: @ts_tag_edit).image.click #编辑第一条规则
            @options_page.eff_start_time1 = effective_time_start
            @options_page.eff_end_time1 = effective_time_end
            @options_page.ip_save1
            sleep @tc_wait_time

            puts "验证是否可以访问外网！".to_gbk
            response = send_http_request(@ts_web)
            assert(response, "IP过滤失败，在生效时间之外，PC1不能访问外网~")
        }


    end

    def clearup
        operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
