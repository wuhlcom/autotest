#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_UserCenter_019", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、登录用户获取access_token值和uid号；") {
}

operate("3、修改密码，新密码为空；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
