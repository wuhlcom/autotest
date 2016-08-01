#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_105", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("3、知路管理员下新增超级管理员；") {
}

operate("4、登录超级管理员获取id和token值") {
}

operate("5、超级管理员下新增一个应用：") {
}

operate("6、知路管理员下删除已创建的超级管理员：") {
}

operate("（其中uid为登录管理员ID，userid为待删除管理员ID，token值为登录管理员token值；)") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
