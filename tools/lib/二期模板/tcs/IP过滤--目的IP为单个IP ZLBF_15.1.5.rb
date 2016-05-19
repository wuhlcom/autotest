#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.5", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为DHCP，保存配置，PC2地址为：192.168.20.100；") {

}

operate("2、先进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {

}

operate("3、添加一条IP过滤规则，设置目的IP为192.168.20.100，端口为1~65535，协议为TCP/UDP，其它不填，保存配置；") {

}

operate("4、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP，UDP的数据包，数据包的目的IP地址设置为192.168.20.100，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包；") {

}

operate("5、更改数据包的目的IP地址,如:192.168.20.99，重复步骤3，查看测试结果。") {

}

operate("6、更改数据包的目胡IP地址,如:192.168.20.101，重复步骤3，查看测试结果。") {

}

operate("7、重启DUT，重复步骤3、4、5，查看测试结果。") {

}



    end

    def clearup

    end

    }
