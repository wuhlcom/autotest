#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_081", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、SSH登录IAM系统；") {
}

operate("2、获取手机验证码；") {
}

operate("3、新密码密码为空；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
