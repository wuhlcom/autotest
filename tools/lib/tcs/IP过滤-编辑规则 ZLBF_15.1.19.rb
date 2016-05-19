#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.19", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为DHCP，保存配置；") {

}

operate("2、进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，在IP过虑界面添加规则，添加一条IP过滤，设置源IP为192.168.100.100，端口为5000，协议为TCP，保存配置；") {

}

operate("3、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，端口为5000，源IP地址为：192.168.100.100，PC2上是否能抓到PC1上发出的数据包；") {

}

operate("4、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，端口为6000，源IP地址为: 192.168.100.100，PC2上是否能抓到PC1上发出的数据包；") {

}

operate("5、编辑步骤2，修改过滤规则，修改过滤端口为6000，保存；") {

}

operate("6、重复步骤3，查看测试结果；") {

}

operate("7、重复步骤4，查看测试结果；") {

}

operate("备注：可以使用iptables-nvx-L查看。") {

}



    end

    def clearup

    end

    }
