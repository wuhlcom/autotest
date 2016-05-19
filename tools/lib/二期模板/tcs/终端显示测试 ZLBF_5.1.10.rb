#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_5.1.10", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、被测AP通过WAN连接到外网，下面接多台有线，无线PC，笔记本，手机，ipad等设备。在终端显示列表中是否正常显示所有的设备") {

}

operate("2、将部分设备断开连接后，再在终端显示列表中是否正常显示当前最新的设备") {

}

operate("3、再将断开的设备连上后，在终端显示列表中是否正常显示完整的当前最新的设备") {

}

operate("4、修改连接终端设备的名称为带特殊字符的，带中文的名称，在终端显示列表中是否能正常显示") {

}



    end

    def clearup

    end

    }
