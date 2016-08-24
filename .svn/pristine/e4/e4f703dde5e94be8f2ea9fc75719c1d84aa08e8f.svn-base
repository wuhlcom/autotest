#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_32.1.16", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP1的LAN地址为192.168.0.1;WAN地址为192.168.1.1；AP2的LAN地址为192.168.2.1，WAN地址为192.168.1.2；") {

}

operate("2、AP1配置静态路由目的地址为192.168.2.0的都转发至192.168.1.2；AP2配置静态路由目的地址为192.168.0.0的都转发至192.168.1.1；") {

}

operate("3、被测AP1和AP2都连接到测试网，AP1配置隧道IP为10.1.1.1，对端IP为192.168.1.2，key=4；AP2配置隧道IP为10.1.1.2，对端IP为192.168.1.1，key=4") {

}

operate("4、在AP1下接电脑ping AP2下接电脑的地址，是否能ping通；在AP2的WAN口处抓包查看报文是否经过GRE封装") {

}

operate("5、关闭此规则后，在AP1下接电脑ping AP2下接电脑的地址，是否能ping通；反过来在AP2下接电脑ping AP1下接电脑的地址，是否能ping通") {

}



    end

    def clearup

    end

    }
