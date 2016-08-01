#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_UserCenter_013", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录用户access_token值和uid号；") {
}

operate("3、修改密码，旧密码输入有误") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
