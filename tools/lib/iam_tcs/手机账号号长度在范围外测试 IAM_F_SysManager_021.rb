#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_021", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录管理员的id号和token值：") {
}

operate("3、手机号输入大于11位号码，如“138265454444”，新增管理员；") {
}

operate("4、手机号输入大于11位号码，如“1382645656”，新增管理员；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
