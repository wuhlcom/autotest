#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_072", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、SSH登录IAM系统；") {
}

operate("2、错误手机号，获取手机验证码；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
