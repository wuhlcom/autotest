#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Application_071", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("3、获取应用列表，取出没有绑定应用和设备的应用ID号；") {
}

operate("4、批量删除应用；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
