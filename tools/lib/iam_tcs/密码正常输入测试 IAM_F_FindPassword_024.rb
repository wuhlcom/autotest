#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_FindPassword_024", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取手机验证码；") {
}

operate("3、修改密码；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
