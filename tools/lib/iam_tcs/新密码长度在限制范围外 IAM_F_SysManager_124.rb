#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_124", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员id和token值；") {
}

operate("3、修改新密码，输入值长度在范围外；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
