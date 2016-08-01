#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_110", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取管理员token值和id号；") {
}

operate("3、修改密码：") {
}

operate("4、使用新密码登录：") {
}

operate("（这里可以先创建一个管理员账号，或者使用已有的账号进行修改，切记若修改知路管理员的账号，修改后要改回来）") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
