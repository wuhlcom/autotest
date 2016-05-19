#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.12", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、登录DUT，设置WAN接入为DHCPC方式；") {

}

operate("2、设置hostname为dut，手动设置主次DNS服务器为202.96.134.133,202.96.168.96，选择“使用计算机MAC地址”克隆，保存；") {

}

operate("3、复位DUT到默认配置状态；") {

}

operate("4、查看DUT的DHCP配置是否被复位到默认状态；") {

}



    end

    def clearup

    end

    }
