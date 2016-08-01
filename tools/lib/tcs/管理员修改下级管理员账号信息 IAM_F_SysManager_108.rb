#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_108", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("2、知路管理员下新增超级管理员；") {
}

operate("3、登录超级管理员获取id") {
}

operate("4、修改超级管理员的信息：") {
}

operate("（其中uid为登录管理员的id，token值为登录管理员的token值，id为待修改管理员的id；）") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
