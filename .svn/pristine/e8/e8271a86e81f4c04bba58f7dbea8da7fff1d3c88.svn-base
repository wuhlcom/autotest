#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.11", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {

}

operate("2、添加两条过滤规则，一条源IP为192.168.100.100,另外一条是192.168.100.101；") {

}

operate("3、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP，UDP的数据包，数据包的源IP地址设置为192.168.100.100和源IP地址为192.168.100.101，端口任意，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包；") {

}

operate("4、在IP过滤界面，点击使所有条目失效，再进行发包，在PC2上抓包，是否能收到PC1发出的数据包；") {

}

operate("5、在IP过滤界面，点击使所有条目生效，再进行发包，在PC2上抓包，是否能收到PC1发出的数据包。") {

}



    end

    def clearup

    end

    }
