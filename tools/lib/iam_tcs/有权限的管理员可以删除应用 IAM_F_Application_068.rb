#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Application_068", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("3、获取要删除应用ID号；") {
}

operate("4、知路管理员删除该应用；") {
}

operate("5、登录一个系统管理员，获取该系统管理员的token值；") {
}

operate("6、系统管理员删除一个应用；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
