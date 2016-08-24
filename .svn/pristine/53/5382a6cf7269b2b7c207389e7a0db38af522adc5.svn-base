#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.37", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dmz_ip       = "192.168.200.200"
        @tc_network_file = "network"
        @tc_zhilu_file   = "zhilu"
        @tc_wifi_file    = "wireless"
    end

    def process

        operate("1 先恢复路由器出厂设置") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.recover_factory(@browser.url)
            login_ui    = @options_page.login_with_exists(@browser.url)
            assert(login_ui, "恢复出厂设置后系统未跳转到登录界面！")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("2、配置WAN连接为PPPoE方式，输入正确用户名与密码，保存，拨号是否成功，PC上网业务是否正常；") {
            @wan_page = RouterPageObject::WanPage.new(@browser)
            @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

            rs = ping(@ts_web)
            assert(rs, "PPPOE上网失败")
        }

        operate("3、修改LAN口IP地址，修改地址池范围，修改无线SSID，修改无线安全，修改无线高级参数，添加端口转发规则、端口触发规则、添加URL过滤规则、IP与端口过滤规则、开启UPNP功能、开启DMZ功能、开启DDNS功能、修改登录密码等，") {
            @lan_page = RouterPageObject::LanPage.new(@browser)
            @lan_page.lan_ip_config(@ts_dhcp_server_ip, @browser.url)
            login_ui = @lan_page.login_with_exists(@browser.url)
            assert(login_ui, "修改LAN口IP地址后系统未跳转到登录界面！")
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
            @lan_page.open_lan_page(@browser.url)
            @lan_ip = @lan_page.lan_ip
            p "局域网ip为：#{@lan_ip}".to_gbk
            @wifi_page = RouterPageObject::WIFIPage.new(@browser)
            rs_wifi    = @wifi_page.modify_ssid_mode_pwd(@browser.url)
            @ssid      = rs_wifi[:ssid]
            @pwd       = rs_wifi[:pwd]
            p "修改ssid为：#{@ssid}，密码为：#{@pwd}".to_gbk
            @options_page.set_dmz(@tc_dmz_ip, @browser.url)
            p "修改dmz主机ip为：#{@tc_dmz_ip}".to_gbk
        }

        operate("4、点击备份，查看备份文件操作是否成功；") {
            #取出下载目录下的所有文件绝对路径存入数组
            old_backup_files = Dir.glob(@ts_backup_directory+"/*")
            #删除目录下所有配置文件
            old_backup_files.each do |file|
                FileUtils.rm_rf(file) if file=~/#{@ts_default_config_name}$/
            end
            old_config = Dir.glob(@ts_backup_directory+"/*").any? { |file| file=~/#{@ts_default_config_name}$/ }
            refute(old_config, "旧的配置文件未删除")
            @options_page.export_file_step(@browser, @browser.url) #导出配置文件

            #查看文件是否下载成功
            config_flag = false
            Dir.glob(@ts_backup_directory+"/*").each { |file|
                if file=~/#{@ts_default_config_name}$/
                    config_flag=true
                    break
                end
            }
            assert(config_flag, "系统配置文件下载失败！")

            archive_path = @ts_backup_directory + "/" + @ts_default_config_name
            network_file = get_tgz_content(archive_path, /#{@tc_network_file}/) #读取network配置文件
            wifi_file    = get_tgz_content(archive_path, /#{@tc_wifi_file}/) #读取wireless配置文件
            zhilu_file   = get_tgz_content(archive_path, /#{@tc_zhilu_file}/) #读取zhilu配置文件
            puts "配置文件匹配结果".encode("GBK")
            matchs = network_file =~ /option proto '#{@ts_wan_mode_pppoe}'/i &&
                network_file =~ /option username '#{@ts_pppoe_usr}'/i &&
                network_file =~ /option password '#{@ts_pppoe_pw}'/i &&
                network_file =~ /option ipaddr '#{@lan_ip}'/i &&
                wifi_file =~ /option ssid '#{@ssid}'/i &&
                wifi_file =~ /option key '#{@pwd}'/i &&
                zhilu_file =~ /option dmzEnable '1'/i &&
                zhilu_file =~ /option dmzAddress '#{@tc_dmz_ip}'/i
            assert(false, "导出的配置文件内容异常") unless matchs
        }
    end

    def clearup

        operate("1 恢复出厂设置以恢复默认配置") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.recover_factory(@browser.url)
            # ## 采用命令方式回复出厂设置，防止路由器登录失败以至无法恢复默认配置
            # lan_ip = ipconfig[@ts_nicname][:gateway][0]
            # telnet_init(lan_ip, @ts_unified_platform_user, @ts_unified_platform_pwd)
            # exp_ralink_init
        }

    end

}
