#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_009", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录到IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("2、新增系统管理员；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
