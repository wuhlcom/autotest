#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_11.1.8", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、设置无线SSID为1个字符，设置为“1”，无线客户端与之关联，查看是否能连接成功，") {

}

operate("2、设置无线SSID为“1234567890ASDFGHJKLMqwertyuiop12”32个字符，无线客户端与之关联，查看是否能连接成功；") {

}



    end

    def clearup

    end

    }
