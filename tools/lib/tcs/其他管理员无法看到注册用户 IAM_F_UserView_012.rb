#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_UserView_012", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取监视管理员/配置管理员token值；") {
}

operate("3、获取所有用户列表；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
