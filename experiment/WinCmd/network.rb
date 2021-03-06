#encoding:GBK
# 1 找到网卡
# 2 网卡扫描wifi
# 3 生成密码文件
# 4 查询配置文件是否存在
# 5 查询配置文件内容
# 6 添加密码文件
# 7 修改密码文件
# 8 使用密码文件连接
module HtmlTag

  class Network

    def parse_ifconfig(str)
      eth= "以太网适配器"
      wlan= "无线局域网适配器"
      mask="子网掩码"
      dgw="默认网关"
      dhcp_server="DHCP 服务器"
      dns_server="DNS 服务器"
      ip_mach="(\d+\.\d+\.\d+\.\d+)"
      mac="物理地址"

      ipinfo={}
      nics = str.split(/#{eth}|#{wlan}/)
      nics.each_index do |index|
        next if index == 0
        ethlan_info={}
        nic=nics[index]
        nic=~/\s*(.+)\:\s*/
        nicname = $1.strip.downcase
        nic=~/#{mac}.+\s+\:\s+(\w{2}-\w{2}-\w{2}-\w{2}-\w{2}-\w{2})/i if !$1.nil?
        ethlan_info[:mac]=$1 if !$1.nil?
        nic=~/IPv4.+\s+\:\s+(\d+\.\d+\.\d+\.\d+)/i
        ethlan_info[:ip]=$1
        nic=~/#{mask}.+\s+\:\s+(\d+\.\d+\.\d+\.\d+)/i
        ethlan_info[:mask]=$1
        nic=~/#{dgw}.+\s+\:\s+(\d+\.\d+\.\d+\.\d+)/i
        ethlan_info[:dgw]=$1 if !$1.nil?
        nic=~/#{dhcp_server}.+\s+\:\s+(\d+\.\d+\.\d+\.\d+)/i
        ethlan_info[:dhcp_server]=$1 if !$1.nil?
        nic=~/#{dns_server}.+\s+\:\s+(\d+\.\d+\.\d+\.\d+.+\d+\n)\s*TCPIP/im
        if !$1.nil?
          dns_servers = $1.split("\n").map { |dns| dns.strip }
          ethlan_info[:dns_server]=dns_servers
        end
        ipinfo[nicname]=ethlan_info
      end
      return ipinfo
    end

    #暂未考虑静态ip的影响
    def ipconfig(args="")
      puts "ipconfig"
      if args==""
        cmd = "ipconfig"
      elsif args=="all"
        cmd = "ipconfig /#{args}"
      else
        raise "ipconfig cmd params error,please check!"
      end
      rs = `#{cmd}`
      print rs
      ipinfo = parse_ifconfig(rs)
      raise "nic name is not modified,please check it" if ipinfo=={}
      return ipinfo
    end

    #暂未考虑静态ip的影响
    def ip_release(args="")
      puts "ipconfig release"
      args = args.downcase
      if args==""
        cmd = "ipconfig /release"
        rs = `#{cmd}`
        puts rs
        sleep 20
        rs1 =ipconfig
        if !rs1["dut"].nil? && rs1["wireless"].nil?
          raise "DUT ip addr release failed：#{rs1["dut"][:ip]}" if rs1["dut"][:ip] !~ /^169/
          return true
        elsif rs1["dut"].nil? && !rs1["wireless"].nil?
          raise "wireless ip addr release failed：#{rs1["wireless"][:ip]}" if rs1["wireless"][:ip] !~ /^169/
          return true
        elsif !rs1["dut"].nil? && !rs1["wireless"].nil?
          raise "DUT and wireless ip addr release failed：DUT->#{rs1["dut"][:ip]},wireless->#{rs1["wireless"][:ip]}" if (rs1["dut"][:ip] !~/^169/) && (rs1["wireless"][:ip] !~ /^169/)
          raise "DUT ip addr release failed：DUT->#{rs1["dut"][:ip]},wireless->#{rs1["wireless"][:ip]}" if (rs1["dut"][:ip] !~ /^169/) && (rs1["wireless"][:ip]=~ /^169/)
          raise "wireless ip addr release failed DUT->#{rs1["dut"][:ip]},wireless->#{rs1["wireless"][:ip]}" if (rs1["dut"][:ip]=~/^169/) && (rs1["wireless"][:ip] !~ /^169/)
          return true
        else
          return false
        end
      elsif args=~/dut/i || args=~/wireless/i
        args_sym=args.downcase.to_sym
        cmd = "ipconfig /release *#{args}*"
        rs = `#{cmd}`
        sleep 20
        print rs
        rs1 =ipconfig()
        if args=~/dut/i && (rs1["dut"][:ip] !~/^169/)
          raise "DUT ip addr release failed"
        elsif args=~/wireless/i && rs1["wireless"][:ip] !~/^169/
          raise "wireless ip addr release failed"
        else
          return true
        end
      else
        raise "ipconfig release nic name error,please check!"
      end
    end

    #暂未考虑静态ip的影响
    def ip_renew(args="")
      error = "已断开媒体连接"
      puts "ipconfig renew"
      args=args.downcase
      if args==""
        cmd = "ipconfig /renew"
        rs=`#{cmd}`
        print rs
        raise "disconnected:#{rs}" if rs =~/#{error}/i
        rs1 = parse_ifconfig(rs)
        if !rs1["dut"].nil? && rs1["wireless"].nil?
          raise "DUT ip addr renew failed" if rs1["dut"][:ip]=~/^169/
          return true
        elsif rs1["dut"].nil? && !rs1["wireless"].nil?
          raise "wireless ip addr renew failed" if rs1["wireless"][:ip]=~ /^169/
          return true
        elsif !rs1["dut"].nil? && !rs1["wireless"].nil?
          raise "DUT and wireless ip addr renew failed" if (rs1["dut"][:ip]=~/^169/) && (rs1["wireless"][:ip]=~/^169/)
          raise "DUT ip addr renew failed" if (rs1["dut"][:ip]=~/^169/) && (rs1["wireless"][:ip]!~/^169/)
          raise "wireless ip addr renew failed" if (rs1["dut"][:ip]!~/^169/) && (rs1["wireless"][:ip]=~/^169/)
          return true
        else
          return false
        end
      elsif args=~/dut/i || args=~/wireless/i
        cmd = "ipconfig /renew *#{args}*"
        rs=`#{cmd}`
        print rs
        raise "disconnected:#{rs}" if rs =~/#{error}/i
        rs1 = parse_ifconfig(rs)
        if args=~/dut/i && (rs1["dut"][:ip]=~/^169/)
          raise "DUT ip addr ip_renew failed"
        elsif args=~/wireless/i && (rs1["wireless"][:ip]=~/^169/)
          raise "wireless ip addr ip_renew failed"
        else
          return true
        end
      else
        raise "ipconfig renew nic name error,please check!"
      end
    end

    #show interfacec
    def netsh_wlan_si
      rs =`netsh wlan show interfaces`
    end

    # 名称                   : Wireless
    # 描述                   : Atheros 11G USB Wireless Network Adapter
    # GUID                   : 03ad312c-3e4c-4843-a684-513a5149d65c
    # 物理地址               : 5c:63:bf:30:95:16
    # 状态                   : 已断开连接
    def parse_wlan_si(rs)
      nonic="系统上没有无线接口"
      raise "no wireless nic found,please check !" if rs=~/nonic/
      disconnected = "已断开连接"
      name = "名称" #: Wireless
      desc = "描述" #: Qualcomm Atheros AR9485 Wireless Network Adapter
      guid ="GUID" #: a9e73df9-2768-459d-98f9-38146d60734b
      mac ="物理地址" #: 48:5a:b6:7c:82:ae
      status="状态" #: 已连接
      ssid="SSID" #: WIFI_002A11
      bssid="BSSID" #: 2c:ad:13:00:1c:4e
      net_ytpe="网络类型" #: 结构
      wifi_type="无线电类型" #: 802.11n
      au_type="身份验证" #: WPA2 - 个人
      pass_type="密码" #: CCMP
      conn_type="连接模式" #: 自动连接
      chanel="信道" #: 11
      rx_rate="接收速率(Mbps)" #: 150
      tx_rate="传输速率 (Mbps)" #: 150
      signal="信号" #: 100%
      config="配置文件" #: WIFI_002A11
      interfacenum1 = "系统上有"
      interfacenum2 = "个接口"
      rs=~/#{interfacenum1}\s*(\d+)\s*#{interfacenum2}\s*/
      nic_num=$1.strip if !$1.nil?
      nicinfo={}
      wlan_nic={}
      interfaces = rs.split(/#{name}/)
      interfaces.each_index { |index|
        next if index==0
        interface = interfaces[index]

        interface=~/#{status}\s*\:\s*(.*)\s*/
        nicinfo[:status]=$1.strip if !$1.nil?

        interface=~/\s*\:\s*(.*)\s*#{desc}/m
        nic_name = $1.strip if !$1.nil?

        interface=~/#{desc}\s*\:\s*(.*)\s*/
        nicinfo[:desc]=$1.strip if !$1.nil?

        interface=~/#{guid}\s*\:\s*(\w+\-\w+\-\w+\-\w+\-\w+)\s*/
        nicinfo[:guid]=$1.strip if !$1.nil?

        interface=~/#{mac}\s*\:\s*(\w+\:\w+\:\w+\:\w+\:\w+\:\w+)\s*/
        nicinfo[:mac]=$1.strip if !$1.nil?

        if nicinfo[:status]!=disconnected
          interface=~/#{ssid}\s*\:\s*(\w+)\s*/
          nicinfo[:ssid]=$1.strip if !$1.nil?

          interface=~/#{bssid}\s*\:\s*(\w+\:\w+\:\w+\:\w+\:\w+\:\w+)\s*/
          nicinfo[:bssid]=$1.strip if !$1.nil?

          interface=~/#{net_ytpe}\s*\:\s*(.*)\s*/
          nicinfo[:net_ytpe]=$1.strip if !$1.nil?

          interface=~/#{wifi_type}\s*\:\s*(\w+\.\w+)\s*/
          nicinfo[:wifi_type]=$1.strip if !$1.nil?

          interface=~/#{au_type}\s*\:\s*(\w+.*)\s*/
          nicinfo[:au_type]=$1.strip if !$1.nil?

          interface=~/#{pass_type}\s*\:\s*(\w+)\s*/
          nicinfo[:pass_type]=$1.strip if !$1.nil?

          interface=~/#{conn_type}\s*\:\s*(.*)\s*/
          nicinfo[:conn_type]=$1.strip if !$1.nil?

          interface=~/#{rx_rate}\s*\:\s*(\w+)\s*/
          nicinfo[:rx_rate]=$1.strip if !$1.nil?

          interface=~/#{tx_rate}\s*\:\s*(\w+)\s*/
          nicinfo[:tx_rate]=$1.strip if !$1.nil?

          interface=~/#{config}\s*\:\s*(\w+)\s*/
          nicinfo[:config]=$1.strip if !$1.nil?
        end

        wlan_nic[nic_name]=nicinfo
      }
      return wlan_nic
    end

    def show_interfaces()
      rs=netsh_wlan_si
      parse_wlan_si(rs)
    end

    #netsh wlan show networks
    def netsh_sn(nicname="wireless")
      `netsh wlan show networks interface="#{nicname}"`
      # `netsh wlan show networks`
    end

    def parse_sn(rs)
      nonic="系统上没有无线接口"
      raise "no wireless nic found,please check !" if rs=~/nonic/
      networks = rs.split(/SSID/)
      network_type = "Network type" #: 结构
      au_type="身份验证" #: WPA2 - 个人
      pass_type = "加密" #: CCMP
      interface = "接口名称" #: Wireless
      ###当前有 38 个网络可见
      networknum1 = "当前有"
      networknum2 = "个网络可见"
      rs=~/#{networknum1}\s*(\d+)\s*#{networknum2}\s*/
      networknum=$1.strip
      rs=~/#{interface}\s*\:\s*(.+)\s*/
      interface_name = $1.strip
      network_info={}
      network_ssid={}
      wifi_network={}
      networks.each_index { |index|
        next if index == 0
        network = networks[index]
        network=~/\s*\d+\s*\:\s*(.*)\s*#{network_type}/
        if !$1.nil?
          ssid_name=$1.strip
          if ssid_name==""
            ssid_name="no_ssid_name#{index}"
          end
        end

        network=~/\s*#{network_type}\s*\:\s*(.*)\s*/
        network_info[:network_type]=$1.strip if !$1.nil?

        network=~/\s*#{au_type}\s*\:\s*(.*)\s*/
        network_info[:au_type]=$1.strip if !$1.nil?

        network=~/\s*#{pass_type}\s*\:\s*(.*)\s*/
        network_info[:pass_type]=$1.strip if !$1.nil?

        network_ssid[ssid_name]=network_info
        wifi_network[interface_name]=network_ssid
      }
      return wifi_network
    end

    def show_networks(nicname="wireless")
      rs = netsh_sn(nicname)
      parse_sn(rs)
    end

    #add profile
    #"已将配置文件 WIFI_002A11 添加到接口 Wireless。\n"
    def netsh_ap(path, nicname="wireless")
      rs = `netsh wlan add profile filename="#{path}" interface="#{nicname}"`
      result="已将配置文件"
      if rs=~/#{result}/
        return true
      else
        puts rs
        return false
      end
    end

    # netsh wlan delete profile name="*" interface="Wireless"
    def netsh_dp(profile_name, nicname="Wireless")
      result= "删除配置文件"
      rs=`netsh wlan delete profile name="#{profile_name}" interface="#{nicname}"`
      if rs=~/#{result}/
        return true
      else
        puts rs
        return false
      end
    end

    #删除所有
    def netsh_dp_all
      succ= "删除配置文件"
      fail="找不到配置文件"
      rs=`netsh wlan delete profile name="*"`
      if rs=~/#{succ}/
        return true
      else
        puts rs
        return false
      end
    end

    #删除部分
    def netsh_dp_some(profile_profix, nicname="Wireless")
      result= "删除配置文件"
      rs=`netsh wlan delete profile name="*#{profile_profix}*" interface="#{nicname}"`
      if rs=~/#{result}/
        return true
      else
        puts rs
        return fase
      end
    end

    #show profiles
    def netsh_sp(nicname="wireless")
      # `netsh wlan show profiles`
      rs = `netsh wlan show profiles interface="#{nicname}"`
    end

    def parse_sp(rs)
      interface1="接口"
      interface2="上的配置文件"
      config_head = "所有用户配置文件"
      rs=~/\s*#{interface1}\s*(.+)\s*#{interface2}\s*\:/
      interface_name = $1.strip
      configs = rs.split(/#{config_head}/)
      config_info={}
      config_files=[]
      configs.each_index { |index|
        next if index==0
        config=configs[index]
        config=~/\s*\:\s*(.+)\s*/
        config_files<<$1.strip
      }
      config_info[interface_name]=config_files
      return config_info
    end

    def show_profiles(nicname="Wireless")
      rs= netsh_sp(nicname)
      parse_sp(rs)
    end

    def netsh_sp_detail(config_name, nicname="wireless")
      rs =`netsh wlan show profiles name=#{config_name} key=clear interface="#{nicname}"`
      # `netsh wlan show profiles interface="#{nicname}"`
    end

    def parse_sp_detail(rs)

    end

    # netsh wlan  connect name="WIFI_002A11" ssid="WIFI_002A11"
    # netsh wlan  connect name="WIFI_002A11" ssid="WIFI_002A11" interface="wireless"
    # netsh wlan  connect name="WIFI_002A11" interface="wireless"
    def netsh_conn(profile_name, nicname="wireless")
      result="已成功完成连接请求"
      rs = `netsh wlan connect name="#{profile_name}" interface="#{nicname}"`
      if rs =~ /#{result}/
        return true
      else
        puts "连接失败：#{rs}"
        return false
      end
    end

    # disconnect
    # disconnect interface="Wireless Network Connection"
    def netsh_disc(nicname="Wireless")
      rs = `netsh wlan disconnect interface="#{nicname}"`
      result ="已成功完成接口"
      if rs=~/#{result}/
        return true
      else
        puts "Disconnect failed or not connected"
        return false
      end
    end

    def netsh_disc_all
      rs = `netsh wlan disconnect`
      result ="已成功完成接口"
      if rs=~/#{result}/
        return true
      else
        puts "Disconnect failed or not connected"
        return false
      end
    end

    def netsh_disc_some(nicname="Wireless")
      rs = `netsh wlan disconnect interface="*#{nicname}*"`
      result ="已成功完成接口"
      if rs=~/#{result}/
        return true
      else
        puts "Disconnect failed or not connected"
        return false
      end
    end

    # set autoconfig [enabled=]yes|no [interface=]<string>
    def netsh_sa(flag="yes", nicname="wireless")
      rs = `netsh wlan set autoconfig enabled=#{flag} interface="#{nicname}"`
    end

    # set profileparameter [name=]<string> [[interface=]<string>]
    # [SSIDname=<string>] [ConnectionType=ESS|IBSS] [autoSwitch=yes|no]
    # [ConnectionMode=auto|manual] [nonBroadcast=yes|no]
    # [authentication=open|shared|WPA|WPA2|WPAPSK|WPA2PSK]
    # [encryption=none|WEP|TKIP|AES] [keyType=networkKey|passphrase]
    # [keyIndex=1-4] [keyMaterial=<string>] [PMKCacheMode=yes|no]
    # [PMKCacheSize=1-255] [PMKCacheTTL=300-86400] [preAuthMode=yes|no]
    # [preAuthThrottle=1-16 [FIPS=yes|no]
    # [useOneX=yes|no] [authMode=machineOrUser|machineOnly|userOnly|guest]
    # [ssoMode=preLogon|postLogon|none] [maxDelay=1-120]
    # [allowDialog=yes|no] [userVLAN=yes|no]
    # [heldPeriod=1-3600] [AuthPeriod=1-3600] [StartPeriod=1-3600]
    # [maxStart=1-100] [maxAuthFailures=1-100] [cacheUserData = yes|no]
    #change pw
    #修改加密连接的密码
    def netsh_modify_pass(profile_name, passwd, ssid="", nicname="Wireless")
      if ssid==""
        rs =`netsh wlan  set  profileparameter name="#{profile_name}" SSIDname="#{ssid}" interface="#{nicname}" KeyMaterial="#{passwd}"`
      else
        rs =`netsh wlan  set  profileparameter name="#{profile_name}" interface="#{nicname}" KeyMaterial="#{passwd}"`
      end
      result ="已成功更新"
      if rs=~/#{result}/
        return true
      else
        puts rs
        puts "Update profile failed"
        return false
      end
    end

    #使用不加密方式连接
    def netsh_set_none(profile_name, ssid="", nicname="Wireless")
      if ssid==""
        rs = `netsh wlan set profileparameter name="#{profile_name}" authentication="open" encryption="none" interface="#{nicname}"`
      else
        rs = `netsh wlan set profileparameter name="#{profile_name}" SSIDname="#{ssid}" authentication="open" encryption="none" interface="#{nicname}"`
      end
      result ="已成功更新"
      if rs=~/#{result}/
        return true
      else
        puts "Update profile failed"
        return false
      end
    end

    #将空密码的设置为WAP2-psk,aes,方式加密
    def netsh_modify_none_pass(profile_name, passwd, ssid="", nicname="Wireless")
      if ssid==""
        rs =`netsh wlan  set  profileparameter name="#{profile_name}" interface="#{nicname}" authentication="WPA2PSK" encryption="AES" keyType="passphrase" KeyMaterial="#{passwd}"`
      else
        rs =`netsh wlan  set  profileparameter name="#{profile_name}" SSIDname="#{ssid}" interface="#{nicname}" authentication="WPA2PSK" encryption="AES" keyType="passphrase" KeyMaterial="#{passwd}"`
      end
      result ="已成功更新"
      if rs=~/#{result}/
        return true
      else
        puts rs
        puts "Update profile failed"
        return false
      end
    end


  end
end

if __FILE__==$0
  # require 'pp'
  n = HtmlTag::Network.new()
  p n.ipconfig()
   # p n.ipconfig("all")
   # p n.ip_release("wireless")
   # p n.ip_renew("wireless")
  # p n.netsh_modify_none_pass("WIFI_002A11", "12345678")
  # p n.netsh_modify_none_pass("WIFI_002A11", "12345678","WIFI_002A11")
  # p s.netsh_ap("e:/Wireless-WIFI_002A11.xml")

  # p rs = n.show_profiles
  # p rs = n.show_networks
  # p rs1 =rs["Wireless"]
  # p rs2 =n.show_interfaces
  # p rs2["Wireless"][:status]
  # p "已断开连接"
  # p "已连接"
  # p rs2["Wireless"][:status].encode("utf-8")==("已断开连接")
  # p rs2["Wireless"][:status].encode("utf-8")==("已连接")
  # p s.netsh_conn(rs["Wireless"][0])
  # p n.netsh_dp_all

  # # p s.netsh_wlan_si
  # p s.show_interfaces
  # p s.netsh_modify_pro(rs["Wireless"][0],"12345678")
  # print s.netsh_sp_detail(rs["Wireless"][0])
  # rs =s.netsh_disc_all
  #  p  n.netsh_dp_all
  # rs = s.netsh_wlan_si
  # pp s.parse_wlan_si(rs)
  # p rs = s.netsh_sp_detail("WIFI_002A11")
  # p s.parse_sp(rs)
  # pp s.parse_sn(rs)
  # s.ipconfig()

  # s = WinCmd.new.ip_release("wireless")
  # #  pp s = WinCmd.new.ip_renew()
  # s = WinCmd.new.ip_renew("wireless")

end