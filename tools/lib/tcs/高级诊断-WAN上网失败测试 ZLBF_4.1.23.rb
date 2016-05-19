#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_4.1.23", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、不插入3G上网卡，将网口配置为WAN口，上行为DHCP，但是DHCP服务器不开启服务，进行高级诊断") {

}

operate("2、配置WAN口为PPPOE，错误的账号密码，进行高级诊断") {

}

operate("3、配置为错误的静态IP地址，进行高级诊断") {

}



    end

    def clearup

    end

    }
