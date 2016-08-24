#
# description:
# author:liluping
# date:2015-09-25
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.10", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
        @tc_telnet_cmd  = "cat /proc/meminfo"
    end

    def process

        operate("1、当前AP通过DHCP接入到测试网") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、点击系统诊断，诊断完成后查看系统内存是否准确，是否包括：") {
            @diagnose_page = RouterPageObject::DiagnosePage.new(@browser)
            @diagnose_page.initialize_diag(@browser)
            @diagnose_page.switch_page(1) #切换到诊断窗口

            tc_diag_mem_status = @diagnose_page.mem_status
            puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
            @memtotal = tc_diag_mem_status.slice(/内存总量\s*：\s*([1-9]+\d*\s*)M/m, 1).to_i*1024
            @memfree  = tc_diag_mem_status.slice(/可用内存\s*：\s*([1-9]+\d*\s*)M/m, 1).to_i*1024
            @cached   = tc_diag_mem_status.slice(/缓存内存\s*：\s*([1-9]+\d*\s*)M/m, 1).to_i*1024
            p "内存总量：#{@memtotal}KB, 可用内存：#{@memfree}KB, 缓存内存：#{@cached}KB".to_gbk

            p "telnet设备，查询内存数据".to_gbk
            telnet_init(@default_url, @ts_unified_platform_user, @ts_unified_platform_pwd)
            @mem_inf = exp_memory_info(@tc_telnet_cmd)
        }


        operate("内存总量：") {
            tel_memtotal = @mem_inf[:memtotal].to_i
            p "Telnet显示内存总量：#{tel_memtotal}KB".to_gbk
            memtotal_dvalue = tel_memtotal-@memtotal
            assert((memtotal_dvalue > -2048 && memtotal_dvalue < 2048), "设备实际内存总量与显示内存总量信息大小不一致，telnet值：#{tel_memtotal},路由器值：#{@memtotal}")
        }

        operate("可用内存：") {
            tel_memfree = @mem_inf[:memfree].to_i
            p "Telnet显示可用内存：#{tel_memfree}KB".to_gbk
            memfree_dvalue = tel_memfree-@memfree
            assert((memfree_dvalue > -2048 && memfree_dvalue < 2048), "设备实际可用内存与显示可用内存信息不一致，telnet值：#{tel_memfree},路由器值：#{@memfree}")
        }

        operate("缓存内存：") {
            tel_cached = @mem_inf[:cached].to_i
            p "Telnet显示缓存内存：#{tel_cached}KB".to_gbk
            cached_dvalue = tel_cached-@cached
            assert((cached_dvalue > -2048 && cached_dvalue < 2048), "设备缓存内存与显示缓存内存信息不一致，telnet值：#{tel_cached},路由器值：#{@cached}")
        }

        # operate("以上各个值可以在串口下使用命令free查看") {
        #
        # }

        operate("3、AP大量接入无线终端，并进行再次诊断查看内存否变化，通过串口命令查看系统内存信息，与页面信息是否一致") {
            @diagnose_page.switch_page(0) #切换到路由器窗口
            p "获取路由器ssid跟密码".to_gbk
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi    = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @dut_ssid  = rs_wifi[:ssid]
            @dut_pwd   = rs_wifi[:pwd]
            p "PC2连接无线wifi".to_gbk
            flag ="1"
            rs   = @tc_dumpcap_pc2.connect(@dut_ssid, flag, @dut_pwd, @ts_wlan_nicname)
            assert(rs, "PC2 wifi连接失败")

            @diagnose_page.switch_page(1) #切换到诊断窗口
            sleep 1
            @diagnose_page.rediagnose(60) #重新诊断


            tc_diag_mem_status = @diagnose_page.mem_status
            puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
            @memtotal_again = tc_diag_mem_status.slice(/内存总量\s*：\s*([1-9]+\d*\s*)M/m, 1).to_i*1024
            @memfree_again  = tc_diag_mem_status.slice(/可用内存\s*：\s*([1-9]+\d*\s*)M/m, 1).to_i*1024
            @cached_again   = tc_diag_mem_status.slice(/缓存内存\s*：\s*([1-9]+\d*\s*)M/m, 1).to_i*1024
            p "内存总量：#{@memtotal_again}KB, 可用内存：#{@memfree_again}KB, 缓存内存：#{@cached_again}KB".to_gbk

            p "telnet设备，查询内存数据".to_gbk
            telnet_init(@default_url, @ts_unified_platform_user, @ts_unified_platform_pwd)
            @mem_inf_again = exp_memory_info(@tc_telnet_cmd)

            tel_memtotal_again = @mem_inf_again[:memtotal].to_i
            p "Telnet显示内存总量：#{tel_memtotal_again}KB".to_gbk
            memtotal_dvalue = tel_memtotal_again-@memtotal_again
            assert((memtotal_dvalue > -2048 && memtotal_dvalue < 2048), "设备实际内存总量与显示内存总量信息大小不一致，telnet值：#{tel_memtotal_again},路由器值：#{@memtotal_again}")

            tel_memfree_again = @mem_inf_again[:memfree].to_i
            p "Telnet显示可用内存：#{tel_memfree_again}KB".to_gbk
            memfree_dvalue = tel_memfree_again-@memfree_again
            assert((memfree_dvalue > -2048 && memfree_dvalue < 2048), "设备实际可用内存与显示可用内存信息不一致，telnet值：#{tel_memfree_again},路由器值：#{@memfree_again}")

            tel_cached_again = @mem_inf_again[:cached].to_i
            p "Telnet显示缓存内存：#{tel_cached_again}KB".to_gbk
            cached_dvalue = tel_cached_again-@cached_again
            assert((cached_dvalue > -2048 && cached_dvalue < 2048), "设备缓存内存与显示缓存内存信息不一致，telnet值：#{tel_cached_again},路由器值：#{@cached_again}")
        }


    end

    def clearup
        operate("1 恢复为默认的接入方式，DHCP接入") {
            @tc_handles = @browser.driver.window_handles
            @browser.driver.switch_to.window(@tc_handles[0]) if @tc_handles.size > 1 #切换到路由器窗口
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
        operate("2 恢复默认ssid") {
            wifi_page = RouterPageObject::WIFIPage.new(@browser)
            wifi_page.modify_default_ssid(@browser.url)
        }
    end

}

