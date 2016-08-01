#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_ApplicationCenter_013", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录服务器；") {
}

operate("2、知路管理员禁用该应用；") {
}

operate("3、用户查询我的应用；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
