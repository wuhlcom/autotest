#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_7.1.26", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1 打开外网连接设置") {
            @wan_page    = RouterPageObject::WanPage.new(@browser)
            @status_page = RouterPageObject::SystatusPage.new(@browser)
        }

        operate("2 设置外网PPPOE接入") {
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("3 检查PPPOE接入网络功能") {
            rs = ping(@ts_web)
            assert(rs, "无法连接网络")
        }

        operate("4 查看WAN状态") {
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            puts "WAN IP:#{wan_addr}"
            puts "WAN TYEP:#{wan_type}"
            puts "WAN Mask:#{mask}"
            puts "WAN Gateway:#{gateway_addr}"
            puts "WAN DNS:#{dns_addr}"
            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
        }

        operate("5 重打开外网连接设置,设置3/4G连接方式") {
            @wan_page.set_3g_auto_dial(@browser.url)
        }

        operate("6 验证业务") {
            rs = ping(@ts_web)
            assert(rs, '无法连接网络')
        }

        operate("7 查看WAN状态") {
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            puts "WAN IP:#{wan_addr}"
            puts "WAN TYEP:#{wan_type}"
            puts "WAN Mask:#{mask}"
            puts "WAN Gateway:#{gateway_addr}"
            puts "WAN DNS:#{dns_addr}"
            assert_match @ts_tag_ip_regxp, wan_addr, '3G获取ip地址失败！'
            assert_match /#{@ts_wan_mode_3g_4g}/, wan_type, '接入类型错误！'
            assert_match @ip_regxp, gateway_addr, '3G获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, mask, '3G获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, '3G获取dns ip地址失败！'

            sim = @status_page.sim_status_element.element.image(src: @ts_tag_img_normal)
            reg = @status_page.reg_status_element.element.image(src: @ts_tag_img_normal)
            assert(sim.exists?, "sim卡状态异常")
            assert(reg.exists?, "sim卡注册失败")
        }


    end

    def clearup

        operate("1 恢复为默认的接入方式，DHCP接入") {
            @browser.refresh #刷新浏览器
            wan_page = RouterPageObject::WanPage.new(@browser)
            wan_page.set_dhcp(@browser, @browser.url)
        }

    end

}
