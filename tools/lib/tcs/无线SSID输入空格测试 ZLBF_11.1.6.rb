#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_11.1.6", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、设置无线SSID第一个字符为空格；") {

}

operate("2、设置无线SSID最后一个字符为空格；") {

}

operate("3、设置无线SSID中间输入一个空格；如123 abc") {

}

operate("4、设置无线SSID间隔输入一个以上空格；如123 abc 123") {

}



    end

    def clearup

    end

    }
