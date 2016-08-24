#encoding:utf-8
#wuhonglinag
#2015-7-25
file_path1 =File.expand_path('../loginout', __FILE__)
file_path2 =File.expand_path('../webdriver_firefox_profile', __FILE__)
require file_path1
require file_path2
require "watir-webdriver"
require 'net/http'
module HtmlTag
    module WinCmdSys
        include HtmlTag::LogInOut

        def tasklist_exists?(imagename)
            rs     =`tasklist /FI "IMAGENAME eq #{imagename}`
            flag   = false
            rs_utf8=rs.encode("UTF-8")
            case rs_utf8
                when /#{imagename}/i
                    flag = true
                when /信息:\s*没有运行的任务匹配指定标准/
                    puts "No task found"
            end
            flag
        end

        def taskkill(imagename)
            rs      = `taskkill /F /FI "IMAGENAME eq #{imagename}"`
            rs_utf8 = rs.encode("UTF-8")
            flag    =false
            case rs_utf8
                when /成功:\s*已终止\s*PID\s*为\s*\d+\s*的进程/i
                    flag=true
                when /信息:\s*没有运行的带有指定标准的任务/
                    puts "No task to be killed"
                when /错误:\s*无法终止\s*PID\s*为\s*\d+\s*的进程/
                    puts "Task kill failed"
            end
            flag
        end

        def judge_login(url)
            puts "#{self.to_s}->method_name:#{__method__}"
            puts "验证：#{url}".to_gbk
            link_error     = "errorTitleText"
            client         = Selenium::WebDriver::Remote::Http::Default.new
            client.timeout = 120 # seconds
            browser        = Watir::Browser.new :ff, :http_client => client, :profile => "default"
            browser.cookies.clear
            begin
                #登陆url
                browser.goto(url)
            rescue
                browser.goto(url) #出现超时等异常时再次尝试登陆
            end
            sleep 1
            judge_link = browser.h1(id: link_error).exists?
            browser.close
            return !judge_link #judge_link:true 不能访问； judge_link:false 可以访问
        end

        def login_vedio(url="www.iqiyi.com")
            puts "#{self.to_s}->method_name:#{__method__}"
            client         = Selenium::WebDriver::Remote::Http::Default.new
            client.timeout = 120 # seconds
            browser        = Watir::Browser.new :ff, :http_client => client, :profile => "default"
            browser.cookies.clear
            begin
                #登陆url
                browser.goto(url)
            rescue
                browser.goto(url) #出现超时等异常时再次尝试登陆
            end
            sleep 1
            browser.ul(class_name: "txt-item fl").lis[0].span(class_name: "txt").click #爱奇艺点播
            sleep 60
            browser.close
        end

        #发送http请求来验证一个url能否访问
        def send_http_request(url)
            puts "#{self.to_s}->method_name:#{__method__}"
            begin
                s  =Net::HTTP.get(url, '/index.html')
                rs = s
            rescue
                #出现异常可以认为是无法获得返回响应，此时响应返回值应该为nil
                rs = false
            end
            if rs
                return true
            else
                return false
            end
        end

        #外网访问web后，恢复出厂设置
        def reset_to_defaults(url, options, advance_src, syssetting, reset, reset_btn, reboot_btn, rebooting, reset_text)
            wait_time      = 3
            client         = Selenium::WebDriver::Remote::Http::Default.new
            client.timeout = 120 # seconds
            browser        = Watir::Browser.new :ff, :http_client => client, :profile => "default"
            browser.cookies.clear
            login = login_default(browser, url)
            if login
                browser.link(:id => options).click #打开高级设置
                option_iframe = browser.iframe(:src => advance_src)
                option_iframe.link(:id => syssetting).wait_until_present(wait_time)
                option_iframe.link(:id => syssetting).click #系统设置
                option_iframe.link(:id => reset).wait_until_present(wait_time)
                option_iframe.link(:id => reset).click #恢复出厂设置
                option_iframe.button(:id => reset_btn).wait_until_present(wait_time)
                option_iframe.button(:id => reset_btn).click #点击恢复出厂设置按钮
                option_iframe.button(:class_name => reboot_btn).wait_until_present(wait_time)
                option_iframe.button(:class_name => reboot_btn).click #点击现在重启
                reboot_status = option_iframe.div(:class_name => rebooting, :text => reset_text).exists?
            else
                reboot_status = login
            end
            browser.close
            return reboot_status
        end

        #外网访问web后，导出配置文件并返回
        def export_configuration_file(url, options, advance_src, syssetting, reset, export)
            wait_time          = 5
            re_file            = ""
            download_directory = "D:\\download"
            if File.directory?(download_directory)
                FileUtils.rm_r(download_directory) #执行前如果目录存在先删除目录
            end
            Dir.mkdir(download_directory) #新建目录

            ts_file_type       = "text/txt,application/rar,application/zip,application/octet-stream"
            ts_default_profile = Selenium::WebDriver::Firefox::Profile.from_name("default")
            ts_default_profile.model_linux_format
            ts_default_profile['browser.helperApps.neverAsk.saveToDisk'] = ts_file_type
            ts_default_profile['browser.download.folderList']            = 2 # custom location
            ts_default_profile['browser.download.dir']                   = download_directory #默认下载路径
            client                                                       = Selenium::WebDriver::Remote::Http::Default.new
            client.timeout                                               = 120 # seconds
            browser                                                      = Watir::Browser.new :ff, :http_client => client, :profile => ts_default_profile
            browser.cookies.clear
            login = login_default(browser, url)
            if login
                browser.link(:id => options).click #打开高级设置
                option_iframe = browser.iframe(:src => advance_src)
                option_iframe.link(:id => syssetting).wait_until_present(wait_time)
                option_iframe.link(:id => syssetting).click #系统设置
                option_iframe.link(:id => reset).wait_until_present(wait_time)
                option_iframe.link(:id => reset).click #恢复出厂设置
                sleep 3
                option_iframe.button(:id => export).wait_until_present(wait_time)
                option_iframe.button(:id => export).click #导出
                sleep wait_time
                configuration_file = Dir.glob(download_directory+"/*").find { |file| file=~/\.dat/i }
                File.open(configuration_file, "r") { |file|
                    re_file = file.read
                    re_file = re_file.encode("UTF-8", {:invalid => :replace, :undef => :replace, :replace => "?"})
                }
            end
            browser.close
            return re_file
        end

        #外网访问web后，导入配置文件
        def import_configuration_file(url, options, advance_src, syssetting, reset, brow_btn, import_btn, import, import_text)
            wait_time          = 5
            download_directory = "D:\\download"
            configuration_file = Dir.glob(download_directory+"/*").find { |file| file=~/\.dat/i }
            client             = Selenium::WebDriver::Remote::Http::Default.new
            client.timeout     = 120 # seconds
            browser            = Watir::Browser.new :ff, :http_client => client, :profile => "default"
            browser.cookies.clear
            login = login_default(browser, url)
            if login
                browser.link(:id => options).click #打开高级设置
                option_iframe = browser.iframe(:src => advance_src)
                option_iframe.link(:id => syssetting).wait_until_present(wait_time)
                option_iframe.link(:id => syssetting).click #系统设置
                option_iframe.link(:id => reset).wait_until_present(wait_time)
                option_iframe.link(:id => reset).click #恢复出厂设置
                option_iframe.button(:id => import_btn).wait_until_present(wait_time)
                option_iframe.file_field(:id => brow_btn).set(configuration_file) #浏览
                option_iframe.button(:id => import_btn).click #导入
                sleep wait_time
                import_status = option_iframe.div(:class_name => import, :text => import_text).exists?
            else
                import_status = login
            end
            browser.close
            return import_status
        end

    end

    module WinCmdRoute
        # 操作网络路由表。
        #
        # ROUTE [-f] [-p] [-4|-6] command [destination]
        # [MASK netmask]  [gateway] [METRIC metric]  [IF interface]
        #
        # -f           清除所有网关项的路由表。如果与某个
        # 命令结合使用，在运行该命令前，
        # 应清除路由表。
        #
        # -p           与 ADD 命令结合使用时，将路由设置为
        # 在系统引导期间保持不变。默认情况下，重新启动系统时，
        # 不保存路由。忽略所有其他命令，
        # 这始终会影响相应的永久路由。Windows 95
        # 不支持此选项。
        #
        # -4           强制使用 IPv4。
        #
        # -6           强制使用 IPv6。
        #
        # command      其中之一:
        # 		             PRINT     打印路由
        # ADD       添加路由
        # DELETE    删除路由
        # CHANGE    修改现有路由
        # destination  指定主机。
        # MASK         指定下一个参数为“网络掩码”值。
        # netmask      指定此路由项的子网掩码值。
        # 如果未指定，其默认设置为 255.255.255.255。
        # gateway      指定网关。
        # interface    指定路由的接口号码。
        # METRIC       指定跃点数，例如目标的成本。

        #操作完成!
        # 路由添加失败: 对象已存在。
        # > route ADD 157.0.0.0 MASK 255.0.0.0  157.55.80.1 METRIC 3 IF 2
        #        destination^         ^mask      ^gateway    metric^    ^Interface
        def cmd_route_add(dst, mask, gw, metric=nil, intf=nil)
            flag=true
            if metric.nil?&&intf.nil?
                rs = `route add "#{dst}" MASK "#{mask}" "#{gw}" -p`
            elsif !metric.nil?&&intf.nil?
                rs = `route add "#{dst}" MASK "#{mask}" "#{gw}" metric "#{metric}" -p`
            elsif metric.nil?&&!intf.nil?
                rs =`route add "#{dst}" MASK "#{mask}" "#{gw}" if #{intf} -p`
            elsif !metric.nil?&&!intf.nil?
                rs = `route add "#{dst}" MASK "#{mask}" "#{gw}" metric "#{metric}" if "#{intf}" -p`
            end
            rs_utf8=rs.encode("UTF-8")
            if rs_utf8 =~/操作完成|路由添加失败:\s*对象已存在/
                flag
            else
                puts "ADD ROUTE Failed"
                flag = false
            end
            flag
        end

        #操作完成!
        #路由删除失败: 找不到元素。
        def cmd_route_delete(dst)
            flag   =true
            rs     = `route delete "#{dst}"`
            rs_utf8=rs.encode("UTF-8")
            if rs_utf8 =~/操作完成/
                flag
            else
                puts "Delete ROUTE Failed"
                flag =false
            end
            flag
        end

        def cmd_route_change dst, mask, gw, metric=nil, intf=nil
            flag=true
            if metric.nil?&&intf.nil?
                rs = `route change "#{dst}" MASK "#{mask}" "#{gw}" -p`
            elsif !metric.nil?&&intf.nil?
                rs = `route change "#{dst}" MASK "#{mask}" "#{gw}" metric "#{metric}" -p`
            elsif metric.nil?&&!intf.nil?
                rs =`route change "#{dst}" MASK "#{mask}" "#{gw}" if #{intf} -p`
            elsif !metric.nil?&&!intf.nil?
                rs = `route change "#{dst}" MASK "#{mask}" "#{gw}" metric "#{metric}" if "#{intf}" -p`
            end

            if rs =~/操作完成/
                flag
            else
                puts "Change ROUTE Failed"
                flag = false
            end
            flag
        end

        # ===========================================================================
        # 		接口列表
        # 15...20 f4 1b 80 00 02 ......Realtek PCIe GBE Family Controller
        # 11...c8 60 00 c5 72 68 ......Atheros AR813x/815x PCI-E Gigabit Ethernet Controller (NDIS 6.20)
        # 1...........................Software Loopback Interface 1
        # 12...00 00 00 00 00 00 00 e0 Microsoft ISATAP Adapter
        # 13...00 00 00 00 00 00 00 e0 Teredo Tunneling Pseudo-Interface
        # 14...00 00 00 00 00 00 00 e0 Microsoft ISATAP Adapter #2
        # 16...00 00 00 00 00 00 00 e0 Microsoft 6to4 Adapter
        # ===========================================================================
        #
        # 		IPv4 路由表
        # ===========================================================================
        # 		活动路由:
        # 		网络目标        网络掩码          网关       接口   跃点数
        # 0.0.0.0          0.0.0.0    192.168.100.1  192.168.100.101     20
        # 50.50.50.0    255.255.255.0            在链路上       50.50.50.55    276
        # 50.50.50.55  255.255.255.255            在链路上       50.50.50.55    276
        # 50.50.50.255  255.255.255.255            在链路上       50.50.50.55    276
        # 100.100.101.0    255.255.255.0    192.168.100.1        127.0.0.1     51
        # 127.0.0.0        255.0.0.0            在链路上         127.0.0.1    306
        # 127.0.0.1  255.255.255.255            在链路上         127.0.0.1    306
        # 127.255.255.255  255.255.255.255            在链路上         127.0.0.1    306
        # 192.168.100.0    255.255.255.0            在链路上   192.168.100.101    276
        # 192.168.100.101  255.255.255.255            在链路上   192.168.100.101    276
        # 192.168.100.255  255.255.255.255            在链路上   192.168.100.101    276
        # 224.0.0.0        240.0.0.0            在链路上         127.0.0.1    306
        # 224.0.0.0        240.0.0.0            在链路上       50.50.50.55    276
        # 224.0.0.0        240.0.0.0            在链路上   192.168.100.101    276
        # 255.255.255.255  255.255.255.255            在链路上         127.0.0.1    306
        # 255.255.255.255  255.255.255.255            在链路上       50.50.50.55    276
        # 255.255.255.255  255.255.255.255            在链路上   192.168.100.101    276
        # ===========================================================================
        # 		永久路由:
        # 		无
        #
        # IPv6 路由表
        # ===========================================================================
        # 		活动路由:
        # 		如果跃点数网络目标      网关
        # 16   1125 ::/0                     2002:c058:6301::c058:6301
        # 1    306 ::1/128                  在链路上
        # 16   1025 2002::/16                在链路上
        # 16    281 2002:3232:3237::3232:3237/128
        # 在链路上
        # 15    276 fe80::/64                在链路上
        # 11    276 fe80::/64                在链路上
        # 15    276 fe80::9127:61ab:5e93:179e/128
        # 在链路上
        # 11    276 fe80::dd91:6c43:cbe5:91fd/128
        # 在链路上
        # 1    306 ff00::/8                 在链路上
        # 15    276 ff00::/8                 在链路上
        # 11    276 ff00::/8                 在链路上
        # ===========================================================================
        # 		永久路由:
        # 		无
        # > route PRINT
        # > route PRINT -4
        # > route PRINT -6
        # > route PRINT 157*          .... 只打印那些匹配  157* 的项
        #这里ip4路由，如果有需求可添加方法解析ipv6路由表
        #----return
        # {:permanent =>
        # 		 {"1.1.1.0" =>
        # 				  {:mask => "255.255.255.0", :gateway => "192.168.100.1", :metric => "1"},
        # 		  "1.1.2.0" =>
        # 				  {:mask => "255.255.255.0", :gateway => "192.168.100.1", :metric => "10"}},
        #  :ipv4route =>
        # 		 {"0.0.0.0"       => {:mask => "0.0.0.0", :gateway => "192.168.100.1", :metric => "192"},
        # 		  "1.1.1.0"       =>
        # 				  {:mask => "255.255.255.0", :gateway => "192.168.100.1", :metric => "192"},
        # 		  "1.1.2.0"       =>
        # 				  {:mask => "255.255.255.0", :gateway => "192.168.100.1", :metric => "127"},
        # 		  "100.100.101.0" =>
        # 				  {:mask => "255.255.255.0", :gateway => "192.168.100.1", :metric => "127"}},
        #  :intflist  =>
        # 		 {"Realtek PCIe GBE Family Controller"                               =>
        # 				  {:index => "15", :mac => "20 f4 1b 80 00 02"},
        # 		  "Atheros AR813x/815x PCI-E Gigabit Ethernet Controller (NDIS 6.20" =>
        # 				  {:index => "11", :mac => "c8 60 00 c5 72 68"}}}
        def cmd_route_print(args="-4")
            if args=="all"
                rs = `route print`
            else
                rs = `route print "#{args}"`
            end
            rs_utf8=rs.encode("UTF-8")
            cmd_parse_route(rs_utf8)
        end

        def cmd_parse_route(rs_utf8)
            arr = rs_utf8.split(/=.*=\n/)
            arr.delete("")
            route_hash             ={}
            route_hash[:permanent] ={}
            route_hash[:ipv4route] ={}
            route_hash[:intflist]  ={}
            arr.each do |type|
                # p type.encode("GBK")
                case type
                    when /永久路由/
                        type_arr = type.split("\n")
                        type_arr.each { |route|
                            route = route.strip
                            if /(?<net>\d+\.\d+\.\d+\.\d+)\s*(?<mask>\d+\.\d+\.\d+\.\d+)\s*(?<gateway>\d+\.\d+\.\d+\.\d+)\s*(?<metric>\d+)/=~route
                                route_hash[:permanent][net] = {mask: mask, gateway: gateway, metric: metric}
                            end
                        }
                    when /活动路由/
                        type_arr = type.split("\n")
                        type_arr.each do |route|
                            route = route.strip
                            if /(?<net>\d+\.\d+\.\d+\.\d+)\s*(?<mask>\d+\.\d+\.\d+\.\d+)\s*(?<gateway>\d+\.\d+\.\d+\.\d+)\s*(?<metric>\d+)/=~route
                                route_hash[:ipv4route][net] = {mask: mask, gateway: gateway, metric: metric}
                            end
                        end
                    when /接口列表/
                        type_arr = type.split("\n")
                        type_arr.each do |intf|
                            intf = intf.strip
                            if /(?<index>\d+).+(?<mac>[0-9a-f]{2}\s+[0-9a-f]{2}\s+[0-9a-f]{2}\s+[0-9a-f]{2}\s+[0-9a-f]{2}\s+[0-9a-f]{2})\s*.+\.(?<desc>\w+\s+.+\w+)/=~intf
                                route_hash[:intflist][desc]={index: index, mac: mac}
                            end
                        end
                end
            end
            route_hash
        end

    end

end

if __FILE__==$0
    # class Test
    # 	include HtmlTag::WinCmdSys
    # end
    # task="ping.exe"
    # p rs = Test.new.tasklist_exists?(task)
    # p Test.new.taskkill(task)
    # rs.strip!
    # y         = rs.split("\n")
    # z         =y.drop(2) #去除从开头开始的两个元素
    # task_hash = {}
    # image_name
    # pid
    # session_name
    # session_id
    # mem_used
    # z.each_with_index { |x, _i|
    # 	p x
    # 	p x.split(" ")
    # 	task_hash[]
    # }

    include HtmlTag::WinCmdSys
    # p reset_to_defaults("192.168.100.1","options","advance.asp","syssetting","reset-titile","reset_submit_btn","aui_state_highlight")
    # p export_configuration_file("192.168.100.1","options","advance.asp","syssetting","reset-titile","setmanExpSetExport")
    p import_configuration_file("192.168.100.1", "options", "advance.asp", "syssetting", "reset-titile", "filename", "update_submit_btn", "aui_content", "正在恢复配置文件，请稍候！")
end