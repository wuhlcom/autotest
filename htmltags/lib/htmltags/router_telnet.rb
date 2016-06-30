require 'net/telnet'
module HtmlTag
  module RouterTelnet

    def init_router_obj(ip, usr="admin", pw="admin", timeout=10, wait_time=1, prompt=/[$%#>:] \z|(\[N\/y\])/n)
      puts "#{self.to_s}->method_name:#{__method__}"
      @router_prompt  = prompt
      @router_timeout = timeout
      @router_wtime   = wait_time
      @router         = Net::Telnet::new("Host"     => ip, #登录地址
                                         "Timeout"  => timeout, #会话超时
                                         "Waittime" => wait_time, #等待响应
                                         "Prompt"   => prompt) #匹配响应
      @router.login(usr, pw) { |str| print str }
      puts
      return @router
    end

    # 在string后添加换行符后,将其发送到远程主机上,并等待远程主机输出下一个提示match.
    # match的默认值取自是new中指定的"Prompt". timeout的默认值取自new中指定的"Timeout".
    # 若带块调用的话, 则把输出字符串当做参数来依次运行块的内容.
    # localhost.cmd("String"=>"top","Match"=>/CPU:/,"Timeout"=>2) { |c| print c }
    #cmd
    #  string, [usrname@devicename] view cmd,eg:"ps -ef"
    #return
    #   string,cmd returns
    def router_send_cmd(cmd, timeout=10)
      puts "#{self.to_s}->method_name:#{__method__}"
      fail "#{cmd} type is #{cmd.class},command must be string!" unless cmd.kind_of?(String)
      fail "cmd is empty string,please check the params!" if cmd.empty?
      unless timeout != @router_timeout
        timeout=@router_timeout
      end
      cmd_return = @router.cmd("String" => cmd, "Match" => @router_prompt, "Timeout" => timeout) { |str|
        print str
      }
      puts
      # if cmd_return=~/not\s*found|syntax\s+error|bad\s+command/i
      # 		fail "Command error!"
      # end
      cmd_return
    end

    #iptables -t nat -L -nv
    def router_nat_list_all(timeout=10)
      nat_cmd = "iptables -t nat -nvL"
      router_send_cmd(nat_cmd, timeout)
    end

    #iptables -t nat -nvL port_forward
    def router_nat_port_forward(chain_name="port_forward", timeout=10)
      puts "#{self.to_s}->method_name:#{__method__}"
      nat_cmd = "iptables -t nat -nvL #{chain_name}"
      rs      = router_send_cmd(nat_cmd, timeout)
      parse_port_forward(rs)
    end

    #解析chain port_forward
    #rs
    #  --string,send_cmd return value
    #return
    #  --hash,{:cmd=>xx,:rules=>[{},{}],has_rule=>true}
    def parse_port_forward(rs)
      port_forward_arr = rs.split(/\n/)
      #删除无用元素
      port_forward_arr.delete("")
      port_forward_arr.delete("#")
      port_forward_arr.delete(" ")
      port_forward_arr.delete("# ")
      port_forward_rs          = {}
      port_forward_rules       = []
      port_forward_srv_configs = []
      port_forward_rs[:cmd]    = port_forward_arr[0].strip
      port_forward_arr.each_with_index { |_, index|
        next if index<=2
        next if port_forward_arr[index] =~ /root@Console|prerouting_lan_rule/i #统一平台版本适配
        port_forward_hash              = {}
        item_arr                       = port_forward_arr[index].split(" ")
        port_forward_hash[:pkts]       = item_arr[0]
        port_forward_hash[:bytes]      = item_arr[1]
        port_forward_hash[:target]     = item_arr[2]
        port_forward_hash[:prot]       = item_arr[3]
        port_forward_hash[:opt]        = item_arr[4]
        port_forward_hash[:in]         = item_arr[5]
        port_forward_hash[:out]        = item_arr[6]
        port_forward_hash[:source]     = item_arr[7]
        port_forward_hash[:destination]= item_arr[8]
        #统一平台跟SDK版本组合规则有区别
        if port_forward_arr.include?("root@Console:~# ")
          port_forward_hash[:rule] = item_arr[9]+" "+item_arr[10]+" "+item_arr[15] #统一平台版本组合规则
        else
          port_forward_hash[:rule] = item_arr[9]+" "+item_arr[10]+" "+item_arr[11] #SDK版本组合规则
        end
        port_forward_rules<<port_forward_hash
        port_forward_srv_configs<<port_forward_hash[:rule]
      }
      port_forward_rs[:rules]      =port_forward_rules
      port_forward_rs[:srv_configs]=port_forward_srv_configs
      if port_forward_rules.empty?
        port_forward_rs[:has_rule] = false
      else
        port_forward_rs[:has_rule] = true
      end
      port_forward_rs
    end

    def router_uptime(timeout=10)
      puts "#{self.to_s}->method_name:#{__method__}"
      cmd = "uptime"
      rs  = router_send_cmd(cmd, timeout)
      parse_uptime(rs)
    end

    #uptime\n 16:12:40 up 12 min, load average: 0.10, 0.16, 0.15\n#
    def parse_uptime(str)
      /load\s+average:\s*\d+\.\d+,\s*(?<average_load>\d+\.\d+),\s*\d+\.\d+/m=~str
      average_load
    end

    def get_router_uptime(cmd="uptime", timeout=10)
      puts "#{self.to_s}->method_name:#{__method__}"
      rs = router_send_cmd(cmd, timeout)
      # parse_uptime(rs)
    end

    #"uptime\n 17:21:58 up 2 days, 45 min,  load average: 0.13, 0.05, 0.05\nroot@Console:~# "
    # 17:29:32 up 1 min,  load average: 1.11, 0.51, 0.19
    def parse_uptime_hash(str)
      /uptime\s+\d+:\d+:(?<seconds>\d+)\s*up\s*load\s+average:\s*\d+\.\d+,\s*(?<average_load>\d+\.\d+),\s*\d+\.\d+/m=~str
    end

    #iwconfig
    def router_iwconfig(intf="ra0", timeout=10)
      cmd = "iwconfig #{intf}"
      str = router_send_cmd(cmd, timeout)
      parse_iwconfig(str)
    end

    #parse iwconfig
    #return,[SSID,信道，速率，功率]，eg:["Wireless0", "1", "300", "20"]
    def parse_iwconfig(str)
      # iw_arr = str.split(/ra\d/)
      # iw_arr.each do |item|
      # next if item !~ /RTWIFI\s+SoftAP/
      m      = /RTWIFI\s+SoftAP\s+ESSID:\"(?<ssid>.+)\"\s+Mode:Master\s+Channel=(?<channel>\d+)\s+Access Point:\s+([0-9|A-F]{2}:[0-9|A-F]{2}:[0-9|A-F]{2}:[0-9|A-F]{2}:[0-9|A-F]{2}:[0-9|A-F]{2})\s+Bit Rate=(?<rate>\d+)\s+Mb\/s\s+Tx-Power=(?<dbm>\d+)\s+dBm/.match(str)
      iwinfo = m.captures
      if iwinfo.nil?
        iwinfo=[]
      end
      iwinfo
    end

    def router_ifconfig(intf, timeout=10)
      cmd = "ifconfig #{intf}"
      str = router_send_cmd(cmd, timeout)
      parse_ifconfig(str)
    end

    def parse_ifconfig(str)
      wan_info = {}
      if str=~/inet\s+addr/i
        arr = str.split("\n")
        arr.each do |item|
          if /inet\s+addr:\s*(?<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/i=~item
            wan_info[:ip]=ip
          elsif /Ethernet\s+HWaddr\s+(?<mac>[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2})/i=~item
            wan_info[:mac]=mac
          end
        end
      elsif str=~/Ethernet\s+HWaddr/i
        /Ethernet\s+HWaddr\s+(?<mac>[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2})/i=~str
        wan_info[:mac]=mac
      end
      return wan_info
    end

    #disconnect router
    def logout_router
      puts "#{self.to_s}->method_name:#{__method__}"
      @router.close
      sleep 5
    end

    def router_ps(str=nil)
      if str.nil?
        cmd = "ps -w"
      else
        cmd = "ps -w | grep #{str}"
      end
      router_send_cmd(cmd)
    end

    #查看以下进程是否正常
    # udhcpc、udhcpd、lighttpd、dnsmasq、ntpd
    def router_attack_ps(dhcpc="udhcpc", dhcpd="udhcpd", httpd="lighttpd", dns="dnsmasq", ntp="ntpd")
      flag1=true
      flag2=true
      flag3=true
      flag4=true
      flag5=true
      flag =true
      begin
        rs1 = router_ps("dhcp")
        unless rs1 =~/#{dhcpc}/i
          puts "PROCESS #{dhcpc} NOT EXIST!"
          flag1=false
        end
        unless rs1 =~/#{dhcpd}/i
          puts "PROCESS #{dhcpd} NOT EXIST!"
          flag2 = false
        end
        rs2 = router_ps("http")
        unless rs2 =~/#{httpd}/i
          puts "PROCESS #{httpd} NOT EXIST!"
          flag3 = false
        end
        rs3 = router_ps("dns")
        unless rs3 =~/#{dns}/i
          puts "PROCESS #{dns} NOT EXIST!"
          flag4 = false
        end
        rs4 = router_ps("ntp")
        unless rs4 =~/#{ntp}/i
          puts "PROCESS #{ntp} NOT EXIST!"
          flag5 = false
        end
      rescue => ex
        p "ERROR:#{ex.message.to_s}"
        flag=false
      end
      flag=flag1&&flag2&&flag3&&flag4&&flag5&&flag
    end

    #
    #args: on/off
    #ifconfig ra0 down
    #echo 0 > /sys/class/leds/zhilu:blue:wifi/brightness-->on
    #echo 1 > /sys/class/leds/zhilu:blue:wifi/brightness-->off
    #
    def power_cmd(args)
      unless args=~/on|off/i
        fail "Params error,please check!"
      end
      if args=~/on/i
        flag = 0
        puts "Power will turn on"
      else
        flag = 1
        puts "Power will turn off"
      end
      sw = "echo #{flag} > /sys/class/leds/zhilu:blue:wifi/brightness"
    end

    def router_ra0down
      ra0down = "ifconfig ra0 down"
      router_send_cmd(ra0down)
      sleep 2
    end

    def rt_power_sw(args)
      cmd = power_cmd(args)
      router_send_cmd(cmd)
    end

    def power_on
      router_ra0down
      rt_power_sw("on")
    end

    def power_off
      rt_power_sw("off")
    end

    def power_off_on
      power_off
      power_on
    end

  end
end

if __FILE__==$0
  # require 'pp'
  # include HtmlTag::RouterTelnet
  # ip  ="192.168.100.1"
  # usr ="root"
  # pw  ="zl4321"
  # init_router_obj(ip, usr, pw)
  # router_nat_port_forward("zone_lan_prerouting")
  # a = router_nat_port_forward
  # pp a
  #  p router_uptime
  # str = "uptime\n 16:12:40 up 12 min, load average: 0.10, 0.16, 0.15\n#"
  # p parse_uptime(str)
  # logout_router unless @router.nil?
end