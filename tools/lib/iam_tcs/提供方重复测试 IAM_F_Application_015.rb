#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Application_015", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("3、创建应用，provider输入知路公司；") {
}

operate("4、再次创建应用，provider输入知路公司；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
