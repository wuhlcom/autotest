#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_013", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录管理员的id号和token值：") {
}

operate("3、执行新增一个管理员，") {
}

operate("用例中列出邮箱都要测试一遍；") {
}

operate("4、邮箱长度32字符：") {
}

operate("5、邮箱输入含有字母、数字、下划线字符：") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
