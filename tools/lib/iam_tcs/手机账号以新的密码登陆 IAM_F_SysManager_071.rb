#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_071", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、SSH登录IAM系统；") {
}

operate("2、使用新密码登录；") {
}

operate("3、使用旧密码登录；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
