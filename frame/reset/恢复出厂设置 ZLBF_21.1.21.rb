#
#description:
# 用例太过复杂，整改用例后再实现
# 会大量增加维护成本
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.21", "level" => "P1", "auto" => "n"}

    def prepare
        @ts_download_directory.gsub!("\\", "\/")
        @tc_file_name          = "config.tgz"
    end

    def process
        operate("1 打开高级设置，选择系统设置->恢复出厂设置") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @wan_page     = RouterPageObject::WanPage.new(@browser)
            @status_page  = RouterPageObject::SystatusPage.new(@browser)
        }

        operate("2 点击恢复出厂设置") {
            @options_page.recover_factory(@browser.url)
            rs = @options_page.login_with_exists(@browser.url)
            assert(rs, "恢复出厂设置后未跳转到路由器登录页面!")
        }

        operate("5 打开外网连接设置") {
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("6 设置PPPOE拨号") {
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
        }

        operate("7 查看PPPOE WAN状态") {
            if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            @browser.refresh
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns

            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
        }

        operate("8 验证PPPOE业务") {
            rs = ping(@ts_web)
            assert(rs, '无法连接网络')
        }

        operate("9 重新打开高级设置，选择系统设置->恢复出厂设置") {
            #判断当前下载目录是否有配置文件，如果有则将其重命名
            config_file_old = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
            unless config_file_old.nil?
                puts config_file_old
                timestamp       = Time.now().strftime("%Y%m%d%H%M%S")
                config_file_new = config_file_old.sub(/\./, "_#{timestamp}\.")
                File.rename(config_file_old, config_file_new)
            end
            #删除旧的默认配置文件
            Dir.glob(@ts_download_directory+"/*").delete_if { |file|
                if file=~/default/
                    FileUtils.rm(file, force: true)
                    true
                end
            }
            #如果有名字中不含"default"且与@tc_file_name匹配的将其修改为default配置
            config_file_old = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
            unless config_file_old.nil?
                config_file_default = config_file_old.sub(/\./, "_default\.")
                File.rename(config_file_old, config_file_default)
            end
        }

        operate("10 导出PPPOE配置文件") {
            #处理默认配置后再导出pppoe配置
            @options_page.export_file_step(@browser, @browser.url)
            config_download = Dir.glob(@ts_download_directory+"/*").any? { |file| file=~/#{@tc_file_name}$/ }
            assert(config_download, "PPPOE配置文件下载失败！")
        }

        operate("11 导出PPPOE配置文件后恢复路由器为出厂设置") {
            @options_page.recover_btn
            rs = @options_page.login_with_exists(@browser.url)
            assert(rs, "恢复出厂设置后未跳转到路由器登录页面!")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("12 恢复出厂设置后检查查看WAN状态,PPPOE是否被恢复") {
            @status_page.open_systatus_page(@browser.url)
            wan_type = @status_page.get_wan_type
            assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型未恢复为默认值！'
        }

        operate("13 导入PPPOE配置文件") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
                @browser.execute_script(@ts_close_div)
            end
            pppoe_config_file = Dir.glob(@ts_download_directory+"/*").find { |file| file=~/#{@tc_file_name}$/ }
            #如果找不到配置文件
            refute(pppoe_config_file.nil?, "配置文件不存")
            #设置配置文件
            @options_page.import_file_step(@browser.url, pppoe_config_file)
            rs = @options_page.login_with_exists(@browser.url)
            assert(rs, "导入配置文件后未跳转到路由器登录页面!")
            #重新登录路由器
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("14 导入PPPOE配置文件后查看PPPOE配置信息") {
            @status_page.open_systatus_page(@browser.url)
            wan_addr     = @status_page.get_wan_ip
            wan_type     = @status_page.get_wan_type
            mask         = @status_page.get_wan_mask
            gateway_addr = @status_page.get_wan_gw
            dns_addr     = @status_page.get_wan_dns
            assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
            assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
            assert_match @ts_tag_ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
            assert_match @ts_tag_ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
            assert_match @ts_tag_ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
        }

        operate("15 重新导入配后查看PPPOE业务") {
            rs = ping(@ts_web)
            assert(rs, '无法连接网络')
        }

    end

    def clearup

        operate("1 恢复为默认的接入方式，DHCP接入") {
            if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
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
