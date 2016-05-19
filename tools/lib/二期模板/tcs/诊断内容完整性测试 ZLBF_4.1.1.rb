#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_4.1.1", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP上插入3G上网卡，使3G拨号成功；") {

}

operate("2、点击网络诊断，查看诊断的内容是否包括以下信息：3G拨号状态，网络连接状态，外网连接状态，路由硬件状态，连接速度状态，系统CPU、内存、负载") {

}

operate("备注:如无3G拨号，则配置为DHCP方式检测完成性。") {

}



    end

    def clearup

    end

    }
