#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Application_050", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("3、获取修改应用的应用ID号;") {
}

operate("4、修改redirect_uri地址为正常格式；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
