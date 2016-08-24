#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.10", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {

}

operate("2、启用IP过滤功能，设置源IP为192.168.100.100，端口为1-65535，协议为TCP/UDP，设置状态为生效，保存配置，在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP，UDP的数据包，数据包的源IP地址设置为192.168.100.100，端口任意，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包；") {

}

operate("3、重启AP，再发包，在PC2上抓包，是否能收到PC1发出的数据包；") {

}

operate("4、编辑步骤2添加的规则，把状态修改为失效，保存，再发包在PC2上抓包，是否能收到PC1发出的数据包；") {

}

operate("5、重启AP,再发包，在PC2上抓包，是否能收到PC1发出的数据包。") {

}



    end

    def clearup

    end

    }
