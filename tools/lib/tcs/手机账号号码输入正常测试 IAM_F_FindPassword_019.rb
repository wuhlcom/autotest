#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_FindPassword_019", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取手机验证码；") {
}

operate("3、找回密码；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
