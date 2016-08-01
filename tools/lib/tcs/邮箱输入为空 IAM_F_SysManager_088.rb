#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_088", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、SSH登录IAM系统；") {
}

operate("2、获取找回账号token值，邮箱为空；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
