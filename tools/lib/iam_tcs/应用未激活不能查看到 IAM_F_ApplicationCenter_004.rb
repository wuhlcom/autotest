#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_ApplicationCenter_004", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、知路管理员新建一个应用；") {
}

operate("3、获取登录用户的token值和id号；") {
}

operate("4、用户查询待绑定的应用列表；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
