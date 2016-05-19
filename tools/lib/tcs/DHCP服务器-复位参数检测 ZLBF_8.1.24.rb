#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_8.1.24", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入LAN设置页面；") {

}

operate("2、更改LAN IP与子网掩码，更改地址池范围，添加一保留地址规则；") {

}

operate("3、恢复DUT为出厂默认状态，查看LAN设置页面的参数是否被复位成默认状态。") {

}



    end

    def clearup

    end

    }
