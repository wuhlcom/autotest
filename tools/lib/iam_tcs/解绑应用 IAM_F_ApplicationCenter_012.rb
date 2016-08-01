#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_ApplicationCenter_012", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录服务器；") {
}

operate("2、获取登录用户的token值和id号；") {
}

operate("3、用户查询我的应用；") {
}

operate("4、用户解除应用绑定；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
