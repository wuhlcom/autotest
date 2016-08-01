#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_134", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("3、查询知路管理员下的管理员信息；（超级管理员、系统管理员查询同上）") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
