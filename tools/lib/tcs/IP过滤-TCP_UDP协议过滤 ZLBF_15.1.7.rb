#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.7", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {

}

operate("2、添加一条规则，设置源IP为192.168.100.100，端口为5000，协议为TCP/UDP，保存配置，在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建UDP的数据包，端口为5000，源IP地址192.168.100.100，PC2上是否能抓到PC1上发出的数据包；") {

}

operate("3、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，端口为5000，源IP地址为：192.168.100.100，PC2上是否能抓到PC1上发出的数据包。") {

}

operate("4、编辑步骤2、3，数据包生成器（如科来数据包生成器、IPTEST）构建UDP的数据包，把端口更改为6000，查看测试结果；") {

}

operate("5、编辑步骤2、3，数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，把源IP设置为192.168.100.200，查看测试结果。") {

}



    end

    def clearup

    end

    }
