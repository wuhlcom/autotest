#
# description:
# author:liluping
# date:2015-09-21
# modify:
#
testcase {
    attr = {"id" => "ZLBF_15.1.6", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_wait_time     = 3
        @tc_tag_url_baidu = 'www.baidu.com'
        @tc_tag_url_yahoo = 'www.yahoo.com'
        @tc_tag_url_sohu  = 'www.sohu.com'
        @tc_ping_num      = 5

    end

    def process

        operate("1、DUT的接入类型选择为DHCP，保存配置。再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {
            #连接方式设置为DHCP
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_dhcp(@browser, @browser.url)
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url)
            @options_page.open_switch("on", "on", "off", "off") #打开防火墙和IP总开关
        }

        operate("2、启用IP过滤功能，设置目的IP为一地址段（如192.168.20.100~192.168.20.200），其它都为默认，保存配置，从PC向服务器作ping操作，ping的IP为过滤网段内的地址，然后在服务器查看是否能抓到数据包。") {
            require "ipaddr"
            rs        = Addrinfo.ip(@tc_tag_url_yahoo) #查询该url对应的ip
            dst_ip    = rs.ip_address #"116.214.12.74"
            dstip_toi = IPAddr.new(dst_ip).to_i

            ns         = Addrinfo.ip(@tc_tag_url_baidu) #查询该url对应的ip
            dst_ipt    = ns.ip_address #"58.217.200.112"
            dstipt_toi = IPAddr.new(dst_ipt).to_i

            ss       = Addrinfo.ip(@tc_tag_url_sohu) #查询该url对应的ip
            sohu_ip  = ss.ip_address #"14.18.240.6"
            sohu_toi = IPAddr.new(sohu_ip).to_i

            if dstip_toi > dstipt_toi && dstip_toi > sohu_toi #dstip_toi最大
                if dstipt_toi > sohu_toi
                    ping_ip           = sohu_ip
                    destination_ip    = dst_ipt
                    destination_endip = dst_ip
                else
                    ping_ip           = dst_ipt
                    destination_ip    = sohu_ip
                    destination_endip = dst_ip
                end
            elsif dstipt_toi > dstip_toi && dstipt_toi > sohu_toi #dstipt_toi最大
                if dstip_toi > sohu_toi
                    ping_ip           = sohu_ip
                    destination_ip    = dst_ip
                    destination_endip = dst_ipt
                else
                    ping_ip           = dst_ip
                    destination_ip    = sohu_ip
                    destination_endip = dst_ipt
                end
            elsif sohu_toi > dstipt_toi && sohu_toi > dstip_toi #sohu_ip最大
                if dstip_toi > dstipt_toi
                    ping_ip           = dst_ipt
                    destination_ip    = dst_ip
                    destination_endip = sohu_ip
                else
                    ping_ip           = dst_ip
                    destination_ip    = dst_ipt
                    destination_endip = sohu_ip
                end
            end
            @options_page.ipfilter_click #打开IP过滤页面
            @options_page.ip_add_item_element.click #添加新条目
            @options_page.ip_filter_dst_ip_input(destination_ip, destination_endip)
            @options_page.ip_save #保存
            sleep @tc_wait_time
            ip_network_segment = destination_ip + "-" + destination_endip
            puts "过滤IP地址段为:#{ip_network_segment}".to_gbk

            #验证ip是否过滤
            puts "验证ip过滤是否生效".to_gbk
            p "验证PC1： #{destination_endip}".to_gbk
            rs = send_http_request(destination_endip)
            refute(rs, "ip过滤失败，#{destination_endip}在过滤网段内却能ping通外网!")

            p "验证PC1： #{ping_ip}".to_gbk
            rss = send_http_request(ping_ip)
            assert(rss, "ip过滤失败，#{ping_ip}在过滤网段外却不能ping通外网!")

        }
    end

    def clearup

        operate("恢复默认配置") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            rs = options_page.login_with_exists(@browser.url)
            if rs
                options_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url)
            end
            options_page.ipfilter_close_sw_del_all_step(@browser.url)
        }
    end

}
