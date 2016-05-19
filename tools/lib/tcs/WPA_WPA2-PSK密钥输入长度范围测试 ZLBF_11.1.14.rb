#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_11.1.14", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、秘钥输入“qwertyuioplkjhgfdsazxcvbnm896543210krtghjuiopasdfghjklmnbvcx123”63个字符，是否可以设置成功； STA是否连接成功；") {

}

operate("2、秘钥输入“12345678901234567890123456789012345678901234567890ABCDEFabcdef34”64个16进制，是否可以设置成功；STA是否连接成功；") {

}



    end

    def clearup

    end

    }
