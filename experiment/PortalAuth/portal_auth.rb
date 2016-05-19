#encoding:utf-8
#===========反复认证===
#一查找网卡对应的注册表目录
#二添加或修改MAC属性到对应注册目录
#三重启网卡
#四打开浏览器登录指定的网站
#==========认证超时===========
#认证后，不停访问外网，直到到第二次认证，计算这个过程的时长
#使用前保存网络正常，保证网还未认证
#1单次认证时长测试
#  设定认证时长，记录第一次认证和第二次认证时间，两次求差算了认证时长
#2 指定测试认证时长次数
#  指定认证时长和次数，通过认证时长和次数算出总测试时长，在测试认证时长，测试的时间累加并记录每次出现认证的时间
#3 指定测试时间和认证时长
#  指定测试时间和认证时长，使用当前时间与起始时间差/认证时长 计算出是否达到认证时长周期，测试时间未达到前会不停测试
#  直到超时或出现异常
#
#=====
#wuhongliang 2015-11-13
require './reporter'
require 'watir-webdriver'
require 'htmltags'
module Portal
  class PortalAuthentication
    include Portal::Reporter
    include HtmlTag::WinCmd
    ENABLED  = "enabled"
    DISABLED = "disabled"
    attr_accessor :browser, :url, :auth_time, :web_time
    current_path    = File.dirname(File.expand_path(__FILE__))
    report_path_int = current_path+"/reports/portal"
    stdio("#{report_path_int}/portalauth.log")

    def initialize(url, url_title,extra_time, profile = "default")
      @url            = url
      @url_title      = url_title
      @extra_time     = extra_time #认证超时的浮动范围
      @auth_flag      = false
      @auth_time      = []
      @web_time       = []
      @default_profile= profile
      client          = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout  = 120 # seconds
      @browser        = Watir::Browser.new :firefox, :http_client => client, :profile => @default_profile
      @browser.cookies.clear
      @browser.driver.manage.timeouts.implicit_wait = 2 # seconds
    end

    def login_router_default(usrname="admin", passwd="admin", relogin=false)
      puts "#{self.to_s}->method_name:#{__method__}"
      @tag_usr_id   = 'admuser'
      @tag_pw_id    = 'admpass'
      @tag_login_btn= '登录'
      @wait_time    = 10
      @tag_lan_id   = "set_wifi"
      unless relogin
        @browser.goto(@url)
      end
      rs_login = @browser.text_field(:name, @tag_usr_id).exists?
      if rs_login
        @browser.text_field(:name, @tag_usr_id).set(usrname)
        browser.text_field(:name, @tag_pw_id).set(passwd)
        sleep 1
        @browser.button(:value, @tag_login_btn).click
        rs_login = @browser.span(:id => @tag_lan_id).wait_until_present(@wait_time)
      end

      unless rs_login
        puts "login router failed!"
      end
      return rs_login
    end

    #认证上网有三个页面 免费上网
    # <a href="http://203.195.162.65/acsrv.cgi?userurl=http://i.17huohu.com/?cachebust=20141231&amp;hotspot=6da80d8119478711&amp;userip=192.168.100.100&amp;usermac=00:25:ab:4b:3b:84&amp;devmac=78:A3:51:01:9C:51&amp;type=1">免费上网</a>
    #<span>直接上网</span>
    #认证
    # <img align="absmiddle" src="images/zjsw_2.png">
    #广告页面
    #<form name="form4"><div></div>.....</form>
    def login_portal
      puts "#{self.to_s}->method_name:#{__method__}"
      href_reg       = "203.195.162.65"
      href_text      = "免费上网"
      connect_direct = "images/zjsw_2.png"
      form_name      = "form4"
      # baidu          = "百度一下，你就知道"
      sohu = "搜狐"
      wait_time      = 2
      auth_flag      = false
      openweb_flag   = false
      @browser.goto(@url)
      sleep wait_time
      portal_first = @browser.link(href: /#{href_reg}/, text: href_text)
      #首页面
      if portal_first.exists?
        t = Time.now
        puts "[#{t}]portal first page appear"
        @auth_time << t
        puts "[#{t}]portal auth time #{t}"
        #点击直接上网
        portal_first.click
        sleep wait_time
        portal_auth = @browser.image(src: connect_direct)
        #认证页面
        if portal_auth.exists?
          puts "[#{Time.now}]portal auth page appear"
          #点击认证
          portal_auth.click
          sleep wait_time
          #广告页面
          form = @browser.form(name: form_name)
          if form.exists?
            #form.div[0],sohu  
            #form.div[2],baidu
            #form.div[3],sina
            #点击广告
            # form.divs[2].button.click
            form.divs[0].button.click
            sleep 5
            if @browser.title==sohu 
              auth_flag=true
              puts "[#{Time.now}]redirect to  #{url}"
            else
              puts "[#{Time.now}]net access failed"
            end
          else
            puts "[#{Time.now}]advertisement page changed"
          end
        else
          puts "[#{Time.now}]authentication page changed"
        end
      else
        puts "[#{Time.now}]open web title #{@browser.title}".encode("GBK")
        if @browser.title==@url_title 
          openweb_flag==true
          web_t = Time.new()
          puts "[#{web_t}]open web success time #{web_t}"
          @web_time<<web_t
        else
          puts "[#{web_t}]net access failed"
        end
      end
      {openweb_flag: openweb_flag, auth_flag: auth_flag}
    end

    def close
      puts "#{self.to_s}->method_name:#{__method__}"
      @browser.close if @browser.exists?
      puts "[#{Time.now}]关闭浏览器".encode("GBK")
    end

    #测试超时时间
    def portal_auth_time(nicname, authtime, interval, nic_wait=600, flag=false)
      puts "#{self.to_s}->method_name:#{__method__}"
      puts "[#{Time.now}]auth timeout #{authtime},query interval #{interval}"
      authtime       = authtime+@extra_time #比设定时间增加30s
      num            = 0
      time_single    = 0
      real_auth_time = 0
      nic_state      = true
      begin
        while_btime = Time.now
        puts "[#{while_btime}]==========循环测试开始时间为#{while_btime}=============".encode("GBK")
        while time_single<=authtime
          num+=1
          if num==2 && flag
            rs          = nic_to_router(nicname, num, nic_wait)
            time_single += rs[:spend_time]
            nic_state   = rs[:state]
            unless nic_state
              puts "[#{Time.now}]========================网卡未获取到IP地址==========================".encode("GBK")
              break
            end
          else
            puts "[#{Time.now}]#{t} time authtime test,sleep #{interval} seconds then open #{@url}...."
            @browser.cookies.clear
            rs = login_portal
            sleep interval
            time_single +=interval
            if @auth_time.size>=2
              real_auth_time = @auth_time[1]-@auth_time[0]
              puts "[#{Time.now}]=================实际认证超时时间为#{real_auth_time}=======================".encode("GBK")
              break
            end
          end
        end
      rescue => ex
        curr_time = Time.now
        puts "[#{curr_time}]========================测试认证超时时间出错==========================".encode("GBK")
        puts "[#{curr_time}]=======================#{ex.message.to_s}============================="
      ensure
        close
        while_etime = Time.now
      end

      if @auth_time.size==1
        real_auth_time=while_etime-@auth_time[0]
        puts "[#{while_etime}]=================经过#{real_auth_time}s后仍未认证超时================".encode("GBK")
      elsif @auth_time.empty?
        puts "[#{while_etime}]====================未弹出认证======================".encode("GBK")
        real_auth_time="noauth"
      end
      puts "[#{while_etime}]==========循环测试结束时间为#{while_etime},测试时长:#{while_etime-while_btime}=============".encode("GBK")
      return real_auth_time
    end

    #禁用或启用网卡
    def nic_to_router(nicname, query_num, wait_time=600)
      state      = false
      spend_time = 0
      t1         = 15
      t2         = 10
      ipinfo     = ""
      #禁用网卡
      puts "=======禁用网卡======".encode("GBK")
      netsh_if_setif_admin(nicname, DISABLED)
      puts "[#{Time.now}]#------ #{query_num} time authtime test,disconnect the router #{wait_time} second ------"
      sleep wait_time
      spend_time =spend_time+wait_time+2 #netsh_if_setif_admin方法中有两秒等待

      #启用网卡
      puts "======启用网卡=====".encode("GBK")
      netsh_if_setif_admin(nicname, ENABLED)
      sleep t1 #等待网卡获取IP地址
      spend_time =spend_time+t1+2 ##netsh_if_setif_admin方法中有两秒等待

      #查询网卡启用后是否获取IP地址
      4.times { |x|
        puts "第#{x+1}次查询网卡IP地址信息".encode("GBK")
        ipinfo = ipconfig
        break if !ipinfo[nicname][:ip].empty? && ipinfo[nicname][:ip][0] !~ /^169/
        sleep t2
        spend_time +=t2
      }

      if ipinfo[nicname][:ip].empty?||ipinfo[nicname][:ip][0] =~ /^169/
        state=false
        puts "#{nicname} havn't get ip address"
        # fail "#{nicname} havn't get ip address" #
      else
        puts "After reconnect router #{nicname} get ip address #{ipinfo[nicname][:ip][0]}"
        state = true
      end
      {state: state, spend_time: spend_time}
    end

    def release_renew(nicname, wait_time = 600)
      ipinfo    = ""
      spend_time= 0
      t2        = 5
      ip_release
      sleep wait_time
      ip_renew
      #查询网卡启用后是否获取IP地址
      4.times { |x|
        puts "第#{x+1}次查询网卡IP地址信息".encode("GBK")
        ipinfo = ipconfig
        break if !ipinfo[nicname][:ip].empty? && ipinfo[nicname][:ip][0] !~ /^169/
        sleep t2
        spend_time +=t2
      }

      if ipinfo[nicname][:ip].empty?||ipinfo[nicname][:ip][0] =~ /^169/
        state=false
        puts "#{nicname} havn't get ip address"
        # fail "#{nicname} havn't get ip address" #
      else
        puts "After reconnect router #{nicname} get ip address #{ipinfo[nicname][:ip][0]}"
        state = true
      end
      {state: state, spend_time: spend_time}
    end

    #断开和连接无线
    def wireless_to_router(nicname, profile, query_num, wait_time=600)
      puts "=======断开无线网卡======".encode("GBK")
      spend_time = 0
      ipinfo     = ""
      t2         = 10
      #断开无线网卡
      netsh_disc(nicname)
      puts "[#{Time.now}]#------ #{query_num} time authtime test,disconnect the router #{wait_time} second ------"
      sleep wait_time
      spend_time =spend_time+wait_time+2
      #查询配置文件
      # netsh_sp(nicname="wireless")
      netsh_conn(profile, nicname)
      #查询网卡启用后是否获取IP地址
      4.times { |x|
        puts "第#{x+1}次查询网卡IP地址信息".encode("GBK")
        ipinfo = ipconfig
        break if !ipinfo[nicname][:ip].empty? && ipinfo[nicname][:ip][0] !~ /^169/
        sleep t2
        spend_time +=t2
      }

      if ipinfo[nicname][:ip].empty?||ipinfo[nicname][:ip][0] =~ /^169/
        state=false
        puts "#{nicname} havn't get ip address"
        # fail "#{nicname} havn't get ip address" #
      else
        puts "After reconnect router #{nicname} get ip address #{ipinfo[nicname][:ip][0]}"
        state = true
      end
      {state: state, spend_time: spend_time}
    end

    #测试超时时间
    #nicname指定网卡名
    #num指定测试次数
    #timeout认证超时时间
    #flag,true 禁用启用一次网卡
    #interval,查询是否超时的间隔
    #timeout要远大于interval
    def spec_portal_authtime_num(nicname, num, authtime, interval, flag=false, nic_wait=600)
      puts "#{self.to_s}->method_name:#{__method__}"
      authtime       = authtime+@extra_time
      time_all       = authtime*num
      time_all_step  = 0
      real_auth_time = 0
      query_all      = 0
      nic_state      = true
      puts "[#{Time.now}]authtime #{authtime},query interval #{interval},test #{num} times,totaltime #{time_all} second,nic_wait #{nic_wait}"

      begin
        while_btime = Time.now
        puts "[#{while_btime}]==========循环测试开始时间为#{while_btime}=============".encode("GBK")
        while time_all_step<=time_all #while 1 #测试总时长
          time_single = 0
          query_num   = 0
          while time_single<=authtime #while 2 #一个周期
            query_all+=1
            if query_num==1 && flag
              rs          = nic_to_router(nicname, query_all, nic_wait)
              time_single += rs[:spend_time]
              nic_state   = rs[:state]
              break unless nic_state
            else
              @browser.cookies.clear
              rs = login_portal
              puts "[#{Time.now}]------ #{query_all} time authtime test,sleep #{interval} seconds then open #{@url} ------"
              sleep interval
              time_single += interval
            end
            #打印所有认证间隔
            if @auth_time.size>=2
              @auth_time.each_with_index { |autime, index|
                puts "[authtime]=================第#{index+1}次认证时间为#{autime}=======================".encode("GBK")
                next if index==0
                real_auth_time = @auth_time[index]-@auth_time[index-1]
                puts "[#{Time.now}]=================第#{index}次实际认证超时时间为#{real_auth_time}=======================".encode("GBK")
              }
            end
            query_num +=1
            unless nic_state
              puts "[#{Time.now}]========================网卡未获取到IP地址==========================".encode("GBK")
              break
            end
          end #while 2
          time_all_step+=time_single #累计总时间
          print "\n"
          puts "++++++++++++++++++++++++++time_single:#{time_single}+++++++++++++++++++++++++++++++++++"
          puts "++++++++++++++++++++++++++time_all_step:#{time_all_step}+++++++++++++++++++++++++++++++++++"
          print "\n"
        end # while 1
      rescue => ex
        curr_time = Time.now
        puts "[#{curr_time}]========================测试认证超时时间出错==========================".encode("GBK")
        puts "[#{curr_time}]=======================#{ex.message.to_s}============================="
        print ex.backtrace.join("\n")
      ensure
        close
        while_etime = Time.now
      end
      if @auth_time.size==1
        real_auth_time=while_etime-@auth_time[0]
        puts "==="*30
        puts "[#{while_etime}]=================经过#{real_auth_time}s后仍未认证超时================".encode("GBK")
        puts "==="*30
      elsif @auth_time.empty?
        puts "==="*30
        puts "[#{while_etime}]====================未弹出认证======================".encode("GBK")
        puts "==="*30
        real_auth_time="noauth"
      else
        puts "==="*30
        @auth_time.each_with_index { |autime, index|
          puts "[authtime]=================第#{index+1}次认证时间为#{autime}=======================".encode("GBK")
          next if index==0
          real_auth_time = @auth_time[index]-@auth_time[index-1]
          puts "[#{while_etime}]=================第#{index}次实际认证超时时间为#{real_auth_time}=======================".encode("GBK")
        }
        puts "==="*30
      end
      puts "[#{while_etime}]==========累计时间#{time_all_step}=============".encode("GBK")
      puts "[#{while_etime}]==========循环测试结束时间为#{while_etime},测试时长:#{while_etime-while_btime}=============".encode("GBK")
      return real_auth_time
    end

    #测试超时时间
    #nicname指定网卡名
    #timeout测试时间
    #flag,true 禁用启用一次网卡
    #interval,查询是否超时的间隔
    #authtime,指定超时时间
    #timeout要大于等于authtime
    #authtime要远大于等于interval
    def spec_portal_authtime_time(nicname, timeout, authtime, interval, ssid, nictype, flag=false, nic_wait=600)
      puts "#{self.to_s}->method_name:#{__method__}"
      authtime       = authtime+@extra_time
      nic_state      = true
      while_btime    = Time.now
      real_auth_time = 0
      time_single    = 0
      query_num      = 0
      cycle          = 0
      cyclenum       = 0
      puts "[#{while_btime}]authtime #{authtime},query interval #{interval},timeout #{timeout} second,nic_wait #{nic_wait}"
      puts "[#{while_btime}]==========循环测试开始时间为#{while_btime}=============".encode("GBK")
      begin
        while time_single<=timeout
          query_num +=1
          c_time    = Time.now
          cyclenum  = ((c_time - while_btime)/authtime).to_i

          #第一个周期第二次循环断开一次连接
          if query_num==2 && flag && time_single>0
            if nictype=="wired"
              rs          = nic_to_router(nicname, query_num, nic_wait) #断开与路由器连接
              time_single += rs[:spend_time]
              nic_state   = rs[:state]
            elsif nictype=="wireless"
              rs          = wireless_to_router(nicname, ssid, query_num, nic_wait) #断开与路由器连接
              time_single += rs[:spend_time]
              nic_state   = rs[:state]
            else
              fail "nic type error!"
            end
            unless nic_state
              puts "[#{Time.now}]========================网卡未获取到IP地址==========================".encode("GBK")
              break
            end
          end

          #从第二个周期开始每个周期会断开一次连接
          if cyclenum>cycle && flag
            cycle       = cyclenum
            rs          = nic_to_router(nicname, query_num, nic_wait) #断开路由器连接
            time_single += rs[:spend_time]
            nic_state   = rs[:state]
            unless nic_state
              puts "[#{Time.now}]========================网卡未获取到IP地址==========================".encode("GBK")
              break
            end
          else
            @browser.cookies.clear
            rs = login_portal #
            puts "[#{Time.now}]------ #{query_num} time authtime test,sleep #{interval} seconds then open #{@url} ------"
            sleep interval
            time_single += interval
          end
          #打印所有认证间隔
          if @auth_time.size>=2
            @auth_time.each_with_index { |autime, index|
              puts "[authtime]=================第#{index+1}次认证时间为#{autime}=======================".encode("GBK")
              next if index==0
              real_auth_time = @auth_time[index]-@auth_time[index-1]
              puts "[#{Time.now}]=================第#{index}次实际认证超时时间为#{real_auth_time}=======================".encode("GBK")
            }
          end
          print "\n"
          puts "++++++++++++++++++++++++++time_single:#{time_single}+++++++++++++++++++++++++++++++++++"
          print "\n"
        end
      rescue => ex
        curr_time = Time.now
        puts "[#{curr_time}]========================测试认证超时时间出错==========================".encode("GBK")
        puts "[#{curr_time}]=======================#{ex.message.to_s}============================="
        print ex.backtrace.join("\n")
      ensure
        close
        while_etime = Time.now
      end
      if @auth_time.size==1
        real_auth_time=while_etime-@auth_time[0]
        puts "==="*30
        puts "[#{while_etime}]=================经过#{real_auth_time}s后仍未认证超时================".encode("GBK")
        puts "==="*30
      elsif @auth_time.empty?
        puts "==="*30
        puts "[#{while_etime}]====================未弹出认证======================".encode("GBK")
        puts "==="*30
        real_auth_time="noauth"
      else
        puts "==="*30
        @auth_time.each_with_index { |autime, index|
          puts "[authtime]=================第#{index+1}次认证时间为#{autime}=======================".encode("GBK")
          next if index==0
          real_auth_time = @auth_time[index]-@auth_time[index-1]
          puts "[#{while_etime}]=================第#{index}次实际认证超时时间为#{real_auth_time}=======================".encode("GBK")
        }
        puts "==="*30
      end
      puts "[#{while_etime}]==========累计时间#{time_single}=============".encode("GBK")
      puts "[#{while_etime}]==========循环测试结束时间为#{while_etime},测试时长:#{while_etime-while_btime}=============".encode("GBK")
      return real_auth_time
    end


  end
end

if __FILE__==$0
  # url        = "www.baidu.com"
  url        = "http://www.sohu.com/"
  url_title  = "搜狐"
  extra_time = 20*60 #认证超时的浮动时间
  portalobj  = Portal::PortalAuthentication.new(url, url_title,extra_time)
  #########################################
  # nicname    = "local" #网卡名称
  # num        = 2 #测试认证周期数
  # authtime   = 1*60 #认证时长
  # interval   = 20 #查询是否间隔
  # flag       = true #是否禁用网卡
  # nic_wait   = 10 #断开连接时长
  # portalobj.spec_portal_authtime_num(nicname, num, authtime, interval, flag, nic_wait)
  ####################################
  # nicname  = "local" #网卡名称
  # authtime = 1*60 #认证时长
  # interval = 20 #查询是否间隔
  # flag     = true #是否禁用网卡
  # nic_wait = 10 #断开连接时长
  # portalobj.portal_auth_time(nicname, timeout, interval, nic_wait=600, flag=false)
  ###################################
  nicname    = "local" #网卡名称
  timeout    = 1*60 #总的测试时长
  authtime   = 60 #认证超时时间
  interval   = 30 #查询认证状态的间隔
  ssid       = "autotest_lixiaoming" #路由器SSID
  nictype    = "wired" #wired->有线，wireless->无线
  flag       = true #是断开连接
  nic_wait   = 10 #断开路由器连接时间


  # nicname  = "wireless" #网卡名称
  # timeout  = 2*60 #总的测试时长
  # authtime = 60 #认证超时时间
  # interval = 30 #查询认证状态的间隔
  # ssid     = "autotest_lixiaoming" #路由器SSID
  # nictype  = "wireless" #wired->有线，wireless->无线
  # flag     = true #是断开连接
  # nic_wait = 10 #断开路由器连接时间
  portalobj.spec_portal_authtime_time(nicname, timeout, authtime, interval, ssid, nictype, flag, nic_wait)
end
