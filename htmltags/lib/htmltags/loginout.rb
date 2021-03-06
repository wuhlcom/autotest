#encoding:utf-8
#login router
#logout router
#1登录是否成功，增加刷新操作 wuhongliang
# author : wuhongliang
# date   : 2015-6-05
file_path1 =File.expand_path('../wincmd', __FILE__)
file_path2 =File.expand_path('../router_telnet', __FILE__)
file_path3 =File.expand_path('../htmltagobj', __FILE__)
require file_path1
require file_path2
require file_path3
module HtmlTag
  module LogInOut
    include HtmlTag::WinCmd
    include HtmlTag::RouterTelnet

    @@default_ip="192.168.100.1"

    def self.included(base)
      base.extend(self)
    end

    #路由器基本登录
    #打开浏览器->输入地址->输入用户名，密码->点击登录
    #relogin==true则进行重登录,不会在地址栏输入地址，相当于login_no_default_ip(browser, usrname="admin", passwd="admin")
    #relogin==false则是新登录，在地址输入地址
    def login_default(browser, default_ip=@@default_ip, usrname="admin", passwd="admin", relogin=false)
      puts "[#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}] #{self.to_s}->method_name:#{__method__}"
      tag_usr        = 'admuser'
      tag_pw         = 'admpass'
      tag_login_btn  = '登录'
      wait_time      = 3
      tag_lan        = "set_wifi"
      tag_options    = "options"
      tag_sysversion = "sysversion"
      rs_login       = false
      browser.cookies.clear
      browser.refresh
      sleep 1
      browser.refresh
      sleep 1
      unless relogin
        puts "Enter url address!"
        browser.goto(default_ip)
        sleep 2
        rs_login = browser.text_field(:name, tag_usr).exists?
        browser.refresh
        sleep 1
        browser.refresh
        sleep 1
        rs_login = browser.text_field(:name, tag_usr).exists?
        unless rs_login
          puts "open login page failed!"
          return rs_login
        end
      end
      rs_login = browser.text_field(:name, tag_usr).exists?
      if rs_login
        puts "Enter usrname and passwd!"
        browser.text_field(:name, tag_usr).click
        browser.text_field(:name, tag_usr).set(usrname)
        browser.text_field(:name, tag_pw).click
        browser.text_field(:name, tag_pw).set(passwd)
        browser.button(:value, tag_login_btn).click
        sleep wait_time
        if browser.button(:value, tag_login_btn).exists? #调试时发现有时会有点击登录按钮未生效现象，就再点击一次
          browser.button(:value, tag_login_btn).click
          sleep wait_time
        end
        5.times do
          rs_login = browser.link(:id => tag_options).exists? && !(browser.span(:id => tag_sysversion).text.slice(/系统版本:(.+)/, 1).nil?)
          break if rs_login
          browser.refresh
          sleep 1
        end
        unless rs_login
          puts "after enter usr and pw,set_wifi tag not present! login router failed!"
          return rs_login
        end
      else
        puts "login page not present!"
      end
      return rs_login
    end

    #检测性登录
    #登录前ping测试网络,如果ping不通则提示连接失败
    def login(browser, default_ip=@@default_ip, usrname="admin", passwd="admin", relogin=false)
      puts "#{self.to_s}->method_name:#{__method__}"
      if ping_default(default_ip)
        login_default(browser, default_ip, usrname, passwd, relogin)
      else
        puts("Error :Ping Router failed!")
        false
      end
    end

    #如果ping不通启用和禁用网卡后再登录
    def login_admin(browser, default_ip=@@default_ip, usrname="admin", passwd="admin", relogin=false, nicname="dut")
      puts "#{self.to_s}->method_name:#{__method__}"
      if ping_admin(default_ip, nicname)
        login_default(browser, default_ip, usrname, passwd)
      else
        puts("Error :Ping Router failed!")
        false
      end
    end

    #如果ping不通，会操作网卡，最终会把网卡设置为了dhcp模式
    def login_dhcp(browser, default_ip=@@default_ip, usrname="admin", passwd="admin", relogin=false, nicname="dut")
      puts "#{self.to_s}->method_name:#{__method__}"
      if ping_dhcp(default_ip, nicname)
        login_default(browser, default_ip, usrname, passwd)
      else
        puts("Error :Ping Router failed!")
        false
      end
    end

    #路由器已经登录,恢复为默认配置
    def router_recover(browser)
      puts "[#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}] #{self.to_s}->method_name:#{__method__}"
      puts "#{self.to_s}->method_name:#{__method__}"
      tag_usr_name         = "admuser"
      ts_reboot_time       = 120
      ts_relogin_time      = 60
      wait_time            = 3
      ts_tag_option        = "options"
      ts_tag_system        = "syssetting"
      ts_tag_reset         = "reset-titile"
      ts_tag_reset_btn     = "reset_submit_btn"
      ts_tag_reset_confirm = "aui_state_highlight"
      begin
        option = browser.link(:id => ts_tag_option).wait_until_present(wait_time)
        browser.link(:id => ts_tag_option).click if option
        sleep wait_time+2
        option_iframe = browser.iframe
        option_iframe.link(:id, ts_tag_system).click #点击系统设置
        sleep wait_time
        option_iframe.link(:id, ts_tag_reset).click #点击配置恢复
        sleep wait_time
        option_iframe.button(:id, ts_tag_reset_btn).click #点击恢复出厂设置
        sleep wait_time
        option_iframe.button(:class_name, ts_tag_reset_confirm).click #确认恢复出厂设置
        puts "sleep #{ts_reboot_time} seconds for router recovering seconds....."
        sleep ts_reboot_time
        rs = browser.text_field(:name, tag_usr_name).wait_until_present(ts_relogin_time)
      rescue => ex
        p "------------------------router_recover----------------------------"
        p ex.message.to_s
        print ex.backtrace.join("\n")
        print "\n"
        p "------------------------router_recover----------------------------"
        rs=false
      end
      return rs
    end

    #当pc ip为default_ip说明路由器此时的地址不为default_ip
    #此时pc网关地址为路由器的登录地址，
    #用网关地址登录路由器，恢复路由器出厂值
    def cip_default_recover(browser, ip, usrname, passwd)
      puts "[#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}] #{self.to_s}->method_name:#{__method__}"
      login_recover_rs = false
      puts("Recover router default dhcp server!")
      #使用非默认地址登录路由器,登录后将路由器恢复出厂值
      login_state = login_default(browser, ip, usrname, passwd, false)
      #如果登录路由器失败返回false
      unless login_state
        return false
      end
      rs = router_recover(browser)
      if rs
        #使用默认地址登录路由器
        login_recover_rs      = login_default(browser, @@default_ip, usrname, passwd, true)
        @router_recover_state = true
      else
        puts("ERROR:login_recover failed,can't relogin with default ip!")
      end
      return login_recover_rs
    end

    #路由器恢复性登录
    #第一次登录失败会断电一次然后重新登录
    def login_recover(browser, powerip, default_ip=@@default_ip, nicname="dut", usrname="admin", passwd="admin", count="5", telnetusr="root", telentpw="zl4321")
      puts "[#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}] #{self.to_s}->method_name:#{__method__}"
      power_sw_err=false
      begin
        init_router_obj(powerip, telnetusr, telentpw)
        power_on
        logout_router #退出telnet登录
      rescue => ex
        puts "Telnet power switch #{powerip} failed!"
        puts ex.message.to_s
        power_sw_err=true
      end
      rs = login_router(browser, default_ip, usrname, passwd, nicname, count)
      if !rs || power_sw_err
        begin
          init_router_obj(powerip, telnetusr, telentpw)
          power_off_on
          puts "After power reset,sleeping 120 seconds..."
          logout_router #退出telnet登录
          sleep 120
          rs = login_router(browser, default_ip, usrname, passwd, nicname, count)
        rescue => ex
          puts "Operating power switch #{powerip} failed!"
          puts ex.message.to_s
          power_sw_err=true
        end
      end
      return rs
    end

    #路由器恢复性登录
    # 增加login_recover，当使用默认的路由器lan ip登录不上,使用网卡网关来登录并恢复路由器的默认设置
    #当lan dhcp服务地址发生改变时，尝试登录并恢复默认路由器dhcp服务器为默认地址
    #如果ping_rs为true则表示可以使用默认地址连接
    #如果ping_rs为Hash则表示lan dhcp不为默认地址需要使用修改后的地址来连接
    #{:ip=>["172.168.0.101"], :mask=>["255.255.255.0"], :dns_server=>[], :gateway=>["172.168.0.1"], :dhcp_state=>"yes"}
    def login_router(browser, default_ip=@@default_ip, usrname="admin", passwd="admin", nicname="dut", count="5", telnetusr="root", telentpw="zl4321")
      puts "[#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}] #{self.to_s}->method_name:#{__method__}"
      tc_dhcp_args          = {nicname: nicname, source: "dhcp"}
      @router_recover_state = false
      login_recover_rs      = false
      args                  = {nicname: nicname, type: "addresses"}
      ip_info               = netsh_if_ip_show(args)

      if ip_info[:ip][0] == default_ip
        gateway = ip_info[:gateway][0]
        puts("Recover router default dhcp server!")
        rs = cip_default_recover(browser, gateway, usrname, passwd)
        return rs
      end

      result = ping_recover(default_ip, nicname, count)
      #result为true表示ping指定IP成功
      #result为hash表示ping指定IP失败，路由器LAN不是默认IP，这里要先恢复为默认IP
      if result==true
        #使用默认地址登录
        login_recover_rs = login_default(browser, default_ip, usrname, passwd, false)
        if login_recover_rs
          router_mode(browser)
        else #ping通但登录失败时查询路由器线程
          begin
            puts "Ping dut successfully,but web login failed!"
            init_router_obj(default_ip, telnetusr, telentpw)
            router_ps
            logout_router
          rescue => ex
            puts "Telnet router #{default_ip} failed!"
            puts ex.message.to_s
          end
        end
      elsif result.kind_of?(Hash)
        if result[:ip].empty?||result[:ip][0]=~/^169/
          puts("Error:pc nic can't connect to router".to_gbk)
          login_recover_rs = false
        else
          puts("Recover router default lan ip".to_gbk)
          gateway     = result[:gateway][0]
          #使用网关地址登录路由器,登录后将路由器恢复出厂值
          login_state = login_default(browser, gateway, usrname, passwd, false)
          #如果使用网关登录路由器失败，尝试使用静态IP来登录,AP模式下虽有IP但却是从上层获取的IP地址
          unless login_state
            rs_static = static_login(browser) #静态IP登录
            puts "static login result:#{rs_static}"
            unless rs_static #静态IP登录失败则恢复DHCP
              netsh_if_ip_setip(tc_dhcp_args)
              return false
            end
          end
          rs = router_recover(browser) #使用恢复出厂设置方式来恢复为默认IP
          if rs
            #使用默认地址登录路由器
            login_recover_rs = login_default(browser, default_ip, usrname, passwd, true)
            router_mode(browser) #再将模式切换成路由模式
            @router_recover_state =true
          else
            puts("ERROR:login_recover failed,can't relogin with default ip!")
          end
          netsh_if_ip_setip(tc_dhcp_args) #恢复dhcp方式
        end
      else
        puts("ERROR:login_recover failed")
        login_recover_rs=false
      end
      return login_recover_rs
    end

    #配置静态ip地址来恢复lan默认值
    def static_login(browser)
      puts "[#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}] #{self.to_s}->method_name:#{__method__}"
      tc_nicname     = "dut"
      tc_static_args = {nicname: tc_nicname, source: "static", ip: "192.168.100.111", mask: "255.255.255.0", gateway: @@default_ip}
      netsh_if_ip_setip(tc_static_args) #修改网卡为静态IP
      static_login_flag = false
      rs_ping           = ping(@@default_ip) #ping
      if rs_ping
        static_login_flag = true
      else #如果ping不通，则无法配置返回false
        puts "After configing static IP,ping failed!"
        return false
      end

      rs_login = login_default(browser, @@default_ip)
      if rs_login
        static_login_flag = true
      else
        puts "Static IP login router failed!"
        return false #如果登录失败，返回false
      end
      static_login_flag
    end

    #恢复路由模式
    def router_mode(browser)
      tag_mode        = "apmode"
      tag_mode_iframe = "modeselect.asp"
      tag_router_mode = "imodel_type_rt"
      tag_submit_btn  = "submit_btn"
      tc_time         = 110
      if browser.span(id: tag_mode).exists? #判断是否有模式切换功能
        browser.span(id: tag_mode).click
        sleep 5
        mode_iframe = browser.iframe(src: tag_mode_iframe)
        router_mode = mode_iframe.radio(id: tag_router_mode).set?
        if router_mode
          p "current mode is router mode..."
          browser.refresh
          sleep 2
          browser.refresh
          sleep 2
          return true
        else
          puts "current mode is ap mode,switch to router mode..."
          mode_iframe.button(id: tag_submit_btn).click
          puts "sleeping #{tc_time} for router mode change"
          sleep tc_time
          browser.cookies.clear
          browser.refresh
          puts "After mode changed,relogin router"
          rs_login = login_default(browser, @@default_ip)
        end
      else
        puts "no mode switch"
      end
    end

    #路由器再登录
    #当路由器已经登录过，并lan网段未发生变化但要重新登录时使用
    #此时网页显示的是登录界面
    def login_no_default_ip(browser, usrname="admin", passwd="admin")
      puts "#[#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}] #{self.to_s}->method_name:#{__method__}"
      tag_usr        = 'admuser'
      tag_pw         = 'admpass'
      tag_login_btn  = 'submit_btn'
      wait_time      = 3
      tag_lan        = "set_wifi"
      tag_options    = "options"
      tag_sysversion = "sysversion"
      rs_login       = false
      login_msg      = ""
      if browser.text_field(:name, tag_usr).exists?
        browser.text_field(:name, tag_usr).click
        browser.text_field(:name, tag_usr).set(usrname)
        sleep 1
        browser.text_field(:name, tag_pw).click
        browser.text_field(:name, tag_pw).set(passwd)
        sleep 1
        browser.button(:id, tag_login_btn).click
        sleep wait_time
        if browser.button(:id, tag_login_btn).exists? #调试时发现有时会有点击登录按钮未生效现象，就再点击一次
          browser.button(:id, tag_login_btn).click
          sleep wait_time
        end
        5.times do
          rs_login = browser.link(:id => tag_options).exists? && !(browser.span(:id => tag_sysversion).text.slice(/系统版本:(.+)/, 1).nil?)
          break if rs_login
          browser.refresh
          sleep 1
        end
        p login_msg = "main page not exist!" unless rs_login
      else
        p login_msg = "login page not exist!"
      end
      return {:flag => rs_login, :message => login_msg}
    end

    #将路由器登录->恢复为默认值
    def login_router_recover(browser, default_ip=@@default_ip, usrname="admin", passwd="admin", nicname="dut", count="5")
      rs = login_recover(browser, default_ip, usrname, passwd, nicname, count)
      unless rs
        puts "login router failed!"
        return false
      end
      #@router_recover为false表示路由器登录过程中未做恢复出厂设置
      #调用router_recover恢复为默认设置
      unless @router_recover_state
        rs = router_recover(browser)
      end
      return rs
    end

    def logout(browser)
      browser.close
    end

    module_function :login, :logout
  end
end




