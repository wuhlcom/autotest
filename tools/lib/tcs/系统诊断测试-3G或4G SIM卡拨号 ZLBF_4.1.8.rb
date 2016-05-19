#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_4.1.8", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP配置为3G拨号，插入3G或4G SIM卡，使拨号成功，点击系统诊断，查看诊断结果；") {

}

operate("3、换插入一张无资费的3G或4G SIM卡，使拨号不成功，点击系统诊断，查看诊断结果；") {

}



    end

    def clearup

    end

    }
