#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_133", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取系统管理员uid和token值；") {
}

operate("3、修改comments信息输入带空格；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
