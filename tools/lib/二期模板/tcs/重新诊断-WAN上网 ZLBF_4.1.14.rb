#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_4.1.14", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、Wan口设置为DHCP拨号；") {

}

operate("2、Wan口不接入网线，点击“网络诊断”功能，查看诊断结果") {

}

operate("3、WAN口接入网线，等拨号成功后，点击“重新诊断”功能，查看诊断结果") {

}

operate("4、使测试网不接入Internet，点击“重新诊断”功能，查看诊断结果") {

}

operate("5、恢复测试网接入Internet，点击“重新诊断”功能，查看诊断结果") {

}



    end

    def clearup

    end

    }
