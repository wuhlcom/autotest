#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.4", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {

}

operate("2、添加一条新规则，设置源IP为所有IP（不填或设置192.168.100.2-192.168.100.254），端口为1-65535，协议为TCP/UDP，保存配置，在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP，UDP的数据包，数据包的源IP地址设置为192.168.100.2，端口任意，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包。") {

}

operate("3、更改数据包的源IP地址为192.168.100.3，端口任意，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包。") {

}

operate("4、更改数据包的源IP地址为192.168.100.253，端口任意，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包。") {

}

operate("5、更改数据包的源IP地址为192.168.100.254，端口任意，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包。") {

}



    end

    def clearup

    end

    }
