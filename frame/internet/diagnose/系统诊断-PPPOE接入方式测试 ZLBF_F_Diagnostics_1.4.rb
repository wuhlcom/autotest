#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.4", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_err_pppoe_usr = "pppoe@err"
        @tc_err_pppoe_pw  = "PPPOEPWERR"
    end

    def process

        operate("1、配置外网设置拨号方式为PPPOE,输入错误的帐户和密码") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@tc_err_pppoe_usr, @tc_err_pppoe_pw, @browser.url)
        }

        operate("2、输入错误的账号密码，使拨号不成功，点击系统诊断，查看诊断结果；") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @diagnose_page = RouterPageObject::DiagnosePage.new(@browser)
            @diagnose_page.initialize_diag(@browser)
            @diagnose_page.switch_page(1) #切换到诊断窗口

            # tc_diag_3gdial_status = @diagnose_page.the_3g
            # puts "3G Dial status:#{tc_diag_3gdial_status}".to_gbk
            # assert_equal(@ts_tag_diag_fail, tc_diag_3gdial_status, "3G状态应该显示为'异常'")

            tc_diag_wan_status = @diagnose_page.wan_conn
            puts "WAN Port status:#{tc_diag_wan_status}".to_gbk
            assert_equal(@ts_tag_diag_success, tc_diag_wan_status, "显示WAN口状态异常")

            tc_diag_internet_status = @diagnose_page.net_status
            puts "Internet status:#{tc_diag_internet_status}".to_gbk
            assert_equal(@ts_tag_diag_fail, tc_diag_internet_status, "显示外网连接状态应该为'异常'")
            tc_diag_internet_err = @diagnose_page.net_status_element.element.parent.parent.div(class_name: @ts_tag_wan_class).text
            assert_equal(@ts_tag_diag_internet_err, tc_diag_internet_err, "网络异常提示内容错误!")

            tc_diag_hardware_status = @diagnose_page.route_status
            puts "Hardware status:#{tc_diag_hardware_status}".to_gbk
            assert_equal(@ts_tag_diag_success, tc_diag_hardware_status, "显示路由器硬件状态异常")

            tc_diag_netspeed_status = @diagnose_page.net_speed
            puts "NetSpeed status:#{tc_diag_netspeed_status}".to_gbk
            assert_equal(@ts_tag_diag_fail, tc_diag_netspeed_status, "显示连接速率异常")

            tc_diag_cpu_status = @diagnose_page.cpu_status
            puts "CPU status:\n#{tc_diag_cpu_status}".to_gbk
            assert_match(@ts_tag_cpu_type_reg, tc_diag_cpu_status, "显示处理器类型异常")
            assert_match(@ts_tag_cpu_name_reg, tc_diag_cpu_status, "显示处理器名称异常")
            assert_match(@ts_tag_cpu_load_reg, tc_diag_cpu_status, "显示处理器负载异常")

            tc_diag_mem_status = @diagnose_page.mem_status
            puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
            assert_match(@ts_tag_mem_total_reg, tc_diag_mem_status, "显示内存总大小类型异常")
            assert_match(@ts_tag_mem_useful_reg, tc_diag_mem_status, "显示可用内存异常")
            assert_match(@ts_tag_mem_cache_reg, tc_diag_mem_status, "显示缓存空间异常")
        }

        operate("3、配置外网设置拨号方式为PPPOE,输入正确的帐户和密码") {
            @diagnose_page.switch_page(0) #切换到路由器窗口
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("4、输入正确的账号密码，使拨号成功，点击系统诊断，查看诊断结果；") {
            @diagnose_page.switch_page(1) #切换到诊断窗口
            sleep 1
            @diagnose_page.rediagnose(60) #重新诊断

            # tc_diag_3gdial_status = @diagnose_page.the_3g
            # puts "3G Dial status:#{tc_diag_3gdial_status}".to_gbk
            # assert_equal(@ts_tag_diag_fail, tc_diag_3gdial_status, "3G状态应该显示为'异常'")

            tc_diag_wan_status = @diagnose_page.wan_conn
            puts "WAN Port status:#{tc_diag_wan_status}".to_gbk
            assert_equal(@ts_tag_diag_success, tc_diag_wan_status, "显示WAN口状态异常")

            tc_diag_internet_status = @diagnose_page.net_status
            puts "Internet status:#{tc_diag_internet_status}".to_gbk
            assert_equal(@ts_tag_diag_success, tc_diag_internet_status, "显示外网连接状态异常")

            tc_diag_hardware_status = @diagnose_page.route_status
            puts "Hardware status:#{tc_diag_hardware_status}".to_gbk
            assert_equal(@ts_tag_diag_success, tc_diag_hardware_status, "显示路由器硬件状态异常")

            tc_diag_netspeed_status = @diagnose_page.net_speed
            puts "Hardware status:#{tc_diag_netspeed_status}".to_gbk
            assert_equal(@ts_tag_diag_success, tc_diag_netspeed_status, "显示连接速率异常")

            tc_diag_cpu_status = @diagnose_page.cpu_status
            puts "CPU status:\n#{tc_diag_cpu_status}".to_gbk
            assert_match(@ts_tag_cpu_type_reg, tc_diag_cpu_status, "显示处理器类型异常")
            assert_match(@ts_tag_cpu_name_reg, tc_diag_cpu_status, "显示处理器名称异常")
            assert_match(@ts_tag_cpu_load_reg, tc_diag_cpu_status, "显示处理器负载异常")

            tc_diag_mem_status = @diagnose_page.mem_status
            puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
            assert_match(@ts_tag_mem_total_reg, tc_diag_mem_status, "显示内存总大小类型异常")
            assert_match(@ts_tag_mem_useful_reg, tc_diag_mem_status, "显示可用内存异常")
            assert_match(@ts_tag_mem_cache_reg, tc_diag_mem_status, "显示缓存空间异常")
        }

        operate("5、测试网不接入Internet，点击系统诊断，查看诊断结果；") {

        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
            @tc_handles = @browser.driver.window_handles
            if @tc_handles.size > 1
                @browser.driver.switch_to.window(@tc_handles[0])
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
