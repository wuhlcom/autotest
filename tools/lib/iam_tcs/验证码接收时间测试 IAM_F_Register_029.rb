#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Register_029", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、分别使用联通、电信、移动手机号码进行验证码获取测试；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
