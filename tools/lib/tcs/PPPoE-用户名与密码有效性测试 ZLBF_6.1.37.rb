#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.37", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、在BAS开启抓包；") {

}

operate("2、登陆DUT，进入PPPoE拨号页面；") {

}

operate("3、在用户名处输入特殊字符~!@#$%^&*()_+{}|:"<>?等键盘上33个特殊字符,查看是否允许输入保存，页面显示是否正常，抓包确认拨号是否以设置用户名拨号；") {

}

operate("4、在用户名处输入09,查看是否允许输入保存，页面显示是否正常，抓包确认拨号是否以设置用户名拨号；") {

}

operate("5、在用户名处输入az,查看是否允许输入保存，页面显示是否正常，抓包确认拨号是否以设置用户名拨号；") {

}

operate("6、在用户名处输入AZ,查看是否允许输入保存，页面显示是否正常，抓包确认拨号是否以设置用户名拨号；") {

}

operate("7、在密码处依次重复步骤3~7，查看测试结果。") {

}



    end

    def clearup

    end

    }
