#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_11.1.18", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入路由器内网设置页面；") {

}

operate("2、设置无线开关为关；") {

}

operate("3、使用无线网卡扫描该SSID，是否可以扫描成功；手动输入连接该SSID，是否可以连接成功；") {

}

operate("4、设置无线开关为开；") {

}

operate("5、使用无线网卡扫描该SSID，是否可以扫描成功，且能连接成功；") {

}



    end

    def clearup

    end

    }
