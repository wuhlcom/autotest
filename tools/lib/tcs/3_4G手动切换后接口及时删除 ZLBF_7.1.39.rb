#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_7.1.39", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、被测AP内插入一张3G SIM卡，将拨号方式切换到3/4G拨号，串口下查看拨号后是否多出对应的接口(ppp0接口)") {

}

operate("2、切换到PPPOE方式上网，串口下查看ppp0接口是否删除，使用route-n查看路由表象是否正常，PC上网是否正常") {

}

operate("3、断电后，AP内插入一张4G SIM卡，将拨号方式切换到3/4G拨号，串口下查看拨号后是否多出对应的接口(usb0接口)") {

}

operate("4、切换到DHCP方式上网，串口下查看usb0接口是否删除，使用route-n查看路由表象是否正常，PC上网是否正常") {

}



    end

    def clearup

    end

    }
