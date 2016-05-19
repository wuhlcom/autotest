#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
    attr = {"id" => "ZLBF_4.1.32", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wan_type    = "WISP"
        @tc_err         = "异常"
        @tc_fail        = "失败"
        @tc_loss        = "100%"
        @tc_http_code   = "404"
    end

    def process

        operate("0、获取陪测AP的ssid跟密码") {
            @browser1         = Watir::Browser.new :ff, :profile => "default"
            @accompany_router = RouterPageObject::AccompanyRouter.new(@browser1)
            @accompany_router.login_accompany_router(@ts_tag_ap_url)
            #陪测AP 2.4G配置
            @accompany_router.open_wireless_24g_page
            #获取ssid和密码
            @ap_ssid = @accompany_router.ap_ssid
            @ap_pwd  = @accompany_router.ap_pwd
            p "陪测AP的ssid为：#{@ap_ssid}，密码为：#{@ap_pwd}".to_gbk
        }

        operate("1、不插入3G上网卡，将网口配置为LAN口，无线WIFI配置为无线WAN，中继的时候输入错误的ROOTAP密码，进行高级诊断") {
            @tc_err_ap_pw = @ap_pwd + "err"
            @wan_page     = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_bridge_pattern(@browser.url, @ap_ssid, @tc_err_ap_pw)

            #打开高级诊断
            @diagnose_advpage = RouterPageObject::DiagnoseAdvPage.new(@browser)
            @diagnose_advpage.initialize_diagadv(@browser)
            #输入地址
            @diagnose_advpage.url_addr = @ts_diag_web
            #点击检测
            @diagnose_advpage.advdiag
            loss = @diagnose_advpage.gw_loss
            @diagnose_advpage.advdiag if loss =~ /gw\s*.+：%/i #如果丢包率出现%时，重新诊断一次
            wan_protocol = @diagnose_advpage.wan_type
            puts "#{wan_protocol}".encode("GBK")
            assert_match(/#{@tc_wan_type}/, wan_protocol, "接入类型错误")

            wanlink = @diagnose_advpage.net_status
            puts "#{wanlink}".encode("GBK")
            assert_match(/#{@tc_err}/, wanlink, "WAN连接状态错误")

            domain_ip = @diagnose_advpage.domain_ip
            puts "#{domain_ip}".encode("GBK")
            assert_match(/#{@tc_fail}/, domain_ip, "域名解析失败")

            loss = @diagnose_advpage.gw_loss
            puts "#{loss}".encode("GBK")
            assert_match(/#{@tc_loss}/, loss, "丢包率错误")

            dns = @diagnose_advpage.dns_parse
            puts "#{dns}".encode("GBK")
            assert_match(/#{@tc_fail}/, dns, "DNS解析失败")

            http_code = @diagnose_advpage.http_code
            puts "#{http_code}".encode("GBK")
            assert_match(/#{@tc_http_code}/, http_code, "状态码错误")
        }

        # operate("2、输入正确的ROOTAP密码，但是ROOTAP不接入Internet，进行高级诊断") {
        #
        # }


    end

    def clearup
        operate("1、恢复默认接入方式DHCP") {
            @browser1.close
            tc_handles = @browser.driver.window_handles
            @browser.driver.switch_to.window(tc_handles[0])
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
        }
    end

}
