#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.15", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为PPPoE，保存配置,再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {

}

operate("2、添加一条IP规则，其它设置不填，只填写源端口设置为80-110，协议为TCP/UDP，保存配置；") {

}

operate("3、在PC1上用数据包生成器（如:科来数据包生成器,IPTEST）构建，目的端口为80的TCP，UDP的数据包，数据包的IP地址相关信息任意设置，由LAN到WAN发送数据包，PC2上是否能抓到PC1上发出的数据包；") {

}

operate("4、模拟发送源端口为81，109，110的TCP，UDP的数据包，数据包的IP地址相关信息任意设置，由LAN到WAN发送数据包，PC2上是否能抓到PC1上发出的数据包；") {

}

operate("5、模拟发送源端口为1，79，111，65535的TCP，UDP的数据包，数据包的IP地址相关信息任意设置，由LAN到WAN发送数据包，PC2上是否能抓到PC1上发出的数据包。") {

}



    end

    def clearup

    end

    }
