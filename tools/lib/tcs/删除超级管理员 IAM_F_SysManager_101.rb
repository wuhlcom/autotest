#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_101", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理token值；") {
}

operate("3、获取管理员列表和管理员uerid号：") {
}

operate("4、删除指定的管理员；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
