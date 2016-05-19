#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.33", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、在BAS启动抓包；") {

}

operate("2、设置DUT的WAN拨号方式为PPPoE，DNS为自动获取方式，认证方法设为自动，并填写正确的拨号用户名和密码，提交，查看拨号是否成功；                            3、切换DUT的WAN方式为DHCP方式后，BAS抓包确认切换成DHCP时，是否发送LCP Termination、PADT终止当前PPPoE连接，再切换成PPPoE方式后，是否能快速拨号成功；") {

}

operate("4、切换DUT的WAN方式分别为STATIC、L2TP、PPTP等其它接入方式，重复步骤3，确认结果；") {

}



    end

    def clearup

    end

    }
