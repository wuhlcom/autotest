#encoding:utf-8
require "htmltags"
require "drb"
require "router_page_object"
require "rexml/document"
require "fileutils"
require "tardotgz"
class FruitRollup
    include Tardotgz
end
# require "drb/observer"
# 1扫描网络
# 2连接网络
# 3查询网络连接
# 4断开网络连接
# 添加FTP client 操作 2015-10-19 wuhongliang
class Wlan
    include HtmlTag::WinCmd
    include HtmlTag::LogInOut
    include HtmlTag::Wireshark
    include HtmlTag::Reporter
    include HtmlTag::WinCmdSys
    include HtmlTag::WinCmdRoute
    include HtmlTag::Socket
    include HtmlTag::RouterOS
    include HtmlTag::NetshWlan
    stdio("logs/druby_server,log")
    attr_accessor :ftp_client_pid

    def initialize(file_name="", nicname="wireless")
        @file_name =file_name
        # @netobj=HtmlTag::Network.new()
        @pwdobj =HtmlTag::Passwd.new()
        @ftp_client_pid =nil
        @default_srv_file ="QOS_TEST2.zip"
        @default_local_path="D:/ftpdownloads/#{@default_srv_file}"
    end

    #@@passwd_profile = "#{nicname}-#{ssid_name}.xml"
    def create_pwfile(ssid_hash, ssid_name, passwd_profile="", passwd="12345678", nicname="wireless", dlink_a1=false)
        passwd_profile=nicname+"-"+ssid_name+".xml" if passwd_profile==""
        puts "method_name:#{__method__.to_s}"
        args={
            :ssid => ssid_name,
            :passwd => passwd,
            :file_path => passwd_profile,
            :au_type => ssid_hash[:au_type],
            :pass_type => ssid_hash[:pass_type]
        }
        if passwd !="" && !dlink_a1
            puts "create AES passwd"
            @pwdobj.create_aes(args)
        elsif passwd !="" && dlink_a1
            puts "create_TKIP passwd"
            @pwdobj.create_tkip_dlink(args)
        else
            puts "create_none passwd"
            @pwdobj.create_none(args)
        end
    end

    def add_new_connection(ssid_hash, ssid_name, passwd="12345678", passwd_profile="", nicname="wireless", dlink_a1=false)
        passwd_profile=nicname+"-"+ssid_name+".xml" if passwd_profile==""
        puts "method_name:#{__method__.to_s}"
        puts "create passwd file..."
        create_pwfile(ssid_hash, ssid_name, passwd_profile, passwd, nicname, dlink_a1)
        puts "add passwd file..."
        netsh_ap(passwd_profile)
        sleep 2
        puts "show profile info..."
        pros = show_profiles
        pros_arr = pros["wireless"]
        if pros_arr.empty?
            fail("add profile failed!")
        end
        #这里要传入配置文件名是指passwd_profile中name属性的值,而不是passwd_profile文件名
        netsh_conn(ssid_name, nicname)
        puts "Waiting for new connecting..."
        sleep 30
        status = ""
        ip_status = false
        10.times.each { |i|
            puts "query wifi connect status #{i+1} time"
            interface= show_interfaces
            status = interface[nicname][:status]
            break if status =="connected"
            sleep 10
        }
        if status=="connected"
            puts "wirless connected..."
            #无线连接后查询是否获取到IP地址
            6.times.each do |i|
                sleep 10
                puts "query wifi ip status #{i+1} time"
                ipinfo = ipconfig
                ip_gw = ipinfo[nicname][:gateway]
                unless ip_gw.empty? || ip_gw[0]=="0.0.0.0" || ip_gw[0]=~/^169/
                    ip_status = true
                    sleep 5 #查到有IP地址仍等待5秒
                    break
                end
            end
            if ip_status
                puts "#{nicname} get ip address succesfull!"
            else
                puts "#{nicname} get ip address failed!"
            end
        else
            puts "wirless connect failed!!!!"
        end
        return ip_status
    end

    #扫描网络一次
    def scan_network_once(ssid_name, nicname="wireless")
        puts "method_name:#{__method__.to_s}"
        ssid_hash ={}
        networks = show_networks #查找网络
        ssid_find = networks[nicname].keys.any? { |key| key==ssid_name } #判断是否扫描到网络
        if ssid_find
            ssid_hash = networks[nicname][ssid_name]
        end
        {:flag => ssid_find, :ssid_hash => ssid_hash}
    end

    #启用、禁用网卡
    def ss_network_card(nic_name, state)
        netsh_if_setif_admin(nic_name, state)
    end

    def scan_network(ssid_name, nicname="wireless")
        puts "method_name:#{__method__.to_s}"
        disable_nic = "disabled"
        enable_nic = "enabled"
        ssid_find = false
        ssid_hash ={}
        5.times {
            networks = show_networks #查找网络
            ssid_find = networks[nicname].keys.any? { |key| key==ssid_name } #判断是否扫描到网络
            if ssid_find
                ssid_hash = networks[nicname][ssid_name]
                break
            end
            sleep 5
        }
        #如果查询了25秒找不到SSID就禁用和启用一次网卡,再循环扫描
        unless ssid_find
            netsh_if_setif_admin(nicname, disable_nic)
            sleep 2
            netsh_if_setif_admin(nicname, enable_nic)
            sleep 2
            5.times {
                networks = show_networks #查找网络
                ssid_find = networks[nicname].keys.any? { |key| key==ssid_name } #判断是否扫描到网络
                if ssid_find
                    ssid_hash = networks[nicname][ssid_name]
                    break
                end
                sleep 5
            }
        end
        {:flag => ssid_find, :ssid_hash => ssid_hash}
    end

    #已经连接的情况下修改配置文件
    #flag->1 已连接时修改现有密码，2 将加密修改为不加密 3 从不加密修改为加密  (profile_name, passwd, ssid="", nicname="wireless")
    def modify_profile passwd_profile, flag, ssid_name="", passwd="12345678", nicname="wireless"
        puts "method_name:#{__method__.to_s}"
        if flag == "1" #修改aes
            netsh_modify_pass passwd_profile, passwd, ssid_name, nicname
        elsif flag=="2" #无加密
            netsh_set_none passwd_profile, ssid_name, nicname
        elsif flag=="3" #从无加密修改为aes
            netsh_modify_none_pass passwd_profile, passwd, ssid_name, nicname
        end
        sleep 1
        #这里要传入配置文件名是指passwd_profile中name属性的值,而不是passwd_profile文件名
        netsh_conn(ssid_name, nicname)
        puts "Waiting for connecting after modified profile..."
        sleep 30
        interface= show_interfaces
        status = interface["wireless"][:status]
        if status=="connected"
            puts "Connected.."
            return true
        else
            puts "Connect failed"
            return false
        end
    end

    def connect(ssid_name, flag, passwd="12345678", nicname="wireless", passwd_profile="", dlink_a1=false)
        puts "method_name:#{__method__.to_s}"
        fail "The nic state is abnormal!" unless enable_wireless_nic
        nicname = nicname.downcase
        if passwd_profile==""
            passwd_profile=nicname+"-"+ssid_name+".xml"
        end

        #初始化密码文件对象
        puts "Password XML file '#{passwd_profile}' initialize"
        @pwdobj.doc = REXML::Document.new
        @pwdobj.root_el = @pwdobj.doc.add_element("WLANProfile")

        #先删除路径下所有的配置文件
        xml_files = Dir.glob("*.xml") #获取当前目录下的所有xml文件，既是配置文件
        FileUtils.rm(xml_files)

        rs = scan_network(ssid_name)
        if rs[:flag]
            profiles = show_profiles
            profiles_arr = profiles[nicname]
            if profiles_arr.empty? #如果不存在配置文件将要添加配置文件
                p "No Profiles create new XML to connect"
                add_new_connection(rs[:ssid_hash], ssid_name, passwd, passwd_profile, nicname, dlink_a1)
            else
                #删除网卡所有配置文件，这里是删除存在电脑中的配置
                profiles_arr.each { |profile|
                    netsh_dp(profile, nicname)
                }
                #删除了配置文件后，新建配置文件(xml文本)
                p "Profiles do not contain #{ssid_name},create new XML to connect".encode("GBK")
                add_new_connection(rs[:ssid_hash], ssid_name, passwd, passwd_profile, nicname, dlink_a1)
            end
        else
            fail("Can't find wifi ssid:#{ssid_name}")
        end
    end

    def delete_pwfile(passwd_profile)
        puts "method_name:#{__method__.to_s}"
        if File.exists?(passwd_profile)
            open("passwd_profile", "w") { |f|
                f.puts ""
            }
        end
    end

    def login_router(address, usr, pw)
        # browser, default_ip=@@default_ip, usrname="admin", passwd="admin", relogin=false
        begin
            browser = Watir::Browser.new :firefox, :profile => "default"
            browser.cookies.clear
            rs = login_default(browser, address, usr, pw)
        rescue => e
            p e.message.to_s
            rs = false
        ensure
            browser.close unless browser.nil?
        end
        rs
    end

    def drb_ftp_client(server_ip, usr, pw, size, action, srv_file=@default_srv_file, local_path=@default_local_path)
        file_dir = File.dirname(local_path)
        #如果目录不存在则创建目录
        FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
        file_name = File.basename(local_path, ".*")
        Dir.glob("#{file_dir}/*") { |filename|
            filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rf要慎用
        }
        client = File.absolute_path("../ftp_client.rb", __FILE__)
        @ftp_client_pid = Process.spawn("ruby #{client} #{server_ip} #{usr} #{pw} #{srv_file} #{local_path} #{size} #{action}", STDERR => :out)
        sleep 30 #等待ftp客户端下载，无线在等待30以上才能稳定
        @ftp_client_pid
    end

    def drb_stop_ftp_client(pid)
        begin
            if Process.detach(pid).alive? #抓完包后杀死进程
                Process.kill(9, pid)
            end #停止下载
        rescue => ex
            puts "#{ex.message.to_s}"
        end
    end

    #外网访问路由器并恢复出厂设置
    def restore_router(address, usr, pw)
        begin
            browser = Watir::Browser.new :firefox, :profile => "default"
            browser.cookies.clear
            rs = login_default(browser, address, usr, pw)
            if rs
                options_page = RouterPageObject::OptionsPage.new(browser)
                #将路由器恢复出厂设置
                options_page.recover_factory(browser.url)
            end
        rescue => e
            p e.message.to_s
            rs = false
        ensure
            browser.close unless browser.nil?
        end
        rs
    end

    #外网连接路由器
    def remote_login_router(address, usr, pw)
        download_directory = "D:\\remote_download"
        if !File.exists?(download_directory)
            Dir.mkdir(download_directory) #如果目录不存在就创建
        else
            new_dir = download_directory.gsub("\\", "\/")+"/*"
            files = Dir.glob(new_dir)
            FileUtils.rm files #删除目录下所有文件
        end

        ts_file_type = "text/txt,application/rar,application/zip,application/octet-stream"
        ts_default_profile = Selenium::WebDriver::Firefox::Profile.from_name("default")
        ts_default_profile.model_linux_format
        ts_default_profile['browser.helperApps.neverAsk.saveToDisk'] = ts_file_type
        ts_default_profile['browser.download.folderList'] = 2 # custom location
        ts_default_profile['browser.download.dir'] = download_directory #默认下载路径
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.timeout = 120 # seconds
        browser = Watir::Browser.new :ff, :http_client => client, :profile => ts_default_profile
        browser.cookies.clear
        @remote_browser = browser
        rs = login_default(@remote_browser, address, usr, pw)
    end

    def export_config_file
        options_page = RouterPageObject::OptionsPage.new(@remote_browser)
        options_page.export_file_step(@remote_browser, @remote_browser.url)
    end

    def import_config_file(file_path)
        options_page = RouterPageObject::OptionsPage.new(@remote_browser)
        options_page.import_file_step(@remote_browser.url, file_path)
    end

    def close_brower
        @remote_browser.close
    end

    def read_file(path)
        File.read(path)
    end

    # 读取压缩文件中的内容
    def get_tgz_content(tgz_path, str)
        fr = FruitRollup.new
        fr.read_from_archive(tgz_path, /#{str}/)
    end
end

#=begin
wifi = Wlan.new()
ipinfo = wifi.ipconfig
nicname1 = "lan"
nicname2 = "control"
server_port = "8787"
ip_reg = /[1-9]\d{0,2}\.\d{1,3}\.\d{1,3}\.[1-9]\d{0,2}/
puts "..."*20
if ipinfo.has_key?(nicname1)
    puts "NIC '#{nicname1}' ip Array:"
    p ipinfo[nicname1][:ip]
    drb_server_ip = ipinfo[nicname1][:ip][1]
    puts "DRB Server #{drb_server_ip} Started on NIC ##{nicname1} port #{server_port}......"
elsif ipinfo.has_key?(nicname2)
    puts "NIC '#{nicname2}' ip Array:"
    p ipinfo[nicname2][:ip]
    drb_server_ip = ipinfo[nicname2][:ip][0]
    puts "DRB Server #{drb_server_ip} Started on NIC ##{nicname2} port #{server_port}......"
end

if drb_server_ip=~ip_reg && drb_server_ip !~ /^169/
    uri = "druby://#{drb_server_ip}:#{server_port}"
    puts "DRB Server started sucessfully,the uri is: #{uri}"
    DRb.start_service(uri, wifi)
    DRb.thread.join
else
    puts "DRB Server run FAILED! DRB server ip error! Please check!"
end
#=end

=begin
if __FILE__==$0
  p wifi = Wlan.new()
  p wifi.ipconfig
  ssid_name = "autotest-ap"
  nicname = "wireless"
  passwd = "zhilutest"
  flag = "1"
  passwd_profile = "#{nicname}-#{ssid_name}.xml"
  # wifi.instance_eval { @ssid_name="Test2" }
  wifi.connect(ssid_name, flag, passwd, nicname, passwd_profile)
  # p wifi.login_router("192.168.100.1", "admin", "admin")
end
=end



