#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_27.1.3", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps；点击保存") {

}

operate("2、输入申请带宽值为非数字，例如输入字母，汉字，特殊字符，空格等字符，点击保存") {

}

operate("3、输入申请带宽值为0，小数，负数，点击保存") {

}

operate("4、输入申请带宽值为超大值，例如输入999999999999999数字，点击保存") {

}



    end

    def clearup

    end

    }
