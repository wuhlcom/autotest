#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.26", "level" => "P1", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_server_obj = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_domain     = "www.baidu.com"
        @tc_cap_time   = 20
        @tc_wait_time  = 2
        @tc_cap_fields = "-e frame.number -e eth.dst -e eth.src -e ip.src -e ip.dst -e dns.qry.name"
    end

    def process

        operate("1、BAS、LAN PC同时开启抓包；") {

        }

        operate("2、DUT上配置相应的PPPoE 方式接入配置，DNS选择自动从ISP获取，保存；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @sys_page = RouterPageObject::SystatusPage.new(@browser)
            puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("3、查看DUT获取的DNS信息是否正确，运行状态及设置页面显示的DNS信息显示是否正常；") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end

            @sys_page.open_systatus_page(@browser.url)
            wan_addr     = @sys_page.get_wan_ip
            wan_type     = @sys_page.get_wan_type
            mask         = @sys_page.get_wan_mask
            gateway_addr = @sys_page.get_wan_gw
            dns_addr     = @sys_page.get_wan_dns
            @tc_dns_addr = dns_addr.slice(/(\d+\.\d+\.\d+\.\d+)\s*(\d+\.\d+\.\d+\.\d+)/, 1)
            assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
            assert_match @ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
            assert_match @ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
            assert_match @ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
        }

        operate("4、LAN PC上在DOS下输入:ipconfig/flushdns，清除PC的DNS缓存,执行ping www.sohu.com；") {
            @tc_main_filter = "dns && ip.dst==#{@tc_dns_addr}"
            @tc_main_args   ={nic: @ts_server_lannic, filter: @tc_main_filter, duration: @tc_cap_time, fields: @tc_cap_fields}
            puts "Capture filter: #{@tc_main_filter}"
            capture_rs = []
            begin
                thr = Thread.new do
                    capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_args)
                end
                #清除DNS缓存
                ipconfig_flushdns
                rs = ping(@tc_domain)
                thr.join if thr.alive?
            rescue => ex
                p ex.messge.to_s
                assert(false, "Capture DNS Packets ERROR")
            end
            assert(rs, "无法连接外网")
            #如果capture_rs不为空说明抓到了报文
            puts "Capture Result: #{capture_rs}"
            refute(capture_rs.empty?, "未抓到DNS报文")
        }

        operate("5、在BAS抓包确认，DUT是否以获取的所有DNS服务器发送出DNS请求；") {
            #第四步已经实现
        }

        operate("6、LAN PC对www.sohu.com解释是否成功。") {
            #第四步已经实现
        }
    end

    def clearup

        operate("恢复默认DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            unless @browser.span(:id => @ts_tag_netset).exists?
                login_recover(@browser, @ts_default_ip)
            end
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
