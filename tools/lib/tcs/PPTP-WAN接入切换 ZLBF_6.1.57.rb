#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.57", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、在BAS启动抓包；") {

}

operate("2、设置DUT的WAN拨号方式为PPTP，DUT上配置相应的PPTP方式接入配置，DNS为自动获取方式，认证方法设为自动，并填写正确的拨号用户名和密码，查看拨号是否成功；") {

}

operate("3、切换DUT的WAN方式为DHCP方式后，BAS抓包确认切换成DHCP时，是否以当前的call ID发送Call-Clear-Request断开请求，再切换成PPTP方式后，是否能快速拨号成功；") {

}

operate("4、切换DUT的WAN方式分别为STATIC、PPPoE、PPTP等其它接入方式，重复步骤3，确认结果；") {

}



    end

    def clearup

    end

    }
