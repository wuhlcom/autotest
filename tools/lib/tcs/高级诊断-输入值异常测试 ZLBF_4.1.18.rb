#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_4.1.18", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、外网连接正常，进入高级诊断") {

}

operate("2、输入非http开头的字符，例如直接输入www.baidu.com字符，点击检测") {

}

operate("3、输入“http://“，后面不输入其他值，点击检测") {

}

operate("4、输入值为空，点击检测") {

}



    end

    def clearup

    end

    }
