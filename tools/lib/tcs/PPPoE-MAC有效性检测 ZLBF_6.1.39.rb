#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.39", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、在BAS启用抓包；") {

}

operate("2、进行PPPoE设置页面，配置正确用户名与密码，选择一直在线模式，选择“使用指定MAC地址”；") {

}

operate("3、输入MAC地址：00:00:00:00:00:00，查看是否允许输入保存；") {

}

operate("4、输入MAC地址：FF:FF:FF:FF:FF:FF，查看是否允许输入保存；") {

}

operate("5、输入MAC地址以01:00:5e开头的MAC地址，如：01:00:5e:00:00:01,查看是否允许输入保存；") {

}

operate("6、输入MAC地址：90:AB:CD:EF:ab:cf，查看是否允许输入保存；") {

}



    end

    def clearup

    end

    }
