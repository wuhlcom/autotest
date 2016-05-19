#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_30.1.8", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、PC1登录DUT页面修改当前配置(WAN 连接(分别配置为PPPOE，PPTP，L2TP，DHCP)、无线、防火墙、DDNS、UPNP、QOS、组播控制)；") {

}

operate("2、PC2远程登录DUT页面，恢复出厂默认设置；") {

}



    end

    def clearup

    end

    }
