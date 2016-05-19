#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.14", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为DHCP，保存配置。再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {

}

operate("2、添加一条过滤规则，其它设置为默认，源端口设置为1-65535，协议为TCP/UDP，保存配置。") {

}

operate("3、在PC1上用数据包生成器（如：科来数据包生成器，IPTEST）构建，目的端口为1的TCP，UDP的数据包，数据包的IP地址相关信息任意设置，由LAN到WAN发送数据包，PC2上是否能抓到PC1上发出的数据包；") {

}

operate("4、编辑步骤2，数据包生成器更改源端口更改为65535，80，21，1024，60000等数据包，查看测试结果；") {

}

operate("5、重启DUT，执行步骤3，查看测试结果。") {

}



    end

    def clearup

    end

    }
