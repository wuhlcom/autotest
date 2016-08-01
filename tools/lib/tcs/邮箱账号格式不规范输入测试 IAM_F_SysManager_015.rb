#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_015", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录管理员的id号和token值：") {
}

operate("3、邮箱账号格式不规范时，新增一个账号；：") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
