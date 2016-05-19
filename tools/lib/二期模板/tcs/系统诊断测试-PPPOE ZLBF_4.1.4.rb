#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_4.1.4", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、配置外网设置拨号方式为PPPOE；") {

}

operate("2、输入错误的账号密码，使拨号不成功，点击系统诊断，查看诊断结果；") {

}

operate("3、输入正确的账号密码，使拨号成功，点击系统诊断，查看诊断结果；") {

}

operate("4、测试网不接入Internet，点击系统诊断，查看诊断结果；") {

}



    end

    def clearup

    end

    }
