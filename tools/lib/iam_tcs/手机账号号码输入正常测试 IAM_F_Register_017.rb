#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Register_017", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取验证码；（测试使用不同手机段的号码）") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
