#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_11.1.27", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、输入框中输入中文，例如输入“中国”，点击保存") {

}

operate("2、输入框中输入字母，例如输入“aaaaa”，点击保存") {

}

operate("3、输入框中输入特殊字符，例如输入“") {

}

operate("~!@#$%^&*()_+{}:"|<>?-=[];'\,./”，点击保存") {

}

operate("4、无线SSID1和SSID8都做同样操作；") {

}



    end

    def clearup

    end

    }
