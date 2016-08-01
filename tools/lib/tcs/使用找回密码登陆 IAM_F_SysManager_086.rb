#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_086", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、SSH登录IAM系统；") {
}

operate("2、使用新密码登录；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
