require 'net/telnet'
module HtmlTag
    module LswTelnet

        def lsw_telnet_obj(url="50.50.50.100", admin="", password="")
            puts "#{self.to_s}->method_name:#{__method__}"
            @localhost = Net::Telnet::new("Host"     => url,
                                          "Timeout"  => 10,
                                          "Waittime" => 2,
                                          "Prompt"   => /[$%#>:]\s*\z|(\[N\/y\])/n)
            @localhost.login({"Name" => admin, "Password" => password, "LoginPrompt" =>/[$%#>:]\s*\z|(\[N\/y\])/n, "PasswordPrompt" => /[$%#>:]\s*\z|(\[N\/y\])/n}) { |c| print c }
            return @localhost
        end

        def send_cmd(cmd, timeout=10)
            puts "#{self.to_s}->method_name:#{__method__}"
            fail "#{cmd} type is #{cmd.class},command must be string!" unless cmd.kind_of?(String)
            fail "cmd is empty string,please check the params!" if cmd.empty?
            cmd_return = @localhost.cmd("String" => cmd, "Timeout" => timeout) { |c| print c }
            # if cmd_return=~/not\s*found|syntax\s+error|bad\s+command/i
            # 		fail "Command error!"
            # end
            cmd_return
        end

        def interface_eth(port)
            puts "#{self.to_s}->method_name:#{__method__}"
            send_cmd("en")
            send_cmd("admin")
            send_cmd("conf t")
            send_cmd("interface fastEthernet #{port}")
        end

        #关闭交换机端口
        def shutdown_port(port, cmd="shutdown")
            puts "#{self.to_s}->method_name:#{__method__}"
            interface_eth(port)
            send_cmd(cmd)
            sleep 10
        end

        #打开交换机端口
        def no_shutdown_port(port, cmd="no shutdown")
            puts "#{self.to_s}->method_name:#{__method__}"
            interface_eth(port)
            send_cmd(cmd)
            sleep 10
        end

        #1.获取WAN口mac地址，2.在交换机中使用“sh mac-address-table address 78a3.5101.2782”命令获取对应端口号
        def get_port(mac_addr)
            puts "#{self.to_s}->method_name:#{__method__}"
            str = send_cmd("sh mac-address-table address #{mac_addr}")
            parser_mac(str)
        end

        def parser_mac(str)
            /\s+Fa(?<port>.+)\nTotal Mac/i =~ str
            port
        end
    end
end


if __FILE__==$0
    include HtmlTag::LswTelnet
    lsw_telnet_obj("50.50.50.100")
    # require 'htmltags'
    # include HtmlTag::WinCmd
    # shutdown_port(19)
    # no_shutdown_port(19)
    # ping("www.cctv.com")
    port = get_port("78a3.5101.2782")
    # str = "sh mac-address-table address 78a3.5101.2782\n          Mac Address Table\n-------------------------------------------\n\nVlan    Mac Address       Type        Ports\n----    -----------       --------    -----\n   1    78a3.5101.2782    DYNAMIC     Fa0/19\nTotal Mac Addresses for this criterion: 1\npubswitch#"
    # p parser_mac(str)

    # p port = "0/19"
    shutdown_port(port)
    # no_shutdown_port(port)
end