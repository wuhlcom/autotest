#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_050", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录到IAM服务器；") {
}

operate("2、登录知路管理员；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
