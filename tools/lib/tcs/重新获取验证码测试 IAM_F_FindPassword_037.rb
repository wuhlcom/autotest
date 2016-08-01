#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_FindPassword_037", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取手机验证码；") {
}

operate("3、2分钟以后再次获取验证码；") {
}

operate("4、使用第一次的验证码进行密码找回；") {
}

operate("5、使用第二的验证吗进行密码找回；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
