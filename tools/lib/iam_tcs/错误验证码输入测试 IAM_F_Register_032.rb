#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Register_032", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、输入手机号码获取验证码；") {
}

operate("3、使用该手机号码进行注册，输入错误验证码；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
