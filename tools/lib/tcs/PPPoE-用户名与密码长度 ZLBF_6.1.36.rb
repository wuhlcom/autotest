#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.36", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、在BAS开启抓包；") {

}

operate("2、登陆DUT，进入PPPoE拨号页面；") {

}

operate("3、在用户名与密码处分别输入1个字节字符，查看是否可以保存，拔号是否以设置用户名与密码拨号；") {

}

operate("4、不输入用户名，输入1个字节字符的密码，查看是否可以保存，拔号是否以设置用户名与密码拨号；") {

}

operate("5、输入1个字节字符的用户名，不输入密码，查看是否可以保存，拔号是否以设置用户名与密码拨号；") {

}

operate("6、在用户名输入128字节字符，查看是否可以保存，拨号是否以设置用户名与密码拨号；") {

}

operate("7、在用户名输入129字节字符，查看是否可以保存，拨号是否以设置用户名与密码拨号；") {

}



    end

    def clearup

    end

    }
