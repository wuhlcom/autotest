#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.8", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为DHCP，保存配置，再进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，保存；") {

}

operate("2、在IP过虑界面添加一条规则，生效时间设置为0000-1200,源IP为192.168.100.100,其它设置为默认的。") {

}

operate("3、当前时间为上午10点，在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建UDP的数据包，源IP地址192.168.100.100，PC2上是否能抓到PC1上发出的数据包；") {

}

operate("4、更改生效时间设置为1200-2300，在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建UDP的数据包，源IP地址192.168.100.100，PC2上是否能抓到PC1上发出的数据包。") {

}



    end

    def clearup

    end

    }
