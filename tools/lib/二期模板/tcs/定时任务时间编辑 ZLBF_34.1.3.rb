#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_34.1.3", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、登录AP，进入到定时任务页面") {

}

operate("2、测试输入正常的时间(包括24小时制)，例如输入00:00:00,23:59:59，是否能输入成功") {

}

operate("3、测试输入异常的时间，例如输入字母，aa:bb:cc,12:00:2c等值，是否能输入成功；输入特殊字符，汉字，是否能输入成功") {

}

operate("4、测试输入值为空，是否能保存成功") {

}

operate("5、测试输入值为超过时钟范围的值，例如输入24:00:01,25:00:00,12:60:00等值，是否能输入成功") {

}

operate("6、测试输入值为当前时间之前的时间，是否能输入成功") {

}



    end

    def clearup

    end

    }
