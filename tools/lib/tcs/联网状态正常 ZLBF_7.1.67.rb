#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_7.1.67", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、被测AP内插入一张有资费的移动SIM卡，将拨号方式切换到3/4G拨号，查看3/4G状态页面联网状态是否显示为正常") {

}

operate("2、更换联通，电信的SIM卡去拨号，联网状态是否正常") {

}



    end

    def clearup

    end

    }
