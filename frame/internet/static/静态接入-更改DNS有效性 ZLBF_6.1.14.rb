#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_6.1.14", "level" => "P2", "auto" => "n"}

    def prepare
        DRb.start_service
        @tc_server_obj            = DRbObject.new_with_uri(@ts_drb_server2)
        @tc_staticBackupDns       = "202.96.128.86"
        @tc_error_staticBackupDns = "192.168.168.1"

        @tc_staticPriDns       = "202.96.134.133"
        @tc_error_staticPriDns = "192.168.168.2"
        @tc_wait_time          = 2
        @tc_cap_time           = 20
        @tc_net_time           = 50
        @tc_domain             = "www.baidu.com"
        @tc_cap_fields         = "-e frame.number -e eth.dst -e eth.src -e ip.src -e ip.dst -e dns.qry.name"
    end

    def process

        operate("1、登录DUT设置页面，在BAS开启抓包；") {
            puts "输入主DNS为#{@tc_staticPriDns}".encode("GBK")
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @tc_staticPriDns, @browser.url)
        }

        operate("2、手动设置静态IP方式接入，如输入IP地址：192.168.25.111，子网掩码：255.255.255.0，网关：192.168.25.9，设置DNS为外网有效的DNS地址，如：202.96.134.133，保存；运行状态及设置页面显示的DNS信息显示是否正常；") {
            @systatus_page = RouterPageObject::SystatusPage.new(@browser)
            @systatus_page.open_systatus_page(@browser.url)
            wan_type = @systatus_page.get_wan_type
            wan_ip   = @systatus_page.get_wan_ip
            wan_mask = @systatus_page.get_wan_mask
            wan_gw   = @systatus_page.get_wan_gw
            wan_dns  = @systatus_page.get_wan_dns
            puts "查询到WAN接入方式为#{wan_type}".to_gbk
            puts "查询到WAN IP为#{wan_ip}".to_gbk
            puts "查询到WAN子网掩码为#{wan_mask}".to_gbk
            puts "查询到WAN网关为#{wan_gw}".to_gbk
            puts "查询到WAN DNS为#{wan_dns}".to_gbk
            assert_equal(@ts_wan_mode_static, wan_type, '接入类型错误！')
            assert_equal(@ts_staticIp, wan_ip, '静态IP配置失败！')
            assert_equal(@ts_staticNetmask, wan_mask, '静态掩码配置失败！')
            assert_equal(@ts_staticGateway, wan_gw, '静态网关配置失败！')
            assert_equal(@tc_staticPriDns, wan_dns, '静态DNS配置失败！')
        }

        operate("3、LAN PC上在DOS下输入:ipconfig/flushdns，清除PC的DNS缓存,执行ping www.sohu.com，在BAS抓包确认，DUT是否以202.96.134.133发送出DNS请求；") {
            @tc_main_filter = "dns && ip.dst==#{@tc_staticPriDns}"
            @tc_main_args   ={nic: @ts_server_lannic, filter: @tc_main_filter, duration: @tc_cap_time, fields: @tc_cap_fields}
            puts "Capture filter: #{@tc_main_filter}"
            capture_rs = []
            begin
                thr = Thread.new do
                    capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_args)
                end
                ipconfig_flushdns
                rs = ping(@tc_domain)
                thr.join if thr.alive?
            rescue => ex
                p ex.messge.to_s
                assert(false, "Capture DNS Packets ERROR")
            end
            assert(rs, "无法连接外网")
            #如果capture_rs不为空说明抓到了报文
            puts "Capture Result: #{capture_rs}".to_gbk
            refute(capture_rs.empty?, "未抓到DNS报文")
        }

        operate("4、在步骤2中更改DNS为：202.96.134.134，重复步骤3，查看测试结果；") {
            #输入无效主DNS无效
            puts "Set main DNS #{@tc_error_staticPriDns}"
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @tc_error_staticPriDns, @browser.url)

            #输入无效的DNS后，只判断能否ping外网
            rs = ping(@tc_domain)
            #DNS错误情况下应该ping不通
            refute(rs, "错误的DNS也能连接外网")
        }

        operate("5、反复更改DNS三次以上，查看测试结果。") {
            #再一次重新输入正确的DNS
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @tc_staticPriDns, @browser.url)
            puts "Capture filter: #{@tc_main_filter}"
            capture_rs = []
            begin
                thr = Thread.new do
                    capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_args)
                end
                ipconfig_flushdns
                rs = ping(@tc_domain)
                thr.join if thr.alive?
            rescue => ex
                p ex.messge.to_s
                assert(false, "Capture DNS Packets ERROR")
            end
            assert(rs, "无法连接外网")
            #如果capture_rs不为空说明抓到了报文
            puts "Capture Result:#{capture_rs}"
            refute(capture_rs.empty?, "未抓到DNS报文")

            #主DNS再次一个输入错误的DNS
            puts "Set main DNS #{@tc_error_staticPriDns}"
            @wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @tc_error_staticPriDns, @browser.url)
            rs = ping(@tc_domain)
            #DNS错误情况下应该ping不通
            refute(rs, "错误的DNS也能连接外网")

        }
    end

    def clearup
        operate("1 恢复默认方式:DHCP") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
