#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Application_069", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("3、获取要删除应用ID号，其中该应用已绑定用户；") {
}

operate("4、删除改应用；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
