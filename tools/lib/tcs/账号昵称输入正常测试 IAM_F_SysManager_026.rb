#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_026", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录管理员的id号和token值：") {
}

operate("3、新增一个管理员，nickname为单个字符、32字符、字母数字下划线中文组合；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
